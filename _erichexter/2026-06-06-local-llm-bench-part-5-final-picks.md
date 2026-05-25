---
title: "23 Models, One Weekend, Final Picks"
date: 2026-06-06T12:00:00+00:00
author: Eric Hexter
layout: post
categories:
  - AI
  - local-llm
  - benchmarks
---

_Part 5 of 5 in the [Local LLM Bench series](/erichexter/2026/05/25/local-llm-bench-part-1-which-models-can-chat/)._

The project started with ten models and two prompts. It ended with 23 models, a 13-point scoring harness, 3 Python agentic tasks, and more surprises per hour than I expected. This is the final leaderboard and the honest verdict.

## Expanding to 23 Models

After the initial ten-model run, I pulled thirteen more based on a mix of research agent recommendations and community signals. The research was right about some things and wrong about others.

It correctly killed two obvious traps. qwen2.5vl is a vision model, not a coder — the "vl" should have been the clue but I wanted confirmation. qwen3.5:27b is a thinking model that burns its token budget on internal reasoning before producing output; on 16GB VRAM with a standard context budget it hits the wall and times out on every agentic task. Both of those were correct calls.

Then there was cogito:14b. The research said: skip it, superseded, runs 2-3 points behind qwen2.5. I almost listened. What actually happened when I ran cogito: 11-second code generation on the fizzbuzz task, 100/100 agentic score, both edit formats working cleanly. The research was wrong. Cogito turned out to be the fastest sweet-spot model I tested, and it passed tasks that models with higher single-shot scores failed entirely.

Two tag hallucinations also surfaced during pulls. qwen3.5:9b doesn't exist — only the 27B is available. qwen3-vl:8b doesn't exist — only the 235B is available. The research had the right model families but invented specific version tags. The fix is always the same: check ollama.com/library before pulling. Don't trust a model recommendation that includes a specific tag without verifying.

## The Pi Harness Experiment

Alongside the expanded model pool, I tested a different agentic harness entirely. Pi is fundamentally different from aider: instead of receiving structured edit instructions, the model gets direct Bash tool access and can run `dotnet new`, `dotnet test`, and anything else itself. It operates as an autonomous loop rather than a guided editor.

I ran devstral and qwen3-coder through pi on two tasks: fizzbuzz-plus and csv-parser. Both timed out at 1020 seconds. Not close calls — full exhaustion, zero useful output across both models and both tasks.

The root cause is that pi is designed for models fine-tuned for tool-calling loops: NousResearch Hermes-class, OpenClaw, models explicitly trained to keep calling tools autonomously and self-terminate when done. Devstral and qwen3-coder via Ollama's OpenAI-compat API don't have that fine-tuning. They can use tools when prompted, but they don't have the trained instinct to keep invoking tools in sequence until a test passes.

The thing pi taught me even while failing: harness design is not neutral. An aider task prompt and a pi task prompt are different programs. The model receives different inputs, operates under different constraints, and requires different trained behaviors to succeed. A 100/100 aider score does not predict pi performance, and vice versa. If a Hermes-class model shows up in Ollama's library with solid benchmark numbers, pi is worth revisiting. Until then, aider is the right tool for local 14-30B models.

## The Scoring Expansion

The harness also grew. I extended the single-shot tests from 10 to 13 points by adding three new probes: a math word problem (3 apples at $0.50 plus 4 oranges at $0.75, reply with only the dollar amount), a JSON output test (return a JSON array of 3 programming languages, nothing else), and a sequence test (output 1 through 5, one per line, nothing else).

These three tests turned out to be more discriminating than I expected. Ten of twenty-three models fail the $4.50 math test — not because they get the arithmetic wrong, but because they reason aloud about the problem instead of answering it. The sequence test catches models that follow instructions in general but can't suppress the urge to add a brief explanation. The JSON test catches models that can't stop themselves from wrapping output in markdown fences when explicitly told not to.

None of these tests are hard. All of them reveal something real about how a model behaves when you need it to produce structured output on command.

## Three New Python Agentic Tasks

The agentic suite expanded to include three Python tasks alongside the existing C# work. The tasks: a markdown-to-html converter (implement `md_to_html()`, 10 pytest tests covering headers, bold, italic, inline code, and links), a JSON validator (implement `validate(data, schema)` returning error strings, 9 pytest cases covering required fields, type checking, and enum validation), and a word-frequency counter (implement `top_words(text, n)` returning top-N tuples sorted by count descending then alphabetically, 8 pytest cases).

