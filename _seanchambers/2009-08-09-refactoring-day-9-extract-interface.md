---
wordpress_id: 3203
title: 'Refactoring Day 9 : Extract Interface'
date: 2009-08-09T11:00:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/09/refactoring-day-9-extract-interface.aspx
dsq_thread_id:
  - "264983766"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/08/09/refactoring-day-9-extract-interface.aspx/"
---
<span style="font-size: xx-small">Today we look at an often overlooked refactoring. Extract Interface. When you notice more than one class using a similar subset of methods on a class, it is useful to break the dependency and introduce an interface that the consumers to use. It&rsquo;s easy to implement and has benefits from loose coupling.</span>

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> ClassRegistration</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Create()</pre>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <pre><span class="lnum">   5:</span>         <span class="rem">// create registration code</span></pre>
    
    <pre><span class="lnum">   6:</span>     }</pre>
    
    <pre><span class="lnum">   7:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   8:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Transfer()</pre>
    
    <pre><span class="lnum">   9:</span>     {</pre>
    
    <pre><span class="lnum">  10:</span>         <span class="rem">// class transfer code</span></pre>
    
    <pre><span class="lnum">  11:</span>     }</pre>
    
    <pre><span class="lnum">  12:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  13:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> Total { get; <span class="kwrd">private</span> set; }</pre>
    
    <pre><span class="lnum">  14:</span> }</pre>
    
    <pre><span class="lnum">  15:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  16:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> RegistrationProcessor</pre>
    
    <pre><span class="lnum">  17:</span> {</pre>
    
    <pre><span class="lnum">  18:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> ProcessRegistration(ClassRegistration registration)</pre>
    
    <pre><span class="lnum">  19:</span>     {</pre>
    
    <pre><span class="lnum">  20:</span>         registration.Create();</pre>
    
    <pre><span class="lnum">  21:</span>         <span class="kwrd">return</span> registration.Total;</pre>
    
    <pre><span class="lnum">  22:</span>     }</pre>
    
    <pre><span class="lnum">  23:</span> }</pre>
  </div>
</div>

<span style="font-size: xx-small">In the after example, you can see we extracted the methods that both consumers use and placed them in an interface. Now the consumers don&rsquo;t care/know about the class that is implementing these methods. We have decoupled our consumer from the actual implementation and depend only on the contract that we have created.</span>

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">interface</span> IClassRegistration</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">void</span> Create();</pre>
    
    <pre><span class="lnum">   4:</span>     <span class="kwrd">decimal</span> Total { get; }</pre>
    
    <pre><span class="lnum">   5:</span> }</pre>
    
    <pre><span class="lnum">   6:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   7:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> ClassRegistration : IClassRegistration</pre>
    
    <pre><span class="lnum">   8:</span> {</pre>
    
    <pre><span class="lnum">   9:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Create()</pre>
    
    <pre><span class="lnum">  10:</span>     {</pre>
    
    <pre><span class="lnum">  11:</span>         <span class="rem">// create registration code</span></pre>
    
    <pre><span class="lnum">  12:</span>     }</pre>
    
    <pre><span class="lnum">  13:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  14:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Transfer()</pre>
    
    <pre><span class="lnum">  15:</span>     {</pre>
    
    <pre><span class="lnum">  16:</span>         <span class="rem">// class transfer code</span></pre>
    
    <pre><span class="lnum">  17:</span>     }</pre>
    
    <pre><span class="lnum">  18:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  19:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> Total { get; <span class="kwrd">private</span> set; }</pre>
    
    <pre><span class="lnum">  20:</span> }</pre>
    
    <pre><span class="lnum">  21:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  22:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> RegistrationProcessor</pre>
    
    <pre><span class="lnum">  23:</span> {</pre>
    
    <pre><span class="lnum">  24:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> ProcessRegistration(IClassRegistration registration)</pre>
    
    <pre><span class="lnum">  25:</span>     {</pre>
    
    <pre><span class="lnum">  26:</span>         registration.Create();</pre>
    
    <pre><span class="lnum">  27:</span>         <span class="kwrd">return</span> registration.Total;</pre>
    
    <pre><span class="lnum">  28:</span>     }</pre>
    
    <pre><span class="lnum">  29:</span> }</pre>
  </div>
</div>

This refactoring was first published by Martin Fowler and can be found in his list of [refactorings here](http://refactoring.com/catalog/extractInterface.html).

_<span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span>_