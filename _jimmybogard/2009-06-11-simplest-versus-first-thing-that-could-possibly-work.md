---
wordpress_id: 323
title: Simplest versus first thing that could possibly work
date: 2009-06-11T02:58:21+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/06/10/simplest-versus-first-thing-that-could-possibly-work.aspx
dsq_thread_id:
  - "265260244"
categories:
  - Design
---
One of the core [XP practices](http://www.xprogramming.com/xpmag/whatisxp.htm) that resonated with me quite early on was the concept of simple design.&#160; When I learned TDD, this practice was further refined with the concept of doing the “simplest thing that could possibly work”.&#160; To make a test pass, I would code the simplest thing that could possibly work.&#160; It takes quite a bit of discipline to adhere to this mantra of simplicity, fighting a constant urge to design something more complex than the problem at hand requires.

Browsing the XP wiki, you can find a lot of discussion of what exactly this means.&#160; TDD calls for “Red, Green, Refactor”, which might lead you to wonder why you would need to refactor after doing the simplest thing that could possibly work.&#160; It seems that the consensus formed around first performing the fewest steps, then refactoring to the fewest pieces or components.&#160; But in our quest for simplicity, I notice a second, more subtle mistake: **confusing the first thing that happens to work with the simplest thing that could possibly work**.&#160; If I choose the first thing that happens to work, my refactoring step often leads me merely to the simplest solution, but not the most elegant.

The difference between the two is easy to fix – it just requires thinking!&#160; Thinking about possible solutions, different designs, vetting alternate paths to the goal.&#160; This can be accomplished through pair programming, whiteboarding, and just about any exercise that requires us to think of at least two possible solutions before picking the winner.&#160; I don’t necessarily see this happening with _every_ possible solution, however.&#160; But some of the most awkward designs I’ve created seem to stem from just picking the first thing that works, and not doing a little thinking.

Which is quite sad, as a little effort and investment in investigating multiple designs pays off many-fold in the long run.&#160; Evolutionary design works best when we’re not stumbling in the dark, but making informed decisions with the most options as possible on the table.&#160; If this sounds something like the idea of concurrent or [set-based engineering](http://xp123.com/xplor/xp0611/index.shtml), it should!&#160; Except in this case, we perform it in the micro, at the point of every non-trivial design decision.&#160; Simplicity is not automatic, and often comes from choosing the best design from a few options.&#160; But we can’t be lazy about it, as taking just five minutes to think of a different approach can save man-hours (or days even) further down the road.