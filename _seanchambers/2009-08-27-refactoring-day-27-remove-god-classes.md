---
wordpress_id: 3221
title: 'Refactoring Day 27 : Remove God Classes'
date: 2009-08-27T12:17:13+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/27/refactoring-day-27-remove-god-classes.aspx
dsq_thread_id:
  - "262356083"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/08/27/refactoring-day-27-remove-god-classes.aspx/"
---
Often with legacy code bases I will often come across classes that are clear <a href="https://lostechies.com/blogs/sean_chambers/archive/2008/03/15/ptom-single-responsibility-principle.aspx" target="_blank">SRP</a> violations. Often these classes will be suffixed with either “Utils” or “Manager”. Sometimes they don’t have this indication and are just classes with multiple grouped pieces of functionality. Another good indicator of a God class is methods grouped together with using statements or comments into seperate roles that this one class is performing.

Over time, these classes become a dumping ground for a method that someone doesn’t have time/want to put in the proper class. The refactoring for situations like these is to break apart the methods into distinct classes that are responsible for specific roles.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> CustomerService</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateOrderDiscount(IEnumerable&lt;Product&gt; products, Customer customer)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   5:</span>         <span class="rem">// do work</span></pre>
    
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
    
    <pre><span class="lnum">   8:</span>     <span class="kwrd">public</span> <span class="kwrd">bool</span> CustomerIsValid(Customer customer, Order order)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   9:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  10:</span>         <span class="rem">// do work</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  11:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  12:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  13:</span>     <span class="kwrd">public</span> IEnumerable&lt;<span class="kwrd">string</span>&gt; GatherOrderErrors(IEnumerable&lt;Product&gt; products, Customer customer)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  14:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  15:</span>         <span class="rem">// do work</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  16:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  17:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  18:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Register(Customer customer)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  19:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  20:</span>         <span class="rem">// do work</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  21:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  22:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  23:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> ForgotPassword(Customer customer)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  24:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  25:</span>         <span class="rem">// do work</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  26:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  27:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        The refactoring for this is very straight forward. Simply take the related methods and place them in specific classes that match their responsibility. This makes them much finer grained and defined in what they do and make future maintenance much easier. Here is the end result of splitting up the methods above into two distinct classes.
      </p>
      
      <div class="csharpcode-wrapper">
        <div class="csharpcode">
          <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> CustomerOrderService</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateOrderDiscount(IEnumerable&lt;Product&gt; products, Customer customer)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   4:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   5:</span>         <span class="rem">// do work</span></pre>
          
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
          
          <pre><span class="lnum">   8:</span>     <span class="kwrd">public</span> <span class="kwrd">bool</span> CustomerIsValid(Customer customer, Order order)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   9:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  10:</span>         <span class="rem">// do work</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  11:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  12:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  13:</span>     <span class="kwrd">public</span> IEnumerable&lt;<span class="kwrd">string</span>&gt; GatherOrderErrors(IEnumerable&lt;Product&gt; products, Customer customer)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  14:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  15:</span>         <span class="rem">// do work</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  16:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  17:</span> }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  18:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  19:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> CustomerRegistrationService</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  20:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  21:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  22:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Register(Customer customer)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  23:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  24:</span>         <span class="rem">// do work</span></pre>
          
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
          
          <pre><span class="lnum">  27:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> ForgotPassword(Customer customer)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  28:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  29:</span>         <span class="rem">// do work</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  30:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  31:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              <em><span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span></em>
            </p>