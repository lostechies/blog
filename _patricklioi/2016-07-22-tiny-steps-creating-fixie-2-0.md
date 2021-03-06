---
wordpress_id: 249
title: 'Tiny Steps: Creating Fixie 2.0'
date: 2016-07-22T13:40:39+00:00
author: Patrick Lioi
layout: post
wordpress_guid: https://lostechies.com/patricklioi/?p=249
dsq_thread_id:
  - "5005795999"
categories:
  - Uncategorized
---
With the recent release of .NET Core, it&#8217;s time to upgrade the [Fixie test framework](https://fixie.github.io/). Fixie needs to support the new project structure, tooling, and cross-platform behavior introduced by .NET Core: not only should developers of this project benefit from all the new things, but more importantly end users should also be able to use Fixie to test their own .NET Core projects, and even do so while developing them outside of Windows. That&#8217;s no small feat. Right now, I&#8217;m about halfway through that effort, which you can track on [Fixie&#8217;s GitHub issue #145](https://github.com/fixie/fixie/issues/145). For the bigger picture, see the new [Roadmap](https://github.com/fixie/fixie/wiki).

Recently, I gave a talk about .NET Core and the challenges it poses for test frameworks like this one.

&#8212; Well, that&#8217;s a lie. &#8212;

It&#8217;s not about that at all. It&#8217;s _really_ about how to recognize a big family of architectural problems in software projects, and how to go about solving those problems in tiny steps:



[Tiny Steps &#8211; Creating Fixie 2](https://vimeo.com/175828748) from [Patrick Lioi](https://vimeo.com/user54647440) on [Vimeo](https://vimeo.com).