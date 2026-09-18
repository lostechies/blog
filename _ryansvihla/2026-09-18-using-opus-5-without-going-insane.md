---
title: 'Using Opus 5 Without Going Insane'
date: 2026-09-18T14:00:00+00:00
author: Ryan Svihla
layout: post
categories:
  - AI
tags:
  - AI
  - Claude
  - Opus 5
  - Coding Agents
---

I've been using Opus 5 as my daily driver for a few weeks now across a bunch of projects and it's a really capable model, but it has two habits that drove me a little nuts before I figured out how to deal with them:

1. It is verbose in a way that actually hides the answer. You ask a yes or no question and get four paragraphs of context, a code snippet, a caveat, and then the answer somewhere in the middle.
2. When it doesn't understand something it does not go look it up, it guesses, and then it builds a lot of confident sounding structure on top of the guess.

This isn't a post about whether Opus 5 is good or not (it is), it's strictly what I do day to day to keep it useful. None of this is clever, most of it is just repeating yourself.

## Start with a CLAUDE.md

The first thing I did was put a global CLAUDE.md in place (~/.claude/CLAUDE.md) that tries to head off the verbosity before it starts. This is the current version, warts and all:

```markdown
# Global instructions

## Be brief
- Answer the question asked, then stop. No preamble, no recap, no summary of what you just did.
- Default to a few sentences. Drop headers, bold, and bullet lists unless the content is genuinely a list.
- Do not restate the user's question back to them.
- Do not offer next steps unless asked.
- No trailing coda. Do not end with a "one thing I didn't do" / "note that" / "caveat" paragraph. If a limitation matters, state it inline where it's relevant, in one clause. If it doesn't matter, leave it out.
- Banned openers for a closing paragraph, no exceptions: "One thing worth deciding", "One thing worth noting", "Worth noting", "Worth flagging", "One caveat", "Separately", "For what it's worth". If you catch yourself starting a final paragraph with any of these, delete the paragraph. Do not rephrase it to evade the list -- the ban is on appending a postscript the user did not ask for, not on those specific words.
- This applies to unsolicited future-work suggestions too. If the answer is done, stop at the answer.

## Never claim credit
- Never say you already had an idea, thought of it first, suggested it earlier, or were about to do it.
- If the user proposes something, implement it. Do not annotate it with your prior reasoning.
- Never describe your own earlier messages as having been right. If a correction is needed, state the fact, not who found it.
- Do not narrate your process or reasoning quality, positively or negatively.

## Verify before asserting
- Never state how code behaves without reading it. "It's not in this repo" is not a stopping point — find the source and read it.
- Never invent a critique, a self-criticism, or an account of what happened earlier. If you are describing the past, quote it or do not claim it.
```

A few notes on why it looks like that:

* The "banned openers" list is there because I kept getting a trailing "One thing worth noting..." paragraph on literally every response, and telling it not to add caveats just made it rephrase the caveat. Listing the exact phrases and saying don't rephrase to evade the list was what finally worked (mostly).
* "Never claim credit" is there because it has a habit of annotating your idea with "as I suggested earlier" which is both annoying and frequently not true.
* "Verify before asserting" is the docs point below in a different form. It will happily tell you how some library behaves without ever having opened the library.

This gets you maybe 70% of the way there. The rest you do it live.

## Simplify, simplify, simplify

Even with the CLAUDE.md in place it'll drift back into long confusing answers, especially when the question has any nuance to it. If I do not understand what it is saying, or there are too many conflicting items in the response, I tell it to simplify and repeat until it is down to the level of directness I actually need. Some real prompts from my history:

I asked why some tests were Unix only and got this:

> Because the worker doesn't run on Windows at all. The worker is the process that actually hosts an agent session, and its whole runtime is `#[cfg(unix)]` — the sub-agent socket is just one piece of it.
>
> The code says so directly, at `mj-worker/src/mcp_stdio.rs:297`:
>
> > Workers run on Unix; the servers compile everywhere so the CLI stays one shape, and say plainly where they cannot run.
>
> That's the design: Windows builds the same CLI so the commands are identical, and the worker-side functions are stubs that return a clear error instead of silently missing. The transport itself is a Unix domain socket via `std::os::unix::net`, which Rust's standard library only provides on Unix.
>
> I didn't make that call — it predates this work. My change only lined up two test helpers with the gate their subject already had.

