---
id: 872
title: 'JavaScript Performance: Pre-Compiling And Caching HTML Templates'
date: 2012-04-10T07:33:11+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=872
dsq_thread_id:
  - "643508719"
categories:
  - Backbone
  - DOM
  - JavaScript
  - JQuery
  - Marionette
  - Performance
---
If you&#8217;re using HTML templates with a JavaScript application, you need to be caching the template&#8217;s raw text and/or pre-compiled version of the template. All of this spawned from a fun thread of discussion on [a StackOverflow question](http://stackoverflow.com/questions/9833312/how-do-i-properly-store-a-javascript-template-so-that-it-isnt-instantiated-mul/).

## DOM Selection Is Expensive

If you didn&#8217;t know this already, DOM selection is expensive. So expensive, in fact, that it should be avoided whenever possible. Of course avoiding it entirely is not likely as we need DOM selection to handle events, update the UI, and more. There&#8217;s a huge performance impact on having to constantly select a <script> tag from the DOM when you need a template, though. See [this JSPerf that I wrote](http://jsperf.com/dom-select-vs-cache) which illustrates the difference.

<img title="Screen Shot 2012-03-28 at 9.35.57 PM.png" src="http://lostechies.com/derickbailey/files/2012/03/Screen-Shot-2012-03-28-at-9.35.57-PM.png" border="0" alt="Screen Shot 2012 03 28 at 9 35 57 PM" width="600" height="337" />

If you&#8217;re storing templates in a script tag, don&#8217;t access that DOM element more than once. After all, you&#8217;re not expecting the contents of the template to change. Only the data that is rendered in to the template changes.

## Simple Template Caching

The easiest way of storing a template is to use the DOM selector as a key, and the template contents as a value. Check for the existence of that key on an object, and if it exists use that. If it doesn&#8217;t exist, load it:

[gist id=2232998 file=1.js]

## Pre-Compile Templates

One of the commenters in the thread of discussion liked the test I put together but thought it could be done better, still. He updated it to show [cached vs non-cached and pre-compiled vs non-pre-compiled templates](http://jsperf.com/dom-select-vs-cache/2).

<img title="Screen Shot 2012-03-28 at 10.02.37 PM.png" src="http://lostechies.com/derickbailey/files/2012/03/Screen-Shot-2012-03-28-at-10.02.37-PM.png" border="0" alt="Screen Shot 2012 03 28 at 10 02 37 PM" width="600" height="306" />

Clearly, pre-compiling your templates is important. So let&#8217;s update our TemplateCache to pre-compile the templates for us (assuming we&#8217;re using underscore.js):

[gist id=2232998 file=2.js]

## Template Cache Built In To Backbone.Marionette

Of course you saw this part coming, right? I&#8217;ve got a much more robust version of the above template caching already available in [Backbone.Marionette](https://github.com/derickbailey/backbone.marionette). It defaults to using underscore.js as it&#8217;s template engine, but that&#8217;s really easy to change. See the documentation for some [examples on how to do that](http://derickbailey.github.com/backbone.marionette/#backbone-marionette-renderer/caching-pre-compiled-templates).

But even if you&#8217;re not using Backbone or Backbone.Marionette, you need to take advantage of the performance improvements that your application will see, by only selecting something from the DOM once, and by pre-compiling and caching any templates that you&#8217;re using.