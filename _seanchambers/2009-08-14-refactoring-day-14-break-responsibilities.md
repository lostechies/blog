---
id: 3208
title: 'Refactoring Day 14 : Break Responsibilities'
date: 2009-08-14T11:45:00+00:00
author: Sean Chambers
layout: post
guid: /blogs/sean_chambers/archive/2009/08/14/refactoring-day-14-break-responsibilities.aspx
dsq_thread_id:
  - "262351614"
categories:
  - Uncategorized
---
When breaking apart responsibilities on a class this is enforcing Single Responsiblity Principle from <a href="/blogs/chad_myers/archive/2008/03/07/pablo-s-topic-of-the-month-march-solid-principles.aspx" target="_blank">SOLID</a>. It&rsquo;s an easy approach to apply this refactoring although it&rsquo;s often disputed as what consitutes a &ldquo;responsibility&rdquo;. While I won&rsquo;t be answering that here, I will show a clear cut example of a class that can be broken into several classes with specific responsibilities.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Video</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> PayFee(<span class="kwrd">decimal</span> fee)</pre>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <pre><span class="lnum">   5:</span>     }</pre>
    
    <pre><span class="lnum">   6:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   7:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> RentVideo(Video video, Customer customer)</pre>
    
    <pre><span class="lnum">   8:</span>     {</pre>
    
    <pre><span class="lnum">   9:</span>         customer.Videos.Add(video);</pre>
    
    <pre><span class="lnum">  10:</span>     }</pre>
    
    <pre><span class="lnum">  11:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  12:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateBalance(Customer customer)</pre>
    
    <pre><span class="lnum">  13:</span>     {</pre>
    
    <pre><span class="lnum">  14:</span>         <span class="kwrd">return</span> customer.LateFees.Sum();</pre>
    
    <pre><span class="lnum">  15:</span>     }</pre>
    
    <pre><span class="lnum">  16:</span> }</pre>
    
    <pre><span class="lnum">  17:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  18:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Customer</pre>
    
    <pre><span class="lnum">  19:</span> {</pre>
    
    <pre><span class="lnum">  20:</span>     <span class="kwrd">public</span> IList&lt;<span class="kwrd">decimal</span>&gt; LateFees { get; set; }</pre>
    
    <pre><span class="lnum">  21:</span>     <span class="kwrd">public</span> IList&lt;Video&gt; Videos { get; set; }</pre>
    
    <pre><span class="lnum">  22:</span> }</pre>
  </div>
</div>

As you can see here, the Video class has two responsibilities, once for handling video rentals, and another for managing how many rentals a customer has. We can break out the customer logic into it&rsquo;s own class to help seperate the responsibilities.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Video</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> RentVideo(Video video, Customer customer)</pre>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <pre><span class="lnum">   5:</span>         customer.Videos.Add(video);</pre>
    
    <pre><span class="lnum">   6:</span>     }</pre>
    
    <pre><span class="lnum">   7:</span> }</pre>
    
    <pre><span class="lnum">   8:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   9:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Customer</pre>
    
    <pre><span class="lnum">  10:</span> {</pre>
    
    <pre><span class="lnum">  11:</span>     <span class="kwrd">public</span> IList&lt;<span class="kwrd">decimal</span>&gt; LateFees { get; set; }</pre>
    
    <pre><span class="lnum">  12:</span>     <span class="kwrd">public</span> IList&lt;Video&gt; Videos { get; set; }</pre>
    
    <pre><span class="lnum">  13:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  14:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> PayFee(<span class="kwrd">decimal</span> fee)</pre>
    
    <pre><span class="lnum">  15:</span>     {</pre>
    
    <pre><span class="lnum">  16:</span>     }</pre>
    
    <pre><span class="lnum">  17:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  18:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateBalance(Customer customer)</pre>
    
    <pre><span class="lnum">  19:</span>     {</pre>
    
    <pre><span class="lnum">  20:</span>         <span class="kwrd">return</span> customer.LateFees.Sum();</pre>
    
    <pre><span class="lnum">  21:</span>     }</pre>
    
    <pre><span class="lnum">  22:</span> }</pre>
  </div>
</div>

_<span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span>_