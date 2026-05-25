---
title: "Single-Shot Lies"
date: 2026-05-31T12:00:00+00:00
author: Eric Hexter
layout: post
categories:
  - AI
  - local-llm
  - benchmarks
---

_Part 3 of 5 in the [Local LLM Bench series](/erichexter/2026/05/25/local-llm-bench-part-1-which-models-can-chat/)._

gemma4:latest scored 10/10 on every test I built. Perfect chat response. Perfect code generation. Perfect tool call. Perfect instruction following. I ran it twice to be sure. Same result. So naturally, when it came time to run the first real agentic coding task, that was the model I reached for.

It produced zero lines of useful code in ten minutes.

That's the story of Phase 8, and it changed everything about how I think about model evaluation.

## The Task

The agentic benchmark I built is a CSV parser in C#. A console app that reads a file with Name and Score columns, prints the top 3 scores descending, ties broken alphabetically. Verify with `dotnet test`. The task is sized to what I'd call "stretch tier" — two projects, roughly 150 lines of code, multi-file, requires the model to scaffold a .NET solution from scratch and then implement correct logic. A competent human developer does this in about ten minutes.

The harness is aider 0.86.2 installed via `uv tools`, running headless with `--yes-always --exit --message-file`. Scoring: 60 points if the verify command passes, 20 if the model finishes in two iterations or fewer, 10 for no compile errors, 10 for clean edit format. 100 points maximum.

I ran six models: the top performers from Phase 4's single-shot benchmark plus two new additions.

## The Results

| Model | Score | Notes |
|---|---|---|
| devstral:latest | 70/100 | 5 iterations, 147 seconds |
| gemma4:latest | 20/100 | 600 second timeout, 0 turns |
| gemma4:26b | 20/100 | 600 second timeout |
| glm-4.7-flash | 20/100 | 600 second timeout |
| qwen2.5:14b | 10/100 | 91 seconds, never recovered |
| qwen3-coder:30b | 0/100 | 77 seconds, garbled output |

One passes. Five fail. The model that aced every single-shot test I designed hits its ten-minute wall and produces nothing. The model that topped the leaderboard with a perfect score is the first casualty.

devstral is, notably, marketed specifically for agentic coding loops. That framing turned out to matter.

## What Went Wrong With gemma4

gemma4:latest doesn't fail because it can't write C#. It fails because it doesn't understand that it's supposed to be writing files. When aider sends it a task, it responds with a description of what the code should look like, or it writes a fenced code block in prose, or it explains the approach in detail without producing any actual edits. I watched this happen in real time and it took longer than I'd like to admit before I understood what I was seeing. These responses look helpful if you're reading them as a chat assistant. aider can't do anything with them — it's waiting for structured edit blocks that follow its protocol, not a tutorial.

The single-shot benchmark rewarded exactly the behavior that makes gemma4 useless in an agentic loop. "Write a Python function that checks if a number is prime" — gemma4 produces clean, correct Python instantly. But that task has one shot, one context, one output. There's no concept of a multi-step session, no expectation that the model needs to write files into a directory, no loop where the model gets feedback and tries again.

Ask gemma4 to run a ten-minute coding session and it has no mental model for what "running a coding session" means. It's a very good chat assistant. That's not the same thing.

## What Went Wrong With qwen3-coder

qwen3-coder:30b scores 0/100, which looks worse than the timeout failures. It's actually more interesting. The model ran for 77 seconds before aider gave up, which means it produced output — just output that aider silently rejected as malformed edits. The code was probably fine. The format wasn't.

This is a harness compatibility problem, not a capability problem. aider expects edit blocks in specific formats — either a `diff`-style patch or a `whole`-file replacement. qwen3-coder was emitting something that resembled neither cleanly enough for aider to parse. aider's response to a malformed edit is to silently skip it, log nothing useful, and eventually exit. From the score sheet, it looks like the model produced nothing. That's not what happened.

This distinction matters, because it's a clue. If the failure is format mismatch rather than capability, changing the format instruction should fix it. I filed that away and moved on.

## What It Means

The research literature on agentic coding benchmarks describes a roughly 17% pass rate for 14-30B parameter models on what they call "stretch tier" tasks: multi-file, 150+ lines of code, multiple tool-call iterations. My six-model run hit 1-in-6. Exactly 17%.

That number didn't come from luck. It came from the same thing the research describes: most models that can answer questions well don't have a working mental model of "I am operating a computer, I need to write files, I need to keep doing work until a test passes." Those are different cognitive tasks. Single-shot chat benchmarks don't distinguish between them.

The models that time out aren't slower or dumber than devstral. They're not designed for this. gemma4 is optimized to produce a high-quality response to a question. devstral is optimized to take a task and not stop until it's done. The training objectives are different. The behavior is different. The single-shot score captures none of that.

## Where This Leaves Us

devstral finished the task with 70/100. It needed five iterations instead of two (losing 20 points on the efficiency score), but it shipped working code. None of the other five models produced a single passing test.

The 70/100 score isn't a ceiling — it's a baseline. devstral used the default aider configuration with no tuning. It worked anyway. The question is whether anything else can be made to work, or whether devstral is the only local model that can do this at all.

qwen3-coder's format failure points toward an answer. If the problem is configuration, not capability, then changing the configuration should change the result. That's the experiment Part 4 runs.

---

_Next up: [Part 4](/erichexter/2026/06/03/local-llm-bench-part-4-harness-optimization/) — one config change takes a model from 0/100 to 100/100, and the harness turns out to matter more than the model._
