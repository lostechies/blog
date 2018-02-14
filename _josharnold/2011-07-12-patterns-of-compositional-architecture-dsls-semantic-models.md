---
wordpress_id: 34
title: 'Patterns of Compositional Architecture: DSLs &#8211; Semantic Models'
date: 2011-07-12T05:17:31+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=34
dsq_thread_id:
  - "355936923"
categories:
  - general
tags:
  - architecture
  - composition
  - composition-patterns
  - design
  - dsls
  - fubumvc
  - Patterns
---
> This is the third post in the [Patterns of Compositional Architecture series](http://lostechies.com/josharnold/tag/composition-patterns/) that I mentioned in my [introductory post](http://lostechies.com/josharnold/2011/07/09/patterns-of-compositional-architecture/).

## Prerequisites

Before reading this post, please read the [introductory post to Domain Specific Languages](http://lostechies.com/josharnold/2011/07/11/patterns-of-compositional-architecture-domain-specific-languages/).

## The Pattern

Separate the concerns of an API by separating its configuration-time activities from runtime activities.

## Overview

The implementation of this pattern aims to keep configuration concerns separate from runtime concerns. This is typically accomplished by modeling your runtime as more of a meta view of the participants. By this I mean, take the time to describe the configuration of your runtime components.

## Pattern in Action

This is a primitive example but it is an example nonetheless. Let’s say we’re interested in converting values to strings. We use this runtime interface and supporting types to do so:



We employ a [basic policy pattern here](http://lostechies.com/josharnold/2011/07/09/patterns-of-compositional-architecture-policies) used within the consumer of this interface. As you can guess, we’re interested in having multiple policies:



Let’s create a way of modeling these:



Let&#8217;s take a second here to discuss the StringifierDef. We’re using this class to specify one of two things that are mutually exclusive: either a type is specified or the value is. Sure, we could create a better data structure for this but let’s keep it simple for this example.

> Why would you want to want to specify the type instead of just supply the value? Leave the answer in the comments <img class="wlEmoticon wlEmoticon-winkingsmile" style="border-style: none;" src="/content/josharnold/uploads/2011/07/wlEmoticon-winkingsmile.png" alt="Winking smile" />

The runtime class that we’re most concerned with in this example is the Stringifier – the consumer of all IStringifier implementations. The configuration of these implementations is not the concern of the Stringifier as it explicitly states by defining them as a dependency.

Once we have our StringifierModel properly constructed, we can register the implementations with our IoC container to teach it how to build up a properly configured Stringifier instance.

We’ll discuss the benefits of this separation more in the next post on Registries.

## Real-World Example

You’ve seen the pattern with a primitive example. Let’s wrap it up by showing off an example of where we use it in FubuMVC.

#### The Semantic Model

[BehaviorGraph](https://github.com/DarthFubuMVC/fubumvc/blob/master/src/FubuMVC.Core/Registration/BehaviorGraph.cs). This class contains anything and everything related to FubuMVC’s configuration model. You’ll notice upon close examination that the only behavior it provides as an API is manipulating the configuration (e.g., adding chains, finding chains).

> I know that this post is vague. I did not introduce a lot of “meat” in this post on purpose as it is better suited to be explained in the subsequent posts. Please bear with me and I will try my best to bring it all together by using the same example for each section.