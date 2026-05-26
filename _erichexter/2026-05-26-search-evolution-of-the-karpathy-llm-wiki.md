---
title: "Search — The Evolution of the Karpathy LLM Wiki"
date: 2026-05-26T12:00:00+00:00
author: Eric Hexter
layout: post
categories:
  - AI
  - dotnet
  - sqlite
  - RAG
  - ollama
  - MCP
---

My LLM notes wiki outgrew file reads. Agents were pulling entire files to find a single relevant section — burning tokens on context that didn't matter, missing things that were buried three pages deep. The corpus had just grown past the point where IO-based access was practical.

The fix was search. And since agents need tools, the obvious move was to build it as an MCP server. But if you're building search anyway, plain keyword matching felt like leaving half the value on the table — too easy to miss conceptual matches that don't share exact terms. So: something old and something new. SQLite already has FTS5. sqlite-vec adds HNSW vector search as a loadable extension. Ollama runs the embedding model locally. Put them together and you get hybrid RAG on hardware you already own, exposed as an MCP tool any agent in the fleet can call.

This post covers how it's built — starting from what the agent sees and working inward to the SQL and vector embeddings.

---

## What the Agent Sees

From the agent's perspective, this is just an MCP server with a set of tools. Point an `.mcp.json` at the host and the tools are available. No setup, no SDK, no awareness of what's running underneath.

The primary tool is `search_knowledge`:

```json
{
  "method": "tools/call",
  "params": {
    "name": "search_knowledge",
    "arguments": {
      "query": "attention mechanism scaled dot product",
      "top_k": 5,
      "hybrid_alpha": 0.6,
      "sources": ["karpathy-wiki"]
    }
  }
}
```

The response comes back as ranked chunks with source context:

```json
{
  "content": [{
    "type": "text",
    "text": "[
      {
        \"text\": \"Scaled dot-product attention divides the dot products by √d_k to prevent vanishing gradients in high dimensions...\",
        \"source\": \"karpathy-wiki\",
        \"relPath\": \"transformers/attention.md\",
        \"score\": 0.91,
        \"frontmatter\": { \"tags\": [\"attention\", \"transformers\"] }
      },
      ...
    ]"
  }]
}
```

The agent gets ranked text chunks, source file paths, and scores. It doesn't need to know whether the result came from a vector search or keyword search — that's the server's problem.

### The Full Tool Set

Seven tools in total. `search_knowledge` covers 95% of use.

| Tool | Purpose |
|---|---|
| `search_knowledge` | Hybrid vec+FTS search across one or more sources. |
| `get_page` | Retrieve a full page by source + relative path. Use when search returns a partial chunk and you want the full document. |
| `list_sources` | Lists indexed sources with page/chunk counts and last-indexed timestamps. |
| `get_stats` | Query counts and latencies over 1h / 24h / 7d / 30d windows. |
| `get_query_log` | Recent query history. Useful for understanding what agents are actually asking. |
| `refresh_ingest` | Trigger immediate re-indexing for a source after a write. |
| `ping` | Returns current UTC. Health check. |

`list_sources` is underrated as a diagnostic. A 200 response from the API tells you nothing about whether the index is populated. If results are poor, check `pageCount > 0` and that `lastIndexed` is recent before assuming the search logic is wrong.

### The `hybrid_alpha` Parameter

This is the control knob for the blend between vector search and full-text search.

- `0.0` — pure FTS (BM25 keyword ranking)
- `1.0` — pure vector (semantic similarity)
- `0.5` — equal blend (default)

In practice, `0.6`–`0.7` (vector-weighted) works better for conceptual queries: "how does attention scale with sequence length." Drop toward `0.3` when you need an exact term match that the embedding model might paraphrase: specific function names, error codes, version numbers.

---

## How the Search Works

When `search_knowledge` is called, the server runs two queries in parallel and merges the results.

```csharp
var vectorTask = SearchByVector(embeddingVector, topK * 2, sources);
var ftsTask    = SearchByFts(query, topK * 2, sources);

await Task.WhenAll(vectorTask, ftsTask);

var merged = Merge(vectorTask.Result, ftsTask.Result, hybridAlpha, topK);
```

The merge step normalizes each result list's scores to `[0, 1]`, applies the alpha weight, sums scores per chunk (a chunk can appear in both lists), and returns the top K. Normalization matters — BM25 and HNSW distance are on completely different scales. Skip it and one path dominates every query regardless of alpha.

Before either query runs, the search query itself gets embedded:

```http
POST http://<ollama-host>:11434/api/embeddings
Content-Type: application/json

{
  "model": "nomic-embed-text:latest",
  "prompt": "attention mechanism scaled dot product"
}
```

That gives back a 768-dimensional float vector — what the vector search runs against.

### The Vector Query

sqlite-vec exposes vector search through a virtual table with a `MATCH` clause. Under the hood it's doing an approximate nearest-neighbor scan via HNSW:

