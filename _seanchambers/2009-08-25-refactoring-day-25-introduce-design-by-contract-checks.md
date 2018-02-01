---
id: 3219
title: 'Refactoring Day 25 : Introduce Design By Contract checks'
date: 2009-08-25T12:02:49+00:00
author: Sean Chambers
layout: post
guid: /blogs/sean_chambers/archive/2009/08/25/refactoring-day-25-introduce-design-by-contract-checks.aspx
dsq_thread_id:
  - "262355361"
categories:
  - Uncategorized
---
Design By Contract or DBC defines that methods should have defined input and output verifications. Therefore, you can be sure you are always working with a usable set of data in all methods and everything is behaving as expected. If not, exceptions or errors should be returned and handled from the methods. To read more on DBC read the <a href="http://en.wikipedia.org/wiki/Design_by_contract" target="_blank">wikipedia page here</a>.

In our example here, we are working with input parameters that may possibly be null. As a result a NullReferenceException would be thrown from this method because we never verify that we have an instance. During the end of the method, we don’t ensure that we are returning a valid decimal to the consumer of this method and may introduce methods elsewhere.

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
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> TotalOrder(IEnumerable&lt;Product&gt; products, Customer customer)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   5:</span>         <span class="kwrd">decimal</span> orderTotal = products.Sum(product =&gt; product.Price);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   6:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   7:</span>         customer.Balance += orderTotal;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   8:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   9:</span>         <span class="kwrd">return</span> orderTotal;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  10:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  11:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        The changes we can make here to introduce DBC checks is pretty easy. First we will assert that we don’t have a null customer, check that we have at least one product to total. Before we return the order total we will ensure that we have a valid amount for the order total. If any of these checks fail in this example we should throw targeted exceptions that detail exactly what happened and fail gracefully rather than throw an obscure NullReferenceException.
      </p>
      
      <p>
        It seems as if there is some DBC framework methods and exceptions in the Microsoft.Contracts namespace that was introduced with .net framework 3.5. I personally haven’t played with these yet, but they may be worth looking at. This is the only thing I could find on <a href="http://msdn.microsoft.com/en-us/devlabs/dd491992.aspx" target="_blank">msdn about the namespace</a>.
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
          
          <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> TotalOrder(IEnumerable&lt;Product&gt; products, Customer customer)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   4:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   5:</span>         <span class="kwrd">if</span> (customer == <span class="kwrd">null</span>)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   6:</span>             <span class="kwrd">throw</span> <span class="kwrd">new</span> ArgumentNullException(<span class="str">"customer"</span>, <span class="str">"Customer cannot be null"</span>);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   7:</span>         <span class="kwrd">if</span> (products.Count() == 0)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   8:</span>             <span class="kwrd">throw</span> <span class="kwrd">new</span> ArgumentException(<span class="str">"Must have at least one product to total"</span>, <span class="str">"products"</span>);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   9:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  10:</span>         <span class="kwrd">decimal</span> orderTotal = products.Sum(product =&gt; product.Price);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  11:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  12:</span>         customer.Balance += orderTotal;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  13:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  14:</span>         <span class="kwrd">if</span> (orderTotal == 0)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  15:</span>             <span class="kwrd">throw</span> <span class="kwrd">new</span> ArgumentOutOfRangeException(<span class="str">"orderTotal"</span>, <span class="str">"Order Total should not be zero"</span>);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  16:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  17:</span>         <span class="kwrd">return</span> orderTotal;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  18:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  19:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              It does add more code to the method for validation checks and you can go overboard with DBC, but I think in most scenarios it is a worthwhile endeavor to catch sticky situations. It really stinks to chase after a NullReferenceException without detailed information.
            </p>
            
            <p>
              <em><span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span></em>
            </p>