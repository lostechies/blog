---
wordpress_id: 294
title: Disambiguating a test fixture
date: 2009-03-16T02:15:12+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/03/15/disambiguating-a-test-fixture.aspx
dsq_thread_id:
  - "264716100"
categories:
  - TDD
---
One of the more disappointing things I found reading the xUnit Test Patterns book was how much one tool could shape my views on a concept.&#160; NUnit, as great and simple tool as it is, doesn’t quite match the other xUnit tools out there when it comes to defining the pieces of a unit test.

As an example, let’s play a game, “spot the fixture”:

<pre>[<span style="color: #2b91af">TestFixture</span>]
<span style="color: blue">public class </span><span style="color: #2b91af">OrderTests
</span>{
    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Total_should_equal_the_sum_of_the_line_item_totals()
    {
        <span style="color: blue">var </span>order = <span style="color: blue">new </span><span style="color: #2b91af">Order</span>();

        order.AddLineItem(<span style="color: #a31515">"Shampoo"</span>, 6, 5.99m);
        order.AddLineItem(<span style="color: #a31515">"Conditioner"</span>, 4, 3.49m);

        <span style="color: blue">var </span>total = order.GetTotal();

        total.ShouldEqual(49.9m);
    }
}</pre>

[](http://11011.net/software/vspaste)

Is it:

a) The class marked clearly as “TestFixture”
    
  
b) Stop messing with me, the code don’t lie

The problem with NUnit is it _assumes_ we’re doing Testcase Class per Fixture.&#160; Wait, what?

### A few definitions

First, let’s set a baseline for what we’re talking about here.

**Test method** – A method that contains the logic/code for a single test

**Testcase class** – A class that hosts test methods

**Test fixture** – The preconditions of a test, or test context.&#160; Everything our system under test needs to be exercised for a test

Clearly we have some ambiguity here.&#160; Instead of marking our testcase class as “TestClass” (as MSTest does, for example), it calls it “TestFixture”.&#160; Why, that’s awfully presumptive of you!&#160; So the answer above was c) the test fixture is order set up with all the necessary order line items.

We also organized our tests above by class, where all my tests for Order go in a testcase class called OrderTests.&#160; NUnit also has the concept of Setup and Teardown, which works great if you’re doing Testcase Class per Fixture, but not so great if you’re doing something like Testcase Class per Class.

### The 12 step fixture program

The first step in the road to NUnit-itis is to realize that there is a big unit testing world out there that doesn’t revolve around a single tool.&#160; Fixtures are what I need to set up a test, nothing more.&#160; NUnit assumes we want to do testcase class per fixture, but that may not be the case.&#160; We may want to try all sorts of other organizations for our testcase classes, such as:

  * Testcase class per class
  * Testcase class per feature
  * Testcase class per user story?
  * Testcase class per method?

We have quite a few options, all of whom the existing assumptions of NUnit stop fitting so nicely.&#160; One of the backlashes against the Setup method was that many teams structured their unit tests in the testcase class per class style, where you rarely had common fixtures/setups between each test.&#160; In fact, doing so could lead to brittle or unreadable tests.

Similar to Mocks, Fixture has become a loaded and incorrect term in the .NET space, largely because of a single tool incorrectly applied.&#160; Fixtures are setup, nothing more.&#160; If we want to use a Setup method in NUnit, don’t assume that your testcase class is also your fixture, and try to separate the two concepts in your head.