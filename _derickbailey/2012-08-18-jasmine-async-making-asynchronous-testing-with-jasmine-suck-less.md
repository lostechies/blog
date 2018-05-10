---
wordpress_id: 982
title: 'Jasmine.Async: Making Asynchronous Testing With Jasmine Suck Less'
date: 2012-08-18T13:54:44+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=982
dsq_thread_id:
  - "810302712"
categories:
  - Async
  - Jasmine
  - jasmine-async
  - JavaScript
  - Unit Testing
---
I love [Jasmine](http://pivotal.github.com/jasmine/). It&#8217;s a great BDD-style testing framework for browser based JavaScript, and my preferred tool for doing that kind of work. But the asynchronous testing story in Jasmine is painful at best.

## Jasmine&#8217;s Async Is Painful

Here&#8217;s a short example of how you make Jasmine work with asynchronous JavaScript:

{% gist 3389343 1.js %}

This isn&#8217;t fun. That &#8220;runs&#8221; and &#8220;waitsFor&#8221; code gets repeated all over the place &#8211; every time you need to wait for something async to complete. By contrast, look at [my previous post on asynchronous testing with Mocha](https://lostechies.com/derickbailey/2012/08/17/asynchronous-unit-tests-with-mocha-promises-and-winjs/). That simple little &#8220;done&#8221; function in the beforeEach and it callbacks is so easy to work with. Just add the parameter to the callback, and call &#8220;done()&#8221; when the async code has completed.

I want Jasmine to work this way, too, because there are things I like about Jasmine vs Mocha and when I use Jasmine, I don&#8217;t want to be stuck with horrible async tests. Thus, [Jasmine.Async](https://github.com/derickbailey/jasmine.async) was born out of frustration and little bit of jealousy in how easy it is to do async tests with [Mocha](http://visionmedia.github.com/mocha/).

## Jasmine.Async

To use [Jasmine.Async](https://github.com/derickbailey/jasmine.async), you need to include the jasmine.async.js file in your test suite. In your &#8220;describe&#8221; functions, create a new instance of the &#8220;AsyncSpec&#8221; object and pass in the current context (&#8220;this&#8221;). Now instead of calling &#8220;beforeEach&#8221;, you can call &#8220;async.beforeEach&#8221; which gives you a &#8220;done&#8221; parameter in the callback function, like Mocha does.

{% gist id=3389343 2.js %}

There&#8217;s an &#8220;async.beforeEach&#8221;, &#8220;async.afterEach&#8221; and &#8220;async.it&#8221; &#8211; all of which are given the &#8220;done&#8221; callback. This is so much more clean and easy to understand now. 

So go grab [Jasmine.Async](https://github.com/derickbailey/jasmine.async) and make your async tests suck less. 
