---
id: 565
title: Duke Nukem, unhappy marriages, and the Anna Karenina principle
date: 2011-12-16T14:40:14+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2011/12/16/duke-nukem-unhappy-marriages-and-the-anna-karenina-principle/
dsq_thread_id:
  - "506502964"
categories:
  - Agile
---
One of my favorite recent books I’ve read is the tome on human societies, “[Guns, Germs, and Steel: The Fates of Human Societies](http://www.amazon.com/Guns-Germs-Steel-Fates-Societies/dp/0393317552)”. In it, there is a section examining domesticable aminals. The author walks through the observation that although there are 148 big wild terrestrial herbivorous mammals, those that could _potentially_ be domesticated, only 14 animals passed the test to actually become domesticated.

The reasons for failure of those other large mammals harks back to the first line of Anna Karenina:

> Happy families are all alike; every unhappy family is unhappy in its own way.

While all 14 domesticated animals had common traits on why they were successful, each species that cannot be domesticated fails the test for some unique, specific reason. For example, zebras evidently have a nasty habit of biting people and not letting go.

Looking at software projects and the rates of failure in the industry, I think that there is a very similar phenomena: **Successful projects all have common reasons for success; failed projects each fail in their own unique, spectacular way.**

### Duke Nukem and unlimited budgets

At a No Fluff Just Stuff conference a couple of years back, the keynote speaker shared a story about a failed project. He joined the project a couple of years into the development, and the team had yet to release anything to production. He went on to detail that he was on the project another year and a half, with no production release in sight, and left the project.

This project was one of those legacy re-writes, given pretty much unlimited budget and resources, in hopes that this would produce the best possible replacement for the existing product. The project had budget, resources, executive backing and visibility, technical leadership, support from domain experts etc. etc. **Yet the project was still a colossal failure**. Why? It never released!

Looking at the infamous story of Duke Nukem Forever, I get the same impression. Fresh of the success of Duke Nukem 3D, the software team set out to create the best 3D shooter on the market. This would of course take time and budget. Both of which the team had nearly unlimited resources for. But the technology kept changing and improving underneath their feet, like that line from Alice in Wonderland:

> It takes all the running you can do, to keep in the same place. If you want to get somewhere else, you must run at least twice as fast as that!

Clearly something was missing on this project, but it wasn’t anything to do with resources. So what was missing?

### Why projects succeed

Instead of looking at the myriad of reasons for why a project could fail (I always go back to the [Classic Mistakes](http://www.stevemcconnell.com/rdenum.htm) from Steve McConnell), how about we look at successful projects and determine what commonalities these have? If we look at the domesticated animals, they all must possess these six common characteristics:

  * Diet
  * Growth Rate
  * Problems of Captive Breeding
  * Nasty Disposition
  * Tendency to Panic
  * Social Structure

That is, if any candidate for domestication fails in one of the above categories, it can’t be domesticated.

So how can we distill the common project mistakes into a set of common characteristics? Since they’re grouped in specific categories, we can trace many of these back to specific root causes:

  * Right people for the project needs
  * Right budget to achieve the project goals
  * Releasing early and often, or a deadline for delivery
  * Constant introspection to improve delivery
  * Alignment between the project sponsor, management, developers and other team members on project’s goals

If these look familiar, it’s because they pretty much make up the [iron triangle of software development](http://www.ambysoft.com/essays/brokenTriangle.html) from Scott Ambler:

![](http://www.ambysoft.com/artwork/ironTriangle.jpg)

Going in to a project, the entire team from executives to developers need to agree on the parameters of the Scope, Resources, and Schedule, and constantly introspect to make sure that the team constantly improves its ability to deliver.

I know I’m probably missing something here, but it seems that all the other project mistakes seem to stem out of a deficiency around:

  * Scope
  * Resources
  * Schedule
  * Alignment
  * Continuous Improvement

A project can succeed despite any of the Classic Mistakes, but lack of any of the above characteristics seems to doom a project to failure.