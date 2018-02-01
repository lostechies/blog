---
id: 3214
title: 'Refactoring Day 20 : Extract Subclass'
date: 2009-08-20T12:08:00+00:00
author: Sean Chambers
layout: post
guid: /blogs/sean_chambers/archive/2009/08/20/refactoring-day-20-extract-subclass.aspx
dsq_thread_id:
  - "262353498"
categories:
  - Uncategorized
---
Todays refactoring comes from Martin Fowlers catalog of patterns. You can find this refactoring in his <a href="http://refactoring.com/catalog/extractSubclass.html" target="_blank">catalog here</a>

This refactoring is useful when you have methods on a base class that are not shared amongst all classes and needs to be pushed down into it&rsquo;s own class. The example I&rsquo;m using here is pretty straightforward. We start out with a single class called Registration. This class handles all information related to a student registering for a course.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Registration</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> NonRegistrationAction Action { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   4:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> RegistrationTotal { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> <span class="kwrd">string</span> Notes { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   6:</span>     <span class="kwrd">public</span> <span class="kwrd">string</span> Description { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   7:</span>     <span class="kwrd">public</span> DateTime RegistrationDate { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   8:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        There is something that we&rsquo;ve realized after working with this class. We are using it in two different contexts. The properties NonRegistrationAction and Notes are only ever used when dealing with a NonRegistration which is used to track a portion of the system that is slightly different than a normal registration. Noticing this, we can extract a subclass and move those properties down into the NonRegistration class where they more appropriately fit.
      </p>
      
      <div class="csharpcode-wrapper">
        <div class="csharpcode">
          <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Registration</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> RegistrationTotal { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   4:</span>     <span class="kwrd">public</span> <span class="kwrd">string</span> Description { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> DateTime RegistrationDate { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   6:</span> }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   7:</span>&nbsp; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   8:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> NonRegistration : Registration</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   9:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  10:</span>     <span class="kwrd">public</span> NonRegistrationAction Action { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  11:</span>     <span class="kwrd">public</span> <span class="kwrd">string</span> Notes { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  12:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              <em><span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span></em>
            </p>