I ran these on seven models: devstral, qwen3-coder, phi4, hermes3, qwen2.5-coder, mistral-small3.2, and codestral. The results reshuffled the leaderboard in ways the single-shot scores did not predict.

## The Full Leaderboard

| Model | Size | SS /13 | Chat ms | Code ms | Agentic Best | Agentic Pass% |
|---|---|---|---|---|---|---|
| gemma4:latest | ~12B | 12/13 | 6,918 | 603 | 20/100 | 0% (0/2) |
| devstral:latest | ~24B | 11/13 | 16,875 | 3,246 | 100/100 | 83% (5/6) |
| gemma4:26b | 26B | 11/13 | 11,029 | 3,255 | 20/100 | 0% (0/2) |
| qwen3.5:27b | 27B | 11/13 | 24,810 | 7,222 | 20/100 | 0% (timeout) |
| deepseek-r1:14b | 14B | 10/13 | 6,286 | 561 | — | — |
| glm-4.7-flash | 30B MoE | 10/13 | 8,843 | 2,531 | 20/100 | 0% (timeout) |
| granite4:32b-a9b-h | 32B MoE | 10/13 | 20,885 | 3,125 | 20/100 | 0% |
| qwen2.5:14b | 14B | 10/13 | 6,221 | 475 | 10/100 | 0% |
| qwen2.5vl:7b | 7B | 10/13 | 5,783 | 863 | — | — |
| qwen3-coder:30b | 30B | 10/13 | 9,948 | 2,143 | 100/100 | 67% (4/6) |
| qwen3:14b | 14B | 10/13 | 3,876 | 523 | 20/100 | 0% |
| cogito:14b | 14B | 9/13 | 6,447 | 438 | — | — |
| hermes3:latest | ~8B | 9/13 | 3,756 | 280 | 100/100 | 40% (2/5) |
| mistral-small3.2:24b | 24B | 9/13 | 12,169 | 3,228 | 100/100 | 100% (3/3) |
| mistral:latest | 7B | 8/13 | 3,335 | 323 | 20/100 | 0% |
| codestral:22b | 22B | 7/13 | 17,182 | 2,427 | 100/100 | 67% (2/3) |
| deepseek-coder-v2:16b | 16B | 7/13 | 6,516 | 298 | — | — |
| llava:7b | 7B | 7/13 | 4,045 | 292 | — | — |
| magistral:24b | 24B | 7/13 | 22,802 | 11,568 | — | — |
| gpt-oss:20b | 20B | 6/13 | 8,751 | 8,915 | 20/100 | 0% |
| phi4:14b | 14B | 6/13 | 6,415 | 466 | 100/100 | 50% (2/4) |
| qwen2.5-coder:14b | 14B | 6/13 | 5,989 | 529 | 100/100 | 100% (4/4) |
| qwen3:30b | 30B | 3/13 | 14,866 | 10,749 | — | — |

qwen3.5:27b, gpt-oss:20b, and deepseek-r1:14b are thinking models — they burn context on internal reasoning before producing visible output. The scores reflect that.

## The Surprising Results

**gemma4:latest.** 12/13 single-shot, 603ms code generation, fastest chat in its size class. Zero percent agentic pass rate across every task it attempted. This is the sharpest split in the entire dataset. gemma4 is an excellent model for answering questions. It has no working mental model of "I am in a multi-turn loop writing files until tests pass." Those are different capabilities. The single-shot tests reward the former. The agentic tasks require the latter. gemma4 nails one and is completely useless at the other.

**mistral-small3.2:24b.** I almost missed this one entirely. It had no agentic run history going into the final Python task batch — it just hadn't come up in earlier experiments. When I finally ran it, it swept all three new Python tasks with 100/100 scores on first attempt, finishing each in 26 to 52 seconds. Nine out of 13 on single-shot. It had minimal community attention during the bench period. It turned out to be one of the two most reliable agentic performers I tested. The lesson here: community signal is a useful prior, not a substitute for running the test.

**qwen2.5-coder:14b.** 6/13 on single-shot. That score is a lie in the specific direction that matters most. The instruction-following tests fail consistently. The code generation test produces output that compiles but gets the wrong answer. On every agentic task I ran it on, it passed. Four for four, 100% pass rate. The single-shot harness penalizes its tendency to reason aloud before writing code. In an agentic loop, that verbosity doesn't hurt — aider just waits for the edit block, and the edit block is correct. Single-shot actively mispredicts this model's real-world utility.

