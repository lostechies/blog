---
id: 1186
title: AutoMapper 5.0 Beta released
date: 2016-05-18T18:21:04+00:00
author: Jimmy Bogard
layout: post
guid: https://lostechies.com/jimmybogard/?p=1186
dsq_thread_id:
  - "4838151787"
categories:
  - AutoMapper
---
This week marks a huge milestone in AutoMapper-land, the [beta release of the 5.0](https://github.com/AutoMapper/AutoMapper/releases/tag/v5.0.0-beta-1) work we’ve been doing over the last many, many months.

In the previous release, 4.2.1, I obsoleted much of the dynamic configuration API in favor of an explicit configuration step. That means you only get to use “Mapper.Initialize” or “new MapperConfiguration”. You can still use a static Mapper.Map call, or create a new Mapper object “new Mapper(configuration)”. The last 4.x release really paved the way to have a static and instance API that were lockstep with each other.

In previous versions of AutoMapper, you could call “Mapper.CreateMap” anywhere in your code. This made two things difficult: performance optimization and dependent configuration. You could get all sorts of weird bugs if you called the configuration in the “wrong” order.

But that’s gone. In AutoMapper 5.0, the configuration is broken into two steps:

  1. Gather configuration
  2. Apply configuration in the correct order

By applying the configuration in the correct order, we can ensure that there’s no order dependency in your configuration, we handle all of that for you. It seems silly in hindsight, but at this point the API inside of AutoMapper is strictly segregated between “DSL API”, “Configuration” and “Execution”. By separating all of these into individual steps, we were able to do something rather interesting.

With AutoMapper 5.0, we are able to build execution plans based on type map configuration to explicitly map based on exactly your configuration. In previous versions, we would have to re-assess decisions every single time we mapped, resulting in huge performance hits. Things like “do you have a condition configured” and so on.

A strict separation meant we could overhaul the entire execution engine, so that each map is a precisely built expression tree only containing the mapping logic you’ve configured. The end result is a **10X performance boost in speed**, but without sacrificing all of the runtime exception logic that makes AutoMapper so useful.

One problem with raw expression trees is that if there’s an exception, you’re left with no stack trace. When we built up our execution plan in an expression tree, we made sure to keep those good parts of capturing context when there’s a problem so that you know exactly which property in exactly which point in the mapping had a problem.

Along with the performance issues, we tightened up quite a bit of the API, making configuration consistent throughout. Additionally, a couple of added benefits moving to expressions:

  * ITypeConverter and IValueResolver are both generic, making it very straightforward to build custom resolvers
  * Supporting open generic type converters with one or two parameters

Overall, it’s been a release full of things I’ve wanted to tackle for years but never quite got the design right. Special thanks to [TylerCarlson1](https://github.com/TylerCarlson1) and [lbargaoanu](https://github.com/lbargaoanu), both of whom passed the 100 commit mark to AutoMapper.