---
wordpress_id: 1154
title: AutoMapper 4.0 Released
date: 2015-08-05T16:46:04+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1154
dsq_thread_id:
  - "4005936702"
categories:
  - AutoMapper
---
Release notes here: https://github.com/AutoMapper/AutoMapper/releases/tag/v4.0.0

On NuGet of course.

This was a big release &#8211; I undertook the exciting challenge of supporting all the new platforms from VS 2015, and in the process, collapsed all of the projects/assemblies into exactly one assembly per target framework. It&#8217;s much easier to manage on my side with just the one project instead of many different ones:

[<img class="alignnone size-full wp-image-1155" title="Screen Shot 2015-08-05 at 11.41.22 AM" src="https://lostechies.com/content/jimmybogard/uploads/2015/08/Screen-Shot-2015-08-05-at-11.41.22-AM.png" alt="" width="742" height="476" />](https://lostechies.com/content/jimmybogard/uploads/2015/08/Screen-Shot-2015-08-05-at-11.41.22-AM.png)

I have to use compiler directives instead of feature discovery, but it&#8217;s a tradeoff I&#8217;m happy to make.

There&#8217;s a ton of small bug fixes in this release, quite a few enhancements and a few larger new features. Configuration performance went up quite a bit, and I&#8217;ve laid the groundwork to make in-memory mapping a lot faster in the future. LINQ projection has gotten to the point where you can do anything that the major query providers support.

Enjoy!
