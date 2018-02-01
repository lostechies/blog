---
id: 747
title: Reducing Backbone Routers To Nothing More Than Configuration
date: 2012-01-02T14:11:09+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=747
dsq_thread_id:
  - "524256727"
categories:
  - Backbone
  - JavaScript
  - Marionette
---
I received an email from someone who was looking through my [BBCloneMail](https://github.com/derickbailey/bbclonemail) and [Backbone.Marionette](https://github.com/derickbailey/backbone.marionette) source code. One of the comments they made talked about how my router callback methods were nothing more than pass-throughs, calling out to another object. (I think this is one of the points that Tim Branyen was making in [the comments of my previous post](http://lostechies.com/derickbailey/2011/12/27/the-responsibilities-of-the-various-pieces-of-backbone-js/), too).

Here&#8217;s an example of the code that the email was referring to:

[gist id=1551892 file=1.js]

The emailer suggested that I factor out the boilerplate code and set up some custom functionality to go straight from the route definition to a method call on another object, In other words, instead of having to implement a callback method on the router itself, having the callback method be on another object.

## Removing The Callback Functions

I like the idea so I hacked together a working version directly in to the BBCloneMail application. The result is that my router went from the code above, to this:

[gist id=1551892 file=2.js]

Now my router is nothing more than configuration! There are no callback methods directly in the router anymore. The callbacks that I defined are located on another object, instead.

To make this work, my &#8220;AppRouter&#8221; expects to receive an &#8220;app&#8221; object when it&#8217;s instantiated. This is the object that contains the callback methods I specified.

[gist id=1551892 file=3.js]

All of the parameters that you define in the route are forwarded to your app object&#8217;s callback method. So, when the empty (&#8220;&#8221;) route fires, the &#8220;showInbox&#8221; method on the &#8220;BBCloneMail.MailApp&#8221; object will be called with no parameters. And when &#8220;inbox/:id&#8221; fires, the &#8220;showMessage&#8221; method on &#8220;BBCloneMail.MailApp&#8221; will receive a single parameter with the id from the route.

## The AppRouter Code

Here&#8217;s the code that I put in to my AppRouter, to make this work:

[gist id=1551892 file=4.js]

This code doesn&#8217;t preclude you from using the standard &#8220;routes&#8221; and callbacks, either. You can mix and match the standard routes and the appRoutes however you want. The routes defined in appRoutes get processed after the standard routes, though. This means it&#8217;s possible for an appRoute to override a normal route.

## Still Needs Work

You can see it live in my [BBCloneMail](https://github.com/derickbailey/bbclonemail) app right now. It may not stay there for long, though, as I&#8217;m constantly changing that code. Also &#8211; I haven&#8217;t thoroughly tested this so there may be some browser compatibility issues that I haven&#8217;t run into yet… or some other issues that I don&#8217;t know about. I&#8217;m going to keep playing with this idea and once I get it to something I really like, I&#8217;ll re-write it (test-first of course) into [Backbone.Marionette](https://github.com/derickbailey/backbone.marionette).

I&#8217;m also looking for feedback on this. I realize there are some limitations to this, and there are probably some dumb thing I&#8217;ve done, too. If anyone has any suggestions for how to improve this, I&#8217;d love to hear it.