---
wordpress_id: 546
title: The last vestiges of Hungarian notation
date: 2011-11-09T14:35:50+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/11/09/the-last-vestiges-of-hungarian-notation/
dsq_thread_id:
  - "466328208"
categories:
  - Rant
---
Certain arguments seem to resurface every few years, like whether or not to use a mocking framework, and more recently on Twitter on why .NET still uses [Hungarian notation](http://en.wikipedia.org/wiki/Hungarian_notation) in a few select cases, namely:

  * Interfaces
  * Generic type parameter names

The argument against Hungarian notation in these cases is that it adds nothing to the equation, and is not self-consistent. We don’t prefix Enums with “E”, classes with “C”, structs with “S”, delegates with “D” and so on. Why are these two special?

I’ve seen perfectly valid arguments on both sides on why these two have special rules, and personally, it’s never really bothered me. But for .NET, **those arguing that we should ditch Hungarian for these two cases are missing the point**.

The train for picking different naming styles for interfaces and generic type parameter names left the station a long, long time ago. **That ship has sailed**. Picking a different naming convention that goes against years and years of prior art, established conventions and expectations is OK if you’re the only one who’s ever going to look at your code.

If you do decide to ignore a decade of convention, you’re also deciding to irritate and confuse every .NET developer that reads your code when you’re done. Because every time someone else sees that interface without the “I”, the question will always come up on why that decision was made. Unless you’re just a complete sadist, just stick with the convention, please?