---
wordpress_id: 4191
title: 'Introducing LazyLinq: Overview'
date: 2009-08-06T18:48:00+00:00
author: Keith Dahlby
layout: post
wordpress_guid: /blogs/dahlbyk/archive/2009/08/06/introducing-lazylinq-overview.aspx
dsq_thread_id:
  - "264888448"
categories:
  - DataContext
  - Expression Trees
  - LazyLinq
  - LINQ
  - LINQ to SQL
redirect_from: "/blogs/dahlbyk/archive/2009/08/06/introducing-lazylinq-overview.aspx/"
---
This is the first in a series of posts on LazyLinq, a wrapper to support lazy initialization and deferred disposal of a LINQ query context, including LINQ to SQL&#8217;s [`DataContext`](http://msdn.microsoft.com/en-us/library/system.data.linq.datacontext.aspx "DataContext Class (System.Data.Linq)"):

  1. **Introducing LazyLinq: Overview**
  2. [Introducing LazyLinq: Internals](/blogs/dahlbyk/archive/2009/08/18/introducing-lazylinq-internals.aspx)
  3. [Introducing LazyLinq: Queryability](http://solutionizing.net/2009/08/20/introducing-lazylinq-queryability/)
  4. [Simplifying LazyLinq](http://solutionizing.net/2009/09/12/simplifying-lazylinq/) 
  5. Introducing LazyLinq: Lazy DataContext

## Motivation

I recently posted [an approach](http://solutionizing.net/2009/07/23/using-idisposables-with-linq/ "Using IDisposables with LINQ") to dealing with `IDisposable` objects and LINQ. In the [comments](/blogs/dahlbyk/archive/2009/07/23/using-idisposables-with-linq.aspx#comments "Using IDisposables with LINQ") at LosTechies, [Steve Gentile](http://blogger.forgottenskies.com/) mentioned that my `IQueryable` example didn&#8217;t actually compile: 

<pre>IQueryable&lt;MyType&gt; MyFunc(string myValue)<br />{<br />    return from dc in new MyDataContext().Use()<br />           from row in dc.MyTable<br />           where row.MyField == myValue<br />           select row;<br />}</pre>

Steve suggested using `AsQueryable()` on the result of the query, which does indeed fix the build. However, the purpose of returning an `IQueryable` is that it would allow us to perform additional query operations using the original query provider. Since the query result isn&#8217;t `IQueryable`, `AsQueryable()` will use a query provider based on LINQ to Objects, with an additional performance penalty to compile the expression trees into IL.

Even worse, because `Use()` is returning an `IEnumerable<T>` the entire query is actually executed with LINQ to Objects. Even though `dc.MyTable` is `IQueryable`, the translated query treats it as a simple `IEnumerable`, essentially performing a `SELECT *` before executing all query operations on entity objects in memory. It should go without saying that this is less than ideal. 

## Introducing LazyLinq

After several iterations, I think I have a better solution. In this post I&#8217;ll review the architecture of the solution, with posts to follow detailing the implementation.

LazyLinq is implemented around three interfaces. The first serves as a deferred query context provider: 

<pre>public interface ILazyContext&lt;TContext&gt; : IDisposable<br />    {<br />        TContext Context { get; }<br /><br />        ILazyQueryable&lt;TContext, TResult, TQuery&gt;<br />            CreateQuery&lt;TResult, TQuery&gt;(Func&lt;TContext, TQuery&gt; queryBuilder)<br />            where TQuery : IQueryable&lt;TResult&gt;;<br /><br />        ILazyOrderedQueryable&lt;TContext, TResult, TQuery&gt;<br />            CreateOrderedQuery&lt;TResult, TQuery&gt;(Func&lt;TContext, TQuery&gt; queryBuilder)<br />            where TQuery : IOrderedQueryable&lt;TResult&gt;;<br /><br />        TResult Execute&lt;TResult&gt;(Func&lt;TContext, TResult&gt; action);<br />    }</pre>

An implementer of `ILazyContext` has four responsibilities: 

  1. Lazily expose the Context.
  2. Produce lazy wrappers to represent queries retrieved from a context by a delegate.
  3. Execute an action on the context.
  4. Ensure the context is disposed as necessary.

The remaining interfaces serve as lazy query wrappers, corresponding to `IQueryable<T>` and `IOrderedQueryable<T>`: 

<pre>public interface ILazyQueryable&lt;TContext, TSource, TQuery&gt;<br />        : IQueryable&lt;TSource&gt;<br />        where TQuery : IQueryable&lt;TSource&gt;<br />    {<br />        ILazyContext&lt;TContext&gt; Context { get; }<br />        Func&lt;TContext, TQuery&gt; QueryBuilder { get; }<br />    }<br />    public interface ILazyOrderedQueryable&lt;TContext, TSource, TQuery&gt;<br />        : ILazyQueryable&lt;TContext, TSource, TQuery&gt;, IOrderedQueryable&lt;TSource&gt;<br />        where TQuery : IOrderedQueryable&lt;TSource&gt;<br />    { }</pre>

An implementer of `ILazyQueryable` has four responsibilities: 

  1. Expose the Context from which it was created.
  2. Expose a delegate that represents how the deferred query is built from Context.
  3. Implement IQueryable for the deferred query.
  4. Ensure the context is disposed after the query is enumerated.

If it seems like these interfaces don&#8217;t do much, you&#8217;re absolutely correct. As we&#8217;ll see later, the light footprint gives us considerable flexibility. 

## LINQ to ILazyContext

Defining a few interfaces is all well and good, but the real goal is to simplify working with our disposable context. What if I told you that our original use case didn&#8217;t need to change at all (other than the lazy return type)? 

<pre>ILazyQueryable&lt;MyType&gt; MyFunc(string myValue)<br />{<br />    return from dc in new MyDataContext().Use()<br />           from row in dc.MyTable<br />           where row.MyField == myValue<br />           select row;<br />}</pre>

We can&#8217;t implement it yet, but our new `Use()` extension method will have this signature: 

<pre>public static ILazyContext&lt;TContext&gt; Use&lt;TContext&gt;(this TContext @this) { ... }</pre>

This is where we really start to bend LINQ against its will. As the first step in the query translation process, the compiler will translate our `from` clauses into a call to `SelectMany`. All we need to do is provide a `SelectMany` method for `ILazyContext` that the compiler will find acceptable: 

<pre>public static ILazyQueryable&lt;TContext, TResult, IQueryable&lt;TResult&gt;&gt; SelectMany&lt;TContext, TCollection, TResult&gt;(<br />        this ILazyContext&lt;TContext&gt; lazyContext,<br />        Expression&lt;Func&lt;TContext, IQueryable&lt;TCollection&gt;&gt;&gt; collectionSelector,<br />        Expression&lt;Func&lt;TContext, TCollection, TResult&gt;&gt; resultSelector)<br />    {</pre>

The method signature is a slight variation from the corresponding overload of [`Queryable.SelectMany()`](http://msdn.microsoft.com/en-us/library/bb549040.aspx), changed to require that `collectionSelector` returns an `IQueryable` that we can defer. If it doesn&#8217;t, the compiler will complain: 

> An expression of type &#8216;System.Collections.Generic.IEnumerable<int>&#8217; is not allowed in a subsequent from clause in a query expression with source type &#8216;Solutionizing.Linq.Test.MyDataContext<Solutionizing.Linq.Test.MyDataContext>&#8217;. Type inference failed in the call to &#8216;SelectMany&#8217;.

Now that we&#8217;ve hijacked the query, we can control the rest of the translation process with the returned `ILazyQueryable`. Recalling that our `ILazyContext` knows how to make an `ILazyQueryable`, we just need to give it a `QueryBuilder` delegate: 

<pre>return lazyContext.CreateQuery&lt;TResult, IQueryable&lt;TResult&gt;&gt;(context =&gt;<br />            {<br />                Func&lt;TContext, IQueryable&lt;TCollection&gt;&gt; getQueryFromContext = collectionSelector.Compile();<br />                IQueryable&lt;TCollection&gt; query = getQueryFromContext(context);<br /><br />                ParameterExpression rangeParameter = resultSelector.Parameters[1];<br />                InvocationExpression invoke = Expression.Invoke(resultSelector, Expression.Constant(context), rangeParameter);<br />                Expression&lt;Func&lt;TCollection, TResult&gt;&gt; selector = Expression.Lambda&lt;Func&lt;TCollection, TResult&gt;&gt;(invoke, rangeParameter);<br /><br />                return query.Select(selector);<br />            });<br />    }</pre>

This is pretty dense, so let&#8217;s walk through it: 

  1. Our lambda expression&#8217;s `context` parameter represents the `MyDataContext` that will be passed in eventually.
  2. We&#8217;re going to manipulate the expression trees passed into the method, which will look something like this: 
      * **`collectionSelector`:** `dc => dc.MyTable`
      * **`resultSelector`:** `(dc, row) => new { dc = dc, row = row }`
  3. Compiling `collectionSelector` produces a delegate we can invoke on context to get an `IQueryable<TCollection>`&mdash;`context.MyTable`, in this case.
  4. Before we can use `resultSelector` on `MyTable`, we need to wrap it in a lambda expression to eliminate its first parameter.: 
      1. Save the second parameter (`row`) to use later.
      2. Create a new invocation expression that will represent calling `resultSelector` with the current `context` and our saved `row` parameter.
      3. Create a new lambda expression that will accept that same `row` parameter and return the invocation expression.
  5. The resulting `selector`, of type `Expression<Func<TCollection, TResult>>`, can then be passed to `query.Select()` which happily returns the desired `IQueryable<TResult>`.

Essentially we&#8217;re pretending that the `SelectMany` call is just a `Select` call on the `IQueryable<TCollection>` generated by `collectionSelector`, all wrapped in a lazy query.

Hopefully this overview has piqued your interest. Next time we&#8217;ll look at a base implementation of the interfaces.