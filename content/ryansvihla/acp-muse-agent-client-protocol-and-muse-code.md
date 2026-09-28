---
title: "Acp Muse Agent Client Protocol and Muse Code"
date: 2026-09-28T12:38:15+02:00
draft: true
categories:
  - AI
tags:
  - AI
  - Muse
  - Agent Client Protocol

---

At [work](https://slopcop.com/) we tend to try every new model and vendor we can so we know what the state of the art is. Enter [Muse Code](https://dev.meta.ai/docs/muse-code), the models are fast, cheap and pretty capable. For $50 a month you get more credits than I can spend, and for API usage there is a 92-95% discount letting them train on your data. TLDR this is a ton of value you get out of the models from [Meta](https://about.meta.com/). So I went ahead and created [Muse ACP](https://github.com/BrokkAi/muse-acp) and my employer was nice enough to let me work on it at work time and now it is a part of several of our projects.

## What is ACP?

[Agent Client Protocol](https://www.agentclientprotocol.com) is an interaction standard to that one can wire up ACP clients (TUI, Text Editor, Batch Processes, Personal Assistants) to an AI agent that has implemented the same protocol. Many Agents provide this out of the box such as [Hermes](https://github.com/NousResearch/hermes-agent) via `hermes acp`, [Opencode](https://opencode.ai) via `opencode acp`, you get the pattern, however as of yet Muse Code does not ship one, so I made one. 

Because of this one can easily hookup Hermes, Opencode or any of the other dozens of clients in the [registry](https://agentclientprotocol.com/get-started/registry) to [IntelliJ](https://www.jetbrains.com/idea/), [Zed](https://zed.dev/), or any number of the clients I have written like [Micro ACP](https://github.com/BrokkAi/micro-acp), [Belgr](https://github.com/foundev/belgr), or [Mjolnir](https://github.com/BrokkAi/mjolnir).

Now there is a registry, but I have personally found it a real and total pain to get into, so I have chosen to ignore it for Muse ACP until I get enough popularity that someone else adds my ACP server to it (10 stars and counting). It is also easy to add custom clients and I have add an installer for IntelliJ and Zed with Muse ACP (muse-acp install) so that you can try this out with your favorite editor.

## Why Muse ACP and not one of the others 

When I started the project there were no mature ACP servers using [Muse Session Protocol](https://meta-models.github.io/muse-code-sdk/next/guides/msp-concepts/) as the integration point. Also, it is written in Rust instead of Typescript and that is for some people a good reason to prefer the BrokkAi version of the rest.

## Conclusion

If you want access to a cheap capable model, go ahead and sign up for a Muse Code subscription plan and give Muse ACP a try, wire it up to your favorite editor or one of mine and get to work.
