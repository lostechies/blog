---
id: 237
title: Lessons from refactoring two year old code
date: 2012-12-16T22:59:10+00:00
author: Josh Arnold
layout: post
guid: http://lostechies.com/josharnold/?p=237
dsq_thread_id:
  - "978010225"
categories:
  - general
tags:
  - Testing
---
About two years ago I took my first swing at FubuValidation and FubuMVC.Validation. Jeremy and I have been playing chicken on a cleanup of both of them for a long time now. Thankfully, two years later, I finally found the time/motivation/energy to dive in and take care of some nasty old code.&nbsp; I’ve found it very freeing to dive in and chainsaw the majority of everything I did.

I’ll try my best to keep this specific and not too philosophical but I still wanted to share a few of my observations so far. Here it goes:

**1. Clumsy and brittle tests**

When you try to adhere to all those crazy principles and maximum flexibility, yada yada…it’s easy to completely miss the mark with regards to usability of your API. Knowing my approach to testing at the time I can safely say that the usability of your API is directly related to the quality of your tests (over time). That is, if your tests are brittle and hard to read…chances are, your usability sucks.

**2. Most of the time, lots of code means you’re doing it wrong**

There are times when you’re tackling a problem that will result in a ton of code. On the other hand, I’m a student of the school of thought that says “your first idea isn’t necessarily the best one”. I’m not the smartest guy (and I’m quite aware of this) so my first ideas are usually pretty…well, they’re usually trash. It takes a few iterations for me to simplify it. Without using the API (through vigorous testing), there’s just no way to see how it’s going to end up.

**3. Dogfooding is critical**

Cliché, but it still counts. 

**4. YAGNI, YAGNI, YAGNI**

I’m horrible at this. I think “Oh, surely someone would want THIS, and THIS, and THAT!”. Pick the simplest possible thing that can work and work it until its done. Make sure your tests can hold up, aren’t terribly brittle, and you can iterate fast. When you get a request or you hit the need yourself (\*ahem\* dogfooding), then you add it in.

The key here is to never be afraid to reevaluate your design. That’s typically the driving force behind me adding far too much fluff.