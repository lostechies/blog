---
id: 172
title: Should you TDD when flying solo?
date: 2008-04-23T00:39:11+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/04/22/should-you-tdd-when-flying-solo.aspx
dsq_thread_id:
  - "273965158"
categories:
  - TDD
---
A couple of weeks ago [a question came up](http://tech.groups.yahoo.com/group/altdotnet/message/6120) on the [ALT.NET message board](http://tech.groups.yahoo.com/group/altdotnet/):

> Does TDD make sense when you&#8217;re the only developer in your company?

To me, this is akin to the following questions:

  * Is quality important?
  * Is maintainability important?
  * Is design important?

Remember, TDD is all about design.&nbsp; Unit tests are icing on the cake.&nbsp; TDD shows me where I violate the [Dependency Inversion Principle](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/03/31/ptom-the-dependency-inversion-principle.aspx).&nbsp; TDD shows me if my design makes sense from the client&#8217;s perspective.&nbsp; TDD encourages low coupling and high cohesion (but doesn&#8217;t guarantee it).&nbsp; TDD gives me immediate visibility into the pain points of my system.&nbsp; TDD gives me confidence that my design is right.&nbsp; TDD gives me confidence to refactor carefully or recklessly.

Without TDD, I have zero confidence in my design is both what I intended nor what is needed.&nbsp; Without client code exercising concrete behavior for explicit contexts, I have no visibility into the &#8220;why&#8221; of the design.&nbsp; Without TDD, I&#8217;m flying completely blind.&nbsp; I can draw UML diagrams, sketch out code, even write little test applications.&nbsp; But unless I can demonstrate behavior in specific contexts, I have no evidence that my design is right.

Now pair programming solo, that requires some extreme dexterity&#8230;