---
wordpress_id: 20
title: Fun with recursive Lambda functions
date: 2007-05-18T14:46:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/05/18/fun-with-recursive-lambda-functions.aspx
dsq_thread_id:
  - "264715367"
categories:
  - 'C#'
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/05/fun-with-recursive-lambda-functions.html)._

I saw a [couple](http://blogs.msdn.com/wesdyer/archive/2007/02/02/anonymous-recursion-in-c.aspx) of [posts](http://blogs.msdn.com/madst/archive/2007/05/11/recursive-lambda-expressions.aspx) on recursive [lambda expressions](http://weblogs.asp.net/scottgu/archive/2007/04/08/new-orcas-language-feature-lambda-expressions.aspx), and I thought it would be fun to write a class to encapsulate those two approaches.&nbsp; BTW, I&#8217;m running this on Orcas Beta 1, so don&#8217;t try this at home (VS 2005) kids.&nbsp; Let&#8217;s say I wanted to write a single Func variable that computed the factorial of a number:

<div class="CodeFormatContainer">
  <pre>Func&lt;<span class="kwrd">int</span>, <span class="kwrd">int</span>&gt; fac = x =&gt; x == 0 ? 1 : x * fac(x-1);</pre>
</div>

When I try to compile this, I get a compiler error:

<div class="CodeFormatContainer">
  <pre>Use of unassigned local variable <span class="str">'fac'</span>
</pre>
</div>

That&#8217;s no good.&nbsp; The C# compiler always evaluates the right hand expression first, and it can&#8217;t use a variable before it is assigned. 

### Something of a solution

Well, the C# compiler couldn&#8217;t automagically figure out my recursion, but I can [see why](http://blogs.msdn.com/ericlippert/archive/2006/08/18/706398.aspx).&nbsp; So I have a couple of different solutions, one where I create an instance of a class that encapsulates my recursion, and another where a static factory method gives me a delegate to call.&nbsp; I combined both approaches into one class:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> RecursiveFunc&lt;T&gt;<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private</span> <span class="kwrd">delegate</span> Func&lt;A, R&gt; Recursive&lt;A, R&gt;(Recursive&lt;A, R&gt; r);<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private</span> <span class="kwrd">readonly</span> Func&lt;Func&lt;T, T&gt;, Func&lt;T, T&gt;&gt; f;<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> RecursiveFunc(Func&lt;Func&lt;T, T&gt;, Func&lt;T, T&gt;&gt; higherOrderFunction)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;f = higherOrderFunction;<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private</span> Func&lt;T, T&gt; Fix(Func&lt;Func&lt;T, T&gt;, Func&lt;T, T&gt;&gt; f)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> t =&gt; f(Fix(f))(t);<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> T Execute(T <span class="kwrd">value</span>)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> Fix(f)(<span class="kwrd">value</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">static</span> Func&lt;T, T&gt; CreateFixedPointCombinator(Func&lt;Func&lt;T, T&gt;, Func&lt;T, T&gt;&gt; f)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Recursive&lt;T, T&gt; rec = r =&gt; a =&gt; f(r(r))(a);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> rec(rec);<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
}<br />
</pre>
</div>

### Using an instance of a class

The idea behind using a class is it might be more clear to the user to have an instance of a concrete type, and call methods on that type instead of calling a delegate directly.&nbsp; Let&#8217;s look at an example of this usage, with the Fibonacci and factorial recursive methods:

<div class="CodeFormatContainer">
  <pre>[TestMethod]<br />
<span class="kwrd">public</span> <span class="kwrd">void</span> RecursiveFunc_WithFactorial_ComputesCorrectly()<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;var factorial = <span class="kwrd">new</span> RecursiveFunc&lt;<span class="kwrd">int</span>&gt;(fac =&gt; x =&gt; x == 0 ? 1 : x * fac(x - 1));<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(1, factorial.Execute(1));<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(6, factorial.Execute(3));<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(120, factorial.Execute(5));<br />
}<br />
<br />
[TestMethod]<br />
<span class="kwrd">public</span> <span class="kwrd">void</span> RecursiveFunc_WithFibonacci_ComputesCorrectly()<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;var fibonacci = <span class="kwrd">new</span> RecursiveFunc&lt;<span class="kwrd">int</span>&gt;(fib =&gt; x =&gt; <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(x == 0) || (x == 1) ? x : fib(x - 1) + fib(x - 2)<br />
&nbsp;&nbsp;&nbsp;&nbsp;);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(0, fibonacci.Execute(0));<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(1, fibonacci.Execute(1));<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(1, fibonacci.Execute(2));<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(2, fibonacci.Execute(3));<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(5, fibonacci.Execute(5));<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(55, fibonacci.Execute(10));<br />
}<br />
</pre>
</div>

So in each case I can pass in the Func delegate I was trying to create (without success) in the compiler error example at the top of the post.&nbsp; I instantiate the class with my recursive function, and call Execute to execute that function recursively.&nbsp; Not too shabby.

### Using a static factory method

With a static factory method, calling the recursive function looks a little prettier.&nbsp; Again, here are two examples that use the Fibonacci sequence and factorials for recursive algorithms:

<div class="CodeFormatContainer">
  <pre>[TestMethod]<br />
<span class="kwrd">public</span> <span class="kwrd">void</span> FixedPointCombinator_WithFactorial_ComputesCorrectly()<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;var factorial = RecursiveFunc&lt;<span class="kwrd">int</span>&gt;.CreateFixedPointCombinator(fac =&gt; x =&gt; x == 0 ? 1 : x * fac(x - 1));<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(1, factorial(1));<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(6, factorial(3));<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(120, factorial(5));<br />
}<br />
<br />
[TestMethod]<br />
<span class="kwrd">public</span> <span class="kwrd">void</span> FixedPointCombinator_WithFibonacci_ComputesCorrectly()<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;var fibonacci = RecursiveFunc&lt;<span class="kwrd">int</span>&gt;.CreateFixedPointCombinator(fib =&gt; x =&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(x == 0) || (x == 1) ? x : fib(x - 1) + fib(x - 2)<br />
&nbsp;&nbsp;&nbsp;&nbsp;);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(0, fibonacci(0));<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(1, fibonacci(1));<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(1, fibonacci(2));<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(2, fibonacci(3));<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(5, fibonacci(5));<br />
&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(55, fibonacci(10));<br />
}<br />
</pre>
</div>

After some thought on both, I think I like the second way better.&nbsp; Calling the Func delegate directly seems to look a little nicer, and it saves me from having to have some random Fibonacci or factorial helper class.&nbsp; Of course, I could still have those&nbsp;helper methods&nbsp;somewhere, but where&#8217;s the fun in that?&nbsp; Now if only I had taken a lambda calculus class in college&#8230;