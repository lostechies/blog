---
title: Big Design Up Front Is Responsible Again
date: 2026-07-31T09:00:00+00:00
author: Eric Hexter
layout: post
categories:
  - AI
  - Software Design
  - Process
tags:
  - AI
  - Agile
  - Requirements
  - Waterfall
---
Agile taught us to avoid big design up front. That was the right call — for the constraints we had. Those constraints are gone, and I think the advice inverted.

Here's why we avoided it. Two things were slow and expensive: **writing the spec, and building the software.** Both were done by hand. So a detailed upfront design was a large bet you couldn't easily change, written before you knew if it was right. The sane response was to write less of it, ship a thin slice, and learn by building the wrong thing first. For twenty years that was the responsible move. I've shipped plenty of thin slices that discovered the wrong product — expensively — and called it agility.

AI deleted both of those costs.

Last week I designed a whole application before writing a line of it. Not a napkin sketch — a complete, traceable spec: stakeholder needs, system requirements, architecture with sequence diagrams, down to component-level tickets. Then it was rendered into a **narrated video walkthrough with real UI screens**, and I handed that to the customer to review. Pause, draw on a frame, leave a voice note.

<img src="/content/erichexter/uploads/2026/07/design-review-frame.png" alt="A design review, rendered: a real UI screen with narration, reviewed before any code was written" style="max-width:100%" />

Writing that spec used to take weeks of typing. It took hours. Building a throwaway version just to get real feedback used to be the only option. Now I get feedback on the design itself, at full fidelity, before building anything.

The part that matters: **this is not waterfall.** Waterfall failed because the big upfront design was unvalidated *and* expensive to change — by the time reality showed up, you were committed. Flip both of those. The design is now cheap to produce, cheap to change, and cheap to validate: render a new video, get feedback, re-render. That is big design up front *with* a tight feedback loop — the thing waterfall couldn't afford and agile gave up on.

Put it in a grid. Waterfall: expensive to produce, expensive to change. Agile: so skip the design. What we have now: cheap to produce, cheap to change, cheap to validate. Different quadrant. Different rules.

<img src="/content/erichexter/uploads/2026/07/design-screen-set.png" alt="A full set of designed screens generated for review before implementation" style="max-width:100%" />

So where did the bottleneck go? It was never typing. It was *typing speed* — for specs and for code — that forced us to go slow and iterate. The model writes specs at the speed of light and builds at the speed of light. The only scarce thing left is **judgment**: deciding what's right, and getting the humans aligned before you commit.

Spend your time there. Do the design work you've been skipping since 2005 — you can finally afford it. Refine it. Review it properly, with people who aren't going to read a forty-page doc but will watch a five-minute video and tell you it's wrong. Then let the model build it.

Concretely, the loop I'm running now:

1. A living spec that deepens by level — stakeholder need, system, architecture, components — each traceable to the next.
2. Every level rendered into a narrated review video, approved before the design goes deeper.
3. The final design compiles to tickets.
4. The model implements; you verify against the spec you already agreed on.

The responsible move in 2026 isn't "move fast and iterate." It's **get it right, then let the machine move fast.**
