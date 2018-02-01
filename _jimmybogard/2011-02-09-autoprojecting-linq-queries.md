---
id: 452
title: Autoprojecting LINQ queries
date: 2011-02-09T13:51:50+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2011/02/09/autoprojecting-linq-queries.aspx
dsq_thread_id:
  - "264716654"
categories:
  - AutoMapper
  - 'C#'
  - LINQ
---
Something I’ve been looking at adding to AutoMapper was the idea of doing automatic query projection in the Select query projection in LINQ statements.&#160; One downside of AutoMapper is that projection from domain objects still forces the entire domain object to be queried and loaded.&#160; For a lot of read-only scenarios, loading up a tracked, persistent entity is a bit of a waste.&#160; And unless you’re doing CQRS with read-specific tables, you’re doing projection somehow from the write tables.

But many LINQ query providers help with this by parsing expression trees to craft specific SQL queries projecting straight down at the SQL layer.&#160; Additionally, projecting in to these DTOs skips loading persistent, tracked entities into memory.&#160; Unfortunately, we’re then forced to write our boring LHS-RHS code when we drop to this layer: 

<pre><span style="color: blue">return </span>Session.Linq&lt;<span style="color: #2b91af">Conference</span>&gt;()
    .Select(c =&gt; <span style="color: blue">new </span><span style="color: #2b91af">ConferenceShowModel
        </span>{
            Name = c.Name,
            AttendeeCount = c.AttendeeCount,
            SessionCount = c.SessionCount
        }
    )
    .ToArray();</pre>

It’s this pointless, repetitive mapping code that AutoMapper was intended to avoid.&#160; Underneath the covers, the Select clause is just a simple expression:

<pre><span style="color: blue">public static </span><span style="color: #2b91af">IQueryable</span>&lt;TResult&gt; Select&lt;TSource, TResult&gt;(
    <span style="color: blue">this </span><span style="color: #2b91af">IQueryable</span>&lt;TSource&gt; source, 
    <span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;TSource, TResult&gt;&gt; selector)</pre>

So our Select clause from the query earlier is really built from building up an expression tree.&#160; Instead of building up an expression tree through the C# compiler, why don’t we just automatically build up one ourselves, based on the source-destination type?&#160; That’s what I set out to do, at least in a very simplified, non-optimized model.&#160; First, I created an extension method to IQueryable that lets me start to build a projection:

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">QueryableExtensions
</span>{
    <span style="color: blue">public static </span><span style="color: #2b91af">IProjectionExpression </span>Project&lt;TSource&gt;(
        <span style="color: blue">this </span><span style="color: #2b91af">IQueryable</span>&lt;TSource&gt; source)
    {
        <span style="color: blue">return new </span><span style="color: #2b91af">ProjectionExpression</span>&lt;TSource&gt;(source);
    }</pre>

The IProjectionExpression objects lets me then specify a model to project to:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IProjectionExpression
</span>{
    <span style="color: #2b91af">IQueryable</span>&lt;TResult&gt; To&lt;TResult&gt;();
}</pre>

The idea being that I’ll be able to Project().To<MyDto>().&#160; I couldn’t do the projection in one fell swoop with Project<MyDto>().&#160; Generic type parameter inference doesn’t let you do partial parameter inference, so this chaining lets me get away with not having to redundantly specify the original type.&#160; The ProjectionExpression implementation then builds out our expression tree dynamically:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">ProjectionExpression</span>&lt;TSource&gt;
    : <span style="color: #2b91af">IProjectionExpression
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IQueryable</span>&lt;TSource&gt; _source;

    <span style="color: blue">public </span>ProjectionExpression(<span style="color: #2b91af">IQueryable</span>&lt;TSource&gt; source)
    {
        _source = source;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">IQueryable</span>&lt;TResult&gt; To&lt;TResult&gt;()
    {
        <span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;TSource, TResult&gt;&gt; expr = BuildExpression&lt;TResult&gt;();

        <span style="color: blue">return </span>_source.Select(expr);
    }

    <span style="color: blue">public static </span><span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;TSource, TResult&gt;&gt; BuildExpression&lt;TResult&gt;()
    {
        <span style="color: blue">var </span>sourceMembers = <span style="color: blue">typeof</span>(TSource).GetProperties();
        <span style="color: blue">var </span>destinationMembers = <span style="color: blue">typeof</span>(TResult).GetProperties();

        <span style="color: blue">var </span>name = <span style="color: #a31515">"src"</span>;

        <span style="color: blue">var </span>parameterExpression = <span style="color: #2b91af">Expression</span>.Parameter(<span style="color: blue">typeof</span>(TSource), name);

        <span style="color: blue">return </span><span style="color: #2b91af">Expression</span>.Lambda&lt;<span style="color: #2b91af">Func</span>&lt;TSource, TResult&gt;&gt;(
            <span style="color: #2b91af">Expression</span>.MemberInit(
                <span style="color: #2b91af">Expression</span>.New(<span style="color: blue">typeof</span>(TResult)),
                destinationMembers.Select(dest =&gt; <span style="color: #2b91af">Expression</span>.Bind(dest,
                    <span style="color: #2b91af">Expression</span>.Property(
                        parameterExpression,
                        sourceMembers.First(pi =&gt; pi.Name == dest.Name)
                    )
                )).ToArray()
                ),
            parameterExpression
            );
    }
}</pre>

It’s not very optimized, as it builds out the expression tree every time.&#160; But that’s an easy enhancement, as once the expression tree is built from TSource –> TDestination, it could be statically cached and re-used.&#160; But once I have this in place, my LINQ query becomes greatly simplified:

<pre><span style="color: blue">public </span><span style="color: #2b91af">ConferenceShowModel</span>[] List()
{
    <span style="color: blue">return </span>Session.Linq&lt;<span style="color: #2b91af">Conference</span>&gt;()
        .Project().To&lt;<span style="color: #2b91af">ConferenceShowModel</span>&gt;()
        .ToArray();
}</pre>

Just one Project().To() method call, and the expression for the projection statement is automatically built up, assuming that all properties match by name.&#160; This is a simplified version of what happens in AutoMapper, so you don’t see all of the things that the underlying LINQ query provider supports with projections.

But it’s a start.