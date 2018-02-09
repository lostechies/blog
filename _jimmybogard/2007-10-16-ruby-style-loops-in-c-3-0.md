---
wordpress_id: 81
title: 'Ruby-style loops in C# 3.0'
date: 2007-10-16T00:44:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/10/15/ruby-style-loops-in-c-3-0.aspx
dsq_thread_id:
  - "289145800"
categories:
  - 'C#'
redirect_from: "/blogs/jimmy_bogard/archive/2007/10/15/ruby-style-loops-in-c-3-0.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/10/ruby-style-loops-in-c-30.html)._

Ruby has a pretty interesting (and succinct) way of looping through a set of numbers:

<pre>5.times do |i|
  print i, " "
end</pre>

The results of executing this Ruby block is:

<pre>0 1 2 3 4</pre>

I really love the readability and conciseness of this syntax, just enough to see what&#8217;s going on, but not a lot of extra stuff to get in the way.&nbsp; In addition to the &#8220;times&#8221; method, there&#8217;s also &#8220;upto&#8221; and &#8220;downto&#8221;&nbsp;methods for other looping scenarios.

#### Some slight of hand

With extension methods and lambda expressions and C# 3.0, this form of loop syntax is pretty easy to do.&nbsp; Not really a great idea, but at least an example of what these new constructs in C# 3.0 can do.

So how can we create this syntax in C#?&nbsp; The &#8220;times&#8221; method is straightforward, that can just be an extension method for ints:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">void</span> Times(<span class="kwrd">this</span> <span class="kwrd">int</span> count)</pre>
</div>

Now this method shows up in IntelliSense (when I add the appropriate &#8220;using&#8221; directive):

![](http://s3.amazonaws.com/grabbagoftimg/Ruby_Loops.PNG)

Now that the Times method shows up for&nbsp;ints, we can focus on the Do block.

#### Adding the loop behavior

Although I can&#8217;t declare blocks in C# 3.0, lambda expressions are roughly equivalent.&nbsp; To take advantage of&nbsp;lambda expressions, I want to&nbsp;give the behavior to the Times method in the form of a delegate.&nbsp; By declaring a delegate parameter type on a method, I&#8217;m able to&nbsp;use lambda expressions when calling that method.

I didn&#8217;t like passing the lambda directly to the &#8220;Times&#8221;&nbsp;method, so I created an interface to encapsulate a loop iteration, faking the Ruby &#8220;do&#8221; block with methods:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">interface</span> ILoopIterator
{
    <span class="kwrd">void</span> Do(Action action);
    <span class="kwrd">void</span> Do(Action&lt;<span class="kwrd">int</span>&gt; action);
}
</pre>
</div>

Now I can return an ILoopIterator from the Times method instead of just &#8220;void&#8221;.&nbsp; Now the final part is to create an &#8220;ILoopIterator&#8221; implementation that will do the actual looping:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">private</span> <span class="kwrd">class</span> LoopIterator : ILoopIterator
{
    <span class="kwrd">private</span> <span class="kwrd">readonly</span> <span class="kwrd">int</span> _start, _end;

    <span class="kwrd">public</span> LoopIterator(<span class="kwrd">int</span> count)
    {
        _start = 0;
        _end = count - 1;
    }

    <span class="kwrd">public</span> LoopIterator(<span class="kwrd">int</span> start, <span class="kwrd">int</span> end)
    {
        _start = start;
        _end = end;
    }  

    <span class="kwrd">public</span> <span class="kwrd">void</span> Do(Action action)
    {
        <span class="kwrd">for</span> (<span class="kwrd">int</span> i = _start; i &lt;= _end; i++)
        {
            action();
        }
    }

    <span class="kwrd">public</span> <span class="kwrd">void</span> Do(Action&lt;<span class="kwrd">int</span>&gt; action)
    {
        <span class="kwrd">for</span> (<span class="kwrd">int</span> i = _start; i &lt;= _end; i++)
        {
            action(i);
        }
    }
}

<span class="kwrd">public</span> <span class="kwrd">static</span> ILoopIterator Times(<span class="kwrd">this</span> <span class="kwrd">int</span> count)
{
    <span class="kwrd">return</span> <span class="kwrd">new</span> LoopIterator(count);
}
</pre>
</div>

I&nbsp;let the &#8220;LoopIterator&#8221; class encapsulate the behavior of performing&nbsp;the underlying &#8220;for&#8221; loop and calling back to the&nbsp;Action passed in as a lambda.&nbsp; It makes more sense when you see some client code calling the Times method:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">int</span> sum = 0;
5.Times().Do( i =&gt; 
    sum += i
);
Assert.AreEqual(10, sum);
</pre>
</div>

That looks pretty similar to the Ruby version (but not quite as nice), but it works.&nbsp; Compare this to a normal loop in C#:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">int</span> sum = 0;
<span class="kwrd">for</span> (<span class="kwrd">int</span> i = 0; i &lt; 5; i++)
{
    sum += i;
}
Assert.AreEqual(10, sum);
</pre>
</div>

Although the &#8220;for&#8221; syntax is functional and about the same number of lines of code, the Ruby version is definitely more readable.&nbsp; Adding additional UpTo and DownTo methods would be straightforward with additional ILoopIterator implementations.

#### Feature abuse

Yeah, I know this is more than a mild case&nbsp;of feature abuse, but it was interesting to see the differences between similar operations in C# 3.0 and Ruby.&nbsp; Although it&#8217;s possible to do these similar operations, with&nbsp;similar names, this example highlights how much the syntax elements of the static CLR languages can get in the way&nbsp;of a readable&nbsp;API, and how much Ruby stays out of the way.