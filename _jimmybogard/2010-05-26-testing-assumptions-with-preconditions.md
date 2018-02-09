---
wordpress_id: 413
title: Testing assumptions with preconditions
date: 2010-05-26T12:25:05+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/05/26/testing-assumptions-with-preconditions.aspx
dsq_thread_id:
  - "265046712"
categories:
  - Testing
redirect_from: "/blogs/jimmy_bogard/archive/2010/05/26/testing-assumptions-with-preconditions.aspx/"
---
While driving design with unit tests, I often break behaviors out into separate classes, both to increase cohesion, and as a side effect, increase testability.&#160; Occasionally, I run into situations where I have some sort of environmental variable that never changes.&#160; Or, if it does change, it would take an act of Congress.

When designing these environmental “astronomical constants”, I take the “[JFHCI](http://ayende.com/Blog/archive/2008/08/21/Enabling-change-by-hard-coding-everything-the-smart-way.aspx)” approach.&#160; These are values that have never changed, and the customer has told us don’t need to change.&#160; One case I ran in to recently is a reward limit.&#160; If you purchase over X dollars, you earn a reward.&#160; The value X does not change, so I made it a constant:

<pre><span style="color: blue">public const decimal </span>GadgetSpendRewardLimit = 200m;</pre>

[](http://11011.net/software/vspaste)

My “testability” hat on says that constants are bad, and that I need to be able to properly set up all environmental variables.&#160; However, in this case, allowing this value to change in ANY way produces a design that does not match reality.&#160; In reality, this reward limit does not need to change.

Instead of going through a bunch of hoops to allow this value to change solely for testing, I’ll leave the value alone.&#160; However, in the off chance that this value DOES change, my tests make the assumption that this value is this constant.

So, I’ve introduced testing assumptions made in my tests with a set of preconditions in the setup portion of the test:

<pre>[<span style="color: #2b91af">SetUp</span>]
<span style="color: blue">public void </span>SetUp()
{
    <span style="color: #2b91af">Debug</span>.Assert(<span style="color: #2b91af">Customer</span>.GadgetSpendRewardLimit == 200m, <span style="color: #a31515">"Assumes threshold is $200"</span>);</pre>

[](http://11011.net/software/vspaste)

I use a Debug.Assert mostly just to signify that I don’t need to test this every time, so I don’t really need a regular test assertion.&#160; Instead, this is just a fail-safe, and matches the intent of assumption validation, rather than behavior validation.

With assumption checking through preconditions, I keep the correct design (an immutable constant), while providing explicit callouts of assumptions made about the “correctness” of my tests.&#160; If my assumptions are wrong, I won’t bother trying to continue the test, as the base set of assumptions the test was built around are no longer valid.