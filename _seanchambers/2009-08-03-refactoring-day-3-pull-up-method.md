---
wordpress_id: 3197
title: 'Refactoring Day 3 : Pull Up Method'
date: 2009-08-03T11:35:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/03/refactoring-day-3-pull-up-method.aspx
dsq_thread_id:
  - "262346651"
categories:
  - Uncategorized
---
The Pull Up Method refactoring is the process of taking a method and &ldquo;Pulling&rdquo; it up in the inheritance chain. This is used when a method needs to be used by multiple implementers.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> Vehicle</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="rem">// other methods</span></pre>
    
    <pre><span class="lnum">   4:</span> }</pre>
    
    <pre><span class="lnum">   5:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   6:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Car : Vehicle</pre>
    
    <pre><span class="lnum">   7:</span> {</pre>
    
    <pre><span class="lnum">   8:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Turn(Direction direction)</pre>
    
    <pre><span class="lnum">   9:</span>     {</pre>
    
    <pre><span class="lnum">  10:</span>         <span class="rem">// code here</span></pre>
    
    <pre><span class="lnum">  11:</span>     }</pre>
    
    <pre><span class="lnum">  12:</span> }</pre>
    
    <pre><span class="lnum">  13:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  14:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Motorcycle : Vehicle</pre>
    
    <pre><span class="lnum">  15:</span> {</pre>
    
    <pre><span class="lnum">  16:</span> }</pre>
    
    <pre><span class="lnum">  17:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  18:</span> <span class="kwrd">public</span> <span class="kwrd">enum</span> Direction</pre>
    
    <pre><span class="lnum">  19:</span> {</pre>
    
    <pre><span class="lnum">  20:</span>     Left,</pre>
    
    <pre><span class="lnum">  21:</span>     Right</pre>
    
    <pre><span class="lnum">  22:</span> }</pre>
  </div>
</div>

As you can see, our Turn method is currently only available to the car class, we also want to use it in the motorcycle class so we create a base class if one doesn&rsquo;t already exist and &ldquo;pull up&rdquo; the method into the base class making it available to both. The only drawback is we have increased surface area of the base class adding to it&rsquo;s complexity so use wisely. Only place methods that need to be used by more that one derived class. Once you start overusing inheritance it breaks down pretty quickly and you should start to lean towards composition over inheritance. Here is the code after the refactoring:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> Vehicle</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Turn(Direction direction)</pre>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <pre><span class="lnum">   5:</span>         <span class="rem">// code here</span></pre>
    
    <pre><span class="lnum">   6:</span>     }</pre>
    
    <pre><span class="lnum">   7:</span> }</pre>
    
    <pre><span class="lnum">   8:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   9:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Car : Vehicle</pre>
    
    <pre><span class="lnum">  10:</span> {</pre>
    
    <pre><span class="lnum">  11:</span> }</pre>
    
    <pre><span class="lnum">  12:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  13:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Motorcycle : Vehicle</pre>
    
    <pre><span class="lnum">  14:</span> {</pre>
    
    <pre><span class="lnum">  15:</span> }</pre>
    
    <pre><span class="lnum">  16:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  17:</span> <span class="kwrd">public</span> <span class="kwrd">enum</span> Direction</pre>
    
    <pre><span class="lnum">  18:</span> {</pre>
    
    <pre><span class="lnum">  19:</span>     Left,</pre>
    
    <pre><span class="lnum">  20:</span>     Right</pre>
    
    <pre><span class="lnum">  21:</span> }</pre>
  </div>
</div>

&nbsp;

_<span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a target="_blank" href="/blogs/sean_chambers/archive/2009/07/31/31-days-of-refactoring.aspx">original introductory post</a>.</span>_