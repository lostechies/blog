---
id: 239
title: Acceptable test failures
date: 2008-10-14T11:25:07+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/10/14/acceptable-test-failures.aspx
dsq_thread_id:
  - "264715940"
categories:
  - TDD
---
As [Derick Bailey](http://www.lostechies.com/blogs/derickbailey/) pointed out in my last post, one of the annoyances with ReSharper is the NotImplementedException it puts in when you generate a method.&#160; Going from the TDD side, this is exactly what we _don’t_ want when we’re doing Red-Green-Refactor.&#160; There’s probably a setting somewhere, but I haven’t found it.&#160; It does bring up a larger issue – **what is an acceptable test failure**?&#160; That’s fairly simple:

**A test should have only one reason to fail.**

When we’re doing Red-Green-Refactor, we fail the test on purpose, mainly to prove that our test is correct.&#160; Without a test failing for the reasons we want, we’re not entirely confident in the correctness of our tests.&#160; Normally, I’ll do something like this:

  * Create the test/spec method
  * Write the client code and behavior I want, even if the members don’t exist
  * Use R# to create members that don’t exist, providing implementations that fail assertions

So I’ll wind up creating a test like this:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_mark_order_as_processed()
{
    <span style="color: blue">var </span>orderProcessor = <span style="color: blue">new </span><span style="color: #2b91af">OrderProcessor</span>();
    <span style="color: blue">var </span>order = <span style="color: blue">new </span><span style="color: #2b91af">Order</span>();

    orderProcessor.ProcessOrder(order);

    order.IsProcessed.ShouldBeTrue();
}</pre>

[](http://11011.net/software/vspaste)

At this point, the ProcessOrder method does not exist.&#160; The problem comes in when I use either VS or R# to create the method:

<pre><span style="color: blue">public void </span>ProcessOrder(<span style="color: #2b91af">Order </span>order)
{
    <span style="color: blue">throw new </span>System.<span style="color: #2b91af">NotImplementedException</span>();
}</pre>

[](http://11011.net/software/vspaste)

Now, R# at least highlights the entire row, so I can remove the NIE block fairly easily.&#160; But I’d rather not see it at all, it violates what a good unit test should be.&#160; **Unit tests should only fail because of a failed assertion**.&#160; I want the above test to fail _when and only when_ the last line, the assertion, executes and fails.

Executing the test as-is gives me a test failure, but not the correct failure.&#160; Things like NotImplementedExceptions or worse, NullReferenceExceptions, cloud the triangulation of the Red-Green-Refactor steps.&#160; When I don’t get the test to fail for the reasons I want, I never really know if the test is correct.&#160; It may pass later, but I don’t know if it will fail correctly.&#160; This is one of the more insidious test smells, as it can lead to a false sense of confidence in the correctness of my specifications.&#160; Accidental truths in my system mislead developers on the true behavior of the system.

When tests fail, and not because of an assertion failure, it’s a smell that I need to write another test.&#160; I then need to go back and ensure my test can fail for the reasons I specify, and only then do I have a valid test.&#160; By following true Red-Green-Refactor steps, and being vigilant on creating new tests when aberrant tests failures pop up, I can have well-founded confidence in the behavior of my system.