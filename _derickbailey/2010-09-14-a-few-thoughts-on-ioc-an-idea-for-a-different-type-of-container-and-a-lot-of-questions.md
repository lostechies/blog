---
id: 181
title: A Few Thoughts On IoC, An Idea For A different Type Of Container, And A Lot Of Questions
date: 2010-09-14T20:18:38+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/09/14/a-few-thoughts-on-ioc-an-idea-for-a-different-type-of-container-and-a-lot-of-questions.aspx
dsq_thread_id:
  - "263850117"
categories:
  - .NET
  - 'C#'
  - Compact Framework
  - Pragmatism
  - Productivity
  - Quality
---
With all the comments on my previous post, there actually is a lot of great insight to be had. I’ve picked up on a few underlying themes and several of the commenters were able to cut through the cruft of my post and post something meaningful, driving to the heart of what I was asking instead of just addressing the surface level issues (I seem to have a hard time getting to the heart of the matter without going through the superficial examples first).

Some of the things I’ve taken away from this conversation include:

  * We are abusing the interface construct in C#, slapping a header interface on everything so it plays nice with IoC containers
  * We are abusing IoC containers and getting lazy in our design, creating more of a mess than we should by having absolutely everything go through the container. We trade understandability for a false sense of modularity and “good” design when we do this
  * We should be looking at all forms of abstraction for our dependencies, includes callable objects (Delegates in .NET – which I use a lot, but never thought of as a dependency for IoC). I’m also interested in an IoC container that would make delegate injection a first class part of IoC in C#. Does something like this exist? Greg Long mentioned Autofac might be able to do something like this. Can anyone confirm?

(Now I’m not saying these take-aways are absolutes or anything… but I feel that they at least apply to the work that I’ve been doing recently, and probably to a larger part of the .NET community as well.)

In addition to these things, I’ve been having various conversations with my coworkers and others on the issues of IoC and general performance problems in Compact Framework. I’ve been working with Ninject in Compact Framework for some time now, and while I appreciate what it does for us, I have a hard time accepting the performance problems that it brings along. Reflection in Compact Framework is terrible, and the amount of code required for an IoC container to spin up an instance is also an issue to be considered. It takes a long time for the container to be configured and a relatively long time for the container to return the objects that we need (this is not a slight against Ninject by any means. It’s simply the reality of the limited resources and capabilities of the Compact Framework and Windows Mobile 5 / 6 devices). 

My boss has suggested a few times, that it would be great to have the design time benefits of IoC but the run time benefits of hard coding the instantiation of the objects we need – to have an IoC container that that would swap out the reflection and “magic” during the build process, for factory classes that are hard coded to the specific dependencies. This would give us the benefit of being able to design a modular system in C# using all the abstractions that we’re used to, but cut down on the run time performance penalties. Of course, this would not be without trade-offs. For example, we would not be able to do contextual resolution or swap out components at run time. But then, I honestly don’t know that I need those capabilities. I so rarely do that, that I’m fairly certain I can design my way out of that situation – even if the design becomes a little less than “perfect” in those situations.

Is this something that would have any traction? Is it something that would be possible? Is it something that has been done before, tried before, etc? I think it would at least benefit my work in the Compact Framework… but I’m not even sure where to begin on trying to experiment with this.

I’m really just tossing out ideas here to see if anything sticks. I don’t know if this would send me down a path of stupid, obtuse code and destroy the modularity and design that I’m looking for. I don’t know if it’s reasonable to expect these things to work in C# or other .NET languages, either. But I’m interested in hearing what others think, what may already be out there, and most of all I’m interested in moving forward with design, expressiveness, modularity, and understanding.