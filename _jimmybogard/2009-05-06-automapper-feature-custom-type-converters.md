---
id: 309
title: AutoMapper feature – custom type converters
date: 2009-05-06T01:57:48+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/05/05/automapper-feature-custom-type-converters.aspx
dsq_thread_id:
  - "264716130"
categories:
  - AutoMapper
---
This one came up on the mailing list, so I thought I might as well blog about it (and fill in the [documentation](http://automapper.codeplex.com/Wiki/View.aspx?title=Custom%20Type%20Converters)).

Sometimes, you need to take complete control over the conversion of one type to another. This is typically when one type looks nothing like the other, a conversion function already exists, and you would like to go from a "looser" type to a stronger type, such as a source type of string to a destination type of Int32.

For example, suppose we have a source type of:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Source
</span>{
    <span style="color: blue">public string </span>Value1 { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>Value2 { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>Value3 { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

But you would like to map it to:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Destination
</span>{
    <span style="color: blue">public int </span>Value1 { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">DateTime </span>Value2 { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">Type </span>Value3 { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

If we were to try and map these two types as-is, AutoMapper would throw an exception (at map time and configuration-checking time), as AutoMapper does not know about any mapping from string to int, DateTime or Type. To create maps for these types, we must supply a custom type converter, and we have three ways of doing so:

<pre><span style="color: blue">void </span>ConvertUsing(<span style="color: #2b91af">Func</span>&lt;TSource, TDestination&gt; mappingFunction);
<span style="color: blue">void </span>ConvertUsing(<span style="color: #2b91af">ITypeConverter</span>&lt;TSource, TDestination&gt; converter);
<span style="color: blue">void </span>ConvertUsing&lt;TTypeConverter&gt;() <span style="color: blue">where </span>TTypeConverter : <span style="color: #2b91af">ITypeConverter</span>&lt;TSource, TDestination&gt;;</pre>

[](http://11011.net/software/vspaste)

The first option is simply any function that takes a source and returns a destination. This works for simple cases, but becomes unwieldy for larger ones. In more difficult cases, we can create a custom ITypeConverter<TSource, TDestination>:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">ITypeConverter</span>&lt;TSource, TDestination&gt;
{
    TDestination Convert(TSource source);
}</pre>

[](http://11011.net/software/vspaste)

And supply AutoMapper with either an instance of a custom type converter, or simply the type, which AutoMapper will instantiate at run time. The mapping configuration for our above source/destination types then becomes:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Example()
{
    <span style="color: #2b91af">Mapper</span>.CreateMap&lt;<span style="color: blue">string</span>, <span style="color: blue">int</span>&gt;().ConvertUsing(<span style="color: #2b91af">Convert</span>.ToInt32);
    <span style="color: #2b91af">Mapper</span>.CreateMap&lt;<span style="color: blue">string</span>, <span style="color: #2b91af">DateTime</span>&gt;().ConvertUsing(<span style="color: blue">new </span><span style="color: #2b91af">DateTimeTypeConverter</span>());
    <span style="color: #2b91af">Mapper</span>.CreateMap&lt;<span style="color: blue">string</span>, <span style="color: #2b91af">Type</span>&gt;().ConvertUsing&lt;<span style="color: #2b91af">TypeTypeConverter</span>&gt;();
    <span style="color: #2b91af">Mapper</span>.CreateMap&lt;<span style="color: #2b91af">Source</span>, <span style="color: #2b91af">Destination</span>&gt;();
    <span style="color: #2b91af">Mapper</span>.AssertConfigurationIsValid();

    <span style="color: blue">var </span>source = <span style="color: blue">new </span><span style="color: #2b91af">Source
    </span>{
        Value1 = <span style="color: #a31515">"5"</span>,
        Value2 = <span style="color: #a31515">"01/01/2000"</span>,
        Value3 = <span style="color: #a31515">"AutoMapperSamples.GlobalTypeConverters.GlobalTypeConverters+Destination"
    </span>};

    <span style="color: #2b91af">Destination </span>result = <span style="color: #2b91af">Mapper</span>.Map&lt;<span style="color: #2b91af">Source</span>, <span style="color: #2b91af">Destination</span>&gt;(source);
    result.Value3.ShouldEqual(<span style="color: blue">typeof </span>(<span style="color: #2b91af">Destination</span>));
}

<span style="color: blue">public class </span><span style="color: #2b91af">DateTimeTypeConverter </span>: <span style="color: #2b91af">ITypeConverter</span>&lt;<span style="color: blue">string</span>, <span style="color: #2b91af">DateTime</span>&gt;
{
    <span style="color: blue">public </span><span style="color: #2b91af">DateTime </span>Convert(<span style="color: blue">string </span>source)
    {
        <span style="color: blue">return </span>System.<span style="color: #2b91af">Convert</span>.ToDateTime(source);
    }
}

<span style="color: blue">public class </span><span style="color: #2b91af">TypeTypeConverter </span>: <span style="color: #2b91af">ITypeConverter</span>&lt;<span style="color: blue">string</span>, <span style="color: #2b91af">Type</span>&gt;
{
    <span style="color: blue">public </span><span style="color: #2b91af">Type </span>Convert(<span style="color: blue">string </span>source)
    {
        <span style="color: #2b91af">Type </span>type = <span style="color: #2b91af">Assembly</span>.GetExecutingAssembly().GetType(source);
        <span style="color: blue">return </span>type;
    }
}</pre>

[](http://11011.net/software/vspaste)

In the first mapping, from string to Int32, we simply use the built-in Convert.ToInt32 function (supplied as a method group). The next two use custom ITypeConverter implementations.

The real power of custom type converters is that they are used any time AutoMapper finds the source/destination pairs on any mapped types. We can build a set of custom type converters, on top of which other mapping configurations use, without needing any extra configuration. In the above example, we never have to specify the string/int conversion again. Where as [Custom Value Resolvers](http://automapper.codeplex.com/Wiki/View.aspx?title=Custom%20Value%20Resolvers&referringTitle=Home) have to be configured at a type member level, custom type converters are global in scope.

In our applications, we use custom type converters to do a lot of the conversions from strings in the UI to real-deal domain-level types, such as real DateTimes, real entities, and so on.&#160; We found custom model binding in MVC to be somewhat lacking in what we needed, especially around validation, for our tastes.&#160; Instead, we convert a UI message to a stronger-typed domain message, and do away with all the duplicated type conversions we had littered around.