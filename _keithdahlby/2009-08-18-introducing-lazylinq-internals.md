---
wordpress_id: 4192
title: 'Introducing LazyLinq: Internals'
date: 2009-08-18T05:25:00+00:00
author: Keith Dahlby
layout: post
wordpress_guid: /blogs/dahlbyk/archive/2009/08/18/introducing-lazylinq-internals.aspx
dsq_thread_id:
  - "274094817"
categories:
  - Uncategorized
---
This is the second in a series of posts on LazyLinq, a wrapper to support lazy initialization and deferred disposal of a LINQ query context: 

  1. [Introducing LazyLinq: Overview](http://solutionizing.net/2009/08/06/introducing-lazylinq-overview/)
  2. **Introducing LazyLinq: Internals**
  3. [Introducing LazyLinq: Queryability](http://solutionizing.net/2009/08/20/introducing-lazylinq-queryability/)
  4. [Simplifying LazyLinq](http://solutionizing.net/2009/09/12/simplifying-lazylinq/) 
  5. Introducing LazyLinq: Lazy DataContext

My first post introduced the three interfaces that LazyLinq provides. Next, we get to implement them. 

## Implementing ILazyQueryable

First, the interface: 

<pre>public interface ILazyQueryable&lt;TContext, TSource, TQuery&gt;<br />        : IQueryable&lt;TSource&gt;<br />        where TQuery : IQueryable&lt;TSource&gt;<br />    {<br />        ILazyContext&lt;TContext&gt; Context { get; }<br />        Func&lt;TContext, TQuery&gt; QueryBuilder { get; }<br />    }</pre>

We&#8217;ll start simple with an implicit implementation of the interface and a trivial constructor: 

<pre>class LazyQueryableImpl&lt;TContext, TSource, TQuery&gt;<br />            : ILazyQueryable&lt;TContext, TSource, TQuery&gt;<br />            where TQuery : IQueryable&lt;TSource&gt;<br />    {<br />            public ILazyContext&lt;TContext&gt; Context { get; private set; }<br />            public Func&lt;TContext, TQuery&gt; QueryBuilder { get; private set; }<br /><br />            internal LazyQueryableImpl(ILazyContext&lt;TContext&gt; deferredContext, Func&lt;TContext, TQuery&gt; queryBuilder)<br />            {<br />                if (deferredContext == null) throw new ArgumentNullException("deferredContext");<br />                if (queryBuilder == null) throw new ArgumentNullException("queryBuilder");<br /><br />                Context = deferredContext;<br />                QueryBuilder = queryBuilder;<br />            }</pre>

Next, a lazy-loaded query built from our lazy context: 

<pre>protected TQuery Query<br />            {<br />                get<br />                {<br />                    if (query == null)<br />                    {<br />                        query = QueryBuilder(Context.Context);<br />                        if (query == null)<br />                            throw new InvalidOperationException("Query built as null.");<br />                    }<br />                    return query;<br />                }<br />            }</pre>

And the internals of managing `Context`, which implements `IDisposable`: 

<pre>private void Dispose()<br />            {<br />                Context.Dispose();<br />                query = default(TQuery);<br />            }<br /><br />            private IEnumerator&lt;TSource&gt; GetEnumerator()<br />            {<br />                try<br />                {<br />                    foreach (var i in Query)<br />                        yield return i;<br />                }<br />                finally<br />                {<br />                    Dispose();<br />                }<br />            }</pre>

Since `Query` depends on `Context`, once `Context` is disposed we need to reset `Query` so a new one can be built (if possible). Note that we use an iterator here to return an `IEnumerator<TSource>`, rather than the usual `IEnumerable<>`.

Finally, we&#8217;ll close out by explicitly implementing `IQueryable`: 

<pre>IEnumerator&lt;TSource&gt; IEnumerable&lt;TSource&gt;.GetEnumerator()<br />            {<br />                return GetEnumerator();<br />            }<br /><br />            IEnumerator IEnumerable.GetEnumerator()<br />            {<br />                return GetEnumerator();<br />            }<br /><br />            Type IQueryable.ElementType<br />            {<br />                get { return Query.ElementType; }<br />            }<br /><br />            Expression IQueryable.Expression<br />            {<br />                get { return Query.Expression; }<br />            }<br /><br />            IQueryProvider IQueryable.Provider<br />            {<br />                get { return Query.Provider; }<br />            }<br />        }</pre>

If this seemed relatively simple, you&#8217;re right. We&#8217;re just building a lazy-loaded `Query` proxy, with a bit of plumbing to clean up our `Context`. 

## Implementing ILazyOrderedQueryable

Not very exciting, but for completeness: 

<pre>public interface ILazyOrderedQueryable&lt;TContext, TSource, TQuery&gt;<br />            : ILazyQueryable&lt;TContext, TSource, TQuery&gt;, IOrderedQueryable&lt;TSource&gt;<br />            where TQuery : IOrderedQueryable&lt;TSource&gt;<br />        { }<br /><br />        class LazyOrderedQueryableImpl&lt;TContext, TSource, TQuery&gt;<br />                : LazyQueryableImpl&lt;TContext, TSource, TQuery&gt;, ILazyOrderedQueryable&lt;TContext, TSource, TQuery&gt;<br />                where TQuery : IOrderedQueryable&lt;TSource&gt;<br />        {<br />            internal LazyOrderedQueryableImpl(ILazyContext&lt;TContext&gt; lazyContext, Func&lt;TContext, TQuery&gt; queryBuilder)<br />                : base(lazyContext, queryBuilder)<br />            {<br />            }<br />        }</pre>

## LazyQueryable Factory

Consumers of this API should never need to know about these implementation details, so we can hide them behind a factory class: 

<pre>public static class LazyQueryable<br />        {<br />            public static ILazyQueryable&lt;TContext, TResult, TQuery&gt; CreateQuery&lt;TContext, TResult, TQuery&gt;(<br />                ILazyContext&lt;TContext&gt; context, Func&lt;TContext, TQuery&gt; queryBuilder)<br />                where TQuery : IQueryable&lt;TResult&gt;<br />            {<br />                return new LazyQueryableImpl&lt;TContext, TResult, TQuery&gt;(context, queryBuilder);<br />            }<br />            public static ILazyOrderedQueryable&lt;TContext, TResult, TQuery&gt; CreateOrderedQuery&lt;TContext, TResult, TQuery&gt;(<br />                ILazyContext&lt;TContext&gt; context, Func&lt;TContext, TQuery&gt; queryBuilder)<br />                where TQuery : IOrderedQueryable&lt;TResult&gt;<br />            {<br />                return new LazyOrderedQueryableImpl&lt;TContext, TResult, TQuery&gt;(context, queryBuilder);<br />            }<br />        }</pre>

## Implementing ILazyContext

Again, we&#8217;ll start with the interface: 

<pre>public interface ILazyContext&lt;TContext&gt; : IDisposable<br />        {<br />            TContext Context { get; }<br /><br />            ILazyQueryable&lt;TContext, TResult, TQuery&gt;<br />                CreateQuery&lt;TResult, TQuery&gt;(Func&lt;TContext, TQuery&gt; queryBuilder)<br />                where TQuery : IQueryable&lt;TResult&gt;;<br /><br />            ILazyOrderedQueryable&lt;TContext, TResult, TQuery&gt;<br />                CreateOrderedQuery&lt;TResult, TQuery&gt;(Func&lt;TContext, TQuery&gt; queryBuilder)<br />                where TQuery : IOrderedQueryable&lt;TResult&gt;;<br /><br />            TResult Execute&lt;TResult&gt;(Func&lt;TContext, TResult&gt; action);<br />        }</pre>

Now we can start fulfilling our requirements: 

### 1. Lazily expose the Context.

<pre>class LazyContextImpl&lt;TContext&gt; : ILazyContext&lt;TContext&gt;, IDisposable<br />        {<br />            public Func&lt;TContext&gt; ContextBuilder { get; private set; }<br /><br />            private TContext context;<br />            public TContext Context<br />            {<br />                get<br />                {<br />                    if (context == null)<br />                    {<br />                        context = ContextBuilder();<br />                        if (context == null)<br />                            throw new InvalidOperationException("Context built as null.");<br />                    }<br />                    return context;<br />                }<br />            }</pre>

### 2. Produce lazy wrappers to represent queries retrieved from a context by a delegate.

<pre>public ILazyQueryable&lt;TContext, TResult, TQuery&gt; CreateQuery&lt;TResult, TQuery&gt;(<br />                Func&lt;TContext, TQuery&gt; queryBuilder)<br />                where TQuery : IQueryable&lt;TResult&gt;<br />            {<br />                return LazyQueryable.CreateQuery&lt;TContext, TResult, TQuery&gt;(this, queryBuilder);<br />            }<br /><br />            public ILazyOrderedQueryable&lt;TContext, TResult, TQuery&gt; CreateOrderedQuery&lt;TResult, TQuery&gt;(<br />                Func&lt;TContext, TQuery&gt; queryBuilder)<br />                where TQuery : IOrderedQueryable&lt;TResult&gt;<br />            {<br />                return LazyQueryable.CreateOrderedQuery&lt;TContext, TResult, TQuery&gt;(this, queryBuilder);<br />            }</pre>

### 3. Execute an action on the context.

There are two ways to &#8220;complete&#8221; a query, and we need to clean up context after each. The first was after enumeration, implemented above. The second is on execute, implemented here: 

<pre>public TResult Execute&lt;TResult&gt;(Func&lt;TContext, TResult&gt; expression)<br />            {<br />                try<br />                {<br />                    return expression(Context);<br />                }<br />                finally<br />                {<br />                    Dispose();<br />                }<br />            }</pre>

### 4. Ensure the context is disposed as necessary.

We don&#8217;t require that `TContext` is `IDisposable`, but we need to handle if it is. We also clear context to support reuse. 

<pre>public void Dispose()<br />            {<br />                var disposable = context as IDisposable;<br />                if (disposable != null)<br />                    disposable.Dispose();<br /><br />                context = default(TContext);<br />            }</pre>

### Constructors

With our requirements met, we just need a way to create our context. We provide two options: 

<pre>internal LazyContextImpl(TContext context) : this(() =&gt; context) { }<br /><br />            internal LazyContextImpl(Func&lt;TContext&gt; contextBuilder)<br />            {<br />                if (contextBuilder == null) throw new ArgumentNullException("contextBuilder");<br /><br />                ContextBuilder = contextBuilder;<br />            }</pre>

The former wraps an existing `TContext` instance in a closure, meaning every time `ContextBuilder` is called it returns the same instance. The latter accepts any delegate that returns a `TContext`. The most common such delegate would be a simple instantiation: `() => new MyDataContext()`.

It should be clear now why we would want to clear our context on dispose. If `ContextBuilder` returns a new context instance each time, it&#8217;s perfectly safe to discard of the old (disposed) context to trigger the creation of a new one. Conversely, if the builder returns a single instance, using the context after disposal would trigger an `ObjectDisposedException` or something similar. 

## LazyContext Factory

For consistency, we should also provide factory methods to hide this specific implementation: 

<pre>public static class LazyContext<br />            {<br />                public static ILazyContext&lt;T&gt; Create&lt;T&gt;(T context)<br />                {<br />                    return new LazyContextImpl&lt;T&gt;(context);<br />                }<br />                public static ILazyContext&lt;T&gt; Create&lt;T&gt;(Func&lt;T&gt; contextBuilder)<br />                {<br />                    return new LazyContextImpl&lt;T&gt;(contextBuilder);<br />                }<br />            }</pre>

## Lazy Extensions

And last, but certainly not least, we&#8217;re ready to reimplement our `Use()` extension methods: 

<pre>public static class Lazy<br />    {<br />        public static ILazyContext&lt;TContext&gt; Use&lt;TContext&gt;(this TContext @this)<br />        {<br />            return LazyContext.Create&lt;TContext&gt;(@this);<br />        }<br /><br />        public static ILazyContext&lt;TContext&gt; Use&lt;TContext&gt;(this Func&lt;TContext&gt; @this)<br />        {<br />            return LazyContext.Create&lt;TContext&gt;(@this);<br />        }<br />    }</pre>

With several usage possibilities: 

<pre>var r1 = from x in new MyDataContext().Use() ...;<br /><br />    Func&lt;MyDataContext&gt; f1 = () =&gt; new MyDataContext();<br />    var r2 = from x in f1.Use() ...;<br /><br />    var r3 = from x in new Func&lt;MyDataContext&gt;(() =&gt; new MyDataContext()).Use() ...;<br /><br />    var r4 = from x in Lazy.Use(() =&gt; new MyDataContext()) ...;</pre>

Or maybe we can make it even easier. Maybe&#8230;