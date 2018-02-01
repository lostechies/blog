---
id: 315
title: Beyond top-down design
date: 2009-05-20T01:35:41+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/05/19/beyond-top-down-design.aspx
dsq_thread_id:
  - "265233431"
categories:
  - Design
---
Here at Los Techies, we talk a lot about SOLID principles and design.&#160; Two of the principles that have always resonated with me are the Single Responsibility Principle and the Dependency Inversion Principle.&#160; With the two together, the need for some kind of inversion of control almost becomes required.&#160; When I first started using the DIP, I didn’t really feel the pain of locating dependencies, I always provided some no-argument constructor or the various construction patterns to get my dependencies in play.

The combination of test-driven development and SOLID led me towards a sort of default top-down design, as [Derick describes as a cloud of objects](http://www.lostechies.com/blogs/derickbailey/archive/2008/10/07/di-and-ioc-creating-and-working-with-a-cloud-of-objects.aspx).&#160; My objects take, for the vast majority, the following shape:

![](http://www.lostechies.com/blogs/derickbailey/WindowsLiveWriter/DependencyInversionAndTheCloudOfObjects_8D80/image_thumb_4.png)

This is great and all, but in some cases, the level of nesting would get completely out-of-hand.&#160; Small classes are great, but I had projects where the level of nesting hit double digits, making it quite difficult to figure out what was going on, and to understand the shape of the application.&#160; At that point, I couldn’t understand what actually happened for a given request by looking at the code, and all of this traced back to top-down design.

But it is still a vast improvement upon the big-ball-of-mud architecture I created before, yet something still bothers me.&#160; Is this all there is to good design?&#160; Top-down, TDD, with SRP and DIP creating top-level controllers, down to a bunch of supporting classes that have a single responsibility but are hard to understand in the whole?

Another issue I run into with top-down design is that I often have vertical slices of functionality, but absolutely zero re-use.&#160; I fully understand that re-use is not the motivator for creating small classes, but I still felt my application partitioned by top-level features.&#160; Sure, there might be some similarities between disparate areas of the application, but I can’t help but feeling there are other, higher-level patterns to better architect an application than purely top down design.

Right now, I have no answers, and really no idea where to look for them.&#160; I have a feeling there are some other crazy ideas out there, beyond top-down design, that I’m just not aware of.&#160; So my question is: am I imagining things, or is there something else beyond top-down design and architecture?

My only inclination of a larger picture as of this moment is Ayende’s post on [concepts and features](http://ayende.com/Blog/archive/2009/03/06/application-structure-concepts-amp-features.aspx).&#160; Much of this post (and corresponding talk at Seattle) resonated quite a bit for me, and looks like one of those ideas that can get rid of much of the orthogonal duplication amongst various features that I don’t really see.

And no, I don’t think there is a magical chapter in the [Big Blue Book](http://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215) on this one…