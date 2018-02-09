---
wordpress_id: 3191
title: Refactoring to Tests
date: 2009-04-20T14:55:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/04/20/refactoring-to-tests.aspx
dsq_thread_id:
  - "337309931"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/04/20/refactoring-to-tests.aspx/"
---
When presenting on TDD/Unit testing to user groups or code camps, a common question I hear is, "How can I get tests into my existing codebase?". This is often where people want to put effort when first starting with unit testing and it is a valid one, albeit a bit difficult at times.

The main reason that getting tests into legacy code is difficult is because the manner in which the code was originally written, which is code without tests. The reason that you can&#8217;t wave the testing magic wand over your code is because tightly coupled code begets hard to test code. This is not to say that ALL legacy code is hard to test, but in my experience this is often the case. There are a few techniques for getting unit tests into legacy code depending on the circumstances that I will go over in this post.

**Unit/Integration/Functional testing**

First and foremost it is important to distinguish between unit/integration and functional testing. A common mistake I see newcomers make is to only write one type of tests, usually integration tests which is fine and good, but you&#8217;re not really getting the most bang for your buck from testing with only integration tests or only unit tests.

Unit testing is defined on wikipedia as: "A unit is the smallest testable part of an application". The idea here is to isolate an inidividual piece of funtionality and remove all dependencies on other classes so that you can test it in isolation. To accomplish proper isolation you can use <a href="http://en.wikipedia.org/wiki/Mock_object" target="_blank">Mocks/Fakes</a> to "mock" out the surrounding dependencies that will narrow the scope of your test to one piece of functionality. Now that we have covered this topic, let&#8217;s look some examples.

**Tight coupling hell**

Here is an example of a class you may find in a legacy codebase that you are trying to get under test:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Employee</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">private</span> IDictionary&lt;<span class="kwrd">int</span>, <span class="kwrd">decimal</span>&gt; _checkAmounts;</pre>
    
    <pre><span class="lnum">   4:</span>&#160; </pre>
    
    <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> <span class="kwrd">string</span> Fullname { get; set; }</pre>
    
    <pre><span class="lnum">   6:</span>&#160; </pre>
    
    <pre><span class="lnum">   7:</span>     <span class="kwrd">public</span> Employee()</pre>
    
    <pre><span class="lnum">   8:</span>     {</pre>
    
    <pre><span class="lnum">   9:</span>         _checkAmounts = <span class="kwrd">new</span> Dictionary&lt;<span class="kwrd">int</span>, <span class="kwrd">decimal</span>&gt;();</pre>
    
    <pre><span class="lnum">  10:</span>     }</pre>
    
    <pre><span class="lnum">  11:</span>&#160; </pre>
    
    <pre><span class="lnum">  12:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Pay(<span class="kwrd">decimal</span> checkAmount)</pre>
    
    <pre><span class="lnum">  13:</span>     {</pre>
    
    <pre><span class="lnum">  14:</span>         <span class="kwrd">int</span> nextCheckNumber = DatabaseProvider.GetNextCheckNumber();</pre>
    
    <pre><span class="lnum">  15:</span>         _checkAmounts.Add(nextCheckNumber, checkAmount);</pre>
    
    <pre><span class="lnum">  16:</span>&#160; </pre>
    
    <pre><span class="lnum">  17:</span>         <span class="rem">// Log the payment to an auditing log</span></pre>
    
    <pre><span class="lnum">  18:</span>         LogAudit(nextCheckNumber, checkAmount);</pre>
    
    <pre><span class="lnum">  19:</span>     }</pre>
    
    <pre><span class="lnum">  20:</span>&#160; </pre>
    
    <pre><span class="lnum">  21:</span>     <span class="kwrd">private</span> <span class="kwrd">void</span> LogAudit(<span class="kwrd">int</span> nextCheckNumber, <span class="kwrd">decimal</span> checkAmount)</pre>
    
    <pre><span class="lnum">  22:</span>     {</pre>
    
    <pre><span class="lnum">  23:</span>         <span class="kwrd">using</span> (StreamWriter streamWriter = File.AppendText(<span class="str">"paymentaudit.log"</span>))</pre>
    
    <pre><span class="lnum">  24:</span>         {</pre>
    
    <pre><span class="lnum">  25:</span>             streamWriter.WriteLine(<span class="kwrd">string</span>.Format(<span class="str">"Check Number:{0} ${1}, {2}"</span>, nextCheckNumber, checkAmount, Fullname));</pre>
    
    <pre><span class="lnum">  26:</span>         }</pre>
    
    <pre><span class="lnum">  27:</span>     }</pre>
    
    <pre><span class="lnum">  28:</span> }</pre></p>
  </div>
</div>

&#160;

This is a pretty contrived example but it will serve our purpose well. This class is violating the Single Responsibility Principle by doing a couple of different things. Notice that the Employee class is not only in charge of paying an employee but also handles writing out auditing entries to a log file on the file system. For this reason (among others that we will get to shortly), this class is unable to be unit tested properly. This leads to my next point about some unit testing rules.

When doing Unit Testing, there are some simple rules you should follow:

  1. Do not touch files on the file system
  2. Do not touch a database that requires a connection
  3. Do not touch configuration files on the filesystem

These rules are only off the top of my head and are up for debate. Tests that fall into the 3 rules above should be treated as integration tests because they are touching areas that will drastically slow down your tests. Slow/Long running tests should be run by a continuous integration server or on your local dev machine infrequently. Unit tests are meant to be blazing fast. The slower they run, the less likely developers are going to run them on an ongoing basis.

The key to getting legacy code like the above sample under test is to create seams in your code. Once