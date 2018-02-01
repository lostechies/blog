---
id: 234
title: JavaScript block scoping
date: 2008-09-26T16:03:03+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/09/26/javascript-block-scoping.aspx
dsq_thread_id:
  - "264715927"
categories:
  - JavaScript
---
I&#8217;m going through [JavaScript: The Good Parts](http://www.amazon.com/JavaScript-Good-Parts-Douglas-Crockford/dp/0596517742) (which I highly, highly recommend), and I&#8217;m finding I knew next to nothing about JavaScript.&nbsp; For example, this does not compile in C#:

<pre><span style="color: blue">public void </span>TestScope()
{
    <span style="color: blue">if </span>(<span style="color: blue">true</span>) 
    {
        <span style="color: blue">int </span>i = 5;
    }

    i.ShouldEqual(5); <span style="color: green">// does not compile
</span>}
</pre>

[](http://11011.net/software/vspaste)

This is because C# has block scope.&nbsp; Any variable declared inside a block is scoped to that block, but not to any parent blocks.&nbsp; JavaScript, however, does _not_ have block scope:

<pre><span style="color: blue">var </span>foo = <span style="color: blue">function</span>()
{
    <span style="color: blue">if </span>(<span style="color: blue">true</span>)
    {
        <span style="color: blue">var </span>a = 5;
    }
    
    alert(a);
}

foo();</pre>

[](http://11011.net/software/vspaste)

That will display &#8220;5&#8221;.&nbsp; Since there is no block scope, the book recommends declaring _all_ variables at the top of the function.&nbsp; JavaScript does have function scope (as well as closures), so this is the safer bet:

<pre><span style="color: blue">var </span>foo = <span style="color: blue">function</span>()
{
    <span style="color: blue">var </span>a;
    
    <span style="color: blue">if </span>(<span style="color: blue">true</span>)
    {
        a = 5;
    }
    
    alert(a);
}

foo();</pre>

[](http://11011.net/software/vspaste)

This includes any variables declared inside for loops and any other kind of block.&nbsp; Declaring them at the top of the function will eliminate pesky scoping bugs, when you might accidentally revert back to C-style block scope rules.

Did I also mention you should pick up JavaScript: The Good Parts?&nbsp; It turns out learning about the language may dispel ill feelings towards it.