---
id: 257
title: Dealing with parameters in expressions and strongly-typed reflection
date: 2008-11-25T03:22:46+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/11/24/dealing-with-parameters-in-expressions-and-strongly-typed-reflection.aspx
dsq_thread_id:
  - "266626728"
categories:
  - 'C#'
---
Something that always bothered me using Expression trees for strongly-typed reflection were the weirdness of doing reflection for methods that return parameters.&#160; Expression trees and reflection go hand-in-hand when doing fluent interfaces/internal DSLs.&#160; Suppose we want to do strongly-typed reflection over this class:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">SomeClass
</span>{
    <span style="color: blue">public int </span>SomeMethod(<span style="color: blue">string </span>one, <span style="color: blue">string </span>two)
    {
        <span style="color: blue">return </span>5;
    }

    <span style="color: blue">public void </span>SomeOtherMethod(<span style="color: blue">string </span>one, <span style="color: blue">string </span>two)
    {
        
    }
}</pre>

[](http://11011.net/software/vspaste)

THE MOST INTERESTING CLASS IN THE WORLD.&#160; For reflection, we have a couple of choices, one where we just use Action<T> as the expression delegate type:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Expr
</span>{
    <span style="color: blue">public static void </span>Test&lt;T&gt;(<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Action</span>&lt;T&gt;&gt; action)
    {
        <span style="color: green">// don't care about parameters!!!
    </span>}
}</pre>

[](http://11011.net/software/vspaste)

Inside Test<T>, we never execute the Action, but walk the expression tree to find what we’re interested in.&#160; For this to work, we still have to call the method inside our lambda with some arbitrary parameters:

<pre><span style="color: #2b91af">Expr</span>.Test&lt;<span style="color: #2b91af">SomeClass</span>&gt;(x =&gt; x.SomeMethod(<span style="color: #a31515">"one"</span>, <span style="color: #a31515">"two"</span>));</pre>

[](http://11011.net/software/vspaste)

In many cases, I actually could care less about the values of the parameters, and I’ll often just pass in a bunch of nulls or default values to get things to work.&#160; The issue comes in with methods with a ton of parameters, which can happen sometimes in things like MVC controller actions.&#160; The other choice is to use [something like this](http://searchwindevelopment.techtarget.com/tip/0,289483,sid8_gci1273739,00.html), where instead of an Action<T>, which lets me put anything under the sun in it, I specify I want a specific Func or Action, and create a bunch of overloads to handle different return values and parameter values:

<pre><span style="color: blue">public static void </span>Method&lt;TType, T0, T1&gt;(<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;TType, T0, T1, <span style="color: blue">object</span>&gt;&gt; method)
{
}
<span style="color: blue">public static void </span>Method&lt;TType, T0, T1&gt;(<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Action</span>&lt;TType, T0, T1&gt;&gt; method)
{
}</pre>

[](http://11011.net/software/vspaste)

Because there is no first-class Void type, I have to declare an Action and a Func.&#160; The usage now seems much more verbose:

<pre><span style="color: #2b91af">Expr</span>.Method&lt;<span style="color: #2b91af">SomeClass</span>, <span style="color: blue">string</span>, <span style="color: blue">string</span>&gt;((o, p1, p2) =&gt; o.SomeMethod(p1, p2));
<span style="color: #2b91af">Expr</span>.Method&lt;<span style="color: #2b91af">SomeClass</span>, <span style="color: blue">string</span>, <span style="color: blue">string</span>&gt;((o, p1, p2) =&gt; o.SomeOtherMethod(p1, p2));</pre>

[](http://11011.net/software/vspaste)

While still refactoring-safe (as I don’t have the method names as strings anywhere), is this really an improvement?&#160; Offhand, I don’t think so, it looks much more verbose just to get at that one method.&#160; In the first example, the types of the parameters would work to choose the right method call, as you could create overloads with the same number of parameters, but different return types.&#160; In the second example, refactoring still gets a little funky if we’re doing things like changing the signature.&#160; Not to mention, the call is frickin’ ginormous.

Where I was going with this is my aversion to all of the string-happy ASP.NET MVC code around controller and action names.&#160; Nothing raises a red flag more than a class or method name hard-coded as a string.&#160; That kind of code is a time-bomb in the face of changing a controller or action name.&#160; Anything that might create an aversion to changing names of classes or members is absolutely insidious and needs to be stamped out with a giant lambda boot.