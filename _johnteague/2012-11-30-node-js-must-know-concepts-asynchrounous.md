---
wordpress_id: 121
title: 'Node.js Must Know Concepts: Asynchronous'
date: 2012-11-30T14:35:23+00:00
author: John Teague
layout: post
wordpress_guid: http://lostechies.com/johnteague/?p=121
dsq_thread_id:
  - "951513841"
categories:
  - JavaScript
  - NodeJS
  - Uncategorized
---
When writing node applications, there are a few concepts that are important to understand in order to create large-scale applications. I&#8217;m going to cover a few concepts that I think are important when building non-trivial sites with node.js.  If you have suggestions of other important topics or concepts, or areas you are struggling with, let me know and I&#8217;ll try to cover them as well.

## It&#8217;s asynchronous, duh

If you&#8217;ve done anything or read anything with node.js, I&#8217;m sure you are aware that it is built on an event-driven, asynchronous model. It&#8217;s one of the first things you have to come to grips with if you are building anything substantial. Because node.js applications are single threaded, it&#8217;s very important that you keep to the asynchronous model. When you do, your apps will be amazingly fast and responsive. If you don&#8217;t, you&#8217;re application will slow to a crawl. Let&#8217;s take the simplest web server example:

{% gist 4155095 file=webserver.js %}

This code is running on a single thread, waiting for a web request. When a web request, comes in you want to pass the work off to an asynchronous callback handler, freeing the main thread to respond to more requests. If you block the main event loop, then no more requests will processed until it completes.

It can take a while to get used to this model, especially coming from a blocking or multi-threaded paradigm, which uses a different approach for concurrency. The first time I ran into this was building the Austin code camp site. To save the results from the form, I abstracted the work into a separate function. on the request handler, I called the save function, then returned the response.

{% gist 4155095 file=no-continuation.js %}

But I forgot that the work to save the data, was done asynchronously, so my output log looked like this:

calling save returning response saving the data

Because the work to save the data was done asynchronously, I sent the response was sent before the data was actually saved. (Keep in mind, this is not always a bad thing, like saving a log statement, but not waiting to see if it completes or not.) What I needed to do was use a continuation model, and pass in a callback that completes the html request, when the request to save the data completes, or sends back an error.

{% gist 4155095 file=save-with-continuation.js %}

&nbsp;

It can take a while to get used to the continuation model, and it can get really messy when you need to complete several operations before completing a request. There are a [lot](https://npmjs.org/package/async) [of](https://npmjs.org/package/q) [workflow modules](https://github.com/joyent/node/wiki/Modules#wiki-async-flow) that you can use to make this easier. It&#8217;s also relatively simple to build your own. In fact it&#8217;s practically a rite of passage that a lot of node developers do.  It&#8217;s also possible to abstract this by using EventEmitters, which we&#8217;ll discuss in a later topic.

&nbsp;