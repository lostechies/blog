---
wordpress_id: 177
title: 'PabloTV: Eliminating static dependencies screencast'
date: 2008-05-06T11:24:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/05/06/pablotv-eliminating-static-dependencies-screencast.aspx
dsq_thread_id:
  - "264715673"
categories:
  - BDD
  - LegacyCode
  - PabloTV
  - Refactoring
  - TDD
redirect_from: "/blogs/jimmy_bogard/archive/2008/05/06/pablotv-eliminating-static-dependencies-screencast.aspx/"
---
Nature abhors a vacuum.&nbsp; It turns out she also abhors static dependencies (I have my sources).&nbsp; Static dependencies are the modern-day globals, often exposed through classes named &#8220;Helper&#8221;.&nbsp; I&#8217;ve certainly been guilty of overusing static dependencies in the past, with classes like &#8220;LoggingHelper&#8221;, &#8220;SessionHelper&#8221;, &#8220;DBHelper&#8221; and so on.

The problem with static dependencies is that they are opaque to the extreme, enforcing a strong coupling that is impossible to see from users of the class.&nbsp; To demonstrate techniques for eliminating static dependencies, Ray Houston and I created a short screencast:

[Eliminating static dependencies screencast](http://screencasts.lostechies.com/screencasts/rhouston/EliminatingStaticDependencies/EliminatingStaticDependencies.htm)

Our screencast demonstrates using TDD along with ideas and techniques laid out in Michael Feathers&#8217; [Working Effectively with Legacy Code](http://www.amazon.com/Working-Effectively-Legacy-Robert-Martin/dp/0131177052) and Joshua Kerievsky&#8217;s [Refactoring to Patterns](http://www.amazon.com/Refactoring-Patterns-Addison-Wesley-Signature-Kerievsky/dp/0321213351).&nbsp; It details how to make safe, responsible changes to an existing legacy codebase, while improving the design by breaking out dependencies to a static class.

Hope you enjoy it!