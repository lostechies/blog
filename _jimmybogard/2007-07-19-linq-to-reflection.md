---
id: 42
title: LINQ to Reflection
date: 2007-07-19T15:27:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/07/19/linq-to-reflection.aspx
dsq_thread_id:
  - "278783893"
categories:
  - 'C#'
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/07/linq-to-reflection.html)._

One of the great things about LINQ is that it allows me to query over any object that implements IEnumerable<T>.&nbsp; This includes arrays, List<T>, Collection<T>, and many others.&nbsp; Since many operations involving reflection return arrays, this means I&#8217;m open to using LINQ over those operations.&nbsp; Let&#8217;s look at a few examples.

#### Loading up assemblies for searching

First, I&#8217;d like to load some assemblies for searching.&nbsp; The easiest way I found to do this was to use [System.Reflection.Assembly.LoadWithPartialName](http://msdn2.microsoft.com/en-us/library/12xc5368.aspx).&nbsp; This method has been deprecated as of .NET 2.0, but it will suffice for simple operations such as searching.&nbsp; I wouldn&#8217;t use that method for production code, it&#8217;s too unreliable.

I first came up with a list of assembly names I wanted to search and dumped them in an array:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">string</span>[] assemblyNames = { <span class="str">"System"</span>, 
                 <span class="str">"mscorlib"</span>, 
                 <span class="str">"System.AddIn"</span>,
                 <span class="str">"System.Configuration"</span>, 
                 <span class="str">"System.Core"</span>, 
                 <span class="str">"System.Data"</span>,
                 <span class="str">"System.Data.Entity"</span>,
                 <span class="str">"System.Data.Entity.Design"</span>,
                 <span class="str">"System.Data.Linq"</span>,
                 <span class="str">"System.Deployment"</span>,
                 <span class="str">"System.Design"</span>,
                 <span class="str">"System.DirectoryServices"</span>,
                 <span class="str">"System.DirectoryServices.Protocols"</span>,
                 <span class="str">"System.Drawing"</span>,
                 <span class="str">"System.Drawing.Design"</span>,
                 <span class="str">"System.EnterpriseServices"</span>,
                 <span class="str">"System.IdentityModel"</span>,
                 <span class="str">"System.IdentityModel.Selectors"</span>,
                 <span class="str">"System.Management"</span>,
                 <span class="str">"System.Management.Instrumentation"</span>,
                 <span class="str">"System.Messaging"</span>,
                 <span class="str">"System.Printing"</span>,
                 <span class="str">"System.Runtime.Remoting"</span>,
                 <span class="str">"System.Runtime.Serialization"</span>,
                 <span class="str">"System.Security"</span>,
                 <span class="str">"System.ServiceModel"</span>,
                 <span class="str">"System.ServiceProcess"</span>,
                 <span class="str">"System.Transactions"</span>,
                 <span class="str">"System.Web"</span>, 
                 <span class="str">"System.Web.Services"</span>, 
                 <span class="str">"System.Windows.Forms"</span>, 
                 <span class="str">"System.Workflow.Activities"</span>, 
                 <span class="str">"System.Workflow.ComponentModel"</span>, 
                 <span class="str">"System.Workflow.Runtime"</span>, 
                 <span class="str">"System.WorkflowServices"</span>, 
                 <span class="str">"System.Xml"</span>, 
                 <span class="str">"System.Xml.Linq"</span>
             };
</pre>
</div>

It&#8217;s pretty much all of the .NET Framework 3.5 assemblies.&nbsp; Next, I want to create a LINQ query to load up all of the assemblies, so I can perform searches over those assemblies.&nbsp; Just using the extension methods, it would look like this:

<div class="CodeFormatContainer">
  <pre>var assemblies = assemblyNames.Select(name =&gt; Assembly.LoadWithPartialName(name));
</pre>
</div>

With LINQ magic, here&#8217;s what the same query would look like:

<div class="CodeFormatContainer">
  <pre>var assemblies = from name <span class="kwrd">in</span> assemblyNames
            select Assembly.LoadWithPartialName(name);
</pre>
</div>

With the &#8220;assemblies&#8221; variable (which is actually IEnumerable<Assembly>), I can start performing queries over the loaded assemblies.

#### Finding generic delegates

I was experimenting with an API, and I wanted to know if a generic delegate I created already existed somewhere in .NET.&nbsp; I can use some handy LINQ expressions over the loaded assemblies to do just that.&nbsp; But first, I need to know how to find what I&#8217;m looking for.&nbsp; I can just load up a generic delegate I&#8217;m already aware of into a Type object:

<div class="CodeFormatContainer">
  <pre>Type actionDelegate = <span class="kwrd">typeof</span>(Action&lt;&gt;);</pre>
</div>

When I load up a generic delegate into an instance of a Type object, I notice some key properties, such as &#8220;IsGenericType&#8221; and &#8220;IsPublic&#8221;.&nbsp; Both of these are true for my generic delegate type.&nbsp; Unfortunately, there is no &#8220;IsDelegate&#8221; property, but it turns out that IsSubclassOf(typeof(Delegate)) will return &#8220;true&#8221;.&nbsp; Combining these three conditions, I have a predicate to use in my search across the assemblies.

Here&#8217;s the final LINQ query:

<div class="CodeFormatContainer">
  <pre>var types = from name <span class="kwrd">in</span> assemblyNames
            select Assembly.LoadWithPartialName(name) into a
            from c <span class="kwrd">in</span> a.GetTypes()
            <span class="kwrd">where</span> c.IsGenericType && c.IsPublic && c.IsSubclassOf(<span class="kwrd">typeof</span>(Delegate))
            select c;

<span class="kwrd">foreach</span> (Type t <span class="kwrd">in</span> types)
{
    Debug.WriteLine(t);
}</pre>
</div>

This is actually two LINQ queries joined together with a continuation (the &#8220;into a&#8221; part).&nbsp; The first query enumerates over the assembly string names to load the assemblies.&nbsp; The second query calls &#8220;GetTypes&#8221; on each assembly to load the types, and uses the &#8220;where&#8221; clause to only pull out the generic delegates using a predicate I found earlier.&nbsp; The results of this block of code shows me the generic delegates:

<div class="CodeFormatContainer">
  <pre>System.EventHandler`1[TEventArgs]
System.Action`1[T]
System.Comparison`1[T]
System.Converter`2[TInput,TOutput]
System.Predicate`1[T]
System.Linq.Func`1[TResult]
System.Linq.Func`2[TArg0,TResult]
System.Linq.Func`3[TArg0,TArg1,TResult]
System.Linq.Func`4[TArg0,TArg1,TArg2,TResult]
System.Linq.Func`5[TArg0,TArg1,TArg2,TArg3,TResult]</pre>
</div>

Not a whole lot, but it did tell me what was already there.&nbsp; Specifically, I had been looking for alternate overloads to Action<T>, to see if there were multiple delegate declarations like there are for Func<TResult>.&nbsp; There aren&#8217;t, but it turns out [there are planned overloads for Action to match Func](http://forums.microsoft.com/MSDN/ShowPost.aspx?PostID=1503788&SiteID=1).

#### Context and IDisposable

I had a discussion with a team member that centered around types with names postfixed with &#8220;Context&#8221;.&nbsp; I was arguing that types named &#8220;Context&#8221; implied that the type implemented IDisposable, as it was intended to create a scope.&nbsp; Instead of arguing in conjectures, I sought to get some actual data, and find how many types in the .NET Framework named &#8220;Context&#8221; also implemented IDisposable.&nbsp; Here&#8217;s the LINQ query I came up with:

<div class="CodeFormatContainer">
  <pre>var types = from name <span class="kwrd">in</span> assemblyNames
            select Assembly.LoadWithPartialName(name) into a
            from c <span class="kwrd">in</span> a.GetTypes()
            <span class="kwrd">where</span> (c.IsClass || c.IsInterface) && c.FullName.EndsWith(<span class="str">"Context"</span>)
            group c.FullName by c.GetInterfaces().Contains(<span class="kwrd">typeof</span>(IDisposable)) into g
            select <span class="kwrd">new</span> { IsIDisposable = g.Key, Types = g };</pre>
</div>

In this query,&nbsp;I want to select all types that the name ends with &#8220;Context&#8221;, and group these into different bins based on whether they implement IDisposable or not.&nbsp; To do this, I take advantage of both grouping in LINQ, and anonymous types to hold the data.&nbsp; I output the results:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">foreach</span> (var g <span class="kwrd">in</span> types)
{
    Debug.WriteLine(<span class="kwrd">string</span>.Format(<span class="str">"{0} types where IsIDisposable is {1}"</span>, g.Types.Count(), g.IsIDisposable));
    <span class="kwrd">if</span> (g.IsIDisposable)
    {
        <span class="kwrd">foreach</span> (<span class="kwrd">string</span> t <span class="kwrd">in</span> g.Types)
        {
            Debug.WriteLine(t);
        }
    }
}</pre>
</div>

And find that my argument doesn&#8217;t hold up.&nbsp; Here are the results:

<div class="CodeFormatContainer">
  <pre>144 types <span class="kwrd">where</span> IsIDisposable <span class="kwrd">is</span> False
50 types <span class="kwrd">where</span> IsIDisposable <span class="kwrd">is</span> True</pre>
</div>

I left out the output that printed out all of the Context IDisposable types, as this list was fairly long.&nbsp; I decided not to filter out non-public types, as MS tends to have lots of types marked &#8220;internal&#8221;.&nbsp; So it turned out that only 25% of types that&nbsp;end with &#8220;Context&#8221;&nbsp;implement IDisposable, so my assumptions were incorrect.

#### Other applications

LINQ provides a clean syntax to search assemblies using reflection.&nbsp; I&#8217;ve also used it to argue against read-write properties for array types (they account for only 0.6% of all collection-type properties).&nbsp; The continuations and joining lower the barrier for searching for specific types, properties, etc.&nbsp; Since the LINQ methods are extension methods for any IEnumerable<T> type, you&#8217;ll be pleasantly surprised when IntelliSense&nbsp;kicks in&nbsp;at the options available&nbsp;for querying and manipulating collections and arrays.