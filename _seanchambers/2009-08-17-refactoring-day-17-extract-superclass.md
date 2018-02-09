---
wordpress_id: 3211
title: 'Refactoring Day 17 : Extract Superclass'
date: 2009-08-17T15:00:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/17/refactoring-day-17-extract-superclass.aspx
dsq_thread_id:
  - "262352974"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/08/17/refactoring-day-17-extract-superclass.aspx/"
---
Today&#8217;s refactoring is from Martin Fowler&#8217;s refactoring catalog. You can find the <a target="_blank" href="http://refactoring.com/catalog/extractSuperclass.html">original description here</a>

This refactoring is used quite often when you have a number of methods that you want to &ldquo;pull up&rdquo; into a base class to allow other classes in the same hierarchy to use. Here is a class that uses two methods that we want to extract and make available to other classes.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Dog</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> EatFood()</pre>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <pre><span class="lnum">   5:</span>         <span class="rem">// eat some food</span></pre>
    
    <pre><span class="lnum">   6:</span>     }</pre>
    
    <pre><span class="lnum">   7:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   8:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Groom()</pre>
    
    <pre><span class="lnum">   9:</span>     {</pre>
    
    <pre><span class="lnum">  10:</span>         <span class="rem">// perform grooming</span></pre>
    
    <pre><span class="lnum">  11:</span>     }</pre>
    
    <pre><span class="lnum">  12:</span> }</pre>
  </div>
</div>

After applying the refactoring we just move the required methods into a new base class. This is very similar to the [pull up refactoring], except that you would apply this refactoring when a base class doesn&rsquo;t already exist.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Animal</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> EatFood()</pre>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <pre><span class="lnum">   5:</span>         <span class="rem">// eat some food</span></pre>
    
    <pre><span class="lnum">   6:</span>     }</pre>
    
    <pre><span class="lnum">   7:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   8:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Groom()</pre>
    
    <pre><span class="lnum">   9:</span>     {</pre>
    
    <pre><span class="lnum">  10:</span>         <span class="rem">// perform grooming</span></pre>
    
    <pre><span class="lnum">  11:</span>     }</pre>
    
    <pre><span class="lnum">  12:</span> }</pre>
    
    <pre><span class="lnum">  13:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  14:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Dog : Animal</pre>
    
    <pre><span class="lnum">  15:</span> {</pre>
    
    <pre><span class="lnum">  16:</span> }</pre>
  </div>
</div>

_<span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span>_