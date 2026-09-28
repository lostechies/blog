---
wordpress_id: 1126
title: 'JavaScript&#8217;s &#8220;super&#8221; Pattern'
date: 2013-08-05T07:00:44+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1126
dsq_thread_id:
  - "1572078599"
categories:
  - Backbone
  - JavaScript
  - Principles and Patterns
  - Prototypal Inheritance
---
Most other languages make it easy to call the &#8220;super&#8221; function when you override method &#8211; to call the original method that you are overriding. JavaScript, unfortunately, doesn&#8217;t have a &#8220;super&#8221; or &#8220;base&#8221; or anything like that at this point.There are ways around this, though, all of which involve getting a reference to the prototype of your type, and calling the method directly.

## The Super Pattern

The &#8220;super-method&#8221; pattern is where you call the parent type&#8217;s method from your own method. For example, overriding the `toJSON` method of a model:

<div class="highlight">
  <pre><span class="kd">var</span> <span class="nx">MyModel</span> <span class="o">=</span> <span class="nx">Backbone</span><span class="p">.</span><span class="nx">Model</span><span class="p">.</span><span class="nx">extend</span><span class="p">({</span>

  <span class="c1">// a super-method</span>
  <span class="nx">toJSON</span><span class="o">:</span> <span class="kd">function</span><span class="p">(){</span>

    <span class="c1">// call the "super" method - </span>
    <span class="c1">// the original, being overriden</span>
    <span class="kd">var</span> <span class="nx">json</span> <span class="o">=</span> <span class="nx">Backbone</span><span class="p">.</span><span class="nx">Model</span><span class="p">.</span><span class="nx">prototype</span><span class="p">.</span><span class="nx">toJSON</span><span class="p">.</span><span class="nx">call</span><span class="p">(<span class="nx">this</span>);
</span>
    <span class="c1">// manipulate the json here</span>
    <span class="k">return</span> <span class="nx">json</span><span class="p">;</span>
  <span class="p">}</span>
<span class="p">});</span></pre>
</div>

This will call the `toJSON` method of the type from which the new type was extended. It&#8217;s a little more code than other languages, but it still gets the job done.

> There are a lot of different ways to get to and call the methods of a prototype object. If you&#8217;d like to learn more, check out my triple pack of screencasts covering [Scope, Context and Objects & Prototypes](http://www.watchmecode.net/javascript-fundamentals).
> 
> Also be sure to check out my [Building Backbone Plugins e-book](http://backboneplugins.com), from which this post was taken.