---
wordpress_id: 3207
title: 'Refactoring Day 13 : Extract Method Object'
date: 2009-08-13T13:30:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/13/refactoring-day-13-extract-method-object.aspx
dsq_thread_id:
  - "262350797"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/08/13/refactoring-day-13-extract-method-object.aspx/"
---
Today&#8217;s refactoring comes from Martin Fowlers list of refactorings. You can find his [original article here with a brief description](http://refactoring.com/catalog/replaceMethodWithMethodObject.html).

This is a more infrequent refactoring that I see myself using but it comes in handy at times. When trying to apply an Extract Method refactoring, and multiple methods are needing to be introduced, it is sometimes gets ugly because of multiple local variables that are being used within a method. Because of this reason, it is better to introduce an Extract Method Object refactoring and to segregate the logic required to perform the task. 

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> OrderLineItem</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> Price { get; <span class="kwrd">private</span> set; }</pre>
    
    <pre><span class="lnum">   4:</span> }</pre>
    
    <pre><span class="lnum">   5:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   6:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Order</pre>
    
    <pre><span class="lnum">   7:</span> {</pre>
    
    <pre><span class="lnum">   8:</span>     <span class="kwrd">private</span> IList&lt;OrderLineItem&gt; OrderLineItems { get; set; }</pre>
    
    <pre><span class="lnum">   9:</span>     <span class="kwrd">private</span> IList&lt;<span class="kwrd">decimal</span>&gt; Discounts { get; set; }</pre>
    
    <pre><span class="lnum">  10:</span>     <span class="kwrd">private</span> <span class="kwrd">decimal</span> Tax { get; set; }</pre>
    
    <pre><span class="lnum">  11:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  12:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> Calculate()</pre>
    
    <pre><span class="lnum">  13:</span>     {</pre>
    
    <pre><span class="lnum">  14:</span>         <span class="kwrd">decimal</span> subTotal = 0m;</pre>
    
    <pre><span class="lnum">  15:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  16:</span>         <span class="rem">// Total up line items</span></pre>
    
    <pre><span class="lnum">  17:</span>         <span class="kwrd">foreach</span> (OrderLineItem lineItem <span class="kwrd">in</span> OrderLineItems)</pre>
    
    <pre><span class="lnum">  18:</span>         {</pre>
    
    <pre><span class="lnum">  19:</span>             subTotal += lineItem.Price;</pre>
    
    <pre><span class="lnum">  20:</span>         }</pre>
    
    <pre><span class="lnum">  21:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  22:</span>         <span class="rem">// Subtract Discounts</span></pre>
    
    <pre><span class="lnum">  23:</span>         <span class="kwrd">foreach</span> (<span class="kwrd">decimal</span> discount <span class="kwrd">in</span> Discounts)</pre>
    
    <pre><span class="lnum">  24:</span>             subTotal -= discount;</pre>
    
    <pre><span class="lnum">  25:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  26:</span>         <span class="rem">// Calculate Tax</span></pre>
    
    <pre><span class="lnum">  27:</span>         <span class="kwrd">decimal</span> tax = subTotal * Tax;</pre>
    
    <pre><span class="lnum">  28:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  29:</span>         <span class="rem">// Calculate GrandTotal</span></pre>
    
    <pre><span class="lnum">  30:</span>         <span class="kwrd">decimal</span> grandTotal = subTotal + tax;</pre>
    
    <pre><span class="lnum">  31:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  32:</span>         <span class="kwrd">return</span> grandTotal;</pre>
    
    <pre><span class="lnum">  33:</span>     }</pre>
    
    <pre><span class="lnum">  34:</span> }</pre>
  </div>
</div>

This entails passing a reference to the class that will be returning the computation to a new object that has the multiple methods via the constructor, or passing the individual parameters to the constructor of the method object. I will be showing the former here.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> OrderLineItem</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> Price { get; <span class="kwrd">private</span> set;}</pre>
    
    <pre><span class="lnum">   4:</span> }</pre>
    
    <pre><span class="lnum">   5:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   6:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Order</pre>
    
    <pre><span class="lnum">   7:</span> {</pre>
    
    <pre><span class="lnum">   8:</span>     <span class="kwrd">public</span> IEnumerable&lt;OrderLineItem&gt; OrderLineItems { get; <span class="kwrd">private</span> set;}</pre>
    
    <pre><span class="lnum">   9:</span>     <span class="kwrd">public</span> IEnumerable&lt;<span class="kwrd">decimal</span>&gt; Discounts { get; <span class="kwrd">private</span> set; }</pre>
    
    <pre><span class="lnum">  10:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> Tax { get; <span class="kwrd">private</span> set; }</pre>
    
    <pre><span class="lnum">  11:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  12:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> Calculate()</pre>
    
    <pre><span class="lnum">  13:</span>     {</pre>
    
    <pre><span class="lnum">  14:</span>         <span class="kwrd">return</span> <span class="kwrd">new</span> OrderCalculator(<span class="kwrd">this</span>).Calculate();</pre>
    
    <pre><span class="lnum">  15:</span>     }</pre>
    
    <pre><span class="lnum">  16:</span> }</pre>
    
    <pre><span class="lnum">  17:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  18:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> OrderCalculator</pre>
    
    <pre><span class="lnum">  19:</span> {</pre>
    
    <pre><span class="lnum">  20:</span>     <span class="kwrd">private</span> <span class="kwrd">decimal</span> SubTotal { get; set;}</pre>
    
    <pre><span class="lnum">  21:</span>     <span class="kwrd">private</span> IEnumerable&lt;OrderLineItem&gt; OrderLineItems { get; set; }</pre>
    
    <pre><span class="lnum">  22:</span>     <span class="kwrd">private</span> IEnumerable&lt;<span class="kwrd">decimal</span>&gt; Discounts { get; set; }</pre>
    
    <pre><span class="lnum">  23:</span>     <span class="kwrd">private</span> <span class="kwrd">decimal</span> Tax { get; set; }</pre>
    
    <pre><span class="lnum">  24:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  25:</span>     <span class="kwrd">public</span> OrderCalculator(Order order)</pre>
    
    <pre><span class="lnum">  26:</span>     {</pre>
    
    <pre><span class="lnum">  27:</span>         OrderLineItems = order.OrderLineItems;</pre>
    
    <pre><span class="lnum">  28:</span>         Discounts = order.Discounts;</pre>
    
    <pre><span class="lnum">  29:</span>         Tax = order.Tax;</pre>
    
    <pre><span class="lnum">  30:</span>     }</pre>
    
    <pre><span class="lnum">  31:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  32:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> Calculate()</pre>
    
    <pre><span class="lnum">  33:</span>     {</pre>
    
    <pre><span class="lnum">  34:</span>         CalculateSubTotal();</pre>
    
    <pre><span class="lnum">  35:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  36:</span>         SubtractDiscounts();</pre>
    
    <pre><span class="lnum">  37:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  38:</span>         CalculateTax();</pre>
    
    <pre><span class="lnum">  39:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  40:</span>         <span class="kwrd">return</span> SubTotal;</pre>
    
    <pre><span class="lnum">  41:</span>     }</pre>
    
    <pre><span class="lnum">  42:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  43:</span>     <span class="kwrd">private</span> <span class="kwrd">void</span> CalculateSubTotal()</pre>
    
    <pre><span class="lnum">  44:</span>     {</pre>
    
    <pre><span class="lnum">  45:</span>         <span class="rem">// Total up line items</span></pre>
    
    <pre><span class="lnum">  46:</span>         <span class="kwrd">foreach</span> (OrderLineItem lineItem <span class="kwrd">in</span> OrderLineItems)</pre>
    
    <pre><span class="lnum">  47:</span>             SubTotal += lineItem.Price;</pre>
    
    <pre><span class="lnum">  48:</span>     }</pre>
    
    <pre><span class="lnum">  49:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  50:</span>     <span class="kwrd">private</span> <span class="kwrd">void</span> SubtractDiscounts()</pre>
    
    <pre><span class="lnum">  51:</span>     {</pre>
    
    <pre><span class="lnum">  52:</span>         <span class="rem">// Subtract Discounts</span></pre>
    
    <pre><span class="lnum">  53:</span>         <span class="kwrd">foreach</span> (<span class="kwrd">decimal</span> discount <span class="kwrd">in</span> Discounts)</pre>
    
    <pre><span class="lnum">  54:</span>             SubTotal -= discount;</pre>
    
    <pre><span class="lnum">  55:</span>     }</pre>
    
    <pre><span class="lnum">  56:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  57:</span>     <span class="kwrd">private</span> <span class="kwrd">void</span> CalculateTax()</pre>
    
    <pre><span class="lnum">  58:</span>     {</pre>
    
    <pre><span class="lnum">  59:</span>         <span class="rem">// Calculate Tax</span></pre>
    
    <pre><span class="lnum">  60:</span>         SubTotal += SubTotal * Tax;</pre>
    
    <pre><span class="lnum">  61:</span>     }</pre>
    
    <pre><span class="lnum">  62:</span> }</pre>
  </div>
</div>

_<span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span>_