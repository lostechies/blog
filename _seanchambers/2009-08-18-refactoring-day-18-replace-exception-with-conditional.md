---
wordpress_id: 3212
title: 'Refactoring Day 18 : Replace exception with conditional'
date: 2009-08-18T12:30:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/18/refactoring-day-18-replace-exception-with-conditional.aspx
dsq_thread_id:
  - "262353176"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/08/18/refactoring-day-18-replace-exception-with-conditional.aspx/"
---
Today&#8217;s refactoring doesn&#8217;t come from any place specifically, just something I&#8217;ve picked up over time that I find myself using often. Any variations/comments would be appreciated to this approach. I think there&#8217;s some other good refactorings around these type of problems.

A common code smell that I come across from time to time is using exceptions to control program flow. You may see something to this effect:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Microwave</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">private</span> IMicrowaveMotor Motor { get; set;}</pre>
    
    <pre><span class="lnum">   4:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> <span class="kwrd">bool</span> Start(<span class="kwrd">object</span> food)</pre>
    
    <pre><span class="lnum">   6:</span>     {</pre>
    
    <pre><span class="lnum">   7:</span>         <span class="kwrd">bool</span> foodCooked = <span class="kwrd">false</span>;</pre>
    
    <pre><span class="lnum">   8:</span>         <span class="kwrd">try</span></pre>
    
    <pre><span class="lnum">   9:</span>         {</pre>
    
    <pre><span class="lnum">  10:</span>             Motor.Cook(food);</pre>
    
    <pre><span class="lnum">  11:</span>             foodCooked = <span class="kwrd">true</span>;</pre>
    
    <pre><span class="lnum">  12:</span>         }</pre>
    
    <pre><span class="lnum">  13:</span>         <span class="kwrd">catch</span>(InUseException)</pre>
    
    <pre><span class="lnum">  14:</span>         {</pre>
    
    <pre><span class="lnum">  15:</span>             foodcooked = <span class="kwrd">false</span>;</pre>
    
    <pre><span class="lnum">  16:</span>         }</pre>
    
    <pre><span class="lnum">  17:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  18:</span>         <span class="kwrd">return</span> foodCooked;</pre>
    
    <pre><span class="lnum">  19:</span>     }</pre>
    
    <pre><span class="lnum">  20:</span> }</pre>
  </div>
</div>

Exceptions should only be there to do exactly what they are for, handle _exceptional_ behavior. Most of the time you can replace this type of code with a proper conditional and handle it properly. This is called design by contract in the after example because we are ensuring a specific state of the Motor class before performing the necessary work instead of letting an exception handle it.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Microwave</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">private</span> IMicrowaveMotor Motor { get; set; }</pre>
    
    <pre><span class="lnum">   4:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> <span class="kwrd">bool</span> Start(<span class="kwrd">object</span> food)</pre>
    
    <pre><span class="lnum">   6:</span>     {</pre>
    
    <pre><span class="lnum">   7:</span>         <span class="kwrd">if</span> (Motor.IsInUse)</pre>
    
    <pre><span class="lnum">   8:</span>             <span class="kwrd">return</span> <span class="kwrd">false</span>;</pre>
    
    <pre><span class="lnum">   9:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  10:</span>         Motor.Cook(food);</pre>
    
    <pre><span class="lnum">  11:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  12:</span>         <span class="kwrd">return</span> <span class="kwrd">true</span>;</pre>
    
    <pre><span class="lnum">  13:</span>     }</pre>
    
    <pre><span class="lnum">  14:</span> }</pre>
  </div>
</div>

_<span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span>_