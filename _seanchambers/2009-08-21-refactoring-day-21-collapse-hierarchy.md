---
wordpress_id: 3215
title: 'Refactoring Day 21 : Collapse Hierarchy'
date: 2009-08-21T12:23:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/21/refactoring-day-21-collapse-hierarchy.aspx
dsq_thread_id:
  - "262353913"
categories:
  - Uncategorized
---
Todays refactoring comes from Martin Fowlers catalog of patterns. You can find this refactoring in his <a target="_blank" href="http://refactoring.com/catalog/collapseHierarchy.html">catalog here</a>

Yesterday we looked at extracting a subclass for moving responsibilities down if they are not needed across the board. A Collapse Hierarchy refactoring would be applied when you realize you no longer need a subclass. When this happens it doesn&rsquo;t really make sense to keep your subclass around if it&rsquo;s properties can be merged into the base class and used strictly from there.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Website</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">string</span> Title { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   4:</span>     <span class="kwrd">public</span> <span class="kwrd">string</span> Description { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> IEnumerable&lt;Webpage&gt; Pages { get; set; }</pre>
    
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
    
    <pre><span class="lnum">   8:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> StudentWebsite : Website</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   9:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  10:</span>     <span class="kwrd">public</span> <span class="kwrd">bool</span> IsActive { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  11:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        Here we have a subclass that isn&rsquo;t doing too much. It just has one property to denote if the site is active or not. At this point maybe we realize that determing if a site is active is something we can use across the board so we can collapse the hierarchy back into only a Website and eliminate the StudentWebsite type.
      </p>
      
      <div class="csharpcode-wrapper">
        <div class="csharpcode">
          <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Website</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">string</span> Title { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   4:</span>     <span class="kwrd">public</span> <span class="kwrd">string</span> Description { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> IEnumerable&lt;Webpage&gt; Pages { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   6:</span>     <span class="kwrd">public</span> <span class="kwrd">bool</span> IsActive { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   7:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              <em><span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a target="_blank" href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx">original introductory post</a>.</span></em>
            </p>