This giant wall of text seemed just unnecessary to parse, it had a lot repetition, and some uncessary data, qualifications ("That's the design", "the transport itself", "the servers compile everywhere") so I just said `simplify` and got this:

> Mjolnir's worker only runs on Unix by design. Windows gets the CLI, not the worker. So sub-agent code on Windows is stubs that return "needs a Unix platform."

WAY more parsable without a lot of garbage, I took this in and saved myself some Ulysses level parsing of text. Here is another one, this time I asked if we could use a different approach to read usage numbers on Mac:

> No — `claude -p /usage` has no parser here. `successful_refresh_output` (`mj-controller/src/claude_usage.rs:197`) only checks the exit status; nothing reads its stdout, and the module header already calls print-mode usage output approximate. Switching mac to it means writing a text parser for an unstable format and getting worse numbers.
>
> The gap isn't the API, it's where the token comes from. `read_credentials` only reads `<home>/.credentials.json`. On macOS the same `{"claudeAiOauth": {...}}` JSON is in the Keychain under `Claude Code-credentials` — `setup.rs:451` already reads it with `security find-generic-password -s "Claude Code-credentials" -w`, and its comment notes that `security` is pre-authorized for the item so it raises no prompt. That blob feeds `oauth_access_token` unchanged.
>
> There's a third source too: `mj login --setup-token` stores a long-lived token at `claude_oauth_token_path(profile_id)`, which sessions use via `apply_claude_setup_token` but quota never reads.
>
> So the fix I'd make is a source chain for the usage API — credentials file, then the stored setup token, then the macOS Keychain — leaving `claude -p /usage` doing only what it does now, forcing a refresh. Want me to implement that?

Again a lot of noise, uncessary information and just a lot to parse for a simple question, instead of making my head hurt figuring out if it actually answered my question, I just said `simpler too much fluff`:

> No. Nothing parses that output — `successful_refresh_output` only checks the exit code.
>
> On mac the token is in the Keychain in the same JSON shape the API path already parses. Fall back to `security find-generic-password -s "Claude Code-credentials" -w` when `.credentials.json` is missing. Want that?

I will be honest I did more rounds after this. The short answer was still wrong, but at least I was sure now.

Some notes:

* It usually takes two or three rounds.
* The shorter answer is almost always the same answer with less around it, so you are not losing anything.
* If it is still confusing after a few rounds it is probably not a verbosity problem, it does not understand the question. In that case I give it the structure I want (a numbered list, a table, an `a -> b -> c` chain) and have it fill that in rather than letting it pick how to lay the answer out.

## Make it read the docs

The other thing is it will implement against a library or an API from memory, and its memory is often out of date or just wrong for anything outside the popular parts of the API. It does not go look unless you tell it to, so I always tell it to. Some real prompts:

```
read this https://<docs url>
```

```
can you look at the sdk docs for <X> and look at the release notes for <X> then look at
the feature set for <Y> and try and find any gaps in the new functionality
```

```
you can search the web for <X>, you will need to do so to find the <X> source and docs
```

```
I mean can you read the <X> sdk surely we can start the server with some flag or something
```

The last one was after it told me something was not supported. It was supported, it was in the docs, it just had not read them.

### My advice

* Give it the actual URL, it will fetch it. If the docs are in a repo tell it to clone the repo and read the source.
* When it says something is not possible ask if it read the docs first.
* The "Verify before asserting" section in the CLAUDE.md above helps some but does not replace saying it in the prompt.

## Summary

That is really it. Tell it to simplify until you can read the answer, and tell it to read the docs before it writes code against them. Boring but simple, and then the model is genuinely very solid and will do often do proper implementatios.
