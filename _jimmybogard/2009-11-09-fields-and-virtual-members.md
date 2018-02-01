---
id: 365
title: Fields and virtual members
date: 2009-11-09T14:40:25+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/11/09/fields-and-virtual-members.aspx
dsq_thread_id:
  - "264716340"
categories:
  - 'C#'
---
It seems like the sillier the bug, the more time you’ll spend debugging it, simply because it’s in functionality you just _knew_ that worked correctly (and had the tests to back it up).&#160; One problem we hit recently was code that used fields to back virtual properties:

<pre><span style="color: blue">public abstract class </span><span style="color: #2b91af">Enumeration </span>: <span style="color: #2b91af">IComparable
</span>{
    <span style="color: blue">private readonly int </span>_value;

    <span style="color: blue">protected </span>Enumeration() { }

    <span style="color: blue">protected </span>Enumeration(<span style="color: blue">int </span>value)
    {
        _value = value;
    }

    <span style="color: blue">public virtual int </span>Value
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span>_value; }
    }

    <span style="color: blue">public virtual int </span>CompareTo(<span style="color: blue">object </span>other)
    {
        <span style="color: blue">return </span>_value.CompareTo(((<span style="color: #2b91af">Enumeration</span>)other).Value);
    }
}</pre>

[](http://11011.net/software/vspaste)

This isn’t a problem in and of itself, except in the behavior of that last method.&#160; Notice its logic uses the _field_ and not the _property_.&#160; I can then define a derived type:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">PercentDiscount </span>: <span style="color: #2b91af">Enumeration
</span>{
    <span style="color: blue">public override int </span>Value
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span>5; }
    }
}</pre>

[](http://11011.net/software/vspaste)

But now my CompareTo method breaks because it isn’t using the correct value.&#160; It uses the uninitialized field, causing all sorts of bizarre behavior.&#160; When you have logic errors in places like GetHashCode, Equals or CompareTo, I can guarantee your application will break in the most hair-pulling ways imaginable.

### Let’s fix it

So what’s a better option?&#160; We could just “make sure” that we don’t use the private field, and only use the virtual property.&#160; But I hate conventions that rely on my memory to not make a mistake, I want to fall into the [pit of success](http://blogs.msdn.com/brada/archive/2003/10/02/50420.aspx).&#160; One way to do so is to use automatic properties:

<pre><span style="color: blue">public abstract class </span><span style="color: #2b91af">Enumeration </span>: <span style="color: #2b91af">IComparable
</span>{
    <span style="color: blue">protected </span>Enumeration() { }

    <span style="color: blue">protected </span>Enumeration(<span style="color: blue">int </span>value)
    {
        Value = value;
    }

    <span style="color: blue">public virtual int </span>Value
    { 
        <span style="color: blue">get</span>;
        <span style="color: blue">private set</span>;
    }

    <span style="color: blue">public virtual int </span>CompareTo(<span style="color: blue">object </span>other)
    {
        <span style="color: blue">return </span>Value.CompareTo(((<span style="color: #2b91af">Enumeration</span>)other).Value);
    }
}</pre>

[](http://11011.net/software/vspaste)[](http://11011.net/software/vspaste)

Instead of a backing field, we’ll use an automatic property, making it impossible to use a non-virtual backing field.&#160; We still get the same access modifiers (a virtual, overridable getter, a private setter), plus the benefits of automatic properties.&#160; So now I’m curious: **are there any valid reasons to keep using fields for holding state**?