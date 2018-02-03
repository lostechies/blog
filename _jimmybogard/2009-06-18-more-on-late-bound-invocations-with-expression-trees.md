---
wordpress_id: 326
title: More on Late-Bound Invocations with Expression Trees
date: 2009-06-18T01:04:44+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/06/17/more-on-late-bound-invocations-with-expression-trees.aspx
dsq_thread_id:
  - "264716181"
categories:
  - 'C#'
---
Recently, I went on a bit of a tear in the AutoMapper trying to improve performance.&#160; Besides the threading issues I introduced (dictionary lookups are NOT thread safe, in case you’re wondering), I looked at improving the performance of the reflection piece of AutoMapper.&#160; At its core, I map various kinds of MemberInfo objects on source types to MemberInfo objects on destination types.&#160; The semantic model is a little more involved of course, but that’s the basic model of going from one complex type to another.

I was quite dreading speeding up the reflection piece, not because IL generation and reflection emit isn’t interesting and all that, but it all looks quite ugly and hard to maintain.&#160; Until I stumbled upon Nate Kohari’s post on [late-bound invocations via expression trees](http://kohari.org/2009/03/06/fast-late-bound-invocation-with-expression-trees/), I was avoiding that piece.&#160; The basic idea is that expression trees, when compiled, are able to use regular reflection MemberInfo objects to generate the right IL at runtime to do what you normally do at compile time.&#160; If you want a good sample of how to do IL, take a look at the expression tree compilation code in Reflector.

His example worked great for methods, but AutoMapper also supports properties and fields.&#160; To achieve the same result, I needed first to define a couple more delegate types to capture the kind of call you would do with fields and properties:

<pre><span style="color: blue">public delegate object </span><span style="color: #2b91af">LateBoundProperty</span>(<span style="color: blue">object </span>target);
<span style="color: blue">public delegate object </span><span style="color: #2b91af">LateBoundField</span>(<span style="color: blue">object </span>target);</pre>

[](http://11011.net/software/vspaste)

Next, I just needed to create the expression tree for calling a field and property.&#160; The property one is this:

<pre><span style="color: blue">public static </span><span style="color: #2b91af">LateBoundProperty </span>Create(<span style="color: #2b91af">PropertyInfo </span>property)
{
    <span style="color: #2b91af">ParameterExpression </span>instanceParameter = <span style="color: #2b91af">Expression</span>.Parameter(<span style="color: blue">typeof</span>(<span style="color: blue">object</span>), <span style="color: #a31515">"target"</span>);

    <span style="color: #2b91af">MemberExpression </span>member = <span style="color: #2b91af">Expression</span>.Property(<span style="color: #2b91af">Expression</span>.Convert(instanceParameter, property.DeclaringType), property);

    <span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">LateBoundProperty</span>&gt; lambda = <span style="color: #2b91af">Expression</span>.Lambda&lt;<span style="color: #2b91af">LateBoundProperty</span>&gt;(
        <span style="color: #2b91af">Expression</span>.Convert(member, <span style="color: blue">typeof</span>(<span style="color: blue">object</span>)),
        instanceParameter
        );

    <span style="color: blue">return </span>lambda.Compile();
}</pre>

[](http://11011.net/software/vspaste)

I first create an expression that represents a call to a property (the MemberExpression instance).&#160; Next, I need to wrap that MemberExpression call with a LambdaExpression, of type LateBoundProperty, so that I can execute the resulting delegate against any object I want.&#160; The one for a field is quite similar:

<pre><span style="color: blue">public static </span><span style="color: #2b91af">LateBoundField </span>Create(<span style="color: #2b91af">FieldInfo </span>field)
{
    <span style="color: #2b91af">ParameterExpression </span>instanceParameter = <span style="color: #2b91af">Expression</span>.Parameter(<span style="color: blue">typeof</span>(<span style="color: blue">object</span>), <span style="color: #a31515">"target"</span>);

    <span style="color: #2b91af">MemberExpression </span>member = <span style="color: #2b91af">Expression</span>.Field(<span style="color: #2b91af">Expression</span>.Convert(instanceParameter, field.DeclaringType), field);

    <span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">LateBoundField</span>&gt; lambda = <span style="color: #2b91af">Expression</span>.Lambda&lt;<span style="color: #2b91af">LateBoundField</span>&gt;(
        <span style="color: #2b91af">Expression</span>.Convert(member, <span style="color: blue">typeof</span>(<span style="color: blue">object</span>)),
        instanceParameter
        );

    <span style="color: blue">return </span>lambda.Compile();
}</pre>

[](http://11011.net/software/vspaste)

I still have a MemberExpression, but I use the Field method to create it instead.&#160; It’s a little func-y looking, but here is what that above expression would look like, if I knew the target type at compile time:

<pre><span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">Order</span>, <span style="color: blue">decimal</span>&gt;&gt; expr = o =&gt; o.Total;</pre>

I have to jump through a few more hoops, as I don’t know the in and out times at compile time, it’s all stored as reflection information.&#160; The expression tree building doesn’t care anyway, as the above lambda syntax is merely syntactic sugar for what we wrote earlier.&#160; But how does this perform?&#160; As [Rick Strahl points out](http://www.west-wind.com/weblog/posts/653034.aspx), it only makes sense after many iterations.&#160; But I can then do fun things like this:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Order
</span>{
    <span style="color: blue">public decimal </span>Total { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}

[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Sample()
{
    <span style="color: #2b91af">PropertyInfo </span>propertyInfo = <span style="color: blue">typeof </span>(<span style="color: #2b91af">Order</span>).GetProperty(<span style="color: #a31515">"Total"</span>);

    <span style="color: blue">var </span>lateBoundProperty = <span style="color: #2b91af">DelegateFactory</span>.Create(propertyInfo);

    <span style="color: blue">var </span>order = <span style="color: blue">new </span><span style="color: #2b91af">Order
        </span>{
            Total = 50m
        };

    <span style="color: blue">var </span>total = lateBoundProperty(order);

    total.ShouldEqual(50m);
}</pre>

[](http://11011.net/software/vspaste)

Since AutoMapper already has all of the reflection information cached on a per app-domain basis (that’s why you should only configure once), I can easily go through all of the reflected information and pre-compile all of the late-bound fields, properties and methods, so that they execute very fast during a mapping operation.

So what’s the downside?&#160; Startup is slower now, as it is CPU intensive to configure AutoMapper now.&#160; But compared to the startup time of NHibernate and StructureMap in our applications, it does not add that much more to the total startup time.&#160; Since we’re using AutoMapper in a web application, the we feel just as confident about its configuration time as we would NHibernate.

Unfortunately, expression trees in .NET 3.0 do not support _setting_ fields and properties.&#160; But since that’s changing in .NET 4.0, I think I’ll just wait to optimize the destination member assignment part of AutoMapper until then.