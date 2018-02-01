---
id: 3209
title: 'Refactoring Day 15 : Remove Duplication'
date: 2009-08-15T10:29:00+00:00
author: Sean Chambers
layout: post
guid: /blogs/sean_chambers/archive/2009/08/15/refactoring-day-15-remove-duplication.aspx
dsq_thread_id:
  - "262352391"
categories:
  - Uncategorized
---
A day late on this one. Sorry about that!

This is probably one of the most used refactoring in the forms of methods that are used in more than one place. Duplication will quickly sneak up on you if you&rsquo;re not careful and give in to apathy. It is often added to the codebase through laziness or a developer that is trying to produce as much code as possible, as quickly as possible. I don&rsquo;t think we need anymore description so let&rsquo;s look at the code. 

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> MedicalRecord</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> DateTime DateArchived { get; <span class="kwrd">private</span> set; }</pre>
    
    <pre><span class="lnum">   4:</span>     <span class="kwrd">public</span> <span class="kwrd">bool</span> Archived { get; <span class="kwrd">private</span> set; }</pre>
    
    <pre><span class="lnum">   5:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   6:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> ArchiveRecord()</pre>
    
    <pre><span class="lnum">   7:</span>     {</pre>
    
    <pre><span class="lnum">   8:</span>         Archived = <span class="kwrd">true</span>;</pre>
    
    <pre><span class="lnum">   9:</span>         DateArchived = DateTime.Now;</pre>
    
    <pre><span class="lnum">  10:</span>     }</pre>
    
    <pre><span class="lnum">  11:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  12:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> CloseRecord()</pre>
    
    <pre><span class="lnum">  13:</span>     {</pre>
    
    <pre><span class="lnum">  14:</span>         Archived = <span class="kwrd">true</span>;</pre>
    
    <pre><span class="lnum">  15:</span>         DateArchived = DateTime.Now;</pre>
    
    <pre><span class="lnum">  16:</span>     }</pre>
    
    <pre><span class="lnum">  17:</span> }</pre>
  </div>
</div>

We move the duplicated code to a shared method and voila! No more duplication. Please enforce this refactoring whenever possible. It leads to much fewer bugs because you aren&rsquo;t copy/pasting the bugs throughout the code.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> MedicalRecord</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> DateTime DateArchived { get; <span class="kwrd">private</span> set; }</pre>
    
    <pre><span class="lnum">   4:</span>     <span class="kwrd">public</span> <span class="kwrd">bool</span> Archived { get; <span class="kwrd">private</span> set; }</pre>
    
    <pre><span class="lnum">   5:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   6:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> ArchiveRecord()</pre>
    
    <pre><span class="lnum">   7:</span>     {</pre>
    
    <pre><span class="lnum">   8:</span>         SwitchToArchived();</pre>
    
    <pre><span class="lnum">   9:</span>     }</pre>
    
    <pre><span class="lnum">  10:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  11:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> CloseRecord()</pre>
    
    <pre><span class="lnum">  12:</span>     {</pre>
    
    <pre><span class="lnum">  13:</span>         SwitchToArchived();</pre>
    
    <pre><span class="lnum">  14:</span>     }</pre>
    
    <pre><span class="lnum">  15:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  16:</span>     <span class="kwrd">private</span> <span class="kwrd">void</span> SwitchToArchived()</pre>
    
    <pre><span class="lnum">  17:</span>     {</pre>
    
    <pre><span class="lnum">  18:</span>         Archived = <span class="kwrd">true</span>;</pre>
    
    <pre><span class="lnum">  19:</span>         DateArchived = DateTime.Now;</pre>
    
    <pre><span class="lnum">  20:</span>     }</pre>
    
    <pre><span class="lnum">  21:</span> }</pre>
  </div>
</div>

_<span style="font-size: xx-small"></span>_

_<span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span>_