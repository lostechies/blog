---
id: 287
title: Polymorphism in Expression trees
date: 2009-02-25T01:11:13+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/02/24/polymorphism-in-expression-trees.aspx
dsq_thread_id:
  - "264716077"
categories:
  - 'C#'
---
While trying to be extra-clever today, I found a potential nasty issue when dealing with [strongly-typed reflection](http://weblogs.asp.net/cazzu/archive/2006/07/06/Linq-beyond-queries_3A00_-strong-typed-reflection_2100_.aspx).&#160; Suppose I have a simple hierarchy of objects:

<pre><span style="color: blue">public abstract class </span><span style="color: #2b91af">Base
</span>{
    <span style="color: blue">public abstract string </span>Foo { <span style="color: blue">get</span>; }
}

<span style="color: blue">public class </span><span style="color: #2b91af">Child </span>: <span style="color: #2b91af">Base
</span>{
    <span style="color: blue">public override string </span>Foo
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span><span style="color: #a31515">"asdf"</span>; }
    }
}</pre>

[](http://11011.net/software/vspaste)

An abstract base class and a child class that implements the one abstract member.&#160; Suppose now we want to do some strongly-typed reflection with the child type:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>PolymorphicWeirdness()
{
    <span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">Child</span>, <span style="color: blue">object</span>&gt;&gt; func = child =&gt; child.Foo;

    <span style="color: blue">var </span>body = (<span style="color: #2b91af">MemberExpression</span>) func.Body;
    body.Member.DeclaringType.ShouldEqual(<span style="color: blue">typeof </span>(<span style="color: #2b91af">Child</span>));
}</pre>

[](http://11011.net/software/vspaste)

Many frameworks, AutoMapper being one of them, take advantage of this strongly-typed reflection to get to MemberInfo information on the property or method used in the expression.&#160; Unfortunately, the above test fails.&#160; Instead of the MemberInfo’s DeclaringType being “Child”, it’s “Base”.

If I’m using Expressions to do things like interrogate the MemberInfo for things like custom attributes, I won’t be getting the whole story here.&#160; Lots of other OSS tools use Expressions quite a bit, so I’m very curious to see what those tools do with this behavior.&#160; Note, it’s only the Expression tree with the polymorphism issue.&#160; Once you compile the Expression, all of the normal CLR resolution rules are applied.

This seems like someone would have written about this issue by now, so I’m off to do some sleuthing to see how others deal with this.