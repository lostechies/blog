---
id: 243
title: Hail to the king, baby!
date: 2008-10-27T10:36:22+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/10/27/hail-to-the-king-baby.aspx
dsq_thread_id:
  - "265811750"
categories:
  - StructureMap
---
Looks like [StructureMap 2.5 dropped](http://codebetter.com/blogs/jeremy.miller/archive/2008/10/26/structuremap-2-5-is-released.aspx) this weekend.&#160; Which is nice, as we’ve been running off of the trunk for around six months.

On a side note, I never really \*openly\* mocked the release as the Duke Nukem Forever release, just some friendly banter on the Twitter, some local lunches, maybe at a conference or two.

Even if you’re not into IoC Containers or specifically Structure Map, I’d also highly suggest taking a look at the ObjectFactory.Initialize call and its options.&#160; It’s a great case study on Internal DSLs, aka Fluent Interfaces.&#160; It uses quite a few techniques that show up on [Fowler’s WIP DSL book site](http://martinfowler.com/dslwip/), including Expression Builder, Method Chaining, Nested Function/Nested Closure, and Parse Tree Manipulation.&#160; Structure Map wins out over most, if not all other .NET IoC Containers, simply by ease of configuration.&#160; You’re not forced to create named instances, and you’re not forced to register every component explicitly.

Let’s rock.