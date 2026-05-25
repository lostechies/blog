---
title: "The Config That Changed Everything"
date: 2026-06-03T12:00:00+00:00
author: Eric Hexter
layout: post
categories:
  - AI
  - local-llm
  - benchmarks
---

_Part 4 of 5 in the [Local LLM Bench series](/erichexter/2026/05/25/local-llm-bench-part-1-which-models-can-chat/)._

After Part 3's 1-in-6 pass rate, I had a theory about qwen3-coder. The model scored 0/100 not because it couldn't write C#, but because aider couldn't parse what it wrote. If the failure was format mismatch, then fixing the format should fix the score.

I was right. One line in a YAML file took qwen3-coder:30b from 0/100 to 100/100. Twenty-six seconds. Same model, same task, same hardware.

That result rewrites how I think about local model evaluation.

## The edit_format Lever

aider supports two primary edit modes. In `diff` mode, the model sends back git-style patches — only the changed lines, with surrounding context. In `whole` mode, the model sends back the entire file contents. These are not stylistic preferences. They require completely different output from the model, and models are not equally capable of both.

The research I ran before Phase 9 turned up a finding I didn't take seriously enough at the time: "harness mismatch is bigger than model choice." One real-world study cited 6x performance variation purely from harness configuration changes, holding the model constant. I read that and thought it was probably overstated. Then I ran the A/B.

The `.aider.model.settings.yml` file lets you configure per-model settings. The critical field is `edit_format`. Here's what qwen3-coder's entry looks like after the fix:

```yaml
- name: ollama_chat/qwen3-coder:30b
  edit_format: whole
  use_repo_map: false
  extra_params:
    num_ctx: 65536
```

Before this change: `edit_format` was unset, defaulting to `diff`. After: `whole`. The model behavior changes completely.

## The A/B Results

I ran six models against both formats on the fizzbuzz-plus sweet-spot task:

| Model | whole | diff |
|---|---|---|
| qwen3-coder:30b | 100/100 (26s) | 0/100 FAIL |
| devstral:latest | 100/100 (53s) | 100/100 (98s) |
| qwen2.5-coder:14b | 100/100 (73s) | 100/100 (65s) |
| gpt-oss:20b | 20/100 FAIL | 20/100 FAIL |
| qwen3:14b | 20/100 FAIL | 20/100 FAIL |
| mistral:latest | 20/100 FAIL | 20/100 FAIL |

Three models work. Three models don't. The format A/B cleanly separates the populations. gpt-oss, qwen3:14b, and mistral fail in both formats — those are genuine capability problems, not configuration problems. qwen3-coder was a false negative: the code was right, the format was wrong, the score said zero.

devstral and qwen2.5-coder work in both formats, which tells you something about their training. They've been explicitly tuned to produce structured edit blocks. qwen3-coder has not — or at least not in the diff format aider expects. Switching to whole file output removes the constraint entirely: just dump the file, let aider handle the diff computation. qwen3-coder is very good at writing complete, correct files.

## The Thinking-Mode Problem

Three models that looked promising on paper — gpt-oss:20b, deepseek-r1:14b, and qwen3.5:27b — share a different failure mode. They all run in "thinking mode": before producing any code output, they generate thousands of internal reasoning tokens. On single-shot tasks this is invisible; the `<think>` block appears in a separate field and the user only sees the final answer. On an agentic task with a 300-second timeout, the thinking block alone can exhaust the budget.

gpt-oss, deepseek-r1, and qwen3.5 all timeout at zero turns — the model thought itself to death before writing a single line of code.

The fix for qwen3 models (not qwen3.5, which has different training) is a `/no_think` prefix in the aider system prompt:

```yaml
- name: ollama_chat/qwen3:14b
  edit_format: whole
  system_prompt_prefix: "/no_think"
  use_temperature: 0.7
  extra_params:
    num_ctx: 32768
    top_p: 0.8
    top_k: 20
```

This worked for qwen3:14b and qwen3:30b. It does nothing for qwen3.5 — different model family, different training, the prefix is ignored. qwen3.5:27b is a 17GB model on 16GB VRAM, so it's partially spilling to RAM anyway. At mixed CPU/GPU generation speed with a thinking block running first, it cannot produce useful output inside 300 seconds. The hardware ceiling and the thinking penalty compound each other. Model eliminated.

## The num_ctx Revelation

Ollama's default context window is 2048 tokens. That's not 2048 for the task — that's 2048 for the entire conversation, including the system prompt, the file content, the task description, and every prior exchange. For an agentic coding session where aider is sending file contents back and forth, 2048 fills in two or three turns. After that, the model is working with a truncated view of its own conversation. It starts looping, contradicting itself, or deleting code it just wrote.

Ollama doesn't warn you when it truncates. It silently discards the oldest tokens and keeps going. The model's outputs start looking confused on turn three and you assume it's a capability problem. It isn't.

Setting `num_ctx: 32768` (or 65536 for the larger models) unlocks stable multi-turn behavior. Several failures that looked like model confusion were actually context truncation. The fix is one line per model in the YAML.

## The Architect Mode Dead End

I wanted to test whether combining two models — one to plan, one to implement — could improve results on stretch-tier tasks. aider calls this "architect mode." In principle: the architect model breaks the task into pieces, the editor model writes the code, and the combination should outperform either alone. It's a reasonable theory. The machine had other plans.

Loading two 14-17GB models on 16GB VRAM means constant unloading and reloading. Every time control switches from architect to editor, Ollama has to evict one model and load the other. That swap is not fast. I ran devstral + qwen3-coder and devstral + qwen2.5-coder. Both pairs hit the five-minute timeout at zero turns. The entire budget went to model swap overhead before a single tool call completed.

Architect mode requires both models to be co-resident in VRAM. On 16GB, that means two models totaling at most 16GB, which limits you to two 7B models — too small to be useful on complex tasks. The minimum viable VRAM for architect mode with 14B+ models is 32GB. Below that, single-model runs strictly better.

## The Scaffolding Experiment

After the format A/B produced clear winners, I wanted to understand what was really limiting the failing models on the csv-parser task. The task asked models to build a C# console app and test project from scratch — which means creating `.csproj` files, a solution file, adding project references, restoring NuGet packages, and then writing correct C#. That's two separate problems: .NET project plumbing and C# logic.

I split them apart. The scaffolded version of the task pre-creates everything: both `.csproj` files with correct `net10.0` targets, a `Program.cs` entry point the model doesn't touch, a stub `CsvProcessor.cs` with a TODO comment, a test project with a NuGet reference already wired, and stub test method shells. `dotnet restore` runs before the model starts. The model's job is to implement one static method and fill in five test bodies.

| Model | From-scratch | Scaffolded | Change |
|---|---|---|---|
| devstral:latest | 70/100 | 90/100 | +20 |
| qwen3-coder:30b | 0/100 | 90/100 | +90 |
| cogito:14b | 0/100 | 10/100 | +10 |
| granite4:32b-a9b-h | 0/100 | 10/100 | +10 |

qwen3-coder was never broken. Its 0/100 on the from-scratch task was entirely a scaffolding failure. It doesn't know how to create a .NET solution structure from the command line — that's a DevOps problem, not a C# problem. Given the structure, it writes correct C# and correct tests in one shot, in 56 seconds. That's four times faster than devstral on the same task.

cogito:14b and granite4:32b-a9b-h still fail on the scaffolded version. Their problem is C# reasoning, not project structure. The scaffolding experiment drew a clean line between the two failure modes.

The practical implication: if you're deploying these models on an existing codebase — the actual real-world use case — the scaffolding problem doesn't exist. The codebase is already there. qwen3-coder becomes a genuine competitor to devstral for existing-codebase work.

## Where the Leaderboard Stands

After format configuration, context window fixes, and scaffolding experiments, the picture looks like this:

For sweet-spot tasks (one or two files, existing codebase, 80-120 lines of code): qwen3-coder:30b at 26 seconds, cogito:14b at 11 seconds on both formats, devstral at 53 seconds, mistral-small3.2:24b at 44 seconds, and qwen2.5-coder:14b at 73 seconds. Five models that work reliably.

For multi-file from scratch: devstral:latest, confirmed against eight challengers. No other local model in this weight class completes the csv-parser task reliably regardless of configuration.

Eliminated regardless of configuration: gemma4 (all variants), glm-4.7-flash, qwen2.5:14b, qwen3:14b, qwen3.5:27b, deepseek-r1, gpt-oss, magistral — all timeout or fail in both formats. These aren't configuration problems. They're either the wrong model type (thinking models on a 16GB budget), capability gaps, or both.

The 6x performance variation claim from the research turned out to be conservative in at least one case. qwen3-coder went from zero to perfect. You can't express that as a multiplier.

---

_Next up: [Part 5](/erichexter/2026/06/06/local-llm-bench-part-5-final-picks/) — expanding the model pool, three surprise entries that research told me to skip, and the final leaderboard after 23 models across six weeks of testing._
