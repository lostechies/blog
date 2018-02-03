---
wordpress_id: 3225
title: 'Refactoring Day 31 : Replace conditional with Polymorphism'
date: 2009-08-28T16:38:46+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/28/refactoring-day-31-replace-conditional-with-polymorphism.aspx
dsq_thread_id:
  - "262356903"
categories:
  - Uncategorized
---
The last day of refactoring comes from Fowlers refactoring catalog and can be <a href="http://refactoring.com/catalog/replaceConditionalWithPolymorphism.html" target="_blank">found here</a>.

This shows one of the foundations of Object Oriented Programming which is <a href="http://en.wikipedia.org/wiki/Type_polymorphism" target="_blank">Polymorphism</a>. The concept here is that in instances where you are doing checks by type, and performing some type of operation, it’s a good idea to encapsulate that algorithm within the class and then use polymorphism to abstract the call to the code.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> Customer</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   3:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   4:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   5:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Employee : Customer</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   6:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   7:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   8:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   9:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> NonEmployee : Customer</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  10:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  11:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  12:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  13:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> OrderProcessor</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  14:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  15:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> ProcessOrder(Customer customer, IEnumerable&lt;Product&gt; products)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  16:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  17:</span>         <span class="rem">// do some processing of order</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  18:</span>         <span class="kwrd">decimal</span> orderTotal = products.Sum(p =&gt; p.Price);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  19:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  20:</span>         Type customerType = customer.GetType();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  21:</span>         <span class="kwrd">if</span> (customerType == <span class="kwrd">typeof</span>(Employee))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  22:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  23:</span>             orderTotal -= orderTotal * 0.15m;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  24:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  25:</span>         <span class="kwrd">else</span> <span class="kwrd">if</span> (customerType == <span class="kwrd">typeof</span>(NonEmployee))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  26:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  27:</span>             orderTotal -= orderTotal * 0.05m;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  28:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  29:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  30:</span>         <span class="kwrd">return</span> orderTotal;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  31:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  32:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        As you can see here, we’re not leaning on our inheritance hierarchy to put the calculation, or even the data needed to perform the calculation lest we have a SRP violation. So to refactor this we simply take the percentage rate and place that on the actual customer type that each class will then implement. I know this is really remedial but I wanted to cover this as well as I have seen it in code.
      </p>
      
      <div class="csharpcode-wrapper">
        <div class="csharpcode">
          <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> Customer</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">decimal</span> DiscountPercentage { get; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   4:</span> }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   5:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   6:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Employee : Customer</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   7:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   8:</span>     <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">decimal</span> DiscountPercentage</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   9:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  10:</span>         get { <span class="kwrd">return</span> 0.15m; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  11:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  12:</span> }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  13:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  14:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> NonEmployee : Customer</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  15:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  16:</span>     <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">decimal</span> DiscountPercentage</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  17:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  18:</span>         get { <span class="kwrd">return</span> 0.05m; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  19:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  20:</span> }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  21:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  22:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> OrderProcessor</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  23:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  24:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> ProcessOrder(Customer customer, IEnumerable&lt;Product&gt; products)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  25:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  26:</span>         <span class="rem">// do some processing of order</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  27:</span>         <span class="kwrd">decimal</span> orderTotal = products.Sum(p =&gt; p.Price);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  28:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  29:</span>         orderTotal -= orderTotal * customer.DiscountPercentage;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  30:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  31:</span>         <span class="kwrd">return</span> orderTotal;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  32:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  33:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              <em><span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span></em>
            </p>