---
id: 302
title: Quality against a deadline
date: 2009-04-09T01:37:44+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/04/08/quality-against-a-deadline.aspx
dsq_thread_id:
  - "264716105"
categories:
  - Process
---
Parkinson’s Law states:

> Work expands so as to fill the time available for its completion.

With one week iterations on an XP team, we really don’t have that problem.&#160; On previous teams, with lengthy six month waterfall cycles, work might get completed in a month or less, but we had to do _something_ until launch night.&#160; Re-work our builds, adding coverage, refactoring, improving automation, refactoring, refactoring, refactoring.

But with such a short cycle time, there’s not much time to fill.&#160; Up against a hard deadline though, I’ve found a corollary:

> Quality decreases as a deadline looms

As a hard deadline looms, it doesn’t seem to matter what our practices are.&#160; Every team I’ve ever worked on has cut corners when up against a hard, important deadline.&#160; At some point, the value of our quality-control measures, whether it’s CI, gated builds, unit testing, or avoidance of hacks, all seem to whither away when a deadline that we _can’t_ miss comes up.

And I’m fine with this.

At some point, we have to realize that there is value in delivery, and a goal beyond our own measures for success.&#160; We as developers know what it takes to create maintainable software, but maintainability is merely a goal that must be considered along with all the other business goals at hand.&#160; Now, in my book, maintainability is a goal of the utmost importance for many projects, especially projects of any significant size or duration.

But what if we’re in a situation where marketing materials, advertisements, and printed stock all point to a release date?&#160; These types of materials must be set up months in advance, much larger than our iteration size.&#160; So what are we to do if the hard release date comes calling, and we’re not quite finished?

Many hard decisions are to be made at this time, but if we can see the light at the end of the tunnel (a VERY important if), I see it as our duty to sacrifice quality in the interest of a deadline.

### Frequent deadlines

I’ve also worked at places where management abused this duty, and imposed frequent hard deadlines upon us in order to prod us into sacrificing quality and our free time more and more often.&#160; In these cases, it’s also our duty to push back in favor of a larger, sustainable goal.

It’s too often that we get caught up in our own myopia – not seeing the larger goal at hand.&#160; Part of this problem is management, in not defining and translating larger goals into tangible team goals, but it’s just as much a developer’s fault, wanting to be master of their own local domain.

As much as it pains me to do so, I still have to recognize when it’s time to just get the product out the door, and skip the quality control at the moment.&#160; As long as I effectively communicate these risks to the decision makers, I’ll sleep well at night.&#160; Because when you put quality up against a big deadline, the deadline _always_ wins.