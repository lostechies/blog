---
wordpress_id: 171
title: Auto-mocking container pitfalls?
date: 2008-04-21T23:57:20+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/04/21/auto-mocking-container-pitfalls.aspx
dsq_thread_id:
  - "272825560"
categories:
  - TDD
  - Tools
redirect_from: "/blogs/jimmy_bogard/archive/2008/04/21/auto-mocking-container-pitfalls.aspx/"
---
I&#8217;m taking a closer look at the auto-mocking container idea, specifically as we&#8217;re including it in the upcoming release of NBehave.&nbsp; I&#8217;m a little wary of prolonged use, but wanted to get some feedback (it&#8217;s also on the ALT.NET message board).&nbsp; Some pitfalls I thought of offhand were:

  * Can allow dependencies to get out of hand
  * Can hide a code smell where you have too many dependencies
  * Forces a reliance on an IoC container for all creation, inside and outside of tests

Specifically the one I&#8217;m most worried about is making it too easy to add a bunch of dependencies and creating god-classes that have too much responsibility and coordinate too much.&nbsp; If I hide that complication in a unit test, it might be perpetuating a bad design.

On the other hand, plenty of design patterns exist to help hide that problem, including creation methods, factory methods, factories and abstract factories.&nbsp; But I&#8217;m thinking I might rather have those abstract away the &#8220;what and how&#8221; than &#8220;just too many dependencies&#8221;.

Finally, AMC could be another sharp tool in the toolbox.&nbsp; It can cut you if you&#8217;re inexperienced, but sometimes it can make the job much easier.&nbsp; Luckily, no mistake is ever more than an iteration&#8217;s length away from reversal.&nbsp; I&#8217;m going to proceed carefully, mindful of the pitfalls I think I might land in.