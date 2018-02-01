---
id: 448
title: Defining unit tests
date: 2011-01-12T13:59:10+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2011/01/12/defining-unit-tests.aspx
dsq_thread_id:
  - "264716660"
categories:
  - TDD
---
I don’t know where I got off the tracks on this one, but I’m really liking [Michael Feathers’ definition of a unit test](http://www.artima.com/weblogs/viewpost.jsp?thread=126923):

> _A test is not a unit test if:_ 
> 
>   * It talks to the database 
>   * It communicates across the network 
>   * It touches the file system 
>   * It can&#8217;t run at the same time as any of your other unit tests
>   * _You have to do special things to your environment (such as editing config files) to run it. 
>     
>     Tests that do these things aren&#8217;t bad. Often they are worth writing, and they can be written in a unit test harness. However, it is important to be able to separate them from true unit tests so that we can keep a set of tests that we can run fast whenever we make our changes.
>     
>     </i></li> </blockquote> 
>     
>     It doesn’t say “must only test one class” or “by jove, every test method name should include the name of the method being exercised”.&#160; Going back to the original [Test-Driven Development](http://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530) book, there are no instructions to test only one class at a time and that every dependency must be some kind of test double for the test to be a true “unit test”.
>     
>     The [xUnit Test Patterns book](http://www.amazon.com/gp/product/0131495054/) does go in to building top-down tests like these, but that book is mostly a collection of patterns rather than prescriptive guidance.
>     
>     Looking at dependency injection, the component’s constructor describes what the component needs for it to function.&#160; Those are implementation details.&#160; When I’m testing that component, is that really something I need to be concerned about?&#160; In some cases, yes, when I’m concerned about interactions and that behavior is interesting to me.&#160; But other times, the level of isolation through a strict mock-everything approach leaks those implementation details of not only what the dependencies are but _how those dependencies are used_ leads to a coupling of test and implementation.
>     
>     Six years of doing TDD and I think I might be getting it.