**hermes3:latest.** 280ms code generation. The fastest model in the field by a significant margin, and at 4.7GB it's the lightest serious option. 3,756ms average chat latency, also fastest. It scored 100/100 on csv-scaffolded with a 25-second wall time — another field record. Then it scored 10/100 on fizzbuzz and instant-failed on json-validator in zero turns. The inconsistency pattern makes sense for a model fine-tuned specifically for tool use and short completions: it handles the tasks that match its training profile well and falls apart outside them. For anyone doing rapid-fire chat or simple completions at scale, hermes3 is the answer. For general agentic coding, the brittleness is a real problem.

**phi4:14b.** 6/13 on single-shot; 100/100 on fizzbuzz and word-freq. It failed markdown-to-html and json-validator, and both failures have the same signature: 16 to 17% context utilization, then the output starts spiraling. phi4 has a 16K context ceiling, and tasks that grow their working context over multiple iterations hit that wall. The context limit is the only thing preventing phi4 from joining the reliable agentic tier. With 32K context or better, I'd expect it to pass everything it currently fails.

**codestral:22b.** The markdown-to-html task produced a unicode crash — aider's display layer choked on an arrow character in a CP1252 terminal. json-validator and word-freq both passed 100/100. That markdown failure is an environment bug, not a model failure. I'm counting it in the pass rate because I can't retroactively change the environment it ran in, but anyone testing codestral in a UTF-8 terminal should expect a different result.

## The Actual Picks

For coding work on a 16GB machine, the answer depends on what you're doing.

If you're working in a new codebase — multi-file, complex scaffolding, scratch-to-working-tests — use devstral:latest. It's the only model in this pool that reliably handles multi-file C# from scratch. 83% agentic pass rate across six diverse tasks spanning C# and Python. Not the fastest at 3 to 20 seconds per response, but it has the highest ceiling and it doesn't fall apart on complexity.

If you're working in an existing codebase — the actual everyday case, where you're editing files that already exist — use qwen3-coder:30b. 100/100 on Python tasks, strong on scaffolded C#, 2-second code generation. The whole edit format is mandatory; diff mode fails silently and produces nothing. Get the format right and this model is very fast for its size.

If VRAM is the constraint, use qwen2.5-coder:14b. It runs on about 9GB, which means it fits alongside other processes. It passed every agentic task I ran it on. The 6/13 single-shot score is misleading — ignore it for agentic work.

mistral-small3.2:24b is on a watch list. Three tasks run, three passed. That's not enough data to promote it above devstral for serious work, but it's enough to keep it in the rotation. If it holds 100% across ten more tasks I'll move it up.

For chat and Q&A, the picks are different. gemma4:latest for quality — 12/13, fast for its size, clean outputs. Don't use it for anything agentic. For speed, hermes3:latest at 4.7GB and 280ms code generation is the answer, especially if you're running it alongside something else or doing high-volume completions.

## What Single-Shot Scores Actually Measure

This question came up enough during the project that it deserves a direct answer.

Single-shot scores measure whether a model understands what it's being asked, can produce a well-formed response on one shot, and follows tight output constraints. That's genuinely useful for chatting, summarizing, classifying, and answering questions. The score is predictive for those tasks.

What it does not measure: will this model keep working across turns, will it understand its own previous outputs, can it handle a tool returning an unexpected result, will it know when to stop and verify rather than spiraling, can it write files instead of prose. Those are the capabilities that determine agentic performance. They don't show up in any single-prompt test because by design they can't — they require multiple turns to observe.

The practical implication is that running a 13-point single-shot harness before picking a coding model will tell you roughly nothing about whether the model can actually do the coding work. You have to run the agentic task. There is no shortcut.

## Closing

Six weeks. 23 models. 630 lines of harness code. 50+ agentic task runs. The answer to "which local model can actually code?" turns out to be a different question depending on what you mean by coding.

The model that tops the single-shot leaderboard is the one to use for chat. The model that wins at agentic coding tasks is a different model entirely. I spent a weekend thinking gemma4 was the obvious answer before it timed out on every real task I gave it.

The bench application and all results are in the repo. The harness accepts any model Ollama can serve — pull it, add an entry to the settings file, run it. The numbers here are reproducible on any machine with 16GB of VRAM. If you find something that beats devstral on multi-file from scratch, I want to know about it.
