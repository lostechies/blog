---
id: 172
title: 'Legacy Operating Systems and Legacy Languages: If it ain&#8217;t broke, it still needs fixing'
date: 2011-08-25T13:39:55+00:00
author: Sharon Cichelli
layout: post
guid: http://lostechies.com/sharoncichelli/?p=172
dsq_thread_id:
  - "1091547294"
categories:
  - Refactoring
---
In my travels I&#8217;ve encountered systems chugging happily along on outdated, discontinued, unsupported technology stacks. Apps written in VB6, FoxPro, Classic ASP, still running without a hitch because the kinks had been shaken out years ago&#8230; Software users delicately avoiding upgrading their Windows 95 machine because it does what they need, in a manner they understand, running the apps they&#8217;ve built their business on&#8230; As a techie, the idea makes your hair curl, but the thing is: these applications _work_. They&#8217;ve been working, and they give the appearance of continuing to work indefinitely.

It&#8217;s an illusion, though. I sympathize with getting taken in by that illusion. After all, I&#8217;ve owned the same cell phone for seven years—I don&#8217;t mind that it doesn&#8217;t do the _latest_ stuff because it does everything I need (makes phone calls). To replace it, just because someone else has something shinier, sounds ridiculous. I&#8217;m the same way with cars, computers, furniture: I evaluate an item&#8217;s utility against my own needs, not something else&#8217;s capabilities. Taking the same view of your software applications can seem like good sense.

Here&#8217;s the difference with software. Factors outside your control can make your application stop working. This is especially true when it is running on a legacy operating system or a legacy language.

I just had a sharp lesson in this on one of my personal websites. My site uses a content-management system written in PHP, which I had allowed to drift a bit behind on version updates. Last weekend my webhost, quite reasonably, upgraded their servers with the latest stable version of PHP. They had notified me, so I was looking out for it, and sure enough: my site was broken. My outdated version of the content-management system was calling deprecated and discontinued PHP methods. To drive the lesson home, I was enough out of date that upgrading the content-management system wasn&#8217;t trivial, either. Here is a case where &#8220;if it ain&#8217;t broke&#8221; turned into &#8220;it&#8217;s broke anyway.&#8221;

Keeping software platforms current is not about wanting the latest features. It is about routine maintenance that keeps your critical systems comfortably supported. If you fall behind the pack, software patches and operating system upgrades offer no guarantees. That&#8217;s what it means when a technology is no longer supported: it means the manufacturer won&#8217;t be testing whether their latest change will impact that end-of-life technology. Complacency is perilous.

You might find it daunting to estimate the value of rewriting an application in a supported language. The cost is plain, but what is the return? It can sound like spending considerable time and resources to end up with the same feature set. In order to make an informed decision, consider what it would cost to lose the application, to have it rendered non-functional&mdash;even non-starting&mdash;by an environment change. Is the application critical to your business? Is it your business&#8217;s product? What would it cost to lose it? Keeping current is insurance against that cost.