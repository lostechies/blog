---
wordpress_id: 157
title: Clearing up the Mock confusion
date: 2008-03-14T01:57:09+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/03/13/clearing-up-the-mock-confusion.aspx
dsq_thread_id:
  - "264715598"
categories:
  - TDD
redirect_from: "/blogs/jimmy_bogard/archive/2008/03/13/clearing-up-the-mock-confusion.aspx/"
---
There&#8217;s some bad blood concerning Mocks, and a lot of it rightfully so.&nbsp; Because of popular mocking frameworks, the name &#8220;Mock&#8221; has become interchangeable for &#8220;Test Double&#8221;.&nbsp; In Texas, we ask for a Kleenex, not a tissue, and a Coke instead of a soft drink.&nbsp; The brand name has defined the family of products, though not every soft drink is a Coke.

Because of the Mock/Test Double confusion, Mocks are used in many wrong places, where another Test Double is more appropriate.&nbsp; For the record:

**A Test Double is a general term for a test-specific substitute.&nbsp; Mocks, among others, are a specific type of Test Double.**

If you look through your tests and all you see are Mock Objects, chances are pretty good you&#8217;ll have some very brittle tests that are coupled tightly to the implementation of the class under test.&nbsp; Specific types of [Test Doubles](http://xunitpatterns.com/Test%20Double.html) include:

  * Test Stub
  * Test Spy
  * Mock Object
  * Fake Object
  * Dummy Object

A **Test Stub** is used to control the indirect inputs of a class under test.&nbsp; By setting up different values for the [Test Stub](http://xunitpatterns.com/Test%20Stub.html), we can force our class under test down specific paths.

A **Test Spy** is used to capture the indirect outputs of a class under test.&nbsp; By capturing the indirect outputs, we can verify messages being sent by the class under test that we might not have access to otherwise.&nbsp; Test Stubs and [Test Spies](http://xunitpatterns.com/Test%20Spy.html) can be combined to force inputs and verify outputs.

A **Mock Object** is used to verify the interactions between a class under test and the [Mock Object](http://xunitpatterns.com/Mock%20Object.html).&nbsp; Mock Objects verify interactions usually by incorporating Record and Replay modes, where all method calls made in the Replay mode must be set up in the Record mode.&nbsp; Strict Mock Objects are useful for ensuring that only the methods specified are called, and nothing more.&nbsp; Loose Mock Objects are useful for ensuring that specified methods are called, but extra methods called won&#8217;t cause errors.

A **Fake Object** is used to substitute a simpler implementation for an otherwise complex or lengthy behavior.&nbsp; Typically this could mean an in-memory database instead of the real thing, which provides all the functionality of the real database, but only for the lifetime of the test.&nbsp; For example, instead of a CustomerRepository hitting the database, the [Fake Object](http://xunitpatterns.com/Fake%20Object.html) might just use local collection objects.

A **Dummy Object** is used to fill a parameter for a method.&nbsp; Similar to Test Stubs, except no verification is done, and they&#8217;re not used to drive specific paths.&nbsp; As the name implies, [Dummy Objects](http://xunitpatterns.com/Dummy%20Object.html) are used just so the code can compile and run.

As you can see from the description of the Mock Object, it tests a very specific scenario, interactions.&nbsp; Using Mock Objects in place of all the others would lead to some serious issues.&nbsp; Test what you mean to test, use the right Test Double for your situation, and you should come out fine in the end.