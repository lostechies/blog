---
id: 143
title: Our Ajax Conventions–Request Correlation
date: 2012-01-07T04:23:41+00:00
author: Josh Arnold
layout: post
guid: http://lostechies.com/josharnold/?p=143
dsq_thread_id:
  - "529875237"
categories:
  - general
tags:
  - ajax
  - conventions
  - fubumvc
  - jquery-continuations
---
As I mentioned in [my previous posts](http://lostechies.com/josharnold/2012/01/06/our-ajax-conventions-the-ajaxcontinuation/), I’m doing a write up of our AJAX conventions and how they’re paying off for us.

In this series of posts, I’m going to cover a few topics:

  1. [The AjaxContinuation](http://lostechies.com/josharnold/2012/01/06/our-ajax-conventions-the-ajaxcontinuation/)
  2. [Clientside Continuations](http://lostechies.com/josharnold/2012/01/06/our-ajax-conventionsclientside-continuations/)
  3. Request Correlation (this post)
  4. [Validation](http://lostechies.com/josharnold/2012/01/08/our-ajax-conventionsvalidation/)

## Correlating your requests

This isn’t a new thing. If you’ve ever dealt with messaging, then you’ve most certainly dealt with the concept. It’s nothing different with the web. But first, let me just answer…

### Why?

Why would you want to be able to identify the response for a given request? Here are two that stood out for me:

1. Keeping track of outstanding requests

There’s this fun thing that you run into when you’re doing automated UI testing and it’s called “waiting”. You wait for elements to be shown – sometimes intelligently or blindly (Thread.Sleep – gah). If you’re able to track your pending requests, you can be a little smarter about waiting for operations to complete.

2. Knowing which form made a request

This is an interesting one. When I know which form was a responsible for a given request, I can handle validation much easier and have more fun with conventions (like closing a dialog).

### How it works

When a request is initiated, jquery.continuations appends a custom header: X-Correlation-Id. This value originates from one of two sources: 1) randomly assigned for a request 2) the id of the form responsible for the request.

It’s up to your web framework to handle shoving the header back into the response. Here’s an example of doing it in FubuMVC:



Assuming that you are sending the header back down through your response, jquery.continuations handles it from there by doing two things:

1) The AjaxCompleted topic

This topic is published through the jquery.continuations event aggregator façade (we use amplify). The message that is published contains a correlationId property with the appropriate value.

2) The continuation processing pipeline

Before the continuation is processed, the correlationId property is set.

## Simple usage

I always understand best by seeing some code. Here’s an example of how to keep track of pending requests:



Until next time.