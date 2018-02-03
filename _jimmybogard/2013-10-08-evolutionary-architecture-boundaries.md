---
wordpress_id: 832
title: Evolutionary architecture boundaries
date: 2013-10-08T13:31:07+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=832
dsq_thread_id:
  - "1836397228"
categories:
  - Architecture
  - Design
---
At Headspring, we’re fairly obstinate in our approach in evolving a system’s design and architecture over time. As a consulting company, we get to see a LOT of different codebases, and while it may be selection bias, we are generally presented with existing systems and codebases in advanced stages of decline and decay.

It’s why we strive to counter what I consider [long-tail design](http://lostechies.com/jimmybogard/2013/10/01/curbing-long-tail-design/), where a team implements new designs for new features but never goes back to existing features. But terms like “design” and “architecture” are a bit nebulous, what kinds of changes are we talking about?

A team I once visited has no less than four (!) different ORMs in a single solution:

  * NHibernate
  * Entity Framework
  * LINQ to SQL
  * Massive

Another team I visited had three different validation frameworks:

  * Data Annotations
  * Castle Validators
  * Fluent Validation

Another team I visited had different unit testing frameworks. Another had three different abstractions on calling web services. Another had three different naming conventions in their DB schema. Another had two different ways of managing CSS/JS assets. Another had two different ways of designing DDD entities.

The kicker here is that none of these are necessarily bad decisions. Decisions require a context, and it’s that context that gives us constraints on how we should responsibly innovate.

**The boundary for consistency in design and architecture is the application/solution/repository boundary, with repository being the ideal.** If I’m inside a repository (the boundary of versioning software), I strive for consistency in my design and approaches. The reasoning is simple – if I’m changing an application, I have to have a reasonable understanding of the design, conventions and architecture before making changes. This is where merely having tests isn’t enough.

A motley design with 100% coverage is still hard to maintain. It’s hard to maintain because developers modifying the system need to have a mental map of how the system is put together. If it has many competing designs at play, that cognitive weight hampers true innovation in design and architecture.

But **consistency of approaches really only applies to a single bounded context/service boundary/repository**. Beyond that, individual solutions/services should be able to pick the best designs for the constraints and problems local to that solution/service. Designs and architectures should exhibit internal consistency, and consistency with other services should be something only seen if problem constraints are similar.

It’s not impossible – we have projects still under active development after almost five years. At no point in those long term projects did we “chase the shiny” – that’s just irresponsible. Instead, we made steady improvements to the design and architecture, retrofitting as we went.

True, the size of the project prevents wild changes, but only because the potential gain of a wildly new approach, with no plan of retrofitting, is outweighed with the cognitive cost of a codebase where every new developer builds features according to their whim. Patchwork, piecemeal&nbsp; design just kills long term maintainability, and I’d favor maintainability through consistency over a design playground any day of the week.

Once you get past your application/service boundary, you’re no longer constrained by those other systems, so by all means, re-visit your design and architecture decisions. As long as your designs and architectures are internally consistent, and you’re shipping, nothing else really matters.