---
wordpress_id: 186
title: Fubu Updates and Announcements
date: 2012-11-03T15:13:25+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=186
dsq_thread_id:
  - "912383568"
categories:
  - general
tags:
  - fubu
---
This week has not been the best week we&#8217;ve had. It&#8217;s been a constant struggle with infrastructure and I&#8217;m finding the title of my last post slightly ironic.

**Don&#8217;t let your build server run out of space**

Early this week, we discovered that our TeamCity VM had run out of disk space. As a result, the artifacts of our builds were missing/corrupted and the built-in NuGet feed that everyone has been using was reporting 404s.

We hussled to add some tooling to help us fix this issues, worked through to get most of the builds green, and called it a successful couple of days. And then it happened again.

**When will the feed be stable again?**

We&#8217;re pushing very hard to get all of the builds green again. When this happens (by the end of this weekend), you will need to update ALL of your nuget versions that you were using from our feed. The previous versions literally do not exist anymore.

**The march towards 1.0**

Jeremy and I are scheduled to give a workshop on FubuMVC at CodeMash this year. Our plan is to have Fubu&#8217;s big &#8220;1.0&#8221; release party while we&#8217;re there and celebrate the long journey to 1.0.

There are a few things left to do &#8212; the biggest being documentation which is pending my work on our FubuWorld ideas. I will be making time for this over the coming weeks because I am absolutely determined to see us hit our milestone.