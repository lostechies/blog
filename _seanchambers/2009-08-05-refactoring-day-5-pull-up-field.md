---
wordpress_id: 3199
title: 'Refactoring Day 5 : Pull Up Field'
date: 2009-08-05T11:39:31+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/05/refactoring-day-5-pull-up-field.aspx
dsq_thread_id:
  - "264034235"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/08/05/refactoring-day-5-pull-up-field.aspx/"
---
</p> 

Today we look at a refactoring that is similar to the Pull Up method. Instead of a method, it is obviously done with a field instead!

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> Account</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span> }</pre>
    
    <pre><span class="lnum">   4:</span>&#160; </pre>
    
    <pre><span class="lnum">   5:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> CheckingAccount : Account</pre>
    
    <pre><span class="lnum">   6:</span> {</pre>
    
    <pre><span class="lnum">   7:</span>     <span class="kwrd">private</span> <span class="kwrd">decimal</span> _minimumCheckingBalance = 5m;</pre>
    
    <pre><span class="lnum">   8:</span> }</pre>
    
    <pre><span class="lnum">   9:</span>&#160; </pre>
    
    <pre><span class="lnum">  10:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> SavingsAccount : Account</pre>
    
    <pre><span class="lnum">  11:</span> {</pre>
    
    <pre><span class="lnum">  12:</span>     <span class="kwrd">private</span> <span class="kwrd">decimal</span> _minimumSavingsBalance = 5m;</pre>
    
    <pre><span class="lnum">  13:</span> }</pre></p>
  </div>
</div>

In this example, we have a constant value that is duplicated between two derived classes. To promote reuse we can pull up the field into the base class and rename it for brevity.
    


<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> Account</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">protected</span> <span class="kwrd">decimal</span> _minimumBalance = 5m;</pre>
    
    <pre><span class="lnum">   4:</span> }</pre>
    
    <pre><span class="lnum">   5:</span>&#160; </pre>
    
    <pre><span class="lnum">   6:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> CheckingAccount : Account</pre>
    
    <pre><span class="lnum">   7:</span> {</pre>
    
    <pre><span class="lnum">   8:</span> }</pre>
    
    <pre><span class="lnum">   9:</span>&#160; </pre>
    
    <pre><span class="lnum">  10:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> SavingsAccount : Account</pre>
    
    <pre><span class="lnum">  11:</span> {</pre>
    
    <pre><span class="lnum">  12:</span> }</pre></p>
  </div>
</div>

&#160;

_<font size="1">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="https://lostechies.com/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</font>_