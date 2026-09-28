---
wordpress_id: 3217
title: 'Refactoring Day 23 : Introduce Parameter Object'
date: 2009-08-23T11:06:49+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/23/refactoring-day-23-introduce-parameter-object.aspx
dsq_thread_id:
  - "262354826"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/08/23/refactoring-day-23-introduce-parameter-object.aspx/"
---
This refactoring comes from Fowler’s refactoring catalog and can be <a href="http://refactoring.com/catalog/introduceParameterObject.html" target="_blank">found here</a>

Sometimes when working with a method that needs several parameters it becomes difficult to read the method signature because of five or more parameters being passed to the method like so:

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
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Create(<span class="kwrd">decimal</span> amount, Student student, IEnumerable&lt;Course&gt; courses,</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   4:</span>         <span class="kwrd">decimal</span> credits)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   5:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   6:</span>         <span class="rem">// do work</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   7:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   8:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        In this instances it’s useful to create a class who’s only responsibility is to carry parameters into the method. This helps make the code more flexible because to add more parameters, you need only to add another field to the parameter object. Be careful to only use this refactoring when you find that you have a large number of parameters to pass to the method however as it does add several more classes to your codebase and should be kept to a minimum.
      </p>
      
      <div class="csharpcode-wrapper">
        <div class="csharpcode">
          <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> RegistrationContext</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> Amount { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   4:</span>     <span class="kwrd">public</span> Student Student { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> IEnumerable&lt;Course&gt; Courses { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   6:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> Credits { get; set; }</pre>
          
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
          
          <pre><span class="lnum">   9:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Registration</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  10:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  11:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Create(RegistrationContext registrationContext)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  12:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  13:</span>         <span class="rem">// do work</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  14:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  15:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              <em><span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span></em>
            </p>