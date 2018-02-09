---
wordpress_id: 3195
title: 'Refactoring Day 1 : Encapsulate Collection'
date: 2009-08-02T06:04:38+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/02/refactoring-day-1-encapsulate-collection.aspx
dsq_thread_id:
  - "262346114"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/08/02/refactoring-day-1-encapsulate-collection.aspx/"
---
In certain scenarios it is beneficial to not expose a full collection to consumers of a class. Some of these circumstances is when there is additional logic associated with adding/removing items from a collection. Because of this reason, it is a good idea to only expose the collection as something you can iterate over without modifying the collection. Let’s take a look at some code 

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Order</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">private</span> List&lt;OrderLine&gt; _orderLines;</pre>
    
    <pre><span class="lnum">   4:</span>&#160; </pre>
    
    <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> IEnumerable&lt;OrderLine&gt; OrderLines</pre>
    
    <pre><span class="lnum">   6:</span>     {</pre>
    
    <pre><span class="lnum">   7:</span>         get { <span class="kwrd">return</span> _orderLines; }</pre>
    
    <pre><span class="lnum">   8:</span>     }</pre>
    
    <pre><span class="lnum">   9:</span>&#160; </pre>
    
    <pre><span class="lnum">  10:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> AddOrderLine(OrderLine orderLine)</pre>
    
    <pre><span class="lnum">  11:</span>     {</pre>
    
    <pre><span class="lnum">  12:</span>         _orderTotal += orderLine.Total;</pre>
    
    <pre><span class="lnum">  13:</span>         _orderLines.Add(orderLine);</pre>
    
    <pre><span class="lnum">  14:</span>     }</pre>
    
    <pre><span class="lnum">  15:</span>&#160; </pre>
    
    <pre><span class="lnum">  16:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> RemoveOrderLine(OrderLine orderLine)</pre>
    
    <pre><span class="lnum">  17:</span>     {</pre>
    
    <pre><span class="lnum">  18:</span>         orderLine = _orderLines.Find(o =&gt; o == orderLine);</pre>
    
    <pre><span class="lnum">  19:</span>         <span class="kwrd">if</span> (orderLine == <span class="kwrd">null</span>) <span class="kwrd">return</span>;</pre>
    
    <pre><span class="lnum">  20:</span>&#160; </pre>
    
    <pre><span class="lnum">  21:</span>         _orderTotal -= orderLine.Total</pre>
    
    <pre><span class="lnum">  22:</span>         _orderLines.Remove(orderLine);</pre>
    
    <pre><span class="lnum">  23:</span>     }</pre>
    
    <pre><span class="lnum">  24:</span> }</pre></p>
  </div>
</div>

&#160;

As you can see, we have encapsulated the collection as to not expose the Add/Remove methods to consumers of this class. There is some other types in the .Net framework that will produce different behavior for encapsulating a collection such as ReadOnlyCollection but they do have different caveats with each. This is a very straightforward refactoring and one worth noting. Using this can ensure that consumers do not mis-use your collection and introduce bugs into the code.

&#160;

_<font size="1">This is Day 1 of the 31 Days of Refactoring. For a full list of Refactorings please see the <a href="http://www.lostechies.com/blogs/sean_chambers/archive/2009/07/31/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</font>_