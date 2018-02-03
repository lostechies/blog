---
wordpress_id: 261
title: 'More C# Attribute annoyances'
date: 2008-12-12T02:09:04+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/12/11/more-c-attribute-annoyances.aspx
dsq_thread_id:
  - "264715987"
categories:
  - 'C#'
---
And on the subject of the deficiencies of attributes, there are a few more things I’d like to accomplish, but cant.&#160; First on the list, generic attributes:

<pre><span style="color: green">// Boo C# compiler, boo!!!
</span><span style="color: blue">public class </span><span style="color: #2b91af">GenericAttribute</span>&lt;T&gt; : <span style="color: #2b91af">Attribute
</span></pre>

[](http://11011.net/software/vspaste)

So many times I’d like to have some kind of generic attribute, whether for validation, for action filters, the list goes on and on:

<pre>error CS0698: A generic type cannot derive from 'Attribute' because it is an attribute class</pre>

[](http://11011.net/software/vspaste)

Well that’s helpful!&#160; It gets worse.&#160; Let’s try a more interesting attribute value for an attribute that takes a value in its constructor:

<pre>[<span style="color: #2b91af">AttributeUsage</span>(<span style="color: #2b91af">AttributeTargets</span>.Method, AllowMultiple = <span style="color: blue">true</span>)]
<span style="color: blue">public class </span><span style="color: #2b91af">FineThenAttribute </span>: <span style="color: #2b91af">Attribute
</span>{
    <span style="color: blue">public </span>FineThenAttribute(<span style="color: blue">int </span>value)</pre>

[](http://11011.net/software/vspaste)

Most of the time, I’ll put a hard-coded value into the constructor.&#160; Sometimes, I’d like for that value to come from…somewhere else:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">PrettyPlease
</span>{
    <span style="color: blue">public const int </span>Five = 5;
    <span style="color: blue">public static int </span>Four = 4;

    [<span style="color: #2b91af">FineThen</span>(6)]
    [<span style="color: #2b91af">FineThen</span>(Five)]
    [<span style="color: #2b91af">FineThen</span>(Four)]
    <span style="color: blue">public void </span>Method()</pre>

[](http://11011.net/software/vspaste)

The first two compile just fine, as the values passed in are constant values.&#160; The third attribute does NOT compile, however.&#160; I get yet another roadblock:

<pre>error CS0182: An attribute argument must be a constant expression, typeof expression or array creation expression of an attribute parameter type</pre>

[](http://11011.net/software/vspaste)

One time I tried to get extra fancy with attribute decorators.&#160; Silly me!&#160; This attribute _definition_ compiles just fine:

<pre>[<span style="color: #2b91af">AttributeUsage</span>(<span style="color: #2b91af">AttributeTargets</span>.Method, AllowMultiple = <span style="color: blue">true</span>)]
<span style="color: blue">public class </span><span style="color: #2b91af">DelegateTypeAttribute </span>: <span style="color: #2b91af">Attribute
</span>{
    <span style="color: blue">public </span>DelegateTypeAttribute(<span style="color: #2b91af">Action </span>jackson)</pre>

[](http://11011.net/software/vspaste)

But it’s impossible to use!&#160; None of these attribute declarations compile:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">WithACherryOnTop
</span>{
    [<span style="color: #2b91af">DelegateType</span>(() =&gt; { })]
    [<span style="color: #2b91af">DelegateType</span>(MatchesAction)]
    [<span style="color: #2b91af">DelegateType</span>(<span style="color: blue">new </span><span style="color: #2b91af">Action</span>(MatchesAction))]
    <span style="color: blue">public void </span>Method()
    {
    }

    <span style="color: blue">private static void </span>MatchesAction()</pre>

[](http://11011.net/software/vspaste)

Blech.&#160; Every time I try and do something mildly interesting with attributes, blocked by the CLR!