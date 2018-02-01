---
id: 4101
title: Fighting the burn out
date: 2012-10-26T18:55:41+00:00
author: Josh Arnold
layout: post
guid: http://lostechies.com/josharnold/?p=184
dsq_thread_id:
  - "901795898"
categories:
  - general
tags:
  - fubu
---
I&#8217;ve heard quite a few people lately talk about being burned out or closing in on a burn out. I&#8217;ve even had a few people tell me they don&#8217;t do OSS because of the fear of burn out.

Developing your own framework is not for the faint of heart. Developing your own web framework is something that crazy people do. Developing your own suite of frameworks is&#8230;well, I&#8217;m not exactly sure what to think about it yet.

This morning I stumbled on the DarthFubuMVC organization page and realized that we are up to 55 public repositories. Now, not all of those repositories are frameworks or subsystems but I&#8217;m willing to bet it&#8217;s pretty close. So why do we have so many and how on earth do we find the time?

## &#8220;For Us, By Us&#8221;

Some of my friends think I&#8217;m crazy. They don&#8217;t understand why I work as hard as I do fighting a seemingly endless battle in the OSS space of the .NET world. They, among many, ask us what makes Fubu so different.

The vision of the world of Fubu is not one that I think we&#8217;ve ever documented. All of us may have variations of it but mine goes something like this:

  * There are no excuses for not having tests
  * Testing must be a first class citizen in everything that you do
  * Tests cannot and should not be brittle
  * Follow principles when they make sense (aka: &#8220;Think for yourself&#8221; or just &#8220;think&#8221;)
  * High ceremony code should never have to exist
  * Reversibility is far more important than you think

When dependencies do not conform to our vision or if they get in the way of us accomplishing our vision&#8230;we carefully reevaluate our usage of them. You can call NIH on us call you want. I simply say that we stand up for what we believe in.

## Finding the time

### Tooling matters

We&#8217;ve invested a large amount of time in tooling. This makes the act of spinning up new repositories, libraries, testing projects, and automated testing suites fairly inexpensive tasks. This is what it looks like when testing is a first class citizen.

If I have an idea, it takes minimal effort for me to spike it out in the environment that I want. I can get rapid feedback and integrate it with existing subsystems in a few minutes.

Sometimes &#8220;finding&#8221; time is a matter of investing the effort required to &#8220;make&#8221; time. Simply put: invest in your infrastructure. The ROI is a streamlined development experience that cultivates innovation.

### Context shifting

One of the hardest parts of having lots of movable pieces is keeping track of all of them. Occasionally we need to enhance something deep in the roots of Fubu. Sometimes this enhancement needs to bubble up through a couple of layers before its usable. This usually surfaces from heavier usage in other systems and the enhancement will help make testing easier. Regardless, a small task just turned into multiple context shifts.

The tooling helps make this relatively simple. Our infrastructure makes this possible by shuffling binaries (nugets) throughout our local clones of the repos. You just need to plan it out a little in your head before you do it.

This leads me to my next point. Context shifting happens to us all the time. No matter how hard we fight it, it&#8217;s just a part of our jobs. One of the best tricks that I&#8217;ve found is this:

> Before you take a break (e.g., shift contexts, quit for the day, go to lunch), write failing tests that capture what your next step was going to be.

It&#8217;s simple but it&#8217;s the fundamental principle that has kept me productive over the last year. We&#8217;ve had a lot happen in the last 12 months. I&#8217;ve had a lot of things happen to me in my personal life and this simple principle has helped keep me pushing out code.