---
id: 128
title: FubuMVC–Action discovery
date: 2011-10-16T03:37:53+00:00
author: Josh Arnold
layout: post
guid: http://lostechies.com/josharnold/?p=128
dsq_thread_id:
  - "444655813"
categories:
  - general
tags:
  - fubumvc
---
## Overview

One of the questions I hear the most is:

> “What’s the Fubu folder structure? Where do I put controllers?”

I admit, I stumble through my answer as I say unhelpful and ambiguous things like “you can do whatever you want”. So, for those of you who have asked me and haven’t received help, consider this as me cashing in my “I owe you”.

## ActionCalls

If you haven’t learned about these yet, then you may want to get a little bit of background. I try my best to introduce the subject in my F101 video and Mike Murray gives an overview as he walks you through building your first Fubu application: <http://mvc.fubu-project.org/videos>

## Discovery

The magic of the discovery happens through one very simple interface:



Like most things used in our semantic model construction, we use this interface internally and expose a DSL for convenience. In this case, we do so via the Actions property on the FubuRegistry.

I was going to spend the time to write up about this piece, but [Chad Myers](http://lostechies.com/chadmyers/) already did: [Cool stuff in FubuMVC No. 2: Action Conventions](http://lostechies.com/chadmyers/2011/10/07/cool-stuff-in-fubumvc-no-2-action-conventions/)

The only thing I want to add is that you can register your own IActionSource implementations via the FindWith method (e.g., Actions.FindWith<MyActionSource>()).

> Note:
   
> Dependency injection is not around for the DSL pieces for FubuRegistry. However as a workaround (if you MUST),  the bootstrapping mechanism works in a way that you’ll have access to ObjectFactory inside of your action sources. It’s not ideal, but it’s there just in case you need it. 

## Piecing it together

Underneath the hood, we use the [BehaviorAggregator](https://github.com/DarthFubuMVC/fubumvc/blob/master/src/FubuMVC.Core/Registration/BehaviorAggregator.cs) class to operate on all IActionSource implementations and register a behavior chain for each call that is found.

## Why do I care?

Scanning is great and it covers you for probably 80% of all use cases (yes, I just made up that statistic). Here’s an example of when it won’t:



Maybe we want to scan our system for all of our known entity types and close on this open generic. Your best bet is to register your own action source that will do exactly that:



And that’s it. It’s simple but powerful.