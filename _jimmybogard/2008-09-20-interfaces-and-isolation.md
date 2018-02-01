---
id: 231
title: Interfaces and isolation
date: 2008-09-20T20:29:02+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/09/20/interfaces-and-isolation.aspx
dsq_thread_id:
  - "264715915"
categories:
  - TDD
---
Roy Osherove has [suggested a new name](http://weblogs.asp.net/rosherove/archive/2008/09/20/goodbye-mocks-farewell-stubs.aspx) for mocks, fakes, stubs or any test double: **Isolation**.&nbsp; True, the myriad of test double names can muddy the language, and Meszaros&#8217; suggested name of &#8220;test double&#8221; still confuses people that don&#8217;t get the &#8220;stunt double&#8221; comparison.

When I first started using mocking frameworks, before I understood the OO design techniques they were intended to support, I used primarily two methods in Rhino Mocks:

  * MockRepository.CreateMock
  * Expect.Call

Using these two techniques of creating Mock objects and setting expectations, without good OO design, led to a lot of over-specified, brittle tests.&nbsp; Setting expectations that seemed to mirror the system under test seemed to be rampant duplication and hindrances to change.&nbsp; Over time, as I started to learn more about good OO design and the SOLID principles, the issues of brittle and over-specified tests simply went away.&nbsp; Techniques such as:

  * Dependency inversion principle
  * Interface-based design
  * Command-query separation
  * Single responsibility principle
  * Separation of concerns

All led to better specified behavior in my tests.

**Which is why the name &#8220;isolation&#8221; means nothing to me.**

When I&#8217;m using interface-based design, I&#8217;m doing so _not_ because of some innate desire to increase testability, but because I want to separate concerns and invert my dependencies.&nbsp; I want users of my class to know _exactly_ what is needed for this class to operate.&nbsp; I employ fanatical refactoring to ensure the names and responsibilities of the classes I create are clear to the maintainers of my application.

If I employ the DIP and interface-based design, what exactly am I isolating my class from?&nbsp; Interfaces of which the class already doesn&#8217;t care which implementation is provided?&nbsp; Again, I don&#8217;t use interfaces solely to swap out a test double in a unit test, but to achieve clear separation of concerns, hone the single responsibility of the class, and invert the dependencies.

When I use Rhino Mocks in the new AAA syntax, I wind up using only three techniques/methods in 99% of cases:

  * MockRepository.GenerateMock<T> to supply my class under test with any dependencies it needs to work
  * Stub extension method to control indirect inputs
  * AssertWasCalled extension method to verify indirect outputs

Following these rules helps me describe very clear behavior in my tests, with obvious results for those reading the tests.&nbsp; I don&#8217;t need to isolate when I&#8217;m already depending upon abstractions.