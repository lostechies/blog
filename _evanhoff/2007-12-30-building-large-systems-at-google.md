---
id: 29
title: Building Large Systems at Google
date: 2007-12-30T22:16:00+00:00
author: Evan Hoff
layout: post
guid: /blogs/evan_hoff/archive/2007/12/30/building-large-systems-at-google.aspx
categories:
  - Uncategorized
---
I watched [this video](http://video.google.com/videoplay?docid=-5699448884004201579) very late last night&#8211;way cool.&nbsp; It&#8217;s a Google TechTalk about building very large systems.

A few things stand out to me:

  * How a large cluster of commodity machines (1000+)&nbsp;can function as a single large fault-tolerant hard drive (GFS)
  * How a large cluster of commodity machines can also function as a single large distributed computation grid

I&#8217;ve often read people talking about ultra-large scale systems where the big clusters function as a single large computer, but this video brought that point home.

It&#8217;s pretty cool to think they have abstracted a cluster as a hard drive, then abstracted on top of that to create a huge virtual machine for solving problems (executing algorithms).

Enjoy!