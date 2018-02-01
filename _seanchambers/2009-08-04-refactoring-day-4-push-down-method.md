---
id: 3198
title: 'Refactoring Day 4 : Push Down Method'
date: 2009-08-04T12:02:04+00:00
author: Sean Chambers
layout: post
guid: /blogs/sean_chambers/archive/2009/08/04/refactoring-day-4-push-down-method.aspx
dsq_thread_id:
  - "262346563"
categories:
  - Uncategorized
---
Yesterday we looked at the pull up refactoring to move a method to a base class so mutiple derived classes can use a method. Today we look at the opposite. Here is the code before the refactoring:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> abstract <span class="kwrd">class</span> Animal</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Bark()</pre>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <pre><span class="lnum">   5:</span>         <span class="rem">// code to bark</span></pre>
    
    <pre><span class="lnum">   6:</span>     }</pre>
    
    <pre><span class="lnum">   7:</span> }</pre>
    
    <pre><span class="lnum">   8:</span>&#160; </pre>
    
    <pre><span class="lnum">   9:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Dog : Animal</pre>
    
    <pre><span class="lnum">  10:</span> {</pre>
    
    <pre><span class="lnum">  11:</span> }</pre>
    
    <pre><span class="lnum">  12:</span>&#160; </pre>
    
    <pre><span class="lnum">  13:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Cat : Animal</pre>
    
    <pre><span class="lnum">  14:</span> {</pre>
    
    <pre><span class="lnum">  15:</span> }</pre></p>
  </div>
</div>

<font size="1">So here we have some code with a base class that has a Bark method. Perhaps at one time our cat could bark, but now we no longer need that functionality on the Cat class. So we “Push Down” the Bark method into the Dog class as it is no longer needed on the base class but perhaps it is still needed when dealing explicitly with a Dog. At this time, it’s worthwhile to evaluate if there is any behavior still located on the Animal base class. If not, it is a good opportunity to turn the Animal abstract class into an interface instead as no code is required on the contract and can be treated as a marker interface.</font>

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> Animal</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span> }</pre>
    
    <pre><span class="lnum">   4:</span>&#160; </pre>
    
    <pre><span class="lnum">   5:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Dog : Animal</pre>
    
    <pre><span class="lnum">   6:</span> {</pre>
    
    <pre><span class="lnum">   7:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Bark()</pre>
    
    <pre><span class="lnum">   8:</span>     {</pre>
    
    <pre><span class="lnum">   9:</span>         <span class="rem">// code to bark</span></pre>
    
    <pre><span class="lnum">  10:</span>     }</pre>
    
    <pre><span class="lnum">  11:</span> }</pre>
    
    <pre><span class="lnum">  12:</span>&#160; </pre>
    
    <pre><span class="lnum">  13:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Cat : Animal</pre>
    
    <pre><span class="lnum">  14:</span> {</pre>
    
    <pre><span class="lnum">  15:</span> }</pre></p>
  </div>
</div>

_<font size="1">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="http://www.lostechies.com/blogs/sean_chambers/archive/2009/07/31/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</font>_