```sql
SELECT c.id, c.body, c.source, c.rel_path, c.frontmatter,
       cv.distance
FROM chunk_vecs cv
JOIN chunks c ON c.id = cv.chunk_id
WHERE cv.embedding MATCH :embedding
  AND cv.k = :k
  AND (:sources IS NULL OR c.source IN :sources)
ORDER BY cv.distance;
```

`distance` here is L2 distance — lower is closer. sqlite-vec handles all the index internals; from the query side it looks like a regular SQL query.

### The FTS Query

Standard SQLite FTS5 with BM25 ranking:

```sql
SELECT c.id, c.body, c.source, c.rel_path, c.frontmatter,
       bm25(chunk_fts) AS fts_score
FROM chunk_fts
JOIN chunks c ON c.id = chunk_fts.rowid
WHERE chunk_fts MATCH :query
ORDER BY bm25(chunk_fts)
LIMIT :k;
```

FTS5's `MATCH` supports phrase queries, prefix matching, and boolean operators. For agent queries coming in as natural language, the server sanitizes the input to a simple term query before passing it to MATCH.

---

## The Data Model

Three tables carry the retrieval workload:

```sql
-- Chunked text with metadata
CREATE TABLE chunks (
    id          INTEGER PRIMARY KEY,
    page_id     INTEGER NOT NULL REFERENCES pages(id),
    chunk_index INTEGER NOT NULL,
    body        TEXT    NOT NULL,
    token_count INTEGER,
    source      TEXT,
    rel_path    TEXT,
    frontmatter TEXT
);

-- Vector index (sqlite-vec extension)
CREATE VIRTUAL TABLE chunk_vecs USING vec0(
    chunk_id INTEGER PRIMARY KEY,
    embedding FLOAT[768]
);

-- Full-text search index (FTS5, built into SQLite)
CREATE VIRTUAL TABLE chunk_fts USING fts5(
    body,
    source    UNINDEXED,
    rel_path  UNINDEXED,
    content='chunks',
    content_rowid='id'
);
```

`chunk_vecs` is a [sqlite-vec](https://github.com/asg017/sqlite-vec) `vec0` virtual table — INSERT a row with the chunk ID and its 768-dim embedding, sqlite-vec maintains the HNSW index internally. `chunk_fts` is a content-backed FTS5 table that stays in sync with `chunks` via triggers.

Supporting tables: `pages` (source files with hash-based change detection), `indexer_runs` (ingest audit log), `query_log` (query history for observability).

One SQLite file. No separate processes, no network hops between storage components, no backup complexity.

---

## The Write Path

When a document is added or updated in the source directory, the indexer picks it up:

1. SHA-256 hash the file. Compare against `pages.content_hash`. Skip if unchanged.
2. Parse YAML frontmatter. Extract the body.
3. Split into chunks — 512-token target, 64-token overlap, break on paragraph boundaries where possible.
4. For each chunk: POST to Ollama `/api/embeddings`. Receive a 768-dim float array.
5. INSERT into `chunks`. INSERT into `chunk_vecs`. FTS5 trigger handles `chunk_fts` sync.
6. Update `pages.content_hash` and `indexed_at`.
7. Write a row to `indexer_runs`.

`nomic-embed-text` is 137M parameters — fast on a GPU host, single-digit milliseconds per chunk. The indexer pipelines requests; Ollama queues them.

---

## Gotchas

**The embed model context limit is a silent failure.**

`nomic-embed-text` has an 8K token context window. Chunks that exceed it are silently not embedded — present in `chunks`, retrievable via `get_page`, invisible to vector search. No error from Ollama. Enforce the chunk size limit at ingest time. Symptom check:

```sql
SELECT p.rel_path, p.source, LENGTH(p.content) AS content_len
FROM pages p
LEFT JOIN chunks c ON c.page_id = p.id
WHERE c.id IS NULL;
```

Any row here is a page with no chunks.

**Stale bind mount after remount.**

If the CIFS mount backing the source directory remounts — after a network blip or server reboot — the container holds a file descriptor to the old empty mount point. The API returns 200. The indexer runs. It finds zero files. Nothing crashes, nothing complains. Restart the container after any storage remount.

**Shallow health checks miss the real failure mode.**

`GET /ping → 200` stays green with an empty index. Real health check: call `list_sources`, assert `pageCount > 0` with a recent `lastIndexed`. You're monitoring the retrieval system, not just the process.

---

## What This Gets You

~11K chunks, query results under 100ms on commodity hardware. The Ollama embedding call is the only network hop on the hot path — ~10ms on a GPU host for a short query. The SQLite ANN index is not the bottleneck.

Hybrid search earns its keep in practice. Pure vector drifts on exact version numbers, function names, and error codes. Pure FTS misses conceptual synonyms. The blend handles both without tuning a separate retriever per query type.

The MCP wrapper means any agent that speaks the protocol can call it without any awareness of the storage layer. Add a source, re-index, done — consumers don't change.

Most databases can store embeddings at this point. The reason to reach for SQLite + sqlite-vec specifically is that you probably already have it, it requires no new infrastructure, and the FTS5 index is already there. The hybrid approach — run both searches, blend by alpha — transfers to any store that can handle both. The schema and the search logic are the portable parts.
