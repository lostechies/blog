---
wordpress_id: 3222
title: 'Refactoring Day 28 : Rename boolean method'
date: 2009-08-28T12:12:10+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/28/refactoring-day-28-rename-boolean-method.aspx
dsq_thread_id:
  - "262149496"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/08/28/refactoring-day-28-rename-boolean-method.aspx/"
---
Today’s refactoring doesn’t necessarily come from Fowlers refactoring catalog. If anyone knows where this “refactoring” actually comes from, please let me know.

Granted, this could be viewed as not being a refactoring as the methods are actually changing, but this is a gray area and open to debate. Methods with a large number of boolean parameters can quickly get out of hand and can produce unexpected behavior. Depending on the number of parameters will determine how many methods need to be broken out. Let’s take a look at where this refactoring starts:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> BankAccount</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> CreateAccount(Customer customer, <span class="kwrd">bool</span> withChecking, <span class="kwrd">bool</span> withSavings, <span class="kwrd">bool</span> withStocks)</pre>
    
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
    
    <pre><span class="lnum">   7:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        We can make this work a little better simple by exposing the boolean parameters via well named methods and in turn make the original method private to prevent anyone from calling it going forward. Obviously you could have a large number of permutations here and perhaps it makes more sense to refactor to a <a href="http://refactoring.com/catalog/introduceParameterObject.html" target="_blank">Parameter object</a> instead.
      </p>
      
      <div class="csharpcode-wrapper">
        <div class="csharpcode">
          <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> BankAccount</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> CreateAccountWithChecking(Customer customer)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   4:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   5:</span>         CreateAccount(customer, <span class="kwrd">true</span>, <span class="kwrd">false</span>);</pre>
          
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
          
          <pre><span class="lnum">   8:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> CreateAccountWithCheckingAndSavings(Customer customer)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   9:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  10:</span>         CreateAccount(customer, <span class="kwrd">true</span>, <span class="kwrd">true</span>);</pre>
          
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
          
          <pre><span class="lnum">  13:</span>     <span class="kwrd">private</span> <span class="kwrd">void</span> CreateAccount(Customer customer, <span class="kwrd">bool</span> withChecking, <span class="kwrd">bool</span> withSavings)</pre>
          
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
            <!--CRLF--></div> </div> 
            
            <p>
              <em><span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span></em>
            </p>