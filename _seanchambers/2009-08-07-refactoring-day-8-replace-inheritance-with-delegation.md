---
wordpress_id: 3202
title: 'Refactoring Day 8 : Replace Inheritance with Delegation'
date: 2009-08-07T15:27:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/07/refactoring-day-8-replace-inheritance-with-delegation.aspx
dsq_thread_id:
  - "262347111"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/08/07/refactoring-day-8-replace-inheritance-with-delegation.aspx/"
---
All too often inheritance is used in the wrong scenarios. Inheritance should only be used in _logical_ circumstances but it is often used for convenience purposes. I&rsquo;ve seen this many times and it leads to complex inheritance hierarchies that don&rsquo;t make sense. Take the following code:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Sanitation</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">string</span> WashHands()</pre>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <pre><span class="lnum">   5:</span>         <span class="kwrd">return</span> <span class="str">"Cleaned!"</span>;</pre>
    
    <pre><span class="lnum">   6:</span>     }</pre>
    
    <pre><span class="lnum">   7:</span> }</pre>
    
    <pre><span class="lnum">   8:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   9:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Child : Sanitation</pre>
    
    <pre><span class="lnum">  10:</span> {</pre>
    
    <pre><span class="lnum">  11:</span> }</pre>
  </div>
</div>

In this instance, a Child is not a &ldquo;Sanitation&rdquo; and therefore doesn&rsquo;t make sense as an inheritance hierarchy. We can refactor by initializing an instance of Sanitation in the Child constructor and delegating the call to the class rather than via inheritance. If you were using Dependency Injection, you would pass in the Sanitation instance via the constructor, although then you would need to register your model in your IoC container which is a smell IMO, you get the idea though. Inheritance should ONLY be used for scenarios where inheritance is warranted. Not instances where it makes it quicker to throw down code.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Sanitation</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">string</span> WashHands()</pre>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <pre><span class="lnum">   5:</span>         <span class="kwrd">return</span> <span class="str">"Cleaned!"</span>;</pre>
    
    <pre><span class="lnum">   6:</span>     }</pre>
    
    <pre><span class="lnum">   7:</span> }</pre>
    
    <pre><span class="lnum">   8:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   9:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Child</pre>
    
    <pre><span class="lnum">  10:</span> {</pre>
    
    <pre><span class="lnum">  11:</span>     <span class="kwrd">private</span> Sanitation Sanitation { get; set; }</pre>
    
    <pre><span class="lnum">  12:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  13:</span>     <span class="kwrd">public</span> Child()</pre>
    
    <pre><span class="lnum">  14:</span>     {</pre>
    
    <pre><span class="lnum">  15:</span>         Sanitation = <span class="kwrd">new</span> Sanitation();</pre>
    
    <pre><span class="lnum">  16:</span>     }</pre>
    
    <pre><span class="lnum">  17:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  18:</span>     <span class="kwrd">public</span> <span class="kwrd">string</span> WashHands()</pre>
    
    <pre><span class="lnum">  19:</span>     {</pre>
    
    <pre><span class="lnum">  20:</span>         <span class="kwrd">return</span> Sanitation.WashHands();</pre>
    
    <pre><span class="lnum">  21:</span>     }</pre>
    
    <pre><span class="lnum">  22:</span> }</pre>
  </div>
</div>

This refactoring comes from Martin Fowlers Refactoring book. You can view the original [refactoring here](http://refactoring.com/catalog/replaceInheritanceWithDelegation.html)

_<span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a target="_blank" href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx">original introductory post</a>.</span>_