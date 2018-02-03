---
wordpress_id: 985
title: MediatR hits 1.0
date: 2014-12-17T14:45:53+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=985
dsq_thread_id:
  - "3333454845"
categories:
  - Architecture
---
I’ve been using a project I wrote/borrowed/stole from a number of internal projects and [existing libraries](https://github.com/mhinze/ShortBus) (thanks Matt) for well over a year now, and are releasing to 1.0. [MediatR](https://github.com/jbogard/MediatR) helps turn complex code into simplified request/response interactions, encapsulating queries, commands and notifications into a single, simple interface, collapsing complex controllers into simple pass-throughs to the real work being done:

[gist id=8034310]

MediatR lets you send a request to a single handler:

[gist id=9c8c822878bcdcd7f8d1]

Or do it asynchronously:

[gist id=bc056d7f122af32c8288]

Or send a notification to a number of handlers:

[gist id=c67c8d224ba29f466437]

I’ve talked about the [advantages to this pattern](http://lostechies.com/jimmybogard/2014/09/09/tackling-cross-cutting-concerns-with-a-mediator-pipeline/) many times, and we use this pattern on nearly every project we encounter these days. The goal of MediatR was to create a small, unambitious implementation of the Mediator pattern, tied only to the [Common Service Locator](https://commonservicelocator.codeplex.com/) library for instantiating handlers and portable, so it works on just about every platform checkbox I could check, including Xamarin.

The GitHub repo has [examples](https://github.com/jbogard/MediatR/tree/master/src) for plugging in all the major containers, and the [wiki](https://github.com/jbogard/MediatR/wiki) has documentation. Although the library uses Common Service Locator, it’s completely DI friendly too. Ultimately, the compositional tool is your container, and MediatR merely provides the mediation from message A to handler of A. Enjoy!