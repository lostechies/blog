---
wordpress_id: 454
title: Trivia Friday
date: 2011-02-11T13:31:32+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2011/02/11/trivia-friday.aspx
dsq_thread_id:
  - "264716670"
categories:
  - 'C#'
---
Everybody loves a cliffhanger, right?&#160; I found myself needing to write the following code the other day: 

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">ExpressionExtensions
</span>{
    <span style="color: blue">public static </span><span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;T, TResult&gt;&gt; Expr&lt;T, TResult&gt;(
        <span style="color: blue">this </span>T item, 
        <span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;T, TResult&gt;&gt; expr)
    {
        <span style="color: blue">return </span>expr;
    }
}</pre>

Why would I want to write something like this, which seems to do absolutely nothing?&#160; One hint – it’s not because I wanted a clever, more terse way to declare an expression, although it does have that effect.