---
wordpress_id: 809
title: 'Rewriting My &#8216;Guaranteed Callbacks&#8217; Code With jQuery Deferred'
date: 2012-02-07T10:11:33+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=809
dsq_thread_id:
  - "567735253"
categories:
  - Async
  - Backbone
  - JavaScript
  - JQuery
  - Marionette
---
In a previous post, I showed some code that I wrote to [guarantee the execution of a callback method](http://lostechies.com/derickbailey/2012/02/03/get-a-model-from-a-backbone-collection-without-knowing-if-the-collection-is-loaded/) after a Backbone collection was loaded. Even if you added the callback after the collection had been loaded, it would run. Shortly after writing that blog post, I extracted the code in to my [Backbone.Marionette](https://github.com/derickbailey/backbone.marionette) framework as an object called &#8220;Callbacks&#8221;. It worked and it got the job done, but I knew it could be done better.

Then a few of my friends started talking about [jQuery&#8217;s &#8220;deferred&#8221; objects and &#8220;promises&#8221;](http://api.jquery.com/category/deferred-object/). I had heard of this previously but had not bothered to learn it. When I finally decided to dig in to it, this morning, I found that it was a much more robust implementation of what I had just written. I found [a good article that helped me understand it better](http://www.erichynds.com/jquery/using-deferreds-in-jquery/), and began working on an update for Marionette to use deferred objects instead of my own code. Addy Osmani also wrote [a really good article on MSDN](http://msdn.microsoft.com/en-us/scriptjunkie/gg723713), which sheds even more light on how these work and how to work with them.

## My New &#8220;Callbacks&#8221; Object

Here&#8217;s the end result of my digging in to this and replacing my Callbacks object with a jQuery deferred / promise implementation:

[gist id=1760312 file=1.js]

This is a reduction in code and complexity, by about 75% on both counts.

## Things To Note

Backbone.Marionette.Callbacks is a constructor function and you are expected to instantiate it before using it:

> var callbacks = new Backbone.Marionette.Callbacks();
> 
> callbacks.add(function(){ … });

I&#8217;m using a single deferred object and promise object in this code. That&#8217;s done on purpose. I am collection an arbitrary list of callbacks, at an unknown time, and want to guarantee execution of those callbacks. By limiting this code to a single deferred object and a single promise, I can do exactly that.

When you call \`add\`, it sets up a \`done\` callback using the single promise object. No matter how many times you call \`add\`, it uses the same promise for that instance of Callbacks.

Then when you finally call \`run\`, it resolves the deferred object. Calling \`resolve\` on the deferred object will kick off all of the callback methods that I had set up with the when/then code.

After you call \`run\` and resolve the deferred object, you can still add callback functions to this Callbacks instance. When you do add more, jQuery is smart enough to know that the promise has already been fulfilled and it immediately executes the callback that you registered.

## Specs And Usage

If you&#8217;d like to see the specs for this to show how it works with pre-run registered and post-run registered callback methods, you can grab the source code for [Backbone.Marionette](https://github.com/derickbailey/backbone.marionette) and look at [the Jasmine specs for Callbacks](https://github.com/derickbailey/backbone.marionette/blob/master/spec/javascripts/callbacks.spec.js).

I&#8217;m using this Callbacks object in [Marionette.Application&#8217;s &#8220;addInitializer&#8221; function](https://github.com/derickbailey/backbone.marionette/blob/master/backbone.marionette.js#L414-423), which I&#8217;m using to guarantee initializer callback execution. Once I get back to working on the client project that I wrote that original code for, I&#8217;ll also update it to use the new Callbacks implementation instead of my original implementation, too.