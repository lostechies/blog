---
wordpress_id: 317
title: Subverting TDD as a design tool
date: 2009-05-22T13:29:45+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/05/22/subverting-tdd-as-a-design-tool.aspx
dsq_thread_id:
  - "264716160"
categories:
  - TDD
redirect_from: "/blogs/jimmy_bogard/archive/2009/05/22/subverting-tdd-as-a-design-tool.aspx/"
---
So TypeMock can now [mock DateTime.Now](http://blog.typemock.com/2009/05/mockingfaking-datetimenow-in-unit-tests.html).&#160; Replacing the functionality of DateTime.Now, which is an external dependency, was one of the first issues that taught me the value of TDD.&#160; With TypeMock replacing DateTime.Now, I get all the benefits of unit testing, but none of the benefits of TDD.&#160; Yes, my code is now “testable” in the sense that I can now write a unit test against my code, but I’m using Jedi mind-tricks to do so.

TDD combines example-driven, client-first development with the icing of providing a safety net of providing executable specifications to lock down existing behavior.&#160; For me, the real benefit of TDD is the former, much more than the latter.&#160; TDD tells me exactly where my design is bad, as tests that are hard to write belie a design that is hard to work with.

When I first hit the “DateTime.Now” problem, TDD led me down a path that forced me to invert dependencies.&#160; Instead of an opaque dependency on DateTime.Now, I had an explicit relationship between that class and its dependency through an IClock interface:

<pre><span style="color: blue">public </span>PunchClock(<span style="color: #2b91af">ISystemClock </span>clock)</pre>

[](http://11011.net/software/vspaste)

From the standard external system dependencies such as clock, files, configuration and so on, I’ve used the dependency inversion principle everywhere inside my codebase.&#160; Why?&#160; TDD and DIP tell me if my class is doing too much.&#160; If my class is doing too much, it will be hard to understand, change and maintain.&#160; In my experience, TDD is by far the most efficient tool at showing me deficiencies in my design.&#160; It shows me not only problems in design of individual members and even type and member names, but problems of my overall architecture.

If I have a legacy system I need to change, there’s a [whole book on techniques](http://www.amazon.com/Working-Effectively-Legacy-Robert-Martin/dp/0131177052) for doing so in a safe, responsible manner.&#160; Changing legacy code is like camping – you always leave your campsite cleaner than when you found it.&#160; But I still can’t understand why I would need a tool that subverts all of the indicators in a unit test of bad design.