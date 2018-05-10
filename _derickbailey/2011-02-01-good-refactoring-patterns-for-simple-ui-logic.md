---
wordpress_id: 212
title: Good Refactoring / Patterns For Simple UI Logic?
date: 2011-02-01T20:06:59+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2011/02/01/good-refactoring-patterns-for-simple-ui-logic.aspx
dsq_thread_id:
  - "262286671"
categories:
  - .NET
  - 'C#'
  - Pragmatism
  - Principles and Patterns
  - Refactoring
redirect_from: "/blogs/derickbailey/archive/2011/02/01/good-refactoring-patterns-for-simple-ui-logic.aspx/"
---
I&#8217;ve got a chunk of C# that sits inside of a very simple form. The form downloads an update from a web page &#8211; one of two possible downloads, based on which one is available &#8211; and shows a message to the user saying it&#8217;s done. The basic rules for which one to download are:

  * If a software update is available, download it, highest priority 
      * After a software update has been downloaded, exit the app immediately so an external process can unpack it
  * If a data update is available, only download it if a software update is not available 
      * After a data update has been downloaded, show the data

As this is a very small application with very simple process and no real business logic, I&#8217;ve coded the majority of it straight into the form, in a method that runs in a background worker. The code works and does everything it needs to do, but it&#8217;s getting ugly and needs some TLC to refactor it into something more manageable and easier to maintain.

> <pre><div class="highlight">
  <pre><div class="line">
  <span class="k">private</span> <span class="k">void</span> <span class="nf">DownloadUpdates</span><span class="p">()</span>
</div>

<div class="line">
  <span class="p">{</span>
</div>

<div class="line">
      <span class="k">try</span>
</div>

<div class="line">
      <span class="p">{</span>
</div>

<div class="line">
          <span class="n">SetProgress</span><span class="p">(</span><span class="m">5</span><span class="p">);</span>
</div>

<div class="line">
          <span class="n">MessageLabel</span><span class="p">.</span><span class="n">Do</span><span class="p">(</span><span class="n">ctl</span> <span class="p">=&gt;</span> <span class="n">ctl</span><span class="p">.</span><span class="n">Text</span> <span class="p">=</span> <span class="n">AvailableUpdate</span><span class="p">.</span><span class="n">DownloadingUpdateLabelText</span><span class="p">);</span>
</div>

<div class="line">
          <span class="c1">//software updates always take precedence over data updates</span>
</div>

<div class="line">
          <span class="k">if</span> <span class="p">(</span><span class="n">AvailableUpdate</span><span class="p">.</span><span class="n">SoftwareUpdateAvailable</span><span class="p">)</span>
</div>

<div class="line">
          <span class="p">{</span>
</div>

<div class="line">
              <span class="n">SetProgress</span><span class="p">(5</span><span class="m"></span><span class="p">);</span>
</div>

<div class="line">
              <span class="n">UpdateSoftware</span><span class="p">();<br />            SetProgress(100); </span>
</div>

<div class="line">
              <span class="k">this</span><span class="p">.</span><span class="n">Do</span><span class="p">(</span><span class="n">frm</span> <span class="p">=&gt;</span> <span class="n">frm</span><span class="p">.</span><span class="n">Close</span><span class="p">());</span>
</div>

<div class="line">
          <span class="p">}</span>
</div>

<div class="line">
          <span class="k">else</span>
</div>

<div class="line">
          <span class="p">{</span>
</div>

<div class="line">
              <span class="k">if</span> <span class="p">(</span><span class="n">AvailableUpdate</span><span class="p">.</span><span class="n">DataUpdateAvailable</span><span class="p">)</span>
</div>

<div class="line">
              <span class="p">{<br />                SetProgress(50) </span>
</div>

<div class="line">
                  <span class="n">UpdateData</span><span class="p">();</span>
</div>

<div class="line">
                  <span class="n">MessageLabel</span><span class="p">.</span><span class="n">Do</span><span class="p">(</span><span class="n">ctl</span> <span class="p">=&gt;</span> <span class="n">ctl</span><span class="p">.</span><span class="n">Text</span> <span class="p">=</span> <span class="s">"Complete"</span><span class="p">);</span>
</div>

<div class="line">
                  <span class="n">SetProgress</span><span class="p">(</span><span class="m">100</span><span class="p">);</span>
</div>

<div class="line">
                  <span class="n">Cancel</span><span class="p">.</span><span class="n">Do</span><span class="p">(</span><span class="n">ctl</span> <span class="p">=&gt;</span> <span class="n">ctl</span><span class="p">.</span><span class="n">Hide</span><span class="p">());</span>
</div>

<div class="line">
                  <span class="n">ContinueButton</span><span class="p">.</span><span class="n">Do</span><span class="p">(</span><span class="n">ctl</span> <span class="p">=&gt;</span> <span class="n">ctl</span><span class="p">.</span><span class="n">Show</span><span class="p">());</span>
</div>

<div class="line">
              <span class="p">}</span>
</div>

<div class="line">
          <span class="p">}</span>
</div>

<div class="line">
      <span class="p">}</span>
</div>

<div class="line">
      <span class="k">catch</span> <span class="p">(</span><span class="n">Exception</span> <span class="n">e</span><span class="p">)</span>
</div>

<div class="line">
      <span class="p">{</span>
</div>

<div class="line">
  <span class="p"><span>	</span>// error handler code here</span>
</div>

<div class="line">
      <span class="p">}</span>
</div>

<div class="line">
  }
</div></pre>
  
</div>
</blockquote>


<p>
  (Note: For a description of the .Do() method shown here, see <a href="https://lostechies.com/blogs/derickbailey/archive/2011/01/24/asynchronous-control-updates-in-c-net-winforms.aspx">my post on async control updates</a>)
</p>


<p>
  As you can see, there are a few nested if statements in here, some possible duplication, and a generally ugly mix of UI and process. In the past, I would have looked at a few basic options to remove the if statement and clean this up by moving the process into separate classes with events that tell the UI when to update with what information. Since this application is so small, I&#8217;m not sure I want to go down that path. There&#8217;s not a lot to this, honestly, other than figuring out which file to download and what to do after the download completes.
</p>


<p>
  Given all that &#8211; including the small nature of the app &#8211; what are the patterns you would move to and suggested refactorings that you would take in this situation? How would you clean up this code, reduce duplication (if it&#8217;s reasonable to do so) and make the easier to work with and maintain?
</p>


<p>
  I have several ideas, of course, but I want to see what I can learn from other people&#8217;s refactoring and clean up ideas. Post your suggestions to a code sharing site such as <a href="https://gist.github.com/">Gists</a> or <a href="http://pastie.org/">Pastie</a>, then link to them in a comment, here.
</p>


<p>
   
</p>