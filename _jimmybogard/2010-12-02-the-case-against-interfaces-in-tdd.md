---
wordpress_id: 442
title: The case against Interfaces in TDD
date: 2010-12-02T13:38:50+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/12/02/the-case-against-interfaces-in-tdd.aspx
dsq_thread_id:
  - "264716627"
categories:
  - Testing
---
[Mark Ploeh](http://blog.ploeh.dk) has an interesting post about [interfaces in TDD](http://blog.ploeh.dk/2010/12/02/InterfacesAreNotAbstractions.aspx) – that interfaces aren’t necessarily abstractions.&#160; That’s certainly true.&#160;&#160; Interfaces don’t guarantee we’re actually following SOLID design principles.&#160; In fact, the whole idea of the typical repository pattern in a lot of “DDD” codebases just screams of ISP violations.

However, I don’t think any of that changes the value of using interfaces in TDD.&#160; Interfaces let me do a few things that are annoying, difficult or impossible with concrete/abstract classes

  * Do top-down design
  * Program to implementations that don’t exist
  * Test against dummy/mock/fake/stub implementations

C# isn’t a dynamic language.&#160; I can’t easily swap out behavior at runtime, (or at least, I don’t want to pay for a tool that lets me).&#160; Interfaces are the easiest way for me to accomplish my goals in TDD, even if I have the issue of 95% of the interfaces I create only having 1 implementation.

All the points Mark made in his post:

  * LSP violations
  * ISP violations
  * Shallow interfaces

None of these go away when I choose classes.&#160; Instead, TDD just becomes harder.&#160; Now, I do have a lot more end-to-end, behavioral tests these days as I find these have more value.&#160; But interfaces still provide the clearest definition to end users on the needs of the class’s dependencies.&#160; Interfaces in the constructor tell us that this class needs an ISomething to accomplish its task, but concrete Something says it needs THIS SPECIFIC Something implementation to do its work.

So no, interfaces aren’t compiler-enforceable contracts, but our usage with proper naming and tests does lead us down this path.