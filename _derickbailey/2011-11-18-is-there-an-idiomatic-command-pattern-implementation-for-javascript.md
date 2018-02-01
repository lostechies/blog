---
id: 677
title: Is There An Idiomatic Command Pattern Implementation For JavaScript?
date: 2011-11-18T14:31:21+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=677
dsq_thread_id:
  - "476649713"
categories:
  - Backbone
  - Design Patterns
  - JavaScript
  - Principles and Patterns
---
I&#8217;ve been looking for a JavaScript Command Pattern implementation for a while now. If you google that term (or click that link) you&#8217;ll find a handful or more, that I simply don&#8217;t like. Granted, the implementations that I&#8217;ve found do work, but there&#8217;s always something about them that bothers me and makes me scream &#8220;NOOOO!!!!!!&#8221;.

So I&#8217;m wondering: is there a truly idiomatic JavaScript command pattern implementation available anywhere? Or do I just need to write my own?

In case there isn&#8217;t, [I whipped up a simple stupid version of what it might look like if I were going to build one](http://jsfiddle.net/derickbailey/HsDNG/), in JSFiddle:



(Click on the link if you&#8217;re in an RSS reader)

You can see the code is simple, as I think it should be. Run the &#8216;Result&#8217; tab if you&#8217;re reading this in the browser. Enter some text and click the &#8220;Say It&#8221; button. It does nothing more than show the text you entered. The point is not what it makes the app do, but how it does it. This provides a decoupled command pattern implementation, using JavaScript idioms like callback functions and key-value/hash/json objects to store registrations and all that jazz.

Of course there&#8217;s a lot missing from this code (like unregistering a command handler) and the core of this code is a very simple, stupid, single handler version of what&#8217;s already available in the [Backbone.Events](http://documentcloud.github.com/backbone/docs/backbone.html#section-12) code &#8211; just with different semantics in the names of the methods.

So I ask &#8211; is there a good, idiomatic JavaScript implementation of a command pattern? One that allows proper decoupling of the command handler, command message and calling for the command to be executed? One that doesn&#8217;t rely on adding &#8220;class&#8221; semantics to JavaScript? One that doesn&#8217;t couple the name of the method being called as a command directly to the calling of the command (srsly… how could that even be called a command pattern?)?

Please let me know via the comments before I continue down the path of rebuilding something that I should be looking at / using.