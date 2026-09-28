---
wordpress_id: 1217
title: AutoMapper 5.0 Released
date: 2016-07-07T15:42:29+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1217
dsq_thread_id:
  - "4967852649"
categories:
  - AutoMapper
---
Release notes:

  * [5.0.0](https://github.com/AutoMapper/AutoMapper/releases/tag/v5.0.0)
  * [5.0.1](https://github.com/AutoMapper/AutoMapper/releases/tag/v5.0.1)

Today I pushed out [AutoMapper 5.0.1](https://www.nuget.org/packages/AutoMapper/5.0.1), the culmination of about 9 months of work from myself and many others to build a better, faster AutoMapper. Technically I pushed out a 5.0.0 package last week, but it turns out that almost nobody really pulls down beta packages to submit bugs so this package fixes the bugs reported from the 5.0.0 drop 🙂

The last 4.x release introduced an instance-based configuration model for AutoMapper, and with 5.0, we’re able to take advantage of that model to focus on speed. So [how much faster](https://lostechies.com/jimmybogard/2016/06/24/automapper-5-0-speed-increases/)? In our benchmarks, 20-50x faster. Compared to hand-rolled mappings, we’re still around 8-10x slower, mostly because we’re taking care of null references, providing diagnostics, good exception messages and more.

To get there, we’ve converted the runtime mappings to a single compiled expression, making it as blazing fast as we can. There’s still some micro-optimizations possible, which we’ll look at for the next dot release, but the gains so far have been substantial. Since compiled expressions give you zero stack trace if there’s a problem, we made sure to preserve all of the great diagnostic/error information to figure out how things went awry.

We’ve also expanded many of the configuration options, and tightened the focus. Originally, AutoMapper would do things like keep track of every single mapped object during mapping, which made mapping insanely slow. Instead, we’re putting the controls back into the developer’s hands of exactly when to use what feature, and our expression builder builds the exact mapping plan based on how you’ve configured your mappings.

This did mean some breaking changes to the API, so to help ease the transition, I’ve included a [5.0 upgrade guide in the wiki](https://github.com/AutoMapper/AutoMapper/wiki/5.0-Upgrade-Guide).

Enjoy!