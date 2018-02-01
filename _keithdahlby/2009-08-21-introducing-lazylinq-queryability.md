---
id: 4193
title: 'Introducing LazyLinq: Queryability'
date: 2009-08-21T02:31:00+00:00
author: Keith Dahlby
layout: post
guid: /blogs/dahlbyk/archive/2009/08/20/introducing-lazylinq-queryability.aspx
dsq_thread_id:
  - "265265259"
categories:
  - ILazyQueryable
  - LazyLinq
  - LINQ
  - Queryable
---
This is the third in a series of posts on LazyLinq, a wrapper to support lazy initialization and deferred disposal of a LINQ query context: 

  1. [Introducing LazyLinq: Overview](http://solutionizing.net/2009/08/06/introducing-lazylinq-overview/)
  2. [Introducing LazyLinq: Internals](http://solutionizing.net/2009/08/17/introducing-lazylinq-internals/)
  3. **Introducing LazyLinq: Queryability**
  4. [Simplifying LazyLinq](http://solutionizing.net/2009/09/12/simplifying-lazylinq/)
  5. Introducing LazyLinq: Lazy DataContext

Having defined the LazyLinq interfaces and provided concrete implementations, we&#8217;re left to provide support for the standard query operators. 

## Learning from Queryable

Before we try to query `ILazyQueryable`, it&#8217;s instructive to look at how `System.Linq.Queryable` works. There are essentially three types of operators on `IQueryable<>`: 

  * Deferred queries returning `IQueryable<>`: Select, Where, etc.
  * Deferred query returning `IOrderedQueryable<>`: OrderBy, OrderByDescending, ThenBy, ThenByDescending
  * Everything else: Aggregate, Count, First, etc.

Reflecting `Queryable.Select`, modulo error checking, we see the following: 

<pre>public static IQueryable&lt;TResult&gt; Select&lt;TSource, TResult&gt;(<br />    this IQueryable&lt;TSource&gt; source, Expression&lt;Func&lt;TSource, TResult&gt;&gt; selector)<br />{<br />    return source.Provider<br />        .CreateQuery&lt;TResult&gt;(<br />            Expression.Call(null,<br />                ((MethodInfo) MethodBase.GetCurrentMethod())<br />                    .MakeGenericMethod(new Type[] { typeof(TSource), typeof(TResult) }),<br />                new Expression[] { source.Expression, Expression.Quote(selector) }));<br />}</pre>

The `source`&#8216;s `Provider` is used to construct a new query whose expression includes the call to `Select` with the given parameters. An ordered query follows a similar pattern, trusting that the query provider will return an `IOrderedQueryable<>` as appropriate: 

<pre>public static IOrderedQueryable&lt;TSource&gt; OrderBy&lt;TSource, TKey&gt;(<br />    this IQueryable&lt;TSource&gt; source, Expression&lt;Func&lt;TSource, TKey&gt;&gt; keySelector)<br />{<br />    return (IOrderedQueryable&lt;TSource&gt;) source.Provider<br />        .CreateQuery&lt;TSource&gt;(<br />            Expression.Call(null,<br />                ((MethodInfo) MethodBase.GetCurrentMethod())<br />                    .MakeGenericMethod(new Type[] { typeof(TSource), typeof(TKey) }),<br />                new Expression[] { source.Expression, Expression.Quote(keySelector) }));<br />}</pre>

And finally, everything that&#8217;s not a query is handled by the provider&#8217;s `Execute` method: 

<pre>public static TSource First&lt;TSource&gt;(this IQueryable&lt;TSource&gt; source)<br />{<br />    return source.Provider<br />        .Execute&lt;TSource&gt;(<br />            Expression.Call(null,<br />                ((MethodInfo) MethodBase.GetCurrentMethod())<br />                    .MakeGenericMethod(new Type[] { typeof(TSource) }),<br />                new Expression[] { source.Expression }));<br />}</pre>

## Querying ILazyQueryable

You may have noticed that the above scenarios map rather closely to the methods provided by `ILazyContext`: 

  * <pre>ILazyQueryable&lt;TContext, TResult, TQuery&gt;<br />    CreateQuery&lt;TResult, TQuery&gt;(Func&lt;TContext, TQuery&gt; queryBuilder)<br />    where TQuery : IQueryable&lt;TResult&gt;;</pre>

  * <pre>ILazyOrderedQueryable&lt;TContext, TResult, TQuery&gt;<br />    CreateOrderedQuery&lt;TResult, TQuery&gt;(Func&lt;TContext, TQuery&gt; queryBuilder)<br />    where TQuery : IOrderedQueryable&lt;TResult&gt;;</pre>

  * <pre>TResult Execute&lt;TResult&gt;(Func&lt;TContext, TResult&gt; action);</pre>

However, rather than expression trees we&#8217;re pushing around delegates. `Execute` seems pretty simple, so let&#8217;s start there: 

<pre>public static TSource First&lt;TSource, TContext, TQuery&gt;(<br />        this ILazyQueryable&lt;TContext, TSource, TQuery&gt; source<br />    ) where TQuery : IQueryable&lt;TSource&gt;<br />{<br />    Func&lt;TContext, TResult&gt; action = context =&gt; ???;<br />    return source.Context.Execute(action);<br />}</pre>

So our source has a `Context`, which knows how to `Execute` an action from `context` to some result. To find that result, we need to leverage the other property of source: `QueryBuilder`. Recalling that `QueryBuilder` is a function from `TContext` to `TQuery`, and that `TQuery` is an `IQueryable<TSource>`, we see something on which we can execute `Queryable.First`: 

<pre>public static TSource First&lt;TSource, TContext, TQuery&gt;(<br />        this ILazyQueryable&lt;TContext, TSource, TQuery&gt; source<br />    ) where TQuery : IQueryable&lt;TSource&gt;<br />{<br />    Func&lt;TContext, TResult&gt; action =<br />        context =&gt; source.QueryBuilder(context).First();<br />    return source.Context.Execute(action);<br />}</pre>

Now seeing as we have dozens of methods to implement like this, it seems an opportune time for a bit of eager refactoring. Recognizing that the only variance is the method call on the `IQueryable`, let&#8217;s extract an extension method that does everything else: 

<pre>private static TResult Execute&lt;TSource, TContext, TResult, TQuery&gt;(<br />        this ILazyQueryable&lt;TContext, TSource, TQuery&gt; source,<br />        Func&lt;TQuery, TResult&gt; queryOperation<br />    ) where TQuery : IQueryable&lt;TSource&gt;<br />{<br />    return source.Context.Execute(<br />        context =&gt; queryOperation(source.QueryBuilder(context)));<br />}</pre>

From there, additional lazy operators are just a lambda expression away: 

<pre>public static TSource First&lt;TSource, TContext, TQuery&gt;(<br />        this ILazyQueryable&lt;TContext, TSource, TQuery&gt; source<br />    ) where TQuery : IQueryable&lt;TSource&gt;<br />{<br />    return source.Execute(q =&gt; q.First());<br />}<br /><br />public static TAccumulate Aggregate&lt;TContext, TSource, TQuery, TAccumulate&gt;(<br />        this ILazyQueryable&lt;TContext, TSource, TQuery&gt; source,<br />        TAccumulate seed, Expression&lt;Func&lt;TAccumulate, TSource, TAccumulate&gt;&gt; func<br />    ) where TQuery : IQueryable&lt;TSource&gt;<br />{<br />    return source.Execute(q =&gt; q.Aggregate(seed, func));<br />}</pre>

And now having done the hard part (finding an `IQueryable`), we can translate that understanding to make similar helpers for queries: 

<pre>private static ILazyQueryable&lt;TContext, TResult, IQueryable&lt;TResult&gt;&gt;<br />    CreateQuery&lt;TSource, TContext, TQuery, TResult&gt;(<br />        this ILazyQueryable&lt;TContext, TSource, TQuery&gt; source,<br />        Func&lt;TQuery, IQueryable&lt;TResult&gt;&gt; queryOperation<br />    ) where TQuery : IQueryable&lt;TSource&gt;<br />{<br />    return source.Context.CreateQuery&lt;TResult, IQueryable&lt;TResult&gt;&gt;(<br />        context =&gt; queryOperation(source.QueryBuilder(context)));<br />}<br /><br />private static ILazyOrderedQueryable&lt;TContext, TResult, IOrderedQueryable&lt;TResult&gt;&gt;<br />    CreateOrderedQuery&lt;TSource, TContext, TQuery, TResult&gt;(<br />        this ILazyQueryable&lt;TContext, TSource, TQuery&gt; source,<br />        Func&lt;TQuery, IOrderedQueryable&lt;TResult&gt;&gt; queryOperation<br />    ) where TQuery : IQueryable&lt;TSource&gt;<br />{<br />    return source.Context.CreateOrderedQuery&lt;TResult, IOrderedQueryable&lt;TResult&gt;&gt;(<br />        context =&gt; queryOperation(source.QueryBuilder(context)));<br />}</pre>

With similarly trivial query operator implementations: 

<pre>public static ILazyQueryable&lt;TContext, TResult, IQueryable&lt;TResult&gt;&gt;<br />    Select&lt;TContext, TSource, TQuery, TResult&gt;(<br />        this ILazyQueryable&lt;TContext, TSource, TQuery&gt; source,<br />        Expression&lt;Func&lt;TSource, TResult&gt;&gt; selector<br />    ) where TQuery : IQueryable&lt;TSource&gt;<br />{<br />    return source.CreateQuery(q =&gt; q.Select(selector));<br />}<br /><br />public static ILazyOrderedQueryable&lt;TContext, TSource, IOrderedQueryable&lt;TSource&gt;&gt;<br />    OrderBy&lt;TContext, TSource, TQuery, TKey&gt;(<br />        this ILazyQueryable&lt;TContext, TSource, TQuery&gt; source,<br />        Expression&lt;Func&lt;TSource, TKey&gt;&gt; keySelector<br />    ) where TQuery : IQueryable&lt;TSource&gt;<br />{<br />    return source.CreateOrderedQuery(q =&gt; q.OrderBy(keySelector));<br />}</pre>

And the end result:

<img src="http://solutionizing.wordpress.com/files/2009/08/lazylinq-first.png" alt="LazyLinq.First" height="226" width="739" />