---
wordpress_id: 360
title: How not to implement a failing test
date: 2009-10-19T13:45:30+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/10/19/how-not-to-implement-a-failing-test.aspx
dsq_thread_id:
  - "268659375"
categories:
  - TDD
---
One of the first things I change in ReSharper, along with one of my biggest pet peeves is a failing test that fails because of something like this:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CombinedStreetAddressResolver 
    </span>: <span style="color: #2b91af">NullSafeValueResolver</span>&lt;<span style="color: #2b91af">Address</span>, <span style="color: blue">string</span>&gt;
{
    <span style="color: blue">protected override string </span>ResolveCore(<span style="color: #2b91af">Address </span>model)
    {
        <span style="color: blue">throw new </span><span style="color: #2b91af">NotImplementedException</span>();
    }
}</pre>

[](http://11011.net/software/vspaste)

In the Red-Green-Refactor progression, the Red of a failing test should come from an _assertion failure_ not a “my code is stupid” failure.&#160; The Red part is intended to triangulate and calibrate your test, to make sure that your test can fail correctly.&#160; A NotImplementedException won’t cause a meaningful failure, and only serves the purpose of getting your code to compile.

Throwing exceptions means your assertions never get executed in RGR until you attempt to make a passing test, in which case you still haven’t proven your test to be correct.&#160; If you don’t know that your test is correct, you have two points of failure: your test, and code under test.

That’s why I’ve set ReSharper to return default values instead of throw exceptions.&#160; I want meaningful failures from a valid test, otherwise I’m better off skipping the Red step altogether.