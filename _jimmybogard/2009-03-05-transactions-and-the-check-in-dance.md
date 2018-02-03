---
wordpress_id: 290
title: Transactions and the check-in dance
date: 2009-03-05T14:28:31+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/03/05/transactions-and-the-check-in-dance.aspx
dsq_thread_id:
  - "264716090"
categories:
  - ContinuousIntegration
---
At our current project, I’m on the largest individual team I’ve ever worked for.&#160; I’ve been in larger groups working on the same codebase, but not where everyone was actually committing code every day.&#160; One thing that’s been a constant for me in XP/Agile teams is CI and the [check-in dance](http://codebetter.com/blogs/jeremy.miller/archive/2005/07/25/129797.aspx).&#160; The check-in dance is roughly as follows:

  * Update from source control
  * Merge any conflicts
  * Run the local build (NOT just compile)
  * If success, commit
  * Make sure automated build succeeds

The check-in dance is transactional, where it all succeeds or it all fails.&#160; If the automated build fails, we roll back the previous commit.

Transactions can use a variety of concurrency to manage conflicts.&#160; In our case, for whatever reason, we used pessimistic concurrency around our check-in dance transaction.&#160; Pessimistic concurrency means we establish a “lock” on committing, and no one else can integrate during the time we commit.

As those familiar with database transactions can attest, pessimistic concurrency can hinder performance when many people want to change the same data, as additional requests have to be queued up until the transaction is complete.

What this meant for _our_ team was that the end of the day was not too much fun.&#160; Since we have a large team, the chances are pretty high that at least a handful of folks want to check in at the end of the day.&#160; Since each check-in dance can take up to 10 minutes of update, merge, build, commit, we had a lot of waiting at the end of the day.

At the recent ALT.NET conference, Ayende suggested that we move to a looser, optimistic model.&#160; Instead of locking the check-in dance process, we would let anyone commit at any time, and just deal with merge conflicts as they occur.

This works because our source control (SVN) detects conflicts on commit, and will fail a commit if the local version does not match the server version.&#160; We’ve been on the optimistic concurrency mode for the past few days, and lock contention has definitely gone down.

The only thing we really need to worry about is making breaking changes to core models.&#160; Since we no longer put a locked boundary on updates and commits, the probability goes up that someone commits _after_ I update, and introduces a change that breaks me that I’m not aware of.

We do have two things on our side here: team communication and the automated build.&#160; Rolling back a commit is annoying, but only takes about a minute.&#160; We can also give each other the heads up when we’re about to introduce a breaking change.

To be honest, the next time someone announces they have a breaking change, you can be sure that I’m going to try and slip my commit in before theirs, because that’s how I roll.