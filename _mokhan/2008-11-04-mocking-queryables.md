---
wordpress_id: 4569
title: Mocking Queryables
date: 2008-11-04T15:59:09+00:00
author: Mo Khan
layout: post
wordpress_guid: /blogs/mokhan/archive/2008/11/04/mocking-queryables.aspx
categories:
  - TDD
---
Recently, we&#8217;ve been mocking out IQueryable&#8217;s as return values, which had led to setups that look like the following&#8230;</p> 

<pre>programs.setup_result_for(x =&gt; x.All()).Return(<span style="color: blue">new </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">IProgram</span>&gt; {active_program,inactive_program}.AsQueryable());</pre>

[](http://11011.net/software/vspaste)

I just switched over to the following syntax&#8230; by creating an extension method.

<pre>programs.setup_result_for(x =&gt; x.All()).will_return(active_program,inactive_program);</pre>

[](http://11011.net/software/vspaste)

The following are the extensions methods to make this work.

<pre><span style="color: blue">public static </span><span style="color: #2b91af">IMethodOptions</span>&lt;<span style="color: #2b91af">IEnumerable</span>&lt;R&gt;&gt; will_return&lt;R&gt;(<span style="color: blue">this </span><span style="color: #2b91af">IMethodOptions</span>&lt;<span style="color: #2b91af">IEnumerable</span>&lt;R&gt;&gt; options,
                                                            <span style="color: blue">params </span>R[] items)
{
    <span style="color: blue">return </span>options.Return(items);
}

<span style="color: blue">public static </span><span style="color: #2b91af">IMethodOptions</span>&lt;<span style="color: #2b91af">IQueryable</span>&lt;R&gt;&gt; will_return&lt;R&gt;(<span style="color: blue">this </span><span style="color: #2b91af">IMethodOptions</span>&lt;<span style="color: #2b91af">IQueryable</span>&lt;R&gt;&gt; options,
                                                           <span style="color: blue">params </span>R[] items)
{
    <span style="color: blue">return </span>options.Return(<span style="color: blue">new </span><span style="color: #2b91af">Query</span>&lt;R&gt;(items));
}</pre>

&#160;

and&#8230;

&#160;

<pre><span style="color: blue">internal class </span><span style="color: #2b91af">Query</span>&lt;T&gt; : <span style="color: #2b91af">IQueryable</span>&lt;T&gt;
{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IQueryable</span>&lt;T&gt; query;

    <span style="color: blue">public </span>Query(<span style="color: blue">params </span>T[] items)
    {
        query = items.AsQueryable();
    }

    <span style="color: blue">public </span><span style="color: #2b91af">Expression </span>Expression
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span>query.Expression; }
    }

    <span style="color: blue">public </span><span style="color: #2b91af">Type </span>ElementType
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span>query.ElementType; }
    }

    <span style="color: blue">public </span><span style="color: #2b91af">IQueryProvider </span>Provider
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span>query.Provider; }
    }

    <span style="color: blue">public </span><span style="color: #2b91af">IEnumerator</span>&lt;T&gt; GetEnumerator()
    {
        <span style="color: blue">return </span>query.GetEnumerator();
    }

    <span style="color: #2b91af">IEnumerator IEnumerable</span>.GetEnumerator()
    {
        <span style="color: blue">return </span>GetEnumerator();
    }
}</pre>

&#160;

Hope, this helps!