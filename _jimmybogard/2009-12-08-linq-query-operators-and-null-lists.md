---
wordpress_id: 373
title: LINQ query operators and null lists
date: 2009-12-08T23:42:15+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/12/08/linq-query-operators-and-null-lists.aspx
dsq_thread_id:
  - "264716406"
categories:
  - LINQ
---
One of my pet peeves with the LINQ extension methods is their inability to handle null source lists.&#160; For example, this will throw an ArgumentNullException:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_handle_nulls()
{
    <span style="color: #2b91af">List</span>&lt;<span style="color: blue">int</span>&gt; ints = <span style="color: blue">null</span>;

    ints.Any(num =&gt; num &lt; 0).ShouldBeFalse();
}</pre>

[](http://11011.net/software/vspaste)

Now I know what you’re saying – why not check for null, or not allow the list to be null in the first place?&#160; After all, the Framework Design Guidelines book recommends that methods and properties that return collection types _never_ be null.&#160; This is so you can merely check for empty collections, and not force users to have null checks everywhere.&#160; That’s all fine and dandy…until you’re forced to interact with systems that _don’t_ play nice.&#160; Especially around serialization libraries, we find places where they don’t abide by this suggestion.

Instead, we have to add a rather annoying, but necessary extension method:

<pre><span style="color: blue">public static </span><span style="color: #2b91af">IEnumerable</span>&lt;TSource&gt; NullToEmpty&lt;TSource&gt;(
    <span style="color: blue">this </span><span style="color: #2b91af">IEnumerable</span>&lt;TSource&gt; source)
{
    <span style="color: blue">if </span>(source == <span style="color: blue">null</span>)
        <span style="color: blue">return </span><span style="color: #2b91af">Enumerable</span>.Empty&lt;TSource&gt;();

    <span style="color: blue">return </span>source;
}</pre>

[](http://11011.net/software/vspaste)

And now my test will pass, as long as I make sure and convert these values properly:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_handle_nulls()
{
    <span style="color: #2b91af">List</span>&lt;<span style="color: blue">int</span>&gt; ints = <span style="color: blue">null</span>;

    ints.NullToEmpty().Any(num =&gt; num &lt; 0).ShouldBeFalse();
}</pre>

[](http://11011.net/software/vspaste)

So yes, it’s annoying, and I’d rather the LINQ operators just ignore null collections, or replace them with Enumerable.Empty().&#160; Until then, we just have to use this annoying extension method.