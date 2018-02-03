---
wordpress_id: 4099
title: 'Our AJAX Conventions &#8211; The AjaxContinuation'
date: 2012-01-06T08:03:29+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=133
dsq_thread_id:
  - "528698026"
categories:
  - general
tags:
  - ajax
  - conventions
  - fubumvc
  - jquery-continuations
---
My team is coming out of the “infrastructure buildup” phase enough for me to take the time to blog. So, I’m going to do a write up of how we’re handling anything and everything AJAX and how it’s paying off really fast.

> **Note:
  
>** I want to make note of one thing here. As usual, I will be using FubuMVC as an example implementation of these concepts. However, these concepts are applicable in any web framework.

In this series of posts, I’m going to cover a few topics:

  1. The AjaxContinuation (this post)
  2. [Clientside Continuations](http://lostechies.com/josharnold/2012/01/06/our-ajax-conventionsclientside-continuations/)
  3. [Request Correlation](http://lostechies.com/josharnold/2012/01/07/our-ajax-conventionsrequest-correlation/)
  4. [Validation](http://lostechies.com/josharnold/2012/01/08/our-ajax-conventionsvalidation/)

## The Ajax Continuation

Like every “convention”, you have to start with some commonality and standardize a few things. For our usage, we chose to use the standard [AjaxContinuation](https://github.com/DarthFubuMVC/fubumvc/blob/master/src/FubuMVC.Core/Ajax/AjaxContinuation.cs) in FubuMVC. Here’s a JSON representation:



> Nothing too fancy here but this is just the baseline. The point is that while there may be additional properties specified on a particular instance, the properties above will always be there. 

Let’s run through each of the properties:

**success**
   
_Type: bool_
   
Flag indicating whether the request was successful.

**refresh**
   
_Type: bool_
   
Flag indicating whether the page should be refreshed.

**message**
   
_Type: string_
   
Server generated message describing the result of the request (or anything else you want to use it for)

**errors**
   
_Type: Array_
   
An array of [AjaxError](https://github.com/DarthFubuMVC/fubumvc/blob/master/src/FubuMVC.Core/Ajax/AjaxError.cs) objects ( { category: ‘’, field: ‘’, message: ‘’ })

## AjaxContinuation and FubuMVC

As I said before, this is a first-class citizen in FubuMVC. There are default conventions provided for you. All you need to do is return an AjaxContinuation from one of your actions and we take care of the rest.

But just for sake of clarity, here’s an example:



Don’t worry, I give a lot more information in the next few posts.
  
Until next time.