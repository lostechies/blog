---
id: 148
title: Our Ajax Conventions–Validation
date: 2012-01-08T08:32:53+00:00
author: Josh Arnold
layout: post
guid: http://lostechies.com/josharnold/?p=148
dsq_thread_id:
  - "531193457"
categories:
  - general
tags:
  - ajax
  - conventions
  - fubumvc
  - jquery-continuations
---
As I mentioned in [my previous posts](http://lostechies.com/josharnold/tag/jquery-continuations/), I’m doing a write up of our AJAX conventions and how they’re paying off for us.

In this series of posts, I’m going to cover a few topics:

  1. [The AjaxContinuation](http://lostechies.com/josharnold/2012/01/06/our-ajax-conventions-the-ajaxcontinuation/)
  2. [Clientside Continuations](http://lostechies.com/josharnold/2012/01/06/our-ajax-conventionsclientside-continuations/)
  3. [Request Correlation](http://lostechies.com/josharnold/2012/01/07/our-ajax-conventionsrequest-correlation/)
  4. Validation (this post)

## Correlation by form

Last time I discussed how to correlate your requests with jquery.continuations. One of the gems that ships with continuations is the $.fn.correlatedSubmit method for forms. This method uses the id of the form (a quick unique check is performed) as the correlation id.

## fubuvalidation.js

> **Note:**
  
> This isn’t an exhaustive explanation of the new fubuvalidation.js bits. I’ll flush this out in the docs.

### Not another one…

First off: no, it’s not “another js validation library”. [fubuvalidation](https://github.com/DarthFubuMVC/fubuvalidation-js) makes use of the continuation contract but makes no effort to perform client-side validation. Instead, it aims to bridge that gap between client-side and server-side validation.

### The handler

I’m only explaining this because I know I’ll get asked about it. fubuvalidation.js ships with a [default handler](https://github.com/DarthFubuMVC/fubuvalidation-js/blob/master/fubuvalidation.js#L15). This handler renders a nice validation summary, highlights fields, and provides a little bit of interactivity. And of course, the handler is exposed through $.fubuvalidation.defaultHandler so you can override any of the functions that you don’t like. And like the rest of the Fubu projects, you can completely [override our defaults if you don’t like them](https://github.com/DarthFubuMVC/fubuvalidation-js/blob/master/fubuvalidation.js#L105).

## Back to my point…

fubuvalidation.js relies on the continuation that is returned by any of your ajax calls via jquery.continuations. Here’s how we plug into the pipeline:



Just another example of what you can do once you get your conventions defined.