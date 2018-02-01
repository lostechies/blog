---
id: 4199
title: Is Functional Abstraction Too Clever?
date: 2009-10-17T07:29:00+00:00
author: Keith Dahlby
layout: post
guid: /blogs/dahlbyk/archive/2009/10/17/is-functional-abstraction-too-clever.aspx
dsq_thread_id:
  - "262493307"
categories:
  - Functional Programming
---
I received a rather interesting comment on a recent Stack Overflow answer:

> This code seems too clever by half. Is it art? &ndash;&nbsp;[PeterAllenWebb](http://stackoverflow.com/users/21365/peterallenwebb)

The [code in question](http://stackoverflow.com/questions/1581394/split-value-in-24-randomly-sized-parts-using-c/1581464#1581464 "Split value in 24 randomly sized parts using C#") was a functional solution to an algorithm described approximately as follows:

> Draw _n_&minus;1 numbers at random, in the range 1 to _m_&minus;1. Add 0 and _m_ to the list and order these numbers. The difference between each two consecutive numbers gives you a return value.

Which I solved like this, with _n_ = `slots` and _m_ = `max`:

<pre>static int[] GetSlots(int slots, int max)<br />{<br />&nbsp; &nbsp; return new Random().Values(1, max)<br />&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.Take(slots - 1)<br />&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.Append(0, max)<br />&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.OrderBy(i =&gt; i)<br />&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.Pairwise((x, y) =&gt; y - x)<br />&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.ToArray();<br />}</pre>

Using a few extension methods:

  * `Values()` returns an infinite sequence of random values within the specified range.
  * `Append()` takes a `params` array and appends its arguments to the original sequence.
  * `Pairwise()` generates a sequence from calculations on pairs of consecutive elements in the original sequence.

I can see how one would think the code is clever; however, I&#8217;m not sure what would qualify it as _too_ clever. Every method call has a well-defined purpose and maps directly to part of the original algorithm:

  1. From random numbers in the range 1 to _m_&minus;1&#8230;
  2. &#8230;draw _n_&minus;1.
  3. Add 0 and _m_ to the list&#8230;
  4. &#8230;and order these numbers.
  5. The difference between each two consecutive numbers&#8230;
  6. &#8230;gives you a return value [in the array].

As far as I&#8217;m concerned, a solution couldn&#8217;t get much clearer than
  
this, but that&#8217;s easy enough for me to say&mdash;what do you think? Is there
  
a better way to express the algorithm? Would an imperative solution
  
with shared state be more readable? How about maintainable?

For example, one could add the requirement that the random numbers
  
not be repeated so that the difference between adjacent numbers is
  
always nonzero. Updating the functional solution is as simple as adding
  
a Distinct() call:

<pre>&nbsp; &nbsp; return new Random().Values(1, max)<br /><b>                       .Distinct()</b><br />&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.Take(slots - 1)<br />&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;...</pre>

To me, this is the value proposition of functional programming. By
  
expressing the algorithm in terms of common operations, we&#8217;re able to
  
spend more time thinking about the problem than the details of the
  
solution. A similar change in an imperative implementation would almost
  
certainly have been more involved and prone to error.

For completeness, here are the implementations of the extension methods used:

<pre>public static IEnumerable&lt;int&gt; Values(this Random random, int minValue, int maxValue)<br />{<br />&nbsp; &nbsp; while (true)<br />&nbsp; &nbsp; &nbsp; &nbsp; yield return random.Next(minValue, maxValue);<br />}<br /><br />public static IEnumerable&lt;TResult&gt; Pairwise&lt;TSource, TResult&gt;(<br />    this IEnumerable&lt;TSource&gt; source,<br />    Func&lt;TSource, TSource, TResult&gt; resultSelector)<br />{<br />&nbsp; &nbsp; TSource previous = default(TSource);<br /><br />&nbsp; &nbsp; using (var it = source.GetEnumerator())<br />&nbsp; &nbsp; {<br />&nbsp; &nbsp; &nbsp; &nbsp; if (it.MoveNext())<br />&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; previous = it.Current;<br /><br />&nbsp; &nbsp; &nbsp; &nbsp; while (it.MoveNext())<br />&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; yield return resultSelector(previous, previous = it.Current);<br />&nbsp; &nbsp; }<br />}<br /><br />public static IEnumerable&lt;T&gt; Append&lt;T&gt;(this IEnumerable&lt;T&gt; source, params T[] args)<br />{<br />&nbsp; &nbsp; return source.Concat(args);<br />}</pre>

This also reminds me that [Jimmy](http://www.lostechies.com/blogs/jimmy_bogard/default.aspx "Jimmy Bogard") posted a similar `Append()` method as part of his latest post on [missing LINQ operators](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/10/15/more-missing-linq-operators.aspx "More missing LINQ operators"). I used to use a version similar to his, but have found the `params` version to be more flexible (and easier to implement). Its `Prepend()` counterpart is similarly trivial:

<pre>public static IEnumerable&lt;T&gt; Prepend&lt;T&gt;(this IEnumerable&lt;T&gt; source, params T[] args)<br />{<br />&nbsp; &nbsp; return args.Concat(source);<br />}</pre>