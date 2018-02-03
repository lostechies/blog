---
wordpress_id: 181
title: 'Domain-Driven Design: Supple Design Patterns Series'
date: 2008-05-15T11:37:15+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/05/15/domain-driven-design-supple-design-patterns-series.aspx
dsq_thread_id:
  - "265518374"
dsq_needs_sync:
  - "1"
categories:
  - DomainDrivenDesign
---
At last week&#8217;s [Austin DDD Book Club](http://groups.google.com/group/austin-ddd-book-club/), we discussed my favorite chapter in Evans&#8217; [Domain-Driven Design book](http://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215): Supple Design.&nbsp; Modeling is an important exercise in Domain-Driven Design, but it&#8217;s not enough to have a codebase that&#8217;s easy to work with.&nbsp; In addition to designs that are easily changed, supple designs enable changes originating from deep modeling.

Code can be easy to change technically with low coupling, high cohesion and a safety net of unit tests.&nbsp; But what about additions or new concepts to your model?&nbsp; With supple design, changes in the model are easily realized in your code.&nbsp; I&#8217;ve been involved in many projects where the conceptual model was clear and well-documented, but the design represented as code was a mess.&nbsp; There&#8217;s always a simplification going from model to code, but it shouldn&#8217;t be a translation.

Evans notes that developers have two roles that must be served by the design:

  * Developer of a client, where concepts of the model are easily discerned and naturally composed
  * Developer working to change it, so that changes necessary are visible and obvious

To move achieve a supple design, Evans lays out a set of design patterns:

  * Intention-Revealing Interfaces
  * Side-Effect-Free Functions
  * Assertions
  * Conceptual Contours
  * Standalone Classes
  * Closure of Operations
  * Declarative Style of Design

The idea of a supple design is fairly abstract and hard to nail down.&nbsp; But its basic principles are those that go beyond simply code that is easy to change.&nbsp; If the code doesn&#8217;t reflect your actual model, it can be just as difficult to work with as bad code.&nbsp; With supple design, a model is more easily realized in code, eliminating some of the wasteful translations that happen on so many projects.

Over the next couple of weeks, I&#8217;ll dive in to each of the design patterns above.&nbsp; These design patterns aren&#8217;t structural, like Strategy or Visitor, but related to the model aspects of the design.&nbsp; By applying the concepts in the supple design patterns, we&#8217;ll have a codebase that&#8217;s both easy to change and a pleasure to work with.