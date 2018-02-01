---
id: 4196
title: 'Hacking LINQ Expressions: Select With Index'
date: 2009-09-15T09:04:00+00:00
author: Keith Dahlby
layout: post
guid: /blogs/dahlbyk/archive/2009/09/15/hacking-linq-expressions-select-with-index.aspx
dsq_thread_id:
  - "262493294"
categories:
  - Hacking LINQ
  - LINQ
---
First, a point of clarification: I use LINQ Expressions to mean
  
(Language-INtegrated) Query Expressions (the language feature) rather
  
than Expression Trees (the .NET 3.5 library in System.Linq.Expressions).

So what do I mean by &#8220;Hacking LINQ Expressions&#8221;? Quite simply, I&#8217;m
  
not content with the rather limited set of operations that query
  
expressions allow me to represent. By understanding how queries are
  
translated, we can use various techniques to broaden our expressive
  
reach. I have already documented one such hack for [managing IDisposable objects with LINQ](http://solutionizing.net/2009/07/23/using-idisposables-with-linq/ "Using IDisposables with LINQ"), so I guess we can call this the second in an unbounded series.

## The Problem

In thinking over use cases for [functional construction of web control trees](http://solutionizing.net/2009/09/13/functional-construction-for-asp-net-web-forms/ "Functional Construction for ASP.NET Web Forms"), I paused to think through how I would express alternate row styling. My mind immediately jumped to the [overload of Select()](http://msdn.microsoft.com/en-us/library/bb534869.aspx "Enumerable.Select<TSource, TResult> Method (IEnumerable<TSource>, Func<TSource, Int32, TResult>)") that exposes the current element&#8217;s index:

<pre>Controls.Add(<br />    new Table().WithControls(<br />        data.Select((x, i) =&gt;<br />            new TableRow() {<br />                CssClass = i % 2 == 0 ? "" : "alt"<br />            }.WithControls(<br />                new TableCell().WithControls(x)<br />            )<br />        )<br />    )<br />);</pre>

This works fine for simple cases, but breaks down for more complex queries:

<pre>Controls.Add(<br />    new Table().WithControls((<br />        from x in Xs<br />        join y in Ys on x.Key equals y.Key<br />        select new { x, y }<br />        ).Select((z, i) =&gt;<br />            new TableRow() {<br />                CssClass = i % 2 == 0 ? "" : "alt"<br />            }.WithControls(<br />                new TableCell().WithControls(z.x.ValueX, z.y.ValueY)<br />            )<br />        )<br />    )<br />);</pre>

## The Goal

Instead, I propose a simple extension method to retrieve an index at arbitrary points in a query:

<pre>var res = from x in data<br />          from i in x.GetIndex()<br />          select new { x, i };</pre>

Or our control examples:

<pre>Controls.Add(<br />    new Table().WithControls(<br />        from x in data<br />        from i in x.GetIndex()<br />        select new TableRow() {<br />            CssClass = i % 2 == 0 ? "" : "alt"<br />        }.WithControls(<br />            new TableCell().WithControls(x)<br />        )<br />    )<br />);<br /><br />Controls.Add(<br />    new Table().WithControls(<br />        from x in Xs<br />        join y in Ys on x.Key equals y.Key<br />        from i in y.GetIndex()<br />        select new TableRow() {<br />            CssClass = i % 2 == 0 ? "" : "alt"<br />        }.WithControls(<br />            new TableCell().WithControls(x.ValueX, y.ValueY)<br />        )<br />    )<br />);</pre>

Much like in the `IDisposable` solution, we use a `from` clause to act as an intermediate assignment. But in this case our hack is a bit trickier than a simple iterator.

## The Hack

For this solution we&#8217;re going to take advantage of how multiple `from` clauses are translated:

<pre>var res = data.SelectMany(x =&gt; x.GetIndex(), (x, i) =&gt; new { x, i });</pre>

Looking at the parameter list, we see that our `collectionSelector` should return the result of `x.GetIndex()` and our `resultSelector`&#8216;s second argument needs to be an `int`:

<pre>public static IEnumerable&lt;TResult&gt; SelectMany&lt;TSource, TResult&gt;(<br />    this IEnumerable&lt;TSource&gt; source,<br />    Func&lt;TSource, SelectIndexProvider&gt; collectionSelector,<br />    Func&lt;TSource, int, TResult&gt; resultSelector)</pre>

The astute observer will notice that the signature of this `resultSelector` exactly matches the `selector` used by `Select`&#8216;s with-index overload, trivializing the method implementation:

<pre>{<br />    return source.Select(resultSelector);<br />}</pre>

Note that we&#8217;re not even using `collectionSelector`! We&#8217;re just using its return type as a flag to force the compiler to use this version of `SelectMany()`. The rest of the pieces are incredibly simple now that we know the actual `SelectIndexProvider` value is never used:

<pre>public sealed class SelectIndexProvider<br />{<br />    private SelectIndexProvider() { }<br />}<br /><br />public static SelectIndexProvider GetIndex&lt;T&gt;(this T element)<br />{<br />    return null;<br />}</pre>

And for good measure, an equivalent version to extend IQueryable<>:

<pre>public static IQueryable&lt;TResult&gt; SelectMany&lt;TSource, TResult&gt;(<br />    this IQueryable&lt;TSource&gt; source,<br />    Expression&lt;Func&lt;TSource, SelectIndexProvider&gt;&gt; collectionSelector,<br />    Expression&lt;Func&lt;TSource, int, TResult&gt;&gt; resultSelector)<br />{<br />    return source.Select(resultSelector);<br />}</pre>

Because we&#8217;re just calling `Select()`, the query expression isn&#8217;t even aware of the call to `GetIndex()`:

> System.Linq.Enumerable+<RangeIterator>d__b1.Select((x, i) => (x * i))

We&#8217;re essentially providing our own syntactic sugar over the sugar already provided by query expressions. Pretty sweet, eh?

As a final exercise for the reader, what would this print?

<pre>var res = from x in Enumerable.Range(1, 5)<br />          from i in x.GetIndex()<br />          from y in Enumerable.Repeat(i, x)<br />          where y % 2 == 1<br />          from j in 0.GetIndex()<br />          select i+j;<br /><br />foreach (var r in res)<br />    Console.WriteLine(r);</pre>