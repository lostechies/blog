---
title: 'Why not use DeepSeek Flash for everything?'
date: 2026-09-22T09:18:47+00:00
author: Ryan Svihla
layout: post
categories:
  - AI
tags:
  - AI
  - Fable
  - Benchmarking
---

I started using AI heavily when a friend [Jonathan Ellis](https://www.linkedin.com/in/jbellis/) launched his own startup [Brokk](https://brokk.ai) and I started using his then revolutionary tool [Brokk](https://github.com/BrokkAi/brokk-app) in April of 2025, at that stage basically all models were pretty terrible and things like Cursor or Claude Code were basically useless (I like to call them tooling harnesses because they hook up tools like bash, read, write, internet search to models... and that is most of what they do), so this meant we had to use the latest and greatest to ever get anything done. Brokk despite being basically unusable for a mere mortal (lesson let a designer build the UX), it was light years ahead of Claude Code and Cursor and with the top end model we could get a ton of solid generated code out of things like GPT 4 and Sonnet 3.5. They routinely invented stuff, didn't know how to look into directories etc, what we knew about prompting then was limited and in general getting good work out of them required a lot of cleverness or at least a willingness to accept really terrible code and a drop in productivity (at least in single threaded modes of work).
At least with Brokk with the tools we had built and the efficiencies we engaged in to keep the context small (the total amount of information sent to the models) we could make good use of cheaper less high end models, but generally speaking the lesson was clear, if you could afford it always use the best, or else waste a lot more time and money getting bad results out of the cheaper stuff.

Fast forward to today and even cheap models can score well on difficult coding benchmarks (source: https://deepswe.datacurve.ai/) and the results are way more about 'feel' than they are about any sort of qualitative result that one can measure easily.

[![DeepSWE v1.1 leaderboard comparing model scores with average cost per task.](/assets/why-not-use-deepseek-flash-for-everything/deepswe-snapshot.png)](/assets/why-not-use-deepseek-flash-for-everything/deepswe-snapshot.png)

*DeepSWE v1.1 score versus average cost per task, September 22, 2026 ([source](https://deepswe.datacurve.ai/)). Click the chart to view it at full size.*

This is because of a few things at once: the tooling harnesses of today all do the things Brokk was doing in 2025 and often with more quality and efficiency, the [advances](https://arxiv.org/abs/2501.12948) [in](https://aclanthology.org/2026.findings-acl.1767/) [reasoning](https://arxiv.org/abs/2607.22529), the advances in [post training](https://arxiv.org/abs/2503.14476), and [distillation becoming](https://arxiv.org/abs/2505.09388) refined to the point that [DeepSeek Flash 4.1](https://www.deepseek.com/en/news/deepseek-v4-1-flash/) which is a model that now beats Sol on our internal benchmarks and is a fraction of the estimated size of Sol.

[![Benchmark table comparing DeepSeek V4.1-Flash with DeepSeek V4-Pro and V4-Flash, GLM 5.3, Kimi K3, GPT 5.6-Sol, and Claude Opus 5.](/assets/why-not-use-deepseek-flash-for-everything/deepseek-benchmarks.png)](/assets/why-not-use-deepseek-flash-for-everything/deepseek-benchmarks.png)

*DeepSeek V4.1-Flash benchmark comparison ([source](https://www.deepseek.com/en/news/deepseek-v4-1-flash/)). Click the table to view it at full size.*

For my own experience I can tell you that:

- Fable 5.1 (Anthropic) and Astra (OpenAI) are great general purpose models and I have used them a lot, but for many tasks they vastly overengineer a solution.
- Sol (OpenAI) is overall a very good value but it also can overengineer on higher thinking levels and is sort of dumb on its default level (it works but you just need to prompt it a lot more). I do not think this is a bad choice honestly as your model for everything and between it and Luna really justifies the cheaper price.
- GLM 5.3 (Z.ai) is very capable and has been my go-to for about a month now.
- GLM 5.3 Flash (Z.ai), DeepSeek Flash v4 are both very cheap to use and for a large variety of straightforward coding or admin tasks are easily good enough.
- Recently I have been using DeepSeek Flash V4.1 and while more expensive to use than Flash v4.0 it has largely replaced most of my model usage, and next month I do not plan on renewing my Anthropic, Z.ai or OpenAI subs at the maximum level as a result.

## Conclusion

I do not actually care or think it is super important which model you use anymore, use the model that fits your style and you can afford and after that really compared to any other point prior we get very good results from nearly any provider. Use Muse, use OpenAI, use Z.ai you should be basing these differences now based on who treats you well, respects your data or [does](https://blog.ferstar.org/en/posts/zcode-silent-workspace-snapshot-upload) [not](https://thehackernews.com/2026/07/grok-build-uploads-entire-git.html). For some gnarly hard problems I will still probably reach a lot for Astra and Fable, but I doubt I will be on a 20x Max sub anymore.
