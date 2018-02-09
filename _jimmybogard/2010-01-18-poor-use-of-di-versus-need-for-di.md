---
wordpress_id: 382
title: Poor use of DI versus need for DI
date: 2010-01-18T14:19:45+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/01/18/poor-use-of-di-versus-need-for-di.aspx
dsq_thread_id:
  - "268147405"
categories:
  - Design
redirect_from: "/blogs/jimmy_bogard/archive/2010/01/18/poor-use-of-di-versus-need-for-di.aspx/"
---
Surprise surprise, but Uncle Bob got the twitterverse all riled up with another opinionated post, “[Dependency Injection Inversion](http://blog.objectmentor.com/articles/2010/01/17/dependency-injection-inversion)”.&#160; His basic advice from the post on DI tools is:

> I think these frameworks are great tools. But I also think you should carefully restrict how and where you use them.

Couldn’t agree more!&#160; Every call to Container.GetInstance should be _carefully, carefully_ thought out.&#160; In fact, our goal should be to reduce the number of calls to the container to hopefully exactly one.&#160; But a slight problem with the example he gives to show that DI is not necessary in all cases:&#160; **It’s so simplistic that it no longer represents any real-world code using DI**.

Uncle Bob also prefers hand-rolled mocks, which may be an artifact of the crappiness of Java mocking tools, which in turn is a reflection of how far behind Java the language is behind C#.&#160; He also points out:

> I don’t want lots of concrete [Container] dependencies scattered through my code.

Couldn’t agree more!&#160; That’s why we limit the container calls in our application as much as possible.&#160; If I have a bunch of container calls in my code, _I’m doing something wrong_.&#160; When I read his post, I thought that they must have been looking at the MVC framework source code, one which was built with IoC hooks, but not with the Dependency Inversion Principle in mind.&#160; If I have to tell MVC that I’m using an IoC tool, it takes quite a bit of work to configure all of the places where things get instantiated manually to work.&#160; I often have to write new classes just to support IoC.&#160; Whether he meant to or not, Uncle Bob’s entire post was a straw man argument.&#160; He argues against _bad_ use of IoC, but never shows _good use_ of IoC.&#160; Which may mean that he’s never built or seen an application built well with IoC.

If you want to see an application written with DIP, IoC and Dependency Injection in mind, check out [FubuMVC](http://fubumvc.com/).&#160; One of its core principles from the get-go was “turtles, all the way down”, basically meaning that a container _will_ be used, and you _cannot_ use the application without an IoC tool.&#160; Guess what?&#160; The design is much cleaner for it.

If I want to use an IoC tool in my application, this is something that should be configured **once and only once**.&#160; If I have to plug a bunch of hooks just to say, “Yes, I am using an IoC tool”, then I haven’t really improved anything for the end user, have I?&#160; Instead, I’ve made my application favor configuration over conventions, forcing more coding and more moving parts to figure out, making it _more difficult_ to configure as needed.

So while it’s a great read and has a lot of great points, all that post showed me was that **poor use of DI leads to a poor DI experience**.