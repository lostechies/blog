---
wordpress_id: 3210
title: 'Refactoring Day 16 : Encapsulate Conditional'
date: 2009-08-16T10:29:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/16/refactoring-day-16-encapsulate-conditional.aspx
dsq_thread_id:
  - "262352595"
categories:
  - Uncategorized
---
Sometimes when doing a number of different checks within a conditional the intent of what you are testing for gets lost in the conditional. In these instances I like to extract the conditional into an easy to read property, or method depending if there is parameters to pass or not. Here is an example of what the code might look like before:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> RemoteControl</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">private</span> <span class="kwrd">string</span>[] Functions { get; set; }</pre>
    
    <pre><span class="lnum">   4:</span>     <span class="kwrd">private</span> <span class="kwrd">string</span> Name { get; set; }</pre>
    
    <pre><span class="lnum">   5:</span>     <span class="kwrd">private</span> <span class="kwrd">int</span> CreatedYear { get; set; }</pre>
    
    <pre><span class="lnum">   6:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   7:</span>     <span class="kwrd">public</span> <span class="kwrd">string</span> PerformCoolFunction(<span class="kwrd">string</span> buttonPressed)</pre>
    
    <pre><span class="lnum">   8:</span>     {</pre>
    
    <pre><span class="lnum">   9:</span>         <span class="rem">// Determine if we are controlling some extra function</span></pre>
    
    <pre><span class="lnum">  10:</span>         <span class="rem">// that requires special conditions</span></pre>
    
    <pre><span class="lnum">  11:</span>         <span class="kwrd">if</span> (Functions.Length &gt; 1 && Name == <span class="str">"RCA"</span> && CreatedYear &gt; DateTime.Now.Year - 2)</pre>
    
    <pre><span class="lnum">  12:</span>             <span class="kwrd">return</span> <span class="str">"doSomething"</span>;</pre>
    
    <pre><span class="lnum">  13:</span>     }</pre>
    
    <pre><span class="lnum">  14:</span> }</pre>
  </div>
</div>

After we apply the refactoring, you can see the code reads much easier and conveys intent:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> RemoteControl</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">private</span> <span class="kwrd">string</span>[] Functions { get; set; }</pre>
    
    <pre><span class="lnum">   4:</span>     <span class="kwrd">private</span> <span class="kwrd">string</span> Name { get; set; }</pre>
    
    <pre><span class="lnum">   5:</span>     <span class="kwrd">private</span> <span class="kwrd">int</span> CreatedYear { get; set; }</pre>
    
    <pre><span class="lnum">   6:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   7:</span>     <span class="kwrd">private</span> <span class="kwrd">bool</span> HasExtraFunctions</pre>
    
    <pre><span class="lnum">   8:</span>     {</pre>
    
    <pre><span class="lnum">   9:</span>         get { <span class="kwrd">return</span> Functions.Length &gt; 1 && Name == <span class="str">"RCA"</span> && CreatedYear &gt; DateTime.Now.Year - 2; }</pre>
    
    <pre><span class="lnum">  10:</span>     }</pre>
    
    <pre><span class="lnum">  11:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  12:</span>     <span class="kwrd">public</span> <span class="kwrd">string</span> PerformCoolFunction(<span class="kwrd">string</span> buttonPressed)</pre>
    
    <pre><span class="lnum">  13:</span>     {</pre>
    
    <pre><span class="lnum">  14:</span>         <span class="rem">// Determine if we are controlling some extra function</span></pre>
    
    <pre><span class="lnum">  15:</span>         <span class="rem">// that requires special conditions</span></pre>
    
    <pre><span class="lnum">  16:</span>         <span class="kwrd">if</span> (HasExtraFunctions)</pre>
    
    <pre><span class="lnum">  17:</span>             <span class="kwrd">return</span> <span class="str">"doSomething"</span>;</pre>
    
    <pre><span class="lnum">  18:</span>     }</pre>
    
    <pre><span class="lnum">  19:</span> }</pre>
  </div>
</div>

_<span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a target="_blank" href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx">original introductory post</a>.</span>_