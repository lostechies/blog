---
title: "Which Local Models Can Actually Code?"
date: 2026-05-25T12:00:00+00:00
author: Eric Hexter
layout: post
categories:
  - AI
  - local-llm
  - benchmarks
---

_Part 1 of 5 in the [Local LLM Bench series](/erichexter/2026/05/25/local-llm-bench-part-1-which-models-can-chat/)._

I had ten local models installed and no good answer to a simple question: which of them could actually do useful work? Chat demos are easy to fake. I wanted to know whether these models could write working code, call tools correctly, and follow instructions without needing hand-holding. The only way to find out was to run them.

## The Setup

Machine is an Alienware Windows 11 box with an RTX 5080 carrying 16GB of VRAM. Ollama is running locally, serving the following ten models:

- mistral:latest (7B)
- llava:7b (7B, vision)
- gemma4:latest (~12B)
- gemma4:26b (26B)
- qwen3:14b (14B)
- qwen3:30b (30B)
- phi4:14b (14B)
- qwen2.5:14b (14B)
- qwen2.5-coder:14b (14B, coding-focused)
- glm-4.7-flash (30B MoE)

The size range alone tells you the hardware story. Anything under about 20B fits in VRAM comfortably. The 26B and 30B models spill onto system RAM — which you feel in the latency numbers.

## First Pass: Two Prompts, PowerShell

The first script was about as minimal as it gets. Two prompts per model: "What is the capital of France?" to confirm the model is responding at all, and "Write an `is_prime()` function in Python" as a basic code generation check. No scoring, no verification — just checking that something came back.

Most models answered both prompts without incident. Then I hit the bigger ones. gemma4:26b, glm-4.7-flash, and qwen3:30b all returned empty responses. Not errors — the HTTP calls succeeded, Ollama said everything was fine, the responses just contained no text.

That took longer than it should have, and the answer was different for each model.

## The Think-Mode Wall

qwen3 models support a reasoning mode where the model works through a problem step by step before producing visible output. The reasoning tokens live inside `<think>...</think>` blocks and don't count against the response. What does count against the response is the token budget, and when I was requesting with a tight `num_predict` limit, the model was spending the entire budget on internal reasoning and returning nothing to the caller. glm-4.7-flash has its own variant of the same mode — different model family, same symptom.

The fix for both: add `"think": false` to the request body. With that flag set, qwen3:14b went from returning a blank response to producing clean, working code in about 2 seconds. The qwen3 and glm models followed.

gemma4:26b's blank responses were a separate problem entirely. At 26B it spills to RAM, and with a tight `num_predict` budget and slow generation speed, the script's read timeout was firing before any tokens arrived. More headroom fixed it.

The lesson here is that "model returned empty string" and "model failed" are not the same thing, and you have to understand what each model family expects before you can interpret the output.

## Tool-Calling: Where Things Got Interesting

Once the basic chat and code tests were passing, I added a tool-calling test. The prompt was "What's the weather in Paris?" with a `get_weather` function schema attached to the request. A model that handles tool calling correctly should stop generating text and instead emit a structured `tool_calls` object pointing at `get_weather` with the right argument. A model that doesn't understand the protocol either returns prose ("I don't have access to weather data"), returns a JSON blob as plain text, or refuses the request entirely with an HTTP 400.

The results split into three clear buckets. mistral, gemma4 (both sizes), qwen3:14b, qwen2.5:14b, and glm-4.7-flash all produced proper structured `tool_calls`. That is the expected behavior — the model uses the tool schema as intended.

qwen2.5-coder:14b was the interesting failure. It returned what looked like a tool call, but as a raw JSON string embedded in the message content rather than as a structured `tool_calls` entry. The model clearly understood what was being asked; it just didn't output it in the right format. A "coder" model is not necessarily a "tool-aware" model. They are different capabilities.

llava:7b and phi4:14b both returned HTTP 400 on any request that included the `tools` field. Those models simply do not accept the parameter — the API rejects it before the model even sees the prompt. llava makes sense here: it is a vision model, not a chat/agent model. phi4 is less obvious.

## Mid-Phase Additions

While working through these tests I pulled in three more models that had come up in research as strong candidates for coding benchmarks: devstral:latest (22B, Devstral Small — Mistral's coding-focused release), qwen3-coder:30b (~30B, Qwen's coding-tuned variant), and gpt-oss:20b (~20B). All three were added before the formal scoring phase started.

## The Baseline Table

Here is where every model stood after the initial phase — response times are wall-clock from the PowerShell script, rounded to the nearest second:

| Model | Size | Chat | Code | Tool call | Notes |
|---|---|---|---|---|---|
| mistral:latest | 7B | 3s | 1s | proper | |
| llava:7b | 7B | 4s | <1s | rejected | Vision model |
| gemma4:latest | ~12B | 6s | 1s | proper | |
| qwen3:14b | 14B | 4s | 1s | proper | think=false required |
| phi4:14b | 14B | 5s | 1s | rejected | |
| qwen2.5:14b | 14B | 6s | 1s | proper | |
| qwen2.5-coder:14b | 14B | 6s | 1s | text (not structured) | "coder" does not mean tool-aware |
| gemma4:26b | 26B | 9s | 3s | proper | Partial CPU offload |
| glm-4.7-flash | 30B MoE | 8s | 4s | proper | |
| qwen3:30b | 30B | 14s | 8s | proper | Slowest in pool |

The latency numbers tell one story — size matters, mostly predictably. The tool-call column tells another: ten models, three different behaviors from the same input, and two of them would silently fail in any agentic loop that expected structured output.

## What "Works" Actually Means

The issue with this baseline is that "passes" hides a lot. A model that returns a tool call in the message content instead of the `tool_calls` field looks fine until your application tries to deserialize the response. A model that works at `num_predict=300` might silently truncate at `num_predict=100`. A model that answers "capital of France" correctly might write Python `is_prime()` that has an off-by-one error nobody noticed because nobody ran it.

Everything in this phase was manual inspection. I was reading outputs and deciding they looked reasonable. That is not a test; that is a vibe check.

The only way to actually know whether a model can write working code is to compile and run the code. Which meant building something more serious.

---

_Next up: [Part 2](/erichexter/2026/05/28/local-llm-bench-part-2-building-the-harness/) covers building the .NET 10 benchmark harness — including a scoring system that actually executes model-generated C# and runs the tests._
