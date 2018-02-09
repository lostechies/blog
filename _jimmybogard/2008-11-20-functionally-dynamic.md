---
wordpress_id: 254
title: Functionally dynamic?
date: 2008-11-20T02:41:29+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/11/19/functionally-dynamic.aspx
dsq_thread_id:
  - "264715986"
categories:
  - 'C#'
redirect_from: "/blogs/jimmy_bogard/archive/2008/11/19/functionally-dynamic.aspx/"
---
I was just playing with this tonight, but I don’t know it’s worth anything.&#160; I thought of it after some conversations with [Matt Podwysocki](http://podwysocki.codebetter.com/) back at KaizenConf on how do apply some functional ideas in C#.&#160; First, I started with a simple class:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">OriginalProduct
</span>{
    <span style="color: blue">public decimal </span>Price { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public decimal </span>Cost { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }

    <span style="color: blue">public decimal </span>CalculateProfit()
    {
        <span style="color: blue">return </span>Price - Cost;
    }
}</pre>

[](http://11011.net/software/vspaste)

To do anything interesting, functional-wise, like swapping implementations or doing things like decorators is annoying or impossible.&#160; But if I went this (albeit weird) direction:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Product
</span>{
    <span style="color: blue">public decimal </span>Price { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public decimal </span>Cost { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }

    <span style="color: blue">public </span>Product()
    {
        CalculateProfit = calculateProfit;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">Func</span>&lt;<span style="color: blue">decimal</span>&gt; CalculateProfit { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }

    <span style="color: blue">private decimal </span>calculateProfit()
    {
        <span style="color: #2b91af">Console</span>.WriteLine(<span style="color: #a31515">"Calculating profit"</span>);
        <span style="color: blue">return </span>Cost == 0 ? 0m : Price - Cost;
    }
}</pre>

[](http://11011.net/software/vspaste)

Yes, weird.&#160; But tests look rather normal, except a function is a property:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>No_change()
{
    <span style="color: blue">var </span>product = <span style="color: blue">new </span><span style="color: #2b91af">Product </span>{Price = 11, Cost = 10};

    product.CalculateProfit().ShouldEqual(1m);
}</pre>

[](http://11011.net/software/vspaste)

Because you can invoke delegate instances directly, it looks like I’m calling a function on the type.&#160; I can do some interesting things with some simple decorator extensions:

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">DelegateExtensions
</span>{
    <span style="color: blue">public static </span><span style="color: #2b91af">Func</span>&lt;T&gt; Before&lt;T&gt;(<span style="color: blue">this </span><span style="color: #2b91af">Func</span>&lt;T&gt; func, <span style="color: #2b91af">Action </span>before)
    {
        <span style="color: blue">return </span>() =&gt;
                   {
                       before();
                       <span style="color: blue">return </span>func();
                   };
    }
    <span style="color: blue">public static </span><span style="color: #2b91af">Func</span>&lt;T&gt; After&lt;T&gt;(<span style="color: blue">this </span><span style="color: #2b91af">Func</span>&lt;T&gt; func, <span style="color: #2b91af">Action </span>after)
    {
        <span style="color: blue">return </span>() =&gt;
                   {
                       T value = func();
                       after();
                       <span style="color: blue">return </span>value;
                   };
    }
}</pre>

[](http://11011.net/software/vspaste)

And now I can decorate my the functions at will:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Decorator_fun()
{
    <span style="color: blue">var </span>product = <span style="color: blue">new </span><span style="color: #2b91af">Product </span>{ Price = 11, Cost = 10 };

    product.CalculateProfit =
        product.CalculateProfit
                .Before(() =&gt; <span style="color: #2b91af">Console</span>.WriteLine(<span style="color: #a31515">"Before"</span>))
                .After(() =&gt; <span style="color: #2b91af">Console</span>.Write(<span style="color: #a31515">"After"</span>));

    product.CalculateProfit().ShouldEqual(1m);
}</pre>

[](http://11011.net/software/vspaste)

This outputs:

<pre>Before
Calculating profit
After
1 passed, 0 failed, 0 skipped, took 1.05 seconds.</pre>

[](http://11011.net/software/vspaste)

That’s just some simple decorator implementation.&#160; Finally, I can swap out implementations at runtime:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Straight_up_replacement()
{
    <span style="color: blue">var </span>product = <span style="color: blue">new </span><span style="color: #2b91af">Product </span>{ Price = 11, Cost = 10 };

    product.CalculateProfit = () =&gt; 1500;

    product.CalculateProfit().ShouldEqual(1500m);
}</pre>

[](http://11011.net/software/vspaste)

It’s still not dynamic typing, as I can’t add new members at runtime.&#160; I have no idea if this is useful or not, as the structure is rather weird, and you’d need to do some interesting things to get polymorphism in play.&#160; But, it might have some interesting applications in some strange scenario.