---
wordpress_id: 4100
title: Our Ajax Conventions–Clientside Continuations
date: 2012-01-06T14:00:26+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=136
dsq_thread_id:
  - "529011319"
categories:
  - general
tags:
  - ajax
  - conventions
  - fubumvc
  - jquery-continuations
---
As I mentioned in [my previous post](http://lostechies.com/josharnold/2012/01/06/our-ajax-conventions-the-ajaxcontinuation/), I’m doing a write up of our AJAX conventions and how they’re paying off for us.

In this series of posts, I’m going to cover a few topics:

  1. [The AjaxContinuation](http://lostechies.com/josharnold/2012/01/06/our-ajax-conventions-the-ajaxcontinuation/)
  2. Clientside Continuations (this post)
  3. [Request Correlation](http://lostechies.com/josharnold/2012/01/07/our-ajax-conventionsrequest-correlation/)
  4. [Validation](http://lostechies.com/josharnold/2012/01/08/our-ajax-conventionsvalidation/)

## $.continuations

I have not had time to make this code public yet, but I promise I’ll get around to it. In the meantime, I’ll explain the concepts and just gist the highlights.

> Update:
  
> I&#8217;ve released an initial v0.1 version of this called [jQuery.continuations](https://github.com/DarthFubuMVC/jquery-continuations).

### The Setup

We start by hooking into jQuery’s global $.ajaxSetup call:



> This is happening within a module block so the “self” is something I’ve declared above this piece of code.

Our convention is that unless you explicitly provide a success callback to any $.ajax call, you’re going to get this one for free.

### Processing Continuations

I’ve talked about [policies](http://lostechies.com/josharnold/2011/07/09/patterns-of-compositional-architecture-policies/) before and that’s exactly what we’re using to process the continuations. We have two functions: 1) matches(continuation) and 2) execute(continuation). Policies are registered via: $.continuations.applyPolicy() and we have several defaults.

**refreshPolicy
  
** _Matches when refresh is true._
  
Simply refreshes the page.

**navigatePolicy
  
** _Matches when url is not empty_
  
Navigate the window to the specified url.

**errorPolicy
  
** _Matches when success is false and there are errors_
  
Publishes the ‘ContinuationError’ topic through amplifyjs

**payloadPolicy
  
** _Matches when the following properties exist: payload, topic_
  
Publishes the specified topic and payload through amplifyjs

> We have a couple more but I’ll save those for the next post.

**Fun Fact**

The payloadPolicy is an interesting one. We knew that we were going to be working w/ websockets but we didn’t start with them. Instead, we used this infrastructure and simply shoved topics/payloads into our continuations. When a response was received, the information was published through amplify and we had structured our code to work against those topics.

When it came time to turn on websockets, we simply started publishing websocket messages through amplify and everything kept working like a charm.

Until next time.