---
wordpress_id: 26
title: “Hero Mode Refactoring” AKA Enemy Of Brown Field Development
date: 2009-08-14T06:48:56+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2009/08/14/hero-mode-refactoring-aka-enemy-of-brown-field-development.aspx
dsq_thread_id:
  - "501199320"
categories:
  - BDD
  - Brownfield
  - TDD
redirect_from: "/blogs/rssvihla/archive/2009/08/14/hero-mode-refactoring-aka-enemy-of-brown-field-development.aspx/"
---
What do I mean by “Hero Mode Refactoring”?&#160; We’ve all worked with code that wasn’t easily made testable. Most of the time we see a big ball of mud and have no idea where to begin. Sometimes however we have an epiphany, a \_great\_idea_ , a “cold fusion” moment (that ends up being poignant in so many ways).&#160; 

Filled with the excitement of our vision we dive head long into our work, replacing concrete classes with interfaces, removing big swaths of redundant code, and in general making changes you should only make with a an already unit tested code base.&#160; Before we know it, 5 things are broken in weird ways, and it now takes us days of manual verification to figure out what works and what doesn’t.&#160; That is hero mode refactoring at its best.

This situation reminds me a great deal of the difficulties I had with getting back in shape. I was a pretty decent athlete in my college days, but the real world had other ideas. Years later I tried to get back in shape several times, each time I tried my hardest right off the bat, and most of the time got injured in the process.&#160; It wasn’t until age had given me some patience that I was able to actually get back in the gym in a consistent way. I had to work on the areas I could handle in a gradual way, instead of going 100% day 1.&#160; I wasted years trying to get to 19 year old me in a month, but it only took me 6 months going the gradual way to be in decent shape.

So too our codebases will behave if we try and go full out on day 1. That code didn’t get that way overnight, and usually cannot be fixed overnight.&#160; Take a “siege” mentality into your code maintenance and realize this is a battle best fought gradually.