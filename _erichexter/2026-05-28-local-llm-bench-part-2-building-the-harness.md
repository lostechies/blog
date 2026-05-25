---
title: "Building a .NET 10 Benchmark Harness"
date: 2026-05-28T12:00:00+00:00
author: Eric Hexter
layout: post
categories:
  - AI
  - local-llm
  - benchmarks
---

_Part 2 of 5 in the [Local LLM Bench series](/erichexter/2026/05/25/local-llm-bench-part-1-which-models-can-chat/)._

The PowerShell script from part one did its job. It surfaced the think-mode problem, sorted out which models could call tools, and gave me rough latency numbers. But it could not tell me whether the code models wrote was actually correct — I was reading output and deciding it looked fine, which is not the same thing as running it.

What I needed was a harness that ran models against defined tasks, verified the outputs mechanically, and produced a repeatable score. I'm a C# developer. .NET 10 was already on the machine. The choice was not a choice.

## Architecture

The project is a .NET 10 console application. The core pieces are:

**OllamaRunner** is a thin HTTP wrapper around Ollama's `/api/generate` and `/api/chat` endpoints. Every request goes out with `temperature=0`, `seed=42`, and `think=false`. Temperature zero makes results deterministic enough to compare across runs. The seed locks that in further. The `think` flag is false by default — models that need it explicitly will be detected and handled.

**RoslynEvaluator** handles the `SumEvens` code test in-process. It takes whatever the model returns, strips any markdown fences, wraps the bare method in a class, and hands it to the Roslyn CSharp scripting API to compile and execute. If it compiles and `SumEvens(new[] {1,2,3,4,5})` returns 6, the model passes. This runs entirely in memory with no disk I/O and no subprocess.

**TempProjectRunner** is where it gets more serious. This component scaffolds actual temporary `dotnet` projects, writes model-generated code into them, builds them with `dotnet build`, and runs them with `dotnet run`. It checks stdout for the expected output. For the test suite portion, it scaffolds a second project alongside the first, adds a project reference, drops in model-generated xUnit test code, and runs `dotnet test`. Every project is cleaned up from the temp directory when the run completes.

**Scorer** orchestrates the sequence — chat test, code test, tool test, instruction test, reasoning test, JSON output test, sequence test, Hello World test — and assembles the results into a `ModelResult` record.

**ModelResult** is a straightforward C# record type. Every boolean metric is a property; `TotalScore` is a computed getter that sums them. The record also carries timing in milliseconds for each test category and a `ThinkRequired` flag that is informational only and does not affect the score.

**ConsoleReporter** prints the final table to the terminal with ANSI color coding. **ResultStore** writes the raw results to `results/model-results.json` and a human-readable markdown ledger to `results/RESULTS.md` after each run.

## The Code Tests

The first code test is `SumEvens`: write a C# method that takes `IEnumerable<int>` and returns the sum of even numbers. Return only the method, no class, no namespace, no explanation. This is deliberately narrow. The narrow scope is the point — it is testing whether a model can follow output constraints and write code that compiles and produces correct results, not whether it can write impressive prose around the code.

RoslynEvaluator wraps the method in a class, invokes it with `{1, 2, 3, 4, 5}`, and checks that the result is 6. Compile error means the model scores zero on both compile and correct. Compiles but returns the wrong number means compile point awarded, correct point denied. Compiles and returns 6 means full credit.

## Hello World: The Real Test

The Hello World test is where I learned something useful. The prompt asks the model to write a complete C# console application: a `Greeter` class with a public static `GetGreeting()` method that returns `"Hello, World!"`, plus a Main method or top-level statements that calls it and prints the result. Separately, it asks the model to write xUnit tests for that `Greeter` class.

TempProjectRunner scaffolds a `dotnet new console` project, replaces `Program.cs` with whatever the model generated, runs `dotnet build`, then `dotnet run`, and checks stdout for `"Hello, World!"`. For the test portion, it scaffolds a `dotnet new xunit` project in the same temp directory, adds a project reference to the app, drops in the model's test code as `GreeterTests.cs`, runs `dotnet build`, and then `dotnet test`.

This turns out to be an excellent proxy for whether a model understands C# project structure. Writing a method is straightforward. Writing a complete application that builds from scratch against a specific framework target, with a class in a form that a separately compiled test project can reference — that is a different problem. Models that understand C# project conventions get it right on the first try. Models that pattern-match on superficial features tend to include the wrong using statements, declare the class in a namespace that the test code does not account for, or produce an entry point that conflicts with the `Greeter` class definition.

Each step is gated: if the app does not compile, neither the output check nor the test run happens. If the tests do not compile, the pass/fail result is not recorded. Partial credit is possible — a model can build the app but write tests that compile and then fail at runtime, earning two of the four Hello World points.

## Scoring

The 10-point scoring breakdown for the initial complete run:

| Category | Points |
|---|---|
| Chat response (non-empty, sensible) | 1 |
| SumEvens compiles | 1 |
| SumEvens correct | 1 |
| Tool call supported (not HTTP 400) | 1 |
| Tool call valid (structured, correct function) | 1 |
| Instruction followed (exactly three words) | 1 |
| Hello World app compiles | 1 |
| Hello World app correct output | 1 |
| Hello World tests compile | 1 |
| Hello World tests pass | 1 |

After the initial runs I extended the suite with three more tests, bringing the maximum to 13: a reasoning test (a word problem with an exact numeric answer — $4.50, no other text), a JSON output test (produce a valid JSON array of at least three programming language names), and a sequence test (output the numbers 1 through 5, one per line, nothing else). All three are binary pass/fail with no partial credit. The reasoning and sequence tests catch models that ignore output constraints even when the constraint is explicit. Several did.

## Unit Tests

The test project covers 13 cases across five test classes. `ModelResultTests` verifies that the scoring logic is correct — all true returns the expected sum, all false returns zero, `ThinkRequired` does not affect the score. `RoslynEvaluatorTests` covers the markdown fence stripping and three evaluation cases: correct implementation, wrong result, and garbage input. `ScorerTests` uses a `MockRunner` that replays canned responses and verifies that the Scorer assembles the `ModelResult` correctly for the pass case, the tool-rejected case, and the instruction-failure case. `ConsoleReporterTests` confirms that `PrintTable` does not throw with null prior results or when a model has regressed since the previous run.

None of these tests require a running Ollama instance. The mock runner pattern makes the Scorer fully testable without any external dependencies.

## First Complete Run

Thirteen models, ten metrics each. This is what came back:

| Model | Score | Notes |
|---|---|---|
| gemma4:latest | 10/10 | Clean sweep |
| glm-4.7-flash | 9/10 | |
| gemma4:26b | 8/10 | |
| qwen2.5:14b | 8/10 | |
| devstral:latest | 7/10 | |
| qwen3-coder:30b | 7/10 | |
| qwen3:14b | 7/10 | |
| mistral:latest | 6/10 | |
| gpt-oss:20b | 5/10 | think_required detected |
| phi4:14b | 5/10 | |
| llava:7b | 5/10 | |
| qwen2.5-coder:14b | 4/10 | |
| qwen3:30b | 3/10 | |

gemma4:latest — a ~12B parameter model — scores 10 out of 10. It answers the chat question, writes `SumEvens` correctly, emits a proper tool call, follows the three-word instruction, builds the Hello World app, writes tests that compile and pass, gets the math problem right, produces valid JSON, and outputs the sequence with no extra text. On every metric the harness defines, it is the best model in the pool by a clean margin over everything larger than it.

The result is worth sitting with. A model less than half the size of qwen3:30b outscores it by seven points. glm-4.7-flash is a 30B MoE and comes in second at 9/10. The coding-focused variants — qwen2.5-coder and qwen3-coder — score lower than their general-purpose counterparts at similar sizes.

The obvious interpretation is that gemma4:latest is simply the best model here. The problem is that the harness measures what I built the harness to measure. Before drawing that conclusion, I need to know whether these metrics are the right metrics.

---

_Next up: [Part 3](/erichexter/2026/05/31/local-llm-bench-part-3-single-shot-lies/) digs into what the scores actually mean — and why gemma4:latest's clean sweep turned out to be almost entirely beside the point._
