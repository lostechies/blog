---
wordpress_id: 1260
title: 'JavaScript Promises: A Journey To The &#8220;Promise Land&#8221;'
date: 2014-02-17T06:00:12+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1260
dsq_thread_id:
  - "2264150475"
categories:
  - JavaScript
  - JQuery
  - NodeJS
  - Qjs
  - RSVPjs
  - Screencast
  - WatchMeCode
  - WinJS
---
Promises certainly aren&#8217;t the holy grail of asynchronous flow control in JavaScript. There are no silver bullets, after all. Promises are a tremendously important concept, and one that you need to understand, though. They&#8217;ve been around for a few years, have gone through various standards and APIs and are finally being added to JavaScript, proper. There are countless resources around the web these days, showing how promises work and what you can do with them. But in all this, it&#8217;s easy to get a bit lost. So I want to take you down a short journey &#8211; one that I&#8217;ve already travelled and documented fairly well. But here, I&#8217;ll summarize my journey of re-inventing promises (by accident), learning what they are and how I came to use them on a daily basis, for a while.

## The TL;DR Of My Promises Journey

I was working with a client a few years ago and we had a problem. We needed to load up a single Backbone model from a collection, but didn&#8217;t have a guarantee of the collection being loaded yet. So I created [a way to guarantee callbacks firing](https://lostechies.com/derickbailey/2012/02/03/get-a-model-from-a-backbone-collection-without-knowing-if-the-collection-is-loaded/). What I didn&#8217;t realize at the time, was that promises did exactly this. It was shortly after writing that post that someone introduced me to [jQuery Deferred objects](http://api.jquery.com/category/deferred-object/). I quickly [rewrote my callbacks class](https://lostechies.com/derickbailey/2012/02/07/rewriting-my-guaranteed-callbacks-code-with-jquery-deferred/) to be a thin wrapper around deferred, and moved on. A short time later, I found myself working on a contract for Microsoft Patterns & Practices group, building a Windows 8 / WinJS application. It turns out Windows 8 / WinJS apps are full of promises, and [you really do have to understand them](https://lostechies.com/derickbailey/2012/07/19/want-to-build-win8winjs-apps-you-need-to-understand-promises/) if you want to build anything with Win8 / WinJS. This was my first in-depth exposure to &#8220;real&#8221; promises, though I had become familiar with the term by now, and knew that jQuery&#8217;s deferred weren&#8217;t quite a &#8220;promise&#8221; (at least, by the standards at the time. maybe that has changed?).

My love affair with promises continued in Backbone for a while. And once I started doing more work in NodeJS, I started doing more work with promises using [Q](https://github.com/kriskowal/q) and [RSVP](https://github.com/tildeio/rsvp.js). I noticed that my NodeJS experience was a little closer to my Win8/WinJS experience, too &#8211; at least for the use of RSVP. Others, though, provided very different APIs in comparison to both jQuery and WinJS. So I wrote up [a small complaint about the inconsistencies in promise libraries](https://lostechies.com/derickbailey/2013/09/20/consistency-problems-with-apis-in-javascript-promise-libraries/), stating my preference for the A+ spec that RSVP was implementing. In that post, I learned that [JavaScript is getting official support for promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise). This is exciting news, to me. It&#8217;s good to see such a great tool being added to the language directly. I&#8217;m hopeful that this will improve the state of promises, in general, and help us move forward with other tools and technologies that are built on top of them.

## My Promises Screencasts

Having learned quite a bit about promises and spent a significant amount of time using them in various forms, I created a couple of screencasts around promises &#8211; one of which is freely available on Youtube and has [a blog post over at Telerik](http://blogs.telerik.com/appbuilder/posts/13-10-07/cleaning-up-nested-callbacks-with-promises). This screencast shows how to clean up nested callbacks with promises. It&#8217;s a great introduction to the things that promises let us do, and shows one option for getting out of callback hell / the christmas tree of doom.



The other is a paid screencast on my WatchMeCode screencast series &#8211; [Episode 13: Promises From The Ground Up](http://www.watchmecode.net/promises-ground-up).

[<img src="https://lostechies.com/content/derickbailey/uploads/2014/02/NewImage.png" alt="NewImage" width="300" height="225" border="0" />](http://www.watchmecode.net/promises-ground-up)

This screencast takes you roughly through the same journey that I had when I first needed a promise. It shows some very basic, async code (facilitated with `setTimeout` in this case) and then walks through a very minimal (incomplete) promise implementation.

The goal is to break down promises in to what they really are &#8211; callbacks that are stored for later execution. If you&#8217;ve been beating your head against the wall of promises, trying to understand how they really work (even if you&#8217;ve used them successfully!), then this screencast is one that you&#8217;ll want to pick up. Tearing down the illusion and revealing the person behind the screen is a powerful way to move from the realm of &#8220;magic&#8221; (that which we don&#8217;t understand) to &#8220;technology&#8221; (that which we do understand). 