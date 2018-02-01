---
id: 1176
title: AutoMapper 4.2.1 released – Static is back (limited) edition
date: 2016-02-24T19:56:24+00:00
author: Jimmy Bogard
layout: post
guid: https://lostechies.com/jimmybogard/?p=1176
dsq_thread_id:
  - "4608119242"
categories:
  - AutoMapper
---
After a bit of feedback and soul searching and honestly tired of dealing with questions, some of the static API is restored in this release. You can now (and in the future) use Mapper.Initialize and Mapper.Map:

[https://github.com/AutoMapper/AutoMapper/releases/tag/v4.2.1](https://github.com/AutoMapper/AutoMapper/releases/tag/v4.2.1 "https://github.com/AutoMapper/AutoMapper/releases/tag/v4.2.1")

The big pain from the static API was that the configuration could be changed at any time, and I couldn’t enforce a clear configuration step. Thinking about it, there was really nothing wrong with having a static API but just forcing you to initialize before mapping. That’s what will be allowed going forward – the instance API is now completely flushed out, and the static API is truly a thin veneer on top of it, where you call a static Initialize method instead of a constructor.

This release removes some of the obsolete attributes and restores the LINQ projections that use the static configuration.

Enjoy!