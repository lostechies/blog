---
id: 4197
title: 'Hacking LINQ Expressions: Join With Comparer'
date: 2009-09-19T18:15:00+00:00
author: Keith Dahlby
layout: post
guid: /blogs/dahlbyk/archive/2009/09/19/hacking-linq-expressions-join-with-comparer.aspx
dsq_thread_id:
  - "262640371"
categories:
  - Hacking LINQ
  - LINQ
---
In this installment of my [Hacking LINQ](http://solutionizing.net/tag/hacking-linq/) series we&#8217;ll take a look at providing an `IEqualityComparer` for use in a LINQ `join` clause.

## The Problem

Many of the [Standard Query Operators](http://msdn.microsoft.com/en-us/library/bb397896.aspx "Standard Query Operators Overview")
  
require comparing sequence elements and the default query providers are
  
kind enough to give us overloads that accept a suitable comparer. Among
  
these operators, `Join` and `GroupJoin` have perhaps the most useful query syntax:

<pre>var res = from s in States<br />          join a in AreaCodes<br />            on s.Abbr equals a.StateAbbr<br />          select new { s.Name, a.AreaCode };</pre>

While a bit more verbose, I find the intent much easier to read then the method equivalent:

<pre>var res = States.Join(AreaCodes,<br />                      s =&gt; s.Abbr, a =&gt; a.StateAbbr,<br />                      (s, a) =&gt; new { s.Name, a.AreaCode });</pre>

Or maybe I&#8217;ve just spent too much time in SQL. Either way, I thought it would be useful to support joins by a comparer.

## The Goal

We will use another extension method to specify how the join should be performed:

<pre>var res = from s in States<br />          join a in AreaCodes.WithComparer(StringComparer.OrdinalIgnoreCase)<br />            on s.Abbr equals a.StateAbbr<br />          select new { s.Name, a.AreaCode };</pre>

We can also support the same syntax for group joins:

<pre>var res = from s in States<br />          join a in AreaCodes.WithComparer(StringComparer.OrdinalIgnoreCase)<br />            on s.Abbr equals a.StateAbbr into j<br />          select new { s.Name, Count = j.Count() };</pre>

## The Hack

As with most LINQ hacks, we&#8217;re going to use the result of `WithComparer` to call a specialized version of `Join` or `GroupJoin`, in this case by providing a replacement for the join&#8217;s inner sequence:

<pre>var res = States.Join(AreaCodes.WithComparer(StringComparer.OrdinalIgnoreCase),<br />                      s =&gt; s.Abbr, a =&gt; a.StateAbbr,<br />                     &nbsp;(s, a) =&gt; new { s.Name, a.AreaCode });</pre>

Eventually leading to this method call:

<pre>var res = States.Join(AreaCodes,<br />                      s =&gt; s.Abbr, a =&gt; a.StateAbbr,<br />                     &nbsp;(s, a) =&gt; new { s.Name, a.AreaCode },<br />                      StringComparer.OrdinalIgnoreCase);</pre>

Since we need both the inner collection we&#8217;re extending and the
  
comparer, we can guess our extension method will be implemented
  
something like this:

<pre>public static JoinComparerProvider&lt;T, TKey&gt; WithComparer&lt;T, TKey&gt;(<br />    this IEnumerable&lt;T&gt; inner, IEqualityComparer&lt;TKey&gt; comparer)<br />{<br />    return new JoinComparerProvider&lt;T, TKey&gt;(inner, comparer);<br />}</pre>

With a trivial provider implementation:

<pre>public sealed class JoinComparerProvider&lt;T, TKey&gt;<br />{<br />    internal JoinComparerProvider(IEnumerable&lt;T&gt; inner, IEqualityComparer&lt;TKey&gt; comparer)<br />    {<br />        Inner = inner;<br />        Comparer = comparer;<br />    }<br /><br />    public IEqualityComparer&lt;TKey&gt; Comparer { get; private set; }<br />    public IEnumerable&lt;T&gt; Inner { get; private set; }<br />}</pre>

The final piece is our `Join` overload:

<pre>public static IEnumerable&lt;TResult&gt; Join&lt;TOuter, TInner, TKey, TResult&gt;(<br />    this IEnumerable&lt;TOuter&gt; outer,<br />    JoinComparerProvider&lt;TInner, TKey&gt; inner,<br />    Func&lt;TOuter, TKey&gt; outerKeySelector,<br />    Func&lt;TInner, TKey&gt; innerKeySelector,<br />    Func&lt;TOuter, TInner, TResult&gt; resultSelector)<br />{<br />    return outer.Join(inner.Inner, outerKeySelector, innerKeySelector,<br />                      resultSelector, inner.Comparer);<br />}</pre>

Implementations of `GroupJoin` and their `IQueryable` counterparts are similarly trivial.