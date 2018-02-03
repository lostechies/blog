---
wordpress_id: 346
title: How to hinder reflection-based scenarios
date: 2009-08-18T01:07:19+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/08/17/how-to-hinder-reflection-based-scenarios.aspx
dsq_thread_id:
  - "264716296"
categories:
  - 'C#'
---
In one easy step:&#160; Make sure an object’s runtime type doesn’t actually match its compile-time type.&#160; This test fails:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>HoorayNullables()
{
    <span style="color: blue">int</span>? i = 5;
    i.GetType().ShouldEqual(<span style="color: blue">typeof</span>(<span style="color: blue">int</span>?));
}</pre>

[](http://11011.net/software/vspaste)

With a rather unexpected error message of:

<pre>Expected: &lt;System.Nullable`1[System.Int32]&gt;
But was:  &lt;System.Int32&gt;</pre>

[](http://11011.net/software/vspaste)

Hmmm, that’s interesting, I wouldn’t expect an object to straight up _lie_ to me about its type.&#160; Even more irritating when you design a framework to examine runtime types of objects to make determinations on what to do.&#160; This is [by design](http://msdn.microsoft.com/en-us/library/ms366789%28VS.80%29.aspx), so that nullable types play as nice as possible with their underlying type counterparts.&#160; That’s why you also see the implicit/explicit conversion operators as well.&#160; There isn’t a way, as far as I can tell, to take an instance of an object by itself and determine if it’s a nullable type or not.