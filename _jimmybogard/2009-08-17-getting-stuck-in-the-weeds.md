---
wordpress_id: 345
title: Getting stuck in the weeds
date: 2009-08-17T01:56:22+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/08/16/getting-stuck-in-the-weeds.aspx
dsq_thread_id:
  - "264716289"
categories:
  - 'C#'
  - Design
redirect_from: "/blogs/jimmy_bogard/archive/2009/08/16/getting-stuck-in-the-weeds.aspx/"
---
While plowing through some AutoMapper support issues this weekend, I got a rather troubling one, where a developer got a rather scary exception message:

“Operation could destabilize the runtime”

Well that’s disturbing.&#160; It all came about because they were trying to map to a value type, a scenario which I assumed I supported.&#160; But, there weren’t any specific tests against this scenario, so you couldn’t map to something like this:

<pre><span style="color: blue">public struct </span><span style="color: #2b91af">IAmAStruct
</span>{
    <span style="color: blue">public string </span>Value { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

We’ll put aside the fact that value types should be immutable for now, but this was a scenario AutoMapper supported…until I started making the performance improvements of [using DynamicMethod](https://lostechies.com/blogs/jimmy_bogard/archive/2009/08/05/late-bound-invocations-with-dynamicmethod.aspx).&#160; But let’s review what I did, I wrapped the call to the real setter method with one that was loosely typed, giving me a method that would look something like this:

<pre><span style="color: blue">private void </span>DoIt(<span style="color: blue">object </span>source, <span style="color: blue">object </span>value)
{
    ((<span style="color: #2b91af">Source</span>)source).Total = (<span style="color: blue">int</span>)value;
}</pre>

[](http://11011.net/software/vspaste)

Now suppose the Source type is a value type, and not a reference type.&#160; How does the value get passed in?&#160; First, it gets boxed to an object.&#160; Then, inside the method, it would get unboxed, and the Total property is set.&#160; At this point, I could have stepped back and realized the impossibility of it all, that all that boxing and unboxing creates copies.&#160; But no, I prolonged the insanity.&#160; My next trick was to use a reference parameter, and fill in the IL for it:

<pre><span style="color: blue">private void </span>DoIt4(<span style="color: blue">ref object </span>source, <span style="color: blue">object </span>value)
{
    <span style="color: blue">var </span>valueSource = (<span style="color: #2b91af">ValueSource</span>) source;
    valueSource.Value = (<span style="color: blue">string</span>) value;
}</pre>

[](http://11011.net/software/vspaste)

Remember, I have to use “object” as the parameter types because I’m doing a late-bound method here.&#160; I don’t know the types until runtime, so I have to be able to use high performing calls on something that is of type Object.&#160; But do you see the problem here?&#160; Because I unbox “source”, I create a new ValueSource object into the “valueSource” variable.&#160; I change the Value property on it, _but not the original source object passed in_.

All of this I find out _after_ I futz around with IL for waaaaaay too long.&#160; But, had I actually tried to create a unit test around the regular, plain jane non-IL’d method, I would have quickly seen that I was trying to attempt the impossible.&#160; Value types aren’t reference types, and I shouldn’t try to treat them that way.

Instead, I went back to the regular reflection, MethodInfo.Invoke way.&#160; I could try the “out” parameter way…but I was tired of wasting my time.

Moral of the story?&#160; **Don’t get stuck in the weeds!**&#160; At any point during my long, pointless journey, I could have stopped and looked to see if what I was trying to do made any sense.&#160; Instead, I got a stack trace and dove headlong into devising the most complex solution imaginable – hand-rolling IL.

Sigh.