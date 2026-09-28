---
wordpress_id: 307
title: The Infinite Extensibility Engine
date: 2009-04-22T02:01:41+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/04/21/the-infinite-extensibility-engine.aspx
dsq_thread_id:
  - "265769949"
categories:
  - Misc
redirect_from: "/blogs/jimmy_bogard/archive/2009/04/21/the-infinite-extensibility-engine.aspx/"
---
The biggest issue facing developers today is not lack of OO knowledge, patterns, or guidance.&#160; It’s a sad lack of extensibility in today’s frameworks.&#160; Over the past year or so, getting familiar with ASP.NET MVC, I think I’ve found an answer to the lack of extensibility in not just application frameworks, but the .NET Framework in general.

What’s been holding me back are the moronic constraints of “method signatures”.&#160; Every time I might need an extra parameter, that maybe someone might have passed in, I have to change the signature!

No more.

Enter the Infinite Extensibility Engine Interface, pronounced “eye-ee-ee-eye”.&#160; And it’s just one awesome interface:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">ICanTasteTheAmazing
</span>{
    <span style="color: #2b91af">Dictionary</span>&lt;<span style="color: blue">string</span>, <span style="color: #2b91af">Dictionary</span>&lt;<span style="color: blue">string</span>, <span style="color: blue">object</span>&gt;&gt; Smurf(
        <span style="color: #2b91af">Dictionary</span>&lt;<span style="color: blue">string</span>, <span style="color: #2b91af">Dictionary</span>&lt;<span style="color: blue">string</span>, <span style="color: blue">object</span>&gt;&gt; @it
    );
}</pre>

[](http://11011.net/software/vspaste)

Yes.&#160; Drink it in.&#160; Taste the amazing.

I came up with this brilliant interface while delving in to the depths of ASP.NET MVC, whose liberal use of hashes and “anonymous types as hashes” is nothing short of breathtaking.&#160; But why be limited to one or two groups of dictionaries per call?&#160; Time to kick it up to 11.&#160; Dictionaries of dictionaries, in and out.

Don’t like what you see?&#160; Pass something else in.&#160; Need something else from callers?&#160; Just go ahead and look for it.&#160; They’ll figure it out.&#160; Eventually.

Naturally, to protect the order of the universe, we’ll create a W3C certified spec to standardize top-level keys, the bucket-of-bucket lookups.&#160; Look for it soon sometime in 2020.&#160; Until then, keep an eye out for the book, audio tape, and speaking tour in your city soon!