---
wordpress_id: 34
title: The Monolith
date: 2008-01-10T01:29:03+00:00
author: Evan Hoff
layout: post
wordpress_guid: /blogs/evan_hoff/archive/2008/01/09/the-monolith.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/evan_hoff/archive/2008/01/09/the-monolith.aspx/"
---
The Monolith is probably one of the most common ways people structure systems these days. <img style="margin: 25px" height="280" src="https://lostechies.com/blogs/evan_hoff/WindowsLiveWriter/TheMonolith_117A4/sunset_boulder1_thumb3.jpg" width="400" align="right" />While this is probably a valid way to build a large majority of small systems, for others, it causes quite a bit of pain.&nbsp; I would imagine a large number of people don&#8217;t realize that it&#8217;s not the only way to build systems.

Your typical n-tier or client/server system is a monolith.

Let&#8217;s look at a few characteristics of the Monolith:

  * Is hard to integrate.&nbsp; The Monolith prefers to be an island of data.&nbsp; When the technical problems of integration are solved, you still have data ownership issues.
  * Is a poor&nbsp;base for a product line.&nbsp; Putting pebbles on top does not result in a system with a Cohesive View.
  * Is hard to scale.&nbsp; This usually isn&#8217;t an issue until it&#8217;s already too late.
  * Is easy to grasp mentally.&nbsp; This is a positive aspect of the monolith.&nbsp; Developers are inherently familiar with it.
  * Is cheaper and faster to build initially than its non-monolith counterparts
  * Large changes must be made at design time by a developer
  * Reusing internal assets is tedious and requires much effort
  * Will succeed or fail as a single unit
  * Can not be used to mitigate&nbsp;against a risky&nbsp;language or runtime platform
  * Platform or language&nbsp;migrations must happen all at once.&nbsp; Rewrites are all or nothing.
  * Must be versioned and deployed as a whole
  * If selling or deploying for multiple user bases, it represents a one-size fits all solution
  * May exhibit design-time modularity, but not runtime modularity
  * Is either fully available (up) or completely unavailable (down)

In terms of business concerns, we can characterize the monolith as:

  * Quicker to market (than it&#8217;s non-monolith counterparts)
  * Targeting related markets is slow and/or hard as it requires building new monoliths
  * Acquiring new monoliths often results in a non-cohesive mess
  * Will likely require a full rewrite at a point in its future (even in an Agile team).&nbsp; This means a shorter lifetime.&nbsp; A shorter lifetime means the costs must be recouped over a shorter period of time.
  * Tied to a particular customer size.&nbsp; If the monolith targets the large customer base, it will likely be unwieldy and/or too costly for small customers.&nbsp; If targeted at small customers, the reverse is true.&nbsp; One size fits all.

If I had to guess, I would say that monoliths are often built even when they do not provide a good fit for the System, Product, or Business Needs.&nbsp; Building a non-monolith system requires a shift in thinking&#8211;a shift that&#8217;s not always quite so obvious at first.