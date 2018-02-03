---
wordpress_id: 3204
title: 'Refactoring Day 10 : Extract Method'
date: 2009-08-10T12:30:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/10/refactoring-day-10-extract-method.aspx
dsq_thread_id:
  - "262660999"
categories:
  - Uncategorized
---
<span style="font-size: xx-small">Today we look at the Extract Method refactoring. This is an extremely easy refactoring with several benefits. First, it helps to make code more readable by placing logic behind descriptive method names. This reduces the amount of investigation the next developer needs to do as a method name can describe what a portion of code is doing. This in turn reduces bugs in the code because less assumptions need to be made. Here&rsquo;s some code before we apply the refactoring:</span>

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Receipt</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">private</span> IList&lt;<span class="kwrd">decimal</span>&gt; Discounts { get; set; }</pre>
    
    <pre><span class="lnum">   4:</span>     <span class="kwrd">private</span> IList&lt;<span class="kwrd">decimal</span>&gt; ItemTotals { get; set; }</pre>
    
    <pre><span class="lnum">   5:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   6:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateGrandTotal()</pre>
    
    <pre><span class="lnum">   7:</span>     {</pre>
    
    <pre><span class="lnum">   8:</span>         <span class="kwrd">decimal</span> subTotal = 0m;</pre>
    
    <pre><span class="lnum">   9:</span>         <span class="kwrd">foreach</span> (<span class="kwrd">decimal</span> itemTotal <span class="kwrd">in</span> ItemTotals)</pre>
    
    <pre><span class="lnum">  10:</span>             subTotal += itemTotal;</pre>
    
    <pre><span class="lnum">  11:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  12:</span>         <span class="kwrd">if</span> (Discounts.Count &gt; 0)</pre>
    
    <pre><span class="lnum">  13:</span>         {</pre>
    
    <pre><span class="lnum">  14:</span>             <span class="kwrd">foreach</span> (<span class="kwrd">decimal</span> discount <span class="kwrd">in</span> Discounts)</pre>
    
    <pre><span class="lnum">  15:</span>                 subTotal -= discount;</pre>
    
    <pre><span class="lnum">  16:</span>         }</pre>
    
    <pre><span class="lnum">  17:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  18:</span>         <span class="kwrd">decimal</span> tax = subTotal * 0.065m;</pre>
    
    <pre><span class="lnum">  19:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  20:</span>         subTotal += tax;</pre>
    
    <pre><span class="lnum">  21:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  22:</span>         <span class="kwrd">return</span> subTotal;</pre>
    
    <pre><span class="lnum">  23:</span>     }</pre>
    
    <pre><span class="lnum">  24:</span> }</pre>
  </div>
</div>

<span style="font-size: xx-small">You can see that the CalculateGrandTotal method is actually doing three different things here. It&rsquo;s calculating the subtotal, applying any discounts and then calculating the tax for the receipt. Instead of making a developer look through that whole method to determine what each thing is doing, it would save time and readability to seperate those distinct tasks into their own methods like so:</span>

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Receipt</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">private</span> IList&lt;<span class="kwrd">decimal</span>&gt; Discounts { get; set; }</pre>
    
    <pre><span class="lnum">   4:</span>     <span class="kwrd">private</span> IList&lt;<span class="kwrd">decimal</span>&gt; ItemTotals { get; set; }</pre>
    
    <pre><span class="lnum">   5:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   6:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateGrandTotal()</pre>
    
    <pre><span class="lnum">   7:</span>     {</pre>
    
    <pre><span class="lnum">   8:</span>         <span class="kwrd">decimal</span> subTotal = CalculateSubTotal();</pre>
    
    <pre><span class="lnum">   9:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  10:</span>         subTotal = CalculateDiscounts(subTotal);</pre>
    
    <pre><span class="lnum">  11:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  12:</span>         subTotal = CalculateTax(subTotal);</pre>
    
    <pre><span class="lnum">  13:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  14:</span>         <span class="kwrd">return</span> subTotal;</pre>
    
    <pre><span class="lnum">  15:</span>     }</pre>
    
    <pre><span class="lnum">  16:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  17:</span>     <span class="kwrd">private</span> <span class="kwrd">decimal</span> CalculateTax(<span class="kwrd">decimal</span> subTotal)</pre>
    
    <pre><span class="lnum">  18:</span>     {</pre>
    
    <pre><span class="lnum">  19:</span>         <span class="kwrd">decimal</span> tax = subTotal * 0.065m;</pre>
    
    <pre><span class="lnum">  20:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  21:</span>         subTotal += tax;</pre>
    
    <pre><span class="lnum">  22:</span>         <span class="kwrd">return</span> subTotal;</pre>
    
    <pre><span class="lnum">  23:</span>     }</pre>
    
    <pre><span class="lnum">  24:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  25:</span>     <span class="kwrd">private</span> <span class="kwrd">decimal</span> CalculateDiscounts(<span class="kwrd">decimal</span> subTotal)</pre>
    
    <pre><span class="lnum">  26:</span>     {</pre>
    
    <pre><span class="lnum">  27:</span>         <span class="kwrd">if</span> (Discounts.Count &gt; 0)</pre>
    
    <pre><span class="lnum">  28:</span>         {</pre>
    
    <pre><span class="lnum">  29:</span>             <span class="kwrd">foreach</span> (<span class="kwrd">decimal</span> discount <span class="kwrd">in</span> Discounts)</pre>
    
    <pre><span class="lnum">  30:</span>                 subTotal -= discount;</pre>
    
    <pre><span class="lnum">  31:</span>         }</pre>
    
    <pre><span class="lnum">  32:</span>         <span class="kwrd">return</span> subTotal;</pre>
    
    <pre><span class="lnum">  33:</span>     }</pre>
    
    <pre><span class="lnum">  34:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  35:</span>     <span class="kwrd">private</span> <span class="kwrd">decimal</span> CalculateSubTotal()</pre>
    
    <pre><span class="lnum">  36:</span>     {</pre>
    
    <pre><span class="lnum">  37:</span>         <span class="kwrd">decimal</span> subTotal = 0m;</pre>
    
    <pre><span class="lnum">  38:</span>         <span class="kwrd">foreach</span> (<span class="kwrd">decimal</span> itemTotal <span class="kwrd">in</span> ItemTotals)</pre>
    
    <pre><span class="lnum">  39:</span>             subTotal += itemTotal;</pre>
    
    <pre><span class="lnum">  40:</span>         <span class="kwrd">return</span> subTotal;</pre>
    
    <pre><span class="lnum">  41:</span>     }</pre>
    
    <pre><span class="lnum">  42:</span> }</pre>
  </div>
</div>

This refactoring comes from Martin Fowler and can be [found here](http://refactoring.com/catalog/extractMethod.html)

_<span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a target="_blank" href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx">original introductory post</a>.</span>_