---
wordpress_id: 176
title: A pointless exercise
date: 2008-05-05T11:40:40+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/05/05/a-pointless-exercise.aspx
dsq_thread_id:
  - "264715686"
categories:
  - Misc
  - Rant
redirect_from: "/blogs/jimmy_bogard/archive/2008/05/05/a-pointless-exercise.aspx/"
---
I caught this last night from [Scott Hanselman](http://www.hanselman.com/blog/) on Twitter:

<http://www.betterwebapp.com/drupal/?q=screencasts>

It&#8217;s a side-by-side comparison of the time to create a simple web app for:

  * Ruby
  * Perl
  * ASP.NET
  * Java

The website compares a few other frameworks to compare which languages and frameworks are the fastest to develop against.&nbsp; Not that it matters, but ASP.NET came out on top for the simple application profile, while Python/Django came out on top for the three-tier application profile.

While viewing the screencast, all I could think was &#8220;Holy jeebus, **is there a more pointless exercise than timing the creation of software**?&#8221;&nbsp; Creating software is easy (some would say too easy).&nbsp; If our problem was &#8220;how fast can we whip out software&#8221;, the issues of today&#8217;s software developers would have been solved decades ago.

The problem is that **software maintenance dwarfs the cost of software creation**, by a factor of at least 3 to 1.&nbsp; So if we&#8217;re trying to optimize software development, isn&#8217;t it the most expensive aspect, maintenance, what we should focus on?&nbsp; We use ReSharper to optimize responsible code creation (i.e., micro-codegen vs. macro-codegen), but it also helps with responsible code maintenance through automated refactorings.&nbsp; Many other responsible engineering practices, such as [those espoused by XP](http://www.extremeprogramming.org/rules.html), aim to reduce the maintenance costs of software development.

In the end, I could care less how long it takes to slap out some sample application.&nbsp; In six years of professional development, no one has ever paid me to write an application on the level of what was demonstrated.&nbsp; Some managers will care how fast you sling code, but the smart ones care about:

  * Can the software you created be easily changed?
  * Can the software you created be easily tested?
  * Can the software you created be easily deployed?
  * Can the software you created be easily diagnosed for bugs?
  * Is the software you created correct?
  * Is the software you created what we actually need?

I&#8217;d love to see those issues in a screencast, but who would want to watch a screencast that lasted for weeks or months?