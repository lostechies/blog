---
wordpress_id: 857
title: Providing Synchronous / Asynchronous Flexibility With jQuery.when
date: 2012-03-27T06:56:27+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=857
dsq_thread_id:
  - "625826252"
categories:
  - Async
  - Backbone
  - JavaScript
  - JQuery
  - Marionette
---
I&#8217;ve quickly become a fan of jQuery&#8217;s [Deferred / Promise](http://api.jquery.com/category/deferred-object/) features. They&#8217;ve been around for a little bit now, but I only recent started using them and they&#8217;ve helped me solve a number of problems with my asynchronous JavaScript code. But what I recently figured out really blew my mind. You can use jQuery to support both synchronous and asynchronous code, with the \`[$.when](http://api.jquery.com/jQuery.when/)\` function, and your code doesn&#8217;t have to care whether or not it&#8217;s async.

## $.when(something).then(doSomething);

The core of the $.when syntax is the when/then statement. It&#8217;s a simple logical progression in syntax and I think it reads quite nicely: When this condition is met, then execute this code. Of course you can make the statement say things that don&#8217;t quite make so much sense if you name your variables oddly, but I prefer to name them so that they do create this type of flow.

For example, you&#8217;ll find code similar to this in my [Backbone.Marionette](https://github.com/derickbailey/backbone.marionette) project:

{% gist 2131284 1.js %}

In this example, I&#8217;m waiting for a template to be retrieved before rendering my view. After the template has been retrieved, I&#8217;m using that template to do the rendering. The code reads fairly well, in my opinion: When the template has been retrieved, render the view.

## $.when.then: Async

If I&#8217;m using [an asynchronous template loading mechanism](https://lostechies.com/derickbailey/2012/02/09/asynchronously-load-html-templates-for-backbone-views/) for my Backbone.Marionette views (like in my [BBCloneMail](https://github.com/derickbailey/bbclonemail) sample app), the above code only needs to have a jQuery deferred object returned from the call to &#8220;getTemplate&#8221; on the view. If a deferred / promise is returned, then the $.when/then call will be set up to execute the &#8216;then&#8217; callback after the template has completed loading. It&#8217;s a fairly simple thing to do, honestly. Just return a deferred / promise from &#8220;getTemplate&#8221; and the view rendering will correctly support asynchronous template loading.

The real magic in this code, though, is that it supports both synchronous and asynchronous returns from the &#8220;getTemplate&#8221; method.

## $.when.then: Synchronous

If you can sift through all of the documentation and really wrap your head around it, you&#8217;ll find this little nuget:

> If a single argument is passed to jQuery.when and it is not a Deferred, it will be treated as a resolved Deferred and any doneCallbacks attached will be executed immediately.

What this is really saying is that if you call $.when with a deferred/promise, then jQuery will wait until that promise has been fulfilled &#8211; resolved &#8211; before executing the &#8216;then&#8217; portion of your code. At the same time, if you pass in an object that is not a jQuery deferred/promise, jQuery will immediately call the &#8220;then&#8221; callback in your code. This means that a call to $.when/then directly supports both synchronous and asynchronous processing.

You can see this evidenced in Backbone.Marionette, once again. The default implementations of the template loading and rendering for the various views are all synchronous. I&#8217;ve added extensive support for asynchronous template loading and rendering, though, using a combination of Deferred objects and $.when/then calls. The above code sample runs no matter the sync/async nature of the template loading and rendering, though.
