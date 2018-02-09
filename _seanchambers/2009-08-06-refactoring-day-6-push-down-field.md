---
wordpress_id: 3200
title: 'Refactoring Day 6 : Push Down Field'
date: 2009-08-06T12:20:01+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/06/refactoring-day-6-push-down-field.aspx
dsq_thread_id:
  - "263160613"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/08/06/refactoring-day-6-push-down-field.aspx/"
---
Opposite of the Pull Up Field refactoring is push down field. Again, this is a pretty straight forward refactoring without much description needed

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> Task</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">protected</span> <span class="kwrd">string</span> _resolution;</pre>
    
    <pre><span class="lnum">   4:</span> }</pre>
    
    <pre><span class="lnum">   5:</span>&#160; </pre>
    
    <pre><span class="lnum">   6:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> BugTask : Task</pre>
    
    <pre><span class="lnum">   7:</span> {</pre>
    
    <pre><span class="lnum">   8:</span> }</pre>
    
    <pre><span class="lnum">   9:</span>&#160; </pre>
    
    <pre><span class="lnum">  10:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> FeatureTask : Task</pre>
    
    <pre><span class="lnum">  11:</span> {</pre>
    
    <pre><span class="lnum">  12:</span> }</pre></p>
  </div>
</div>

In this example, we have a string field that is only used by one derived class, and thus can be pushed down as no other classes are using it. It’s important to do this refactoring at the moment the base field is no longer used by other derived classes. The longer it sits the more prone it is for someone to simply not touch the field and leave it be.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> Task</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span> }</pre>
    
    <pre><span class="lnum">   4:</span>&#160; </pre>
    
    <pre><span class="lnum">   5:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> BugTask : Task</pre>
    
    <pre><span class="lnum">   6:</span> {</pre>
    
    <pre><span class="lnum">   7:</span>     <span class="kwrd">private</span> <span class="kwrd">string</span> _resolution;</pre>
    
    <pre><span class="lnum">   8:</span> }</pre>
    
    <pre><span class="lnum">   9:</span>&#160; </pre>
    
    <pre><span class="lnum">  10:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> FeatureTask : Task</pre>
    
    <pre><span class="lnum">  11:</span> {</pre>
    
    <pre><span class="lnum">  12:</span> }</pre></p>
  </div>
</div>

&#160;

_<font size="1">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="http://www.lostechies.com/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</font>_