---
wordpress_id: 3224
title: 'Refactoring Day 30 : Return ASAP'
date: 2009-08-28T16:38:40+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/28/refactoring-day-30-return-asap.aspx
dsq_thread_id:
  - "262356806"
categories:
  - Uncategorized
---
This topic actually came up during the Remove Arrowhead Antipattern refactoring. The refactoring introduces this as a side effect to remove the arrowhead. To eliminate the arrowhead you return as soon as possible.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Order</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> Customer Customer { get; <span class="kwrd">private</span> set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   4:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateOrder(Customer customer, IEnumerable&lt;Product&gt; products, <span class="kwrd">decimal</span> discounts)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   6:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   7:</span>         Customer = customer;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   8:</span>         <span class="kwrd">decimal</span> orderTotal = 0m;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   9:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  10:</span>         <span class="kwrd">if</span> (products.Count() &gt; 0)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  11:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  12:</span>             orderTotal = products.Sum(p =&gt; p.Price);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  13:</span>             <span class="kwrd">if</span> (discounts &gt; 0)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  14:</span>             {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  15:</span>                 orderTotal -= discounts;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  16:</span>             }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  17:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  18:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  19:</span>         <span class="kwrd">return</span> orderTotal;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  20:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  21:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        The idea is that as soon as you know what needs to be done and you have all the required information, you should exit the method as soon as possible and not continue along.
      </p>
      
      <div class="csharpcode-wrapper">
        <div class="csharpcode">
          <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Order</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> Customer Customer { get; <span class="kwrd">private</span> set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   4:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateOrder(Customer customer, IEnumerable&lt;Product&gt; products, <span class="kwrd">decimal</span> discounts)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   6:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   7:</span>         <span class="kwrd">if</span> (products.Count() == 0)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   8:</span>             <span class="kwrd">return</span> 0;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   9:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  10:</span>         Customer = customer;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  11:</span>         <span class="kwrd">decimal</span> orderTotal = products.Sum(p =&gt; p.Price);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  12:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  13:</span>         <span class="kwrd">if</span> (discounts == 0)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  14:</span>             <span class="kwrd">return</span> orderTotal;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  15:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  16:</span>         orderTotal -= discounts;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  17:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  18:</span>         <span class="kwrd">return</span> orderTotal;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  19:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  20:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              <em><span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span></em>
            </p>