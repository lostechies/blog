---
wordpress_id: 3216
title: 'Refactoring Day 22 : Break Method'
date: 2009-08-22T20:25:50+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/22/refactoring-day-22-break-method.aspx
dsq_thread_id:
  - "262354038"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/08/22/refactoring-day-22-break-method.aspx/"
---
Today’s refactoring didn’t really come from any one source. It just named it although someone else may have something similar that’s named differently. If you know of anyone that has a name for this other than Break Method, please let me know.

This refactoring is kind of a meta-refactoring in the fact that it’s just extract method applied over and over until you decompose one large method into several smaller methods. This example here is a tad contrived because the AcceptPayment method isn’t doing as much as I wanted. Imagine that there is much more supporting code around each action that the one method is doing. That would match a real world scenario if you can picture it that way.

Below we have the AcceptPayment method that can be decomposed multiple times into distinct methods.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> CashRegister</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> CashRegister()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   5:</span>         Tax = 0.06m;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   6:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   7:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   8:</span>     <span class="kwrd">private</span> <span class="kwrd">decimal</span> Tax { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   9:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  10:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> AcceptPayment(Customer customer, IEnumerable&lt;Product&gt; products, <span class="kwrd">decimal</span> payment)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  11:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  12:</span>         <span class="kwrd">decimal</span> subTotal = 0m;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  13:</span>         <span class="kwrd">foreach</span> (Product product <span class="kwrd">in</span> products)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  14:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  15:</span>             subTotal += product.Price;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  16:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  17:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  18:</span>         <span class="kwrd">foreach</span>(Product product <span class="kwrd">in</span> products)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  19:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  20:</span>             subTotal -= product.AvailableDiscounts;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  21:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  22:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  23:</span>         <span class="kwrd">decimal</span> grandTotal = subTotal * Tax;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  24:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  25:</span>         customer.DeductFromAccountBalance(grandTotal);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  26:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  27:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  28:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  29:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Customer</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  30:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  31:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> DeductFromAccountBalance(<span class="kwrd">decimal</span> amount)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  32:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  33:</span>         <span class="rem">// deduct from balance</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  34:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  35:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  36:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  37:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Product</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  38:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  39:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> Price { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  40:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> AvailableDiscounts { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  41:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        As you can see the AcceptPayment method has a couple of things that can be decomposed into targeted methods. So we perform the Extract Method refactoring a number of times until we come up with the result:
      </p>
      
      <div class="csharpcode-wrapper">
        <div class="csharpcode">
          <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> CashRegister</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> CashRegister()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   4:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   5:</span>         Tax = 0.06m;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   6:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   7:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   8:</span>     <span class="kwrd">private</span> <span class="kwrd">decimal</span> Tax { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   9:</span>     <span class="kwrd">private</span> IEnumerable&lt;Product&gt; Products { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  10:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  11:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> AcceptPayment(Customer customer, IEnumerable&lt;Product&gt; products, <span class="kwrd">decimal</span> payment)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  12:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  13:</span>         <span class="kwrd">decimal</span> subTotal = CalculateSubtotal();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  14:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  15:</span>         subTotal = SubtractDiscounts(subTotal);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  16:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  17:</span>         <span class="kwrd">decimal</span> grandTotal = AddTax(subTotal);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  18:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  19:</span>         SubtractFromCustomerBalance(customer, grandTotal);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  20:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  21:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  22:</span>     <span class="kwrd">private</span> <span class="kwrd">void</span> SubtractFromCustomerBalance(Customer customer, <span class="kwrd">decimal</span> grandTotal)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  23:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  24:</span>         customer.DeductFromAccountBalance(grandTotal);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  25:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  26:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  27:</span>     <span class="kwrd">private</span> <span class="kwrd">decimal</span> AddTax(<span class="kwrd">decimal</span> subTotal)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  28:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  29:</span>         <span class="kwrd">return</span> subTotal * Tax;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  30:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  31:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  32:</span>     <span class="kwrd">private</span> <span class="kwrd">decimal</span> SubtractDiscounts(<span class="kwrd">decimal</span> subTotal)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  33:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  34:</span>         <span class="kwrd">foreach</span>(Product product <span class="kwrd">in</span> Products)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  35:</span>         {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  36:</span>             subTotal -= product.AvailableDiscounts;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  37:</span>         }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  38:</span>         <span class="kwrd">return</span> subTotal;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  39:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  40:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  41:</span>     <span class="kwrd">private</span> <span class="kwrd">decimal</span> CalculateSubtotal()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  42:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  43:</span>         <span class="kwrd">decimal</span> subTotal = 0m;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  44:</span>         <span class="kwrd">foreach</span> (Product product <span class="kwrd">in</span> Products)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  45:</span>         {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  46:</span>             subTotal += product.Price;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  47:</span>         }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  48:</span>         <span class="kwrd">return</span> subTotal;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  49:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  50:</span> }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  51:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  52:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Customer</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  53:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  54:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> DeductFromAccountBalance(<span class="kwrd">decimal</span> amount)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  55:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  56:</span>         <span class="rem">// deduct from balance</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  57:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  58:</span> }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  59:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  60:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Product</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  61:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  62:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> Price { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  63:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> AvailableDiscounts { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  64:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              <em><span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span></em>
            </p>