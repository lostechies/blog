---
id: 359
title: More missing LINQ operators
date: 2009-10-16T03:19:55+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/10/15/more-missing-linq-operators.aspx
dsq_thread_id:
  - "264827790"
categories:
  - LINQ
---
Continuing an [old post on missing LINQ operators](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/06/07/some-improved-linq-operators.aspx), the wonders of extension methods allow us as developers to fill potential holes in LINQ operators.&#160; Whether it’s a Zip method (now included in .NET 4.0), or better methods for IComparer-based operators, I find myself adding more and more helpful LINQ operators, I wish were already in the framework.

### Alternate

Do you ever want to weave two collections together, like shuffling a deck of cards?&#160; Well I know I do!&#160; Suppose we have this collection:

[1, 3, 5]

And this collection:

[2, 4, 6]

I’d like to create new collection that is the alternating items from the first and second list:

[1, 2, 3, 4, 5, 6]

Here’s the code to do it:

<pre><span style="color: blue">public static </span><span style="color: #2b91af">IEnumerable</span>&lt;TSource&gt; Alternate&lt;TSource&gt;(<span style="color: blue">this </span><span style="color: #2b91af">IEnumerable</span>&lt;TSource&gt; first, <span style="color: #2b91af">IEnumerable</span>&lt;TSource&gt; second)
{
    <span style="color: blue">using </span>(<span style="color: #2b91af">IEnumerator</span>&lt;TSource&gt; e1 = first.GetEnumerator())
    <span style="color: blue">using </span>(<span style="color: #2b91af">IEnumerator</span>&lt;TSource&gt; e2 = second.GetEnumerator())
        <span style="color: blue">while </span>(e1.MoveNext() && e2.MoveNext())
        {
            <span style="color: blue">yield return </span>e1.Current;
            <span style="color: blue">yield return </span>e2.Current;
        }
}</pre>

[](http://11011.net/software/vspaste)

Very simple, I iterate both enumerables at the same time, yielding the first, then second collection’s current item.&#160; So how is this useful?&#160; How about this action:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Word_play()
{
    <span style="color: blue">var </span>source = <span style="color: blue">new</span>[] {<span style="color: #a31515">"The"</span>, <span style="color: #a31515">"quick"</span>, <span style="color: #a31515">"brown"</span>, <span style="color: #a31515">"fox"</span>};

    <span style="color: blue">var </span>result = source.Alternate(Spaces()).Aggregate(<span style="color: blue">string</span>.Empty, (a, b) =&gt; a + b);

    result.ShouldEqual(<span style="color: #a31515">"The quick brown fox "</span>);
}

<span style="color: blue">private </span><span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: blue">string</span>&gt; Spaces()
{
    <span style="color: blue">while </span>(<span style="color: blue">true</span>)
        <span style="color: blue">yield return </span><span style="color: #a31515">" "</span>;
}</pre>

[](http://11011.net/software/vspaste)

I cheated a little bit with an infinite sequence (the Spaces() method), but I found this method useful when I had to split, then reconstruct new sequences of strings.

### Append

I really hate this syntax:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Bad_concat_method()
{
    <span style="color: blue">var </span>ints = <span style="color: blue">new</span>[] {1, 2, 3};

    <span style="color: blue">var </span>oneToFour = ints.Concat(<span style="color: #2b91af">Enumerable</span>.Repeat(4, 1));

    <span style="color: #2b91af">CollectionAssert</span>.AreEqual(<span style="color: blue">new</span>[] { 1, 2, 3, 4 }, oneToFour.ToArray());
}</pre>

[](http://11011.net/software/vspaste)

I want to just stick an item on the end of an existing collection, but I have to use this arcane Enumerable.Repeat method to do so.&#160; Instead, let’s create an operator that lets us tack an item on to the end of a collection:

<pre><span style="color: blue">public static </span><span style="color: #2b91af">IEnumerable</span>&lt;TSource&gt; Append&lt;TSource&gt;(<span style="color: blue">this </span><span style="color: #2b91af">IEnumerable</span>&lt;TSource&gt; source, TSource element)
{
    <span style="color: blue">using </span>(<span style="color: #2b91af">IEnumerator</span>&lt;TSource&gt; e1 = source.GetEnumerator())
        <span style="color: blue">while </span>(e1.MoveNext())
            <span style="color: blue">yield return </span>e1.Current;

    <span style="color: blue">yield return </span>element;
}</pre>

[](http://11011.net/software/vspaste)

Now our code becomes much easier to understand:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Easier_concat_with_append()
{
    <span style="color: blue">var </span>ints = <span style="color: blue">new</span>[] {1, 2, 3};

    <span style="color: blue">var </span>oneToFour = ints.Append(4);

    <span style="color: #2b91af">CollectionAssert</span>.AreEqual(<span style="color: blue">new</span>[] { 1, 2, 3, 4 }, oneToFour.ToArray());
}</pre>

[](http://11011.net/software/vspaste)

### Prepend

Append wouldn’t be complete without the converse, Prepend, now would it?

<pre><span style="color: blue">public static </span><span style="color: #2b91af">IEnumerable</span>&lt;TSource&gt; Prepend&lt;TSource&gt;(<span style="color: blue">this </span><span style="color: #2b91af">IEnumerable</span>&lt;TSource&gt; source, TSource element)
{
    <span style="color: blue">yield return </span>element;

    <span style="color: blue">using </span>(<span style="color: #2b91af">IEnumerator</span>&lt;TSource&gt; e1 = source.GetEnumerator())
        <span style="color: blue">while </span>(e1.MoveNext())
            <span style="color: blue">yield return </span>e1.Current;
}</pre>

[](http://11011.net/software/vspaste)

Now putting something on the beginning of a list is easier as well:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Easier_concat_with_prepend()
{
    <span style="color: blue">var </span>ints = <span style="color: blue">new</span>[] {1, 2, 3};

    <span style="color: blue">var </span>zeroToThree = ints.Prepend(0);

    <span style="color: #2b91af">CollectionAssert</span>.AreEqual(<span style="color: blue">new</span>[] { 0, 1, 2, 3 }, zeroToThree.ToArray());
}</pre>

[](http://11011.net/software/vspaste)

Much more readable.&#160; I have a few more around replacing the IEqualityComparer<T> overloads, but those are a little bit more esoteric in their examples of crazy set-based logic.&#160; What’s really cool about all these methods is they still allow all sorts of fun chaining, allowing me to create very terse chains of operations on lists, with what would have taken a bazillion cryptic for..each loops.&#160; Cool stuff!