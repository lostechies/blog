---
wordpress_id: 136
title: 'Some C# obscurities'
date: 2008-01-31T02:40:38+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/01/30/some-c-obscurities.aspx
dsq_thread_id:
  - "264715537"
categories:
  - 'C#'
redirect_from: "/blogs/jimmy_bogard/archive/2008/01/30/some-c-obscurities.aspx/"
---
I&#8217;m sure everyone&#8217;s tired of hearing about C# 3.0 features like lambda expressions, extension methods, anonymous types and so on.&nbsp; Before you fall in love with the new features, there are a few oldies-but-goodies that revolve around the &#8220;?&#8221; character.&nbsp; I use a couple of these to stump interviewees who proclaim themselves to be C# experts.&nbsp; These question marks can provide a much cleaner, terser syntax for some fairly common C# usage patterns.

### Conditional operator

This one can be easy to abuse, but it provides a nice terseness to code that has conditional assignments:

<pre><span style="color: blue">if </span>(hoursTraveled &gt; 0)
    speed = distanceInMiles / hoursTraveled;
<span style="color: blue">else
    </span>speed = 0;
</pre>

[](http://11011.net/software/vspaste)

I&#8217;m trying to calculate speed, but clearly I don&#8217;t want to get DivideByZeroException.&nbsp; Sometimes these types of assignments can add up, so I like to condense them down with the [C# conditional operator](http://msdn2.microsoft.com/en-us/library/aa691313(VS.71).aspx):

<pre>speed = hoursTraveled &gt; 0 ? distanceInMiles / hoursTraveled : 0;
</pre>

[](http://11011.net/software/vspaste)

Now the conditional assignment can be written on a single line.

I don&#8217;t see this feature used very often, so there is a tradeoff in familiarity.&nbsp; If the conditional or assignment statements grow too large, it can start to hurt readability, so just use your best judgement on this one.

### Nullable types

The release of the .NET Framework 2.0 brought along a little struct type that solved a whole heap of problems.&nbsp; Value types ([structs](http://msdn2.microsoft.com/en-us/library/ah19swz4.aspx)) can be used to represent types that don&#8217;t care about referential identity.&nbsp; For example, if I have the number 2, and you have the number 2, they&#8217;re the same number no matter how many times we create it.

Value types have another interesting aspect, they can never have a null value.&nbsp; The details behind this are exciting if you like things Jeffrey Richter style, full of heap and stack knowledge, but in the end you just need to know that C# structs can never be null.&nbsp; This line does not compile:

<pre><span style="color: blue">int </span>i = <span style="color: blue">null</span>;</pre>

[](http://11011.net/software/vspaste)

But not every system in the world that deals with &#8220;int&#8221; recognizes this rule.&nbsp; Databases and XML schemas are two examples where &#8220;int&#8221; values can be null.&nbsp; To handle the impedance mismatch of real-world nulls and CLR-land value types, the Nullable<T> generic value type was introduced.&nbsp; By declaring a variable to be Nullable<int>, I can now do this:

<pre><span style="color: #2b91af">Nullable</span>&lt;<span style="color: blue">int</span>&gt; i;
i = <span style="color: blue">null</span>;

<span style="color: #2b91af">Assert</span>.That(i.HasValue, <span style="color: #2b91af">Is</span>.False);

i = 3;

<span style="color: #2b91af">Assert</span>.That(i.HasValue, <span style="color: #2b91af">Is</span>.True);
<span style="color: #2b91af">Assert</span>.That(i.Value, <span style="color: #2b91af">Is</span>.EqualTo(3));
<span style="color: #2b91af">Assert</span>.That(i, <span style="color: #2b91af">Is</span>.EqualTo(3));
</pre>

[](http://11011.net/software/vspaste)

Note that I have no problems assigning int values to the Nullable<int> type, as the [appropriate cast operators](https://lostechies.com/blogs/jimmy_bogard/archive/2007/12/03/dealing-with-primitive-obsession.aspx) have been defined.&nbsp; Declaring a nullable type is fairly ugly using the full generic notation, so C# has a nice shortcut:

<pre><span style="color: blue">int</span>? i;
i = <span style="color: blue">null</span>;
</pre>

[](http://11011.net/software/vspaste)

There&#8217;s our friend the question mark.&nbsp; It&#8217;s telling us &#8220;I think this variable is an int, but I&#8217;m not sure?&#8221;.&nbsp; This is just another compiler trick C# uses, just like extension methods.&nbsp; At compile time, &#8220;int?&#8221; is replaced with &#8220;Nullable<int>&#8221;, so it&#8217;s really just a shorthand way of expressing nullable types.

Before nullable types, I had to use a bunch of dirty tricks to represent nulls in my entities, usually with magic numbers and values like &#8220;Double.NaN&#8221; or &#8220;DateTime.MinValue&#8221;.&nbsp; Nullable types let me bridge the gap between the nullable and non-nullable worlds.

### Null coalescing operator

This is the one I love to stump the self-proclaimed experts with.&nbsp; I draw this on the whiteboard:

??

And ask them, &#8220;what does this operator do in C#?&#8221;&nbsp; Usually I get the crickets, but the special few can tell me about the [null coalescing operator](http://msdn2.microsoft.com/en-us/library/ms173224.aspx).&nbsp; The null coalescing operator is very similar to the conditional operator, but with the conditional built-in.&nbsp; I find myself doing this quite a lot with nulls:

<pre><span style="color: blue">if </span>(category.Description == <span style="color: blue">null</span>)
    output = <span style="color: #a31515">"&lt;Empty&gt;"</span>;
<span style="color: blue">else
    </span>output = category.Description;
</pre>

[](http://11011.net/software/vspaste)

I have a value that could potentially be null, in this case the description of a category, but I need to output that value to a friendly format.&nbsp; Unfortunately, nulls aren&#8217;t always too friendly to end-users.&nbsp; Let&#8217;s try the conditional operator to see how that cleans things up:

<pre>output = category.Description != <span style="color: blue">null </span>? category.Description : <span style="color: #a31515">"&lt;Empty&gt;"</span>;
</pre>

[](http://11011.net/software/vspaste)

But these conditionals can get ugly, so I can use the &#8220;??&#8221; operator to provide an even terser syntax:

<pre>output = category.Description ?? <span style="color: #a31515">"&lt;Empty&gt;"</span>;
</pre>

[](http://11011.net/software/vspaste)

All of these representations are equivalent, but I like the short and sweet syntax the &#8220;??&#8221; operator provides.&nbsp; Someone not familiar with this operator might not have any clue what the code does, so there is some level of risk involved.

But I generally don&#8217;t like to let a lack of knowledge with a built-in language feature deter me from using it, especially if it can provide a much cleaner syntax.

### And as always&#8230;

If the syntax and usage these little question marks provide don&#8217;t provide better readability (solubility?), then don&#8217;t put them in.&nbsp; These features are there to help, not to satisfy technical fetishes.&nbsp; As always, keep in mind that your end goal is better readability and better maintainability, not a checklist of features used.