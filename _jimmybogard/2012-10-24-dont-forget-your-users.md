---
id: 680
title: Don’t forget your users
date: 2012-10-24T14:54:57+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2012/10/24/dont-forget-your-users/
dsq_thread_id:
  - "898316039"
categories:
  - Agile
---
Some time ago, we at [Headspring](http://www.headspring.com/) were brought in to help replace an existing legacy system based on Excel with a new web application built using the latest and greatest architectural patterns and practices. During the initial discovery phase, we spoke to both IT and the users on how they used their existing system. We found that the IT group had already built some sort of web application for the end users, which from my understanding IT believed the users were happy with.

We sat down and talked with the actual users, who painted a very different picture of their thoughts on the “improved” UI. In short:

  * Productivity was much lower
  * It drastically changed how they did their job
  * It felt forced down their throat

The reasons for moving from Excel to an online form were obvious to just about everyone, except the end users. IT’s reasons (and the manager of the user’s reasons were:

  * A single Excel doc doesn’t scale with users
  * New employees are hard to train
  * See #1

So while it was completely obvious why the existing system should be replaced, it **wasn’t a choice the existing users were happy with, or were even willing to cooperate with**.

One interesting anecdote we had was that the IT group was perplexed with the CPU usage of their new app. For about a month, CPU usage on their web server was relatively constant and low. One day, they saw a marked change. Instead of constant usage, they would see insane spikes in CPU usage at the end of the working day, for about 5 minutes, then drop to zero. Back to that in a second.

### Mind your users

The real problem here is that **with an existing user base, you have to have an actual transition plan**. Not a “surprise them one day” plan or a “we’ll show prototypes often” plan, but a real plan for how to migrate the existing users to the new application, in production. Word of warning: unless the new application demonstrably solves problems the users have and improves their daily lives, you’ll have to drag them kicking and screaming.

Looking at that CPU spike. It turns out that one enterprising user had experience with VBA, and designed a macro to use their existing spreadsheet, launch the browser using [WatiN](http://watin.org/), and fill in that annoying online form, all at the end of the day and in minutes!

Why was this better for the users? Simply because they were **much more productive in Excel**. They could use tools like dragging cells to fill in multiple items, glance at multiple rows at once, and make large-scale corrections before ultimately submitting their work as a whole. Filling in a form one row at a time was absolute torture for them!

### Planning the transition

In order to keep existing users happy, but provide a better path for new users, we had two options:

  * You may use your Excel spreadsheet and here’s an import tool
  * You may use the new web app

The import tool would run the Excel doc through domain commands, and could report validation failures back. The nice part is, some folks never needed to transition! They kept on using what made them happy and productive. What was disconcerting was the complete disconnect from what was designed and the user’s opinion of the new system.

When introducing a new system to replace a legacy one, it’s absolutely critical to **come up with a viable transition plan that shepherds the existing users into the new system**, or **provides an integration point so that they can continue forward with their existing approach**.

Unhappy users can sabotage a rollout. Plan for their transition with respect and dignity, and don’t just dismiss their frustrations. If it’s upper management doing the dismissal, it’s our duty to raise these risks and be upfront, honest and frank on what unhappy existing users can do to sink a rollout.

Just to repeat – raise these risks, be frank about the outcomes, and not in a wishy-washy way. Phrase it like this: “If we don’t provide an adequate transition plan for existing users, here’s what’s going to happen: the existing users will constantly complain, poison the well for new users, and wind up working around whatever we build anyway.” Notice I’m not talking in terms of maybe/might/perhaps. I talk about things in certain terms, because that’s what will be responded to.

Remember, **respect your users**. Ultimately, it’s their success that will pay the bills.