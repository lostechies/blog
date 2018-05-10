---
wordpress_id: 215
title: A lesson in automated testing via SlickGrid
date: 2012-11-23T16:30:01+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=215
dsq_thread_id:
  - "939637719"
categories:
  - general
tags:
  - automated-testing
  - fubumvc
  - serenity
  - Testing
---
### Overview

Some time ago I became absolutely obsessed with testing – automated testing to be more specific. While I mostly blame <a title="Jeremy Miller" href="http://jeremydmiller.com/" target="_blank">Jeremy Miller</a> for drilling the concepts and values into my skull, I’ve recently started wondering what changed in me. Where was the “ah-ha” moment? And then it finally hit me:

> Automated testing (for me) has always involved far too much friction.

My development career has been a continuous mission to remove friction and avoid it at all costs. Rather than striving for quality in the realm of automated testing, I avoided the friction.

_Until I learned how to do it [“the Fubu way”](https://lostechies.com/josharnold/2012/11/16/automated-testing-with-fubumvc-storyteller-and-serenity/)._

As a result of some reflection over this last year, I’ve settled on one point that I feel is pivotal for frictionless testing.

### Invest in your tests

In our last project, my team spent a significant portion of our development efforts working on testing infrastructure. This infrastructure allowed us to accomplish the things we needed to write our tests quickly but it was no small undertaking**. It paid off. Big time. We were able to add complex tests and build up an extremely extensive suite of regression tests.

My point is that if your team requires infrastructure for testing that does not exist, don’t be afraid to invest the time to create it. Believe it or not, there are areas of automated testing that have not yet been explored.

> ** Of course, the benefit to YOU is that this infrastructure is available to you via our Serenity project <img class="wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="/content/josharnold/uploads/2012/11/wlEmoticon-winkingsmile.png" alt="Winking smile" />

### The principle in action

In our current project we are working with SlickGrid. Luckily, we had a bit of infrastructure in place for working with it through Jeremy’s work on FubuMVC.Diagnostics which gave birth to the FubuMVC.SlickGrid project. This let us get up and running fairly quickly with a very basic grid. So we could render a grid from our read model. Great. Now what about testing?

Let me give you a little context here. This isn’t a grid with 4-5 columns. No, we have 72 columns. Each of which are displayed in various contexts (named groups, only columns with errors, etc.). We spiked out a couple of tests with StoryTeller/Serenity but it quickly became apparent that we needed to invest some time for this.

We needed the ability to programmatically point at particular rows in the grid. It wasn’t always as simple as “the row with this ID”, either. Naturally, FubuMVC.SlickGrid.Serenity was born.

The SlickGrid + Serenity project gives you helpers that hang off of the IWebDriver interface. The main “brain” is found in the GridAction<T> class that let’s you do stuff like this:
  


You can access the underlying formatters, editors, and interact with the grid. More importantly, you can do all of that making use of the **strongly-typed model** that powers the conventions of the grid.

### Wrapping up

Too often I see developers bumping into walls with frameworks, tools, and approaches that limit testing. The limits rarely make it impossible to test but the friction involved with the testing serves as a strong demotivator. Testing is a hard discipline to get your team to follow. The last thing you need is to make it needlessly hard and painful.