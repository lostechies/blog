---
id: 4190
title: Using IDisposables with LINQ
date: 2009-07-23T08:29:00+00:00
author: Keith Dahlby
layout: post
guid: /blogs/dahlbyk/archive/2009/07/23/using-idisposables-with-linq.aspx
dsq_thread_id:
  - "262493303"
categories:
  - IDisposable
  - LINQ
  - LINQ to SQL
---
Objects that implement `IDisposable` are everywhere. The interface even gets its own language features ([C#](http://msdn.microsoft.com/en-us/library/yh598w02.aspx "using Statement (C# Reference)"), [VB](http://msdn.microsoft.com/en-us/library/htd05whh.aspx "Using Statement (Visual Basic)"), [F#](http://msdn.microsoft.com/en-us/library/dd233240(VS.100).aspx "Resource Management (F#)")). However, LINQ throws a few wrenches into things: 

  1. LINQ&#8217;s query syntax depends on expressions; `using` blocks are statements.
  2. When querying a sequence of `IDisposable` objects, there&#8217;s no easy way to ensure disposal after each element has been consumed.
  3. Returning deferred queries from within a `using` statement is often desired, but fails spectacularly.

There are possible work-arounds for each issue&#8230; 

  1. Put the using statement in a method (named or anonymous) that is called from the query. See also: [Thinking Functional: Using](http://solutionizing.net/2009/02/20/thinking-functional-using/).
  2. Use a method that creates a dispose-safe iterator of the sequence, like [AsSafeEnumerable()](http://solutionizing.net/2009/01/05/linq-for-spwebcollection-revisited-assafeenumerable/ "LINQ for SPWebCollection Revisited: AsSafeEnumerable").
  3. Refactor the method to inject the `IDisposable` dependency, as shown in the first part of Marc&#8217;s answer [here](http://stackoverflow.com/questions/456691/how-does-linq-defer-execution-when-in-a-using-statement/456698#456698 "How does LINQ defer execution when in a using statement").

But, as you might have guessed, I would like to propose a better solution. The code is really complex, so bear with me: 

<pre>public static IEnumerable&lt;T&gt; Use&lt;T&gt;(this T obj) where T : IDisposable
{
    try
    {
        yield return obj;
    }
    finally
    {
        if (obj != null)
            obj.Dispose();
    }
}</pre>

That&#8217;s it. We&#8217;re turning our `IDisposable` object into a single-element sequence. The trick is that the C# compiler will build an iterator for us that properly handles the `finally` clause, ensuring that our object will be disposed. It might be helpful to set a breakpoint on the `finally` clause to get a better idea what&#8217;s happening.

So how can this simple method solve all our problems? First up: &#8220;using&#8221; a `FileStream` object created in a LINQ query: 

<pre>var lengths = from path in myFiles
              from fs in File.OpenRead(path).Use()
              select new { path, fs.Length };</pre>

Since the result of `Use()` is a single-element sequence, we can think of `from fs in something.Use()` as an assignment of that single value, `something`, to `fs`. In fact, it&#8217;s really quite similar to an F# `use` binding in that it will automatically clean itself up when it goes out of scope (by its enumerator calling `MoveNext()`).

Next, disposing elements from a collection. I&#8217;ll use the same SharePoint problem that `AsSafeEnumerable()` solves: 

<pre>var webs = from notDisposed in site.AllWebs
           from web in notDisposed.Use()
           select web.Title;</pre>

I find this syntax rather clumsy compared with `AsSafeEnumerable()`, but it&#8217;s there if you need it.

Finally, let&#8217;s defer disposal of a LINQ to SQL `DataContext` until after the deferred query is executed, as an answer to the [previously-linked Stack Overflow question](http://stackoverflow.com/questions/456691/how-does-linq-defer-execution-when-in-a-using-statement "How does LINQ defer execution when in a using statement"): 

<pre>IQueryable&lt;MyType&gt; MyFunc(string myValue)
{
    return from dc in new MyDataContext().Use()
           from row in dc.MyTable
           where row.MyField == myValue
           select row;
}

void UsingFunc()
{
    var result = MyFunc("MyValue").OrderBy(row =&gt; row.SortOrder);
    foreach(var row in result)
    {
        //Do something
    }
}</pre>

The result of `MyFunc` now owns its destiny completely. It doesn&#8217;t depend on some potentially disposed `DataContext` &#8211; it just creates one that it will dispose when it&#8217;s done. There are probably situations where you would want to share a `DataContext` rather than create one on demand (I don&#8217;t use LINQ to SQL, I just blog about it), but again it&#8217;s there if you need it.

I&#8217;ve only started using this approach recently, so if you have any problems with it please share.