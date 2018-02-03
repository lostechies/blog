---
wordpress_id: 3206
title: 'Refactoring Day 12 : Break Dependencies'
date: 2009-08-12T12:15:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/12/refactoring-day-12-break-dependencies.aspx
dsq_thread_id:
  - "262350112"
categories:
  - Uncategorized
---
Today&#8217;s refactoring is useful if you are trying to introduce unit tests into your code base as testing &ldquo;seams&rdquo; are needed to properly mock/isolate areas you don&rsquo;t wish to test. In this example we have client code that is using a static class to accomplish some work. The problem with this when it comes to unit testing because there is no way to mock the static class from our unit test. To work around this you can apply a wrapper interface around the static to create a seam and break the dependency on the static.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> AnimalFeedingService</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">private</span> <span class="kwrd">bool</span> FoodBowlEmpty { get; set; }</pre>
    
    <pre><span class="lnum">   4:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Feed()</pre>
    
    <pre><span class="lnum">   6:</span>     {</pre>
    
    <pre><span class="lnum">   7:</span>         <span class="kwrd">if</span> (FoodBowlEmpty)</pre>
    
    <pre><span class="lnum">   8:</span>             Feeder.ReplenishFood();</pre>
    
    <pre><span class="lnum">   9:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  10:</span>         <span class="rem">// more code to feed the animal</span></pre>
    
    <pre><span class="lnum">  11:</span>     }</pre>
    
    <pre><span class="lnum">  12:</span> }</pre>
    
    <pre><span class="lnum">  13:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  14:</span> <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">class</span> Feeder</pre>
    
    <pre><span class="lnum">  15:</span> {</pre>
    
    <pre><span class="lnum">  16:</span>     <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">void</span> ReplenishFood()</pre>
    
    <pre><span class="lnum">  17:</span>     {</pre>
    
    <pre><span class="lnum">  18:</span>         <span class="rem">// fill up bowl</span></pre>
    
    <pre><span class="lnum">  19:</span>     }</pre>
    
    <pre><span class="lnum">  20:</span> }</pre>
  </div>
</div>

All we did to apply this refactoring was introduce an interface and class that simply calls the underlying static class. So the behavior is still the same, just the manner in which it is invoked has changed. This is good to get a starting point to begin refactoring from and an easy way to add unit tests to your code base.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> AnimalFeedingService</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> IFeederService FeederService { get; set; }</pre>
    
    <pre><span class="lnum">   4:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> AnimalFeedingService(IFeederService feederService)</pre>
    
    <pre><span class="lnum">   6:</span>     {</pre>
    
    <pre><span class="lnum">   7:</span>         FeederService = feederService;</pre>
    
    <pre><span class="lnum">   8:</span>     }</pre>
    
    <pre><span class="lnum">   9:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  10:</span>     <span class="kwrd">private</span> <span class="kwrd">bool</span> FoodBowlEmpty { get; set; }</pre>
    
    <pre><span class="lnum">  11:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  12:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Feed()</pre>
    
    <pre><span class="lnum">  13:</span>     {</pre>
    
    <pre><span class="lnum">  14:</span>         <span class="kwrd">if</span> (FoodBowlEmpty)</pre>
    
    <pre><span class="lnum">  15:</span>             FeederService.ReplenishFood();</pre>
    
    <pre><span class="lnum">  16:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  17:</span>         <span class="rem">// more code to feed the animal</span></pre>
    
    <pre><span class="lnum">  18:</span>     }</pre>
    
    <pre><span class="lnum">  19:</span> }</pre>
    
    <pre><span class="lnum">  20:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  21:</span> <span class="kwrd">public</span> <span class="kwrd">interface</span> IFeederService</pre>
    
    <pre><span class="lnum">  22:</span> {</pre>
    
    <pre><span class="lnum">  23:</span>     <span class="kwrd">void</span> ReplenishFood();</pre>
    
    <pre><span class="lnum">  24:</span> }</pre>
    
    <pre><span class="lnum">  25:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  26:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> FeederService : IFeederService</pre>
    
    <pre><span class="lnum">  27:</span> {</pre>
    
    <pre><span class="lnum">  28:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> ReplenishFood()</pre>
    
    <pre><span class="lnum">  29:</span>     {</pre>
    
    <pre><span class="lnum">  30:</span>         Feeder.ReplenishFood();</pre>
    
    <pre><span class="lnum">  31:</span>     }</pre>
    
    <pre><span class="lnum">  32:</span> }</pre>
    
    <pre><span class="lnum">  33:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  34:</span> <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">class</span> Feeder</pre>
    
    <pre><span class="lnum">  35:</span> {</pre>
    
    <pre><span class="lnum">  36:</span>     <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">void</span> ReplenishFood()</pre>
    
    <pre><span class="lnum">  37:</span>     {</pre>
    
    <pre><span class="lnum">  38:</span>         <span class="rem">// fill up bowl</span></pre>
    
    <pre><span class="lnum">  39:</span>     }</pre>
    
    <pre><span class="lnum">  40:</span> }</pre>
  </div>
</div>

We can now mock IFeederService during our unit test via the AnimalFeedingService constructor by passing in a mock of IFeederService. Later we can move the code in the static into FeederService and delete the static class completely once we have some tests in place.

<span style="font-size: xx-small"></span>

_<span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span>_