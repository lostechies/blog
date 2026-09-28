---
wordpress_id: 4194
title: Simplifying LazyLinq
date: 2009-09-13T05:09:00+00:00
author: Keith Dahlby
layout: post
wordpress_guid: /blogs/dahlbyk/archive/2009/09/13/simplifying-lazylinq.aspx
dsq_thread_id:
  - "266760568"
categories:
  - ILazyContext
  - ILazyQueryable
  - LazyLinq
  - LINQ
  - LINQ to SQL
  - Queryable
redirect_from: "/blogs/dahlbyk/archive/2009/09/13/simplifying-lazylinq.aspx/"
---
This is the fourth in a series of posts on [LazyLinq](http://lazylinq.codeplex.com/), a wrapper to support lazy initialization and deferred disposal of a LINQ query context:

  1. [Introducing LazyLinq: Overview](http://solutionizing.net/2009/08/06/introducing-lazylinq-overview/)
  2. [Introducing LazyLinq: Internals](http://solutionizing.net/2009/08/17/introducing-lazylinq-internals/)
  3. [Introducing LazyLinq: Queryability](http://solutionizing.net/2009/08/20/introducing-lazylinq-queryability/)
  4. **Simplifying LazyLinq
  
** 
  5. Introducing LazyLinq: Lazy DataContext

As I was iterating on the proof of concept for LazyLinq, I always wanted to get rid of the `TQuery` type parameter. I thought I needed it to distinguish between ordered and unordered wrapped queries, but it just felt messy. The underlying provider mechanism didn&rsquo;t need it, so why should I?

Well after taking a closer look at the SQL query provider, I figured out how to eliminate it. The object of inspiration is `System.Data.Linq.DataQuery<T>`, defined as follows:

<pre>internal sealed class DataQuery&lt;T&gt; :
    IOrderedQueryable&lt;T&gt;, IQueryable&lt;T&gt;,
    IOrderedQueryable, IQueryable,
    IEnumerable&lt;T&gt;, IEnumerable,
    IQueryProvider,
    IListSource</pre>

The key was realizing that `IOrderedQueryable<>` and `ILazyOrderedQueryable<>` don&rsquo;t actually do anything. Implementation-wise, they&rsquo;re just `IQueryable<>` or `ILazyQueryable<>` with an extra interface on top. It&rsquo;s only on the design side that it actually matters, essentially providing a hook for additional ordering with `ThenBy`. In LINQ to SQL&rsquo;s case, that means supporting orderability is as simple as specifying that the query object is both `IQueryable<>` and `IOrderedQueryable<>`.

So how does this revelation simplify Lazy LINQ? First, it allows us to remove `TQuery` from the interfaces:

<pre>public interface ILazyContext&lt;TContext&gt; : IDisposable
    {
        TContext Context { get; }
        ILazyQueryable&lt;TContext, TResult&gt;
            CreateQuery&lt;TResult&gt;(Func&lt;TContext, IQueryable&lt;TResult&gt;&gt; queryBuilder);
        TResult Execute&lt;TResult&gt;(Func&lt;TContext, TResult&gt; action);
    }

    public interface ILazyQueryable&lt;TContext, TSource&gt; : IQueryable&lt;TSource&gt;

    {
        ILazyContext&lt;TContext&gt; Context { get; }
        Func&lt;TContext, IQueryable&lt;TSource&gt;&gt; QueryBuilder { get; }
    }

    public interface ILazyOrderedQueryable&lt;TContext, TSource&gt;
        : ILazyQueryable&lt;TContext, TSource&gt;, IOrderedQueryable&lt;TSource&gt;

    { }</pre>

Note that we can also eliminate `ILazyContext.CreateOrderedQuery()`, instead assuming that `CreateQuery()` will return something that can be treated as `ILazyOrderedQueryable<>` as necessary.

For the concrete implementations, we take the cue from `DataQuery<T>`, letting `LazyQueryableImpl` implement `ILazyOrderedQueryable<>` so we can eliminate `LazyOrderedQueryableImpl`:

<pre>class LazyQueryableImpl&lt;TContext, TSource&gt;
        : ILazyQueryable&lt;TContext, TSource&gt;, ILazyOrderedQueryable&lt;TContext, TSource&gt;
    {
        // Implementation doesn't change
    }</pre>

Finally, our sorting query operations will look more like their counterparts in `System.Linq.Queryable`, casting the result of `CreateQuery()` to `ILazyOrderedQueryable<>`. To keep things readable, we&rsquo;ll split our `CreateOrderedQuery<>` helper into separate versions for `OrderBy` and `ThenBy`. Note how the types of `queryOperation` map to the usage of `OrderBy` (unordered to ordered) and `ThenBy` (ordered to ordered):

<pre>private static ILazyOrderedQueryable&lt;TContext, TResult&gt;
            CreateOrderByQuery&lt;TSource, TContext, TResult&gt;(
                this ILazyQueryable&lt;TContext, TSource&gt; source,
                Func&lt;IQueryable&lt;TSource&gt;, IOrderedQueryable&lt;TResult&gt;&gt; queryOperation
            )
        {
            return (ILazyOrderedQueryable&lt;TContext, TResult&gt;) source.Context.CreateQuery&lt;TResult&gt;(
               context =&gt; queryOperation(source.QueryBuilder(context)));
        }

        private static ILazyOrderedQueryable&lt;TContext, TResult&gt;

            CreateThenByQuery&lt;TSource, TContext, TResult&gt;(
                this ILazyQueryable&lt;TContext, TSource&gt; source,
                Func&lt;IOrderedQueryable&lt;TSource&gt;, IOrderedQueryable&lt;TResult&gt;&gt; queryOperation
            )
        {
            return (ILazyOrderedQueryable&lt;TContext, TResult&gt;) source.Context.CreateQuery&lt;TResult&gt;(
               context =&gt; queryOperation((IOrderedQueryable&lt;TSource&gt;) source.QueryBuilder(context)));
        }</pre>

Removing `TQuery` from the query operators is left as an exercise for the reader. Or you can just [get the source on CodePlex](http://lazylinq.codeplex.com/ "Lazy LINQ Changeset 26863").

### A Note on `IOrderedEnumerable<>`

Having taken advantage of how LINQ to IQueryable handles orderability, it&rsquo;s worth pointing out that LINQ to Objects uses a different approach, specifying new behavior in `IOrderedEnumerable<>` that is used to support multiple sort criteria:

<pre>public interface IOrderedEnumerable&lt;TElement&gt; : IEnumerable&lt;TElement&gt;, IEnumerable
{
    IOrderedEnumerable&lt;TElement&gt;

        CreateOrderedEnumerable&lt;TKey&gt;(
            Func&lt;TElement, TKey&gt; keySelector,
            IComparer&lt;TKey&gt; comparer, bool descending);
}</pre>