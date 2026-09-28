---
wordpress_id: 3218
title: 'Refactoring Day 24 : Remove Arrowhead Antipattern'
date: 2009-08-24T12:00:39+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/24/refactoring-day-24-remove-arrowhead-antipattern.aspx
dsq_thread_id:
  - "262182271"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/08/24/refactoring-day-24-remove-arrowhead-antipattern.aspx/"
---
Today’s refactoring is based on the c2 wiki entry and can be <a href="http://c2.com/cgi/wiki?ArrowAntiPattern" target="_blank">found here</a>. Los Techies own Chris Missal also did a very informative post on the antipattern that you can <a href="https://lostechies.com/blogs/chrismissal/archive/2009/05/27/anti-patterns-and-worst-practices-the-arrowhead-anti-pattern.aspx" target="_blank">find here</a>.

Simply put, the arrowhead antipattern is when you have nested conditionals so deep that they form an arrowhead of code. I see this very often in different code bases and it makes for high <a href="http://en.wikipedia.org/wiki/Cyclomatic_complexity" target="_blank">cyclomatic complexity</a> in code.

A good example of the arrowhead antipattern can be found in this sample here:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Security</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> ISecurityChecker SecurityChecker { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   4:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> Security(ISecurityChecker securityChecker)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   6:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   7:</span>         SecurityChecker = securityChecker;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   8:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   9:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  10:</span>     <span class="kwrd">public</span> <span class="kwrd">bool</span> HasAccess(User user, Permission permission, IEnumerable&lt;Permission&gt; exemptions)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  11:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  12:</span>         <span class="kwrd">bool</span> hasPermission = <span class="kwrd">false</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  13:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  14:</span>         <span class="kwrd">if</span> (user != <span class="kwrd">null</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  15:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  16:</span>             <span class="kwrd">if</span> (permission != <span class="kwrd">null</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  17:</span>             {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  18:</span>                 <span class="kwrd">if</span> (exemptions.Count() == 0)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  19:</span>                 {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  20:</span>                     <span class="kwrd">if</span> (SecurityChecker.CheckPermission(user, permission) || exemptions.Contains(permission))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  21:</span>                     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  22:</span>                         hasPermission = <span class="kwrd">true</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  23:</span>                     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  24:</span>                 }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  25:</span>             }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  26:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  27:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  28:</span>         <span class="kwrd">return</span> hasPermission;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  29:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  30:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        Refactoring away from the arrowhead antipattern is as simple as swapping the conditionals to leave the method as soon as possible. Refactoring in this manner often starts to look like Design By Contract checks to evaluate conditions before performing the work of the method. Here is what this same method might look like after refactoring.
      </p>
      
      <div class="csharpcode-wrapper">
        <div class="csharpcode">
          <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Security</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> ISecurityChecker SecurityChecker { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   4:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> Security(ISecurityChecker securityChecker)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   6:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   7:</span>         SecurityChecker = securityChecker;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   8:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   9:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  10:</span>     <span class="kwrd">public</span> <span class="kwrd">bool</span> HasAccess(User user, Permission permission, IEnumerable&lt;Permission&gt; exemptions)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  11:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  12:</span>         <span class="kwrd">if</span> (user == <span class="kwrd">null</span> || permission == <span class="kwrd">null</span>)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  13:</span>             <span class="kwrd">return</span> <span class="kwrd">false</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  14:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  15:</span>         <span class="kwrd">if</span> (exemptions.Contains(permission))</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  16:</span>             <span class="kwrd">return</span> <span class="kwrd">true</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  17:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  18:</span>         <span class="kwrd">return</span> SecurityChecker.CheckPermission(user, permission);</pre>
          
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
              As you can see, this method is much more readable and maintainable going forward. It’s not as difficult to see all the different paths you can take through this method.
            </p>
            
            <p>
              <em><span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span></em>
            </p>