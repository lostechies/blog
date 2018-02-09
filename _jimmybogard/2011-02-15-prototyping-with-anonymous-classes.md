---
wordpress_id: 455
title: Prototyping with anonymous classes
date: 2011-02-15T13:55:09+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2011/02/15/prototyping-with-anonymous-classes.aspx
dsq_thread_id:
  - "264733374"
categories:
  - 'C#'
redirect_from: "/blogs/jimmy_bogard/archive/2011/02/15/prototyping-with-anonymous-classes.aspx/"
---
In the [last post](http://www.lostechies.com/blogs/jimmy_bogard/archive/2011/02/11/trivia-friday.aspx), I presented a rather strange bit of code: 

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">ExpressionExtensions
</span>{
    <span style="color: blue">public static </span><span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;T, TResult&gt;&gt; Expr&lt;T, TResult&gt;(
        <span style="color: blue">this </span>T item,
        <span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;T, TResult&gt;&gt; expr)
    {
        <span style="color: blue">return </span>expr;
    }
}</pre>

It looks like a rather pointless bit of code that I would write.&#160; As [Jeremy Skinner](http://www.jeremyskinner.co.uk/) pointed out, this kind of code can help build up an expression for an anonymous type.&#160; Anonymous types work really great, except that you can’t normally declare them as return types:

<pre><span style="color: blue">public object </span>BuildSomething()
{
    <span style="color: blue">var </span>item = <span style="color: blue">new
    </span>{
        Foo = <span style="color: #a31515">"foo"</span>,
        Bar = 1
    };
    <span style="color: blue">return </span>item;
}</pre>

I can only return the anonymous object as a return type.&#160; However, that’s not always the case.&#160; With generic inference, the entire LINQ set of extension methods is built around the idea of using anonymous types for the “T” in IEnumerable<T>:

<pre><span style="color: blue">var </span>item = <span style="color: blue">new
</span>{
    Foo = <span style="color: #a31515">"foo"</span>,
    Bar = 1
};

<span style="color: blue">var </span>range = <span style="color: #2b91af">Enumerable</span>.Repeat(item, 1);</pre>

Here, I can build an enumerable of some anonymous item, using a compiler trick (and our friend the “var” keyword) to do so.&#160; Because the anonymous object is passed in to the Repeat method, the compiler is able to do the generic inference and determine what the anonymous type is.&#160; But I wouldn’t be able to specify the generic arguments if I wanted to.

This technique becomes interesting when you want to do things like build lists, dictionaries, expressions and so on of anonymous types.&#160; In many unit tests, I have to build up dummy classes representing a prototype class for something I’m interested in testing.&#160; In the expression case, I was using expressions to test out a custom expression visitor.&#160; Rather than building out a ton of dummy classes, I can use an anonymous type as a prototype:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Some_test()
{
    <span style="color: blue">var </span>anon = <span style="color: blue">new
    </span>{
        Foo = <span style="color: #a31515">"foo"
    </span>};

    <span style="color: blue">var </span>expr = anon.Expr(x =&gt; x.Foo);

    <span style="color: blue">var </span>result = <span style="color: blue">new </span><span style="color: #2b91af">CustomExpressionVisitor</span>().Visit(expr);

    <span style="color: green">// Assert the result
    </span>result.ShouldEqual(<span style="color: #a31515">"foo"</span>);
}</pre>

The building of my anonymous object represents a specification of the shape of what I’m asserting against.&#160; It’s a prototype class that only exists in the context of this one method, and is then thrown away.

The trick is just to build a generic method that accepts a the item as one of its parameters – that allows the C# type inference to do its work.&#160; It doesn’t even have to be an extension method:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Some_test()
{
    <span style="color: blue">var </span>anon = <span style="color: blue">new
    </span>{
        Foo = <span style="color: #a31515">"foo"
    </span>};

    <span style="color: blue">var </span>expr = Expr(anon, x =&gt; x.Foo);

    <span style="color: blue">var </span>result = <span style="color: blue">new </span><span style="color: #2b91af">CustomExpressionVisitor</span>().Visit(expr);

    <span style="color: green">// Assert the result
    </span>result.ShouldEqual(<span style="color: #a31515">"foo"</span>);
}

<span style="color: blue">private static </span><span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;T, TResult&gt;&gt; Expr&lt;T, TResult&gt;(
        T item,
        <span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;T, TResult&gt;&gt; expr)
{
    <span style="color: blue">return </span>expr;
}</pre>

Imagine that I could build a List<T>, Dictionary, etc.&#160; Any kind of real generic method can be now called by wrapping it in an overload that takes the prototype object as an argument.

It has the tendency to obfuscate a little, but it’s a handy trick to reduce a lot of the dummy classes I wind up creating in tests.