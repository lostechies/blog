---
wordpress_id: 3201
title: 'Refactoring Day 7 : Rename (method, class, parameter)'
date: 2009-08-07T12:38:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/07/refactoring-day-7-rename-method-class-parameter.aspx
dsq_thread_id:
  - "264034533"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/08/07/refactoring-day-7-rename-method-class-parameter.aspx/"
---
This refactoring I use most often and is one of the most useful refactoring. All too often we do not name methods/classes/parameters properly that leads to a misunderstanding as to what the method/class/parameter&rsquo;s function is. When this occurs, assumptions are made and bugs are introduced to the system. As simple of a refactoring this seems, it is one of the most important to leverage.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Person</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">string</span> FN { get; set; }</pre>
    
    <pre><span class="lnum">   4:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> ClcHrlyPR()</pre>
    
    <pre><span class="lnum">   6:</span>     {</pre>
    
    <pre><span class="lnum">   7:</span>         <span class="rem">// code to calculate hourly payrate</span></pre>
    
    <pre><span class="lnum">   8:</span>         <span class="kwrd">return</span> 0m;</pre>
    
    <pre><span class="lnum">   9:</span>     }</pre>
    
    <pre><span class="lnum">  10:</span> }</pre>
  </div>
</div>

As you can see here, we have a class/method/parameter that all have very non-descriptive, obscure names. They can be interpreted in a number of different ways. Applying this refactoring is as simple as renaming the items at hand to be more descriptive and convey what exactly they do. Simple enough.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="rem">// Changed the class name to Employee</span></pre>
    
    <pre><span class="lnum">   2:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Employee</pre>
    
    <pre><span class="lnum">   3:</span> {</pre>
    
    <pre><span class="lnum">   4:</span>     <span class="kwrd">public</span> <span class="kwrd">string</span> FirstName { get; set; }</pre>
    
    <pre><span class="lnum">   5:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   6:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateHourlyPay()</pre>
    
    <pre><span class="lnum">   7:</span>     {</pre>
    
    <pre><span class="lnum">   8:</span>         <span class="rem">// code to calculate hourly payrate</span></pre>
    
    <pre><span class="lnum">   9:</span>         <span class="kwrd">return</span> 0m;</pre>
    
    <pre><span class="lnum">  10:</span>     }</pre>
    
    <pre><span class="lnum">  11:</span> }</pre>
  </div>
</div>

&nbsp;

_<span style="font-size: xx-small">This refactoring was originally published by Martin Fowler and can be <a target="_blank" href="http://www.refactoring.com/catalog/renameMethod.html">found here</a></span>_

_<span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a target="_blank" href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx">original introductory post</a>.</span>_