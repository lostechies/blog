---
wordpress_id: 970
title: WinJS Event Aggregators And Observable/Evented Objects
date: 2012-07-31T13:19:37+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=970
dsq_thread_id:
  - "787328925"
categories:
  - Classy Inheritance
  - Design Patterns
  - JavaScript
  - WinJS
---
In a previous post, I showed a very brief intro to using [an application level event aggregator in WinJS](http://lostechies.com/derickbailey/2012/07/26/a-quick-note-on-pub-sub-event-aggregators-in-winjswinrt/). At the end of that post, I hinted at an option I was looking in to for creating localized event aggregators &#8211; basically, objects that can be observed. It turns out the path I was heading down was right, and it&#8217;s super simple to implement an evented object in WinJS.

## A Brief Detour: WinJS &#8220;Class&#8221;

Before I show you how to create an evented object in WinJS, you need to know how to create a &#8220;class&#8221; in WinJS. This is done by passing a constructor function and/or a list of methods as an object literal in to a [WinJS.Class.define API](http://msdn.microsoft.com/en-us/library/windows/apps/br229813.aspx):

{% gist 3219691 1.js %}

There are two other methods on the [WinJS.Class](http://msdn.microsoft.com/en-us/library/windows/apps/br229776.aspx) object, which are also useful but not important to this blog post.

Personally, I think it&#8217;s very unfortunate that they chose to use the word &#8220;class&#8221; for this. It will be misleading and cause problems for developers that come from other languages, because people will expect the result to be a class. And while JavaScript functions can be used to create new object instances, thus behaving like a class a little, they are not classes. (For more of my thoughts, read [this post on class-y frameworks](http://lostechies.com/derickbailey/2012/04/12/classyobjects-a-javascript-classy-inheritance-example/))

But moving on…

## Making An Object Evented

Now that we know how to build a &#8220;class&#8221; in WinJS, we can very easily add an implementation of [the observer pattern](http://en.wikipedia.org/wiki/Observer_pattern) to the object, allowing it to trigger events that other objects can listen to.

Here&#8217;s how you do that, using [WinJS.Utilities.eventMixin](http://msdn.microsoft.com/en-us/library/windows/apps/br211693.aspx):

{% gist 3219691 2.js %}

Yes, it&#8217;s that easy. One line of code, and you&#8217;re done. This object is now capable of triggering events and having those events listened to, which gives us everything we need to either create a dedicated event aggregator or just have our objects trigger events to facilitate workflow or other event-driven features of our app.

## Triggering, Handling, and Removing Event Handlers

Triggering and handling events in an eventMixin object is a little different than in the WinJS.Application, but should be familiar to anyone that has done DOM events, jQuery events or Backbone events.

To trigger an event, call the &#8220;[dispatchEvent](http://msdn.microsoft.com/en-us/library/windows/apps/br211692.aspx)&#8221; method and pass the name of the event as the first parameter, with the event arguments as the second parameter.

{% gist 3219691 3.js %}

To handle an event triggered by another object, call the &#8220;[addEventListener](http://msdn.microsoft.com/en-us/library/windows/apps/br211690.aspx)&#8221; method and tell it what event you want to listen to, then provide a callback function that receives the event arguments.

{% gist 3219691 4.js %}

Lastly, event handlers can be removed via a call to the &#8220;[removeEventListener](http://msdn.microsoft.com/en-us/library/windows/apps/br211695.aspx)&#8221; method.

{% gist 3219691 5.js %}

(You may have noticed the &#8220;useCapture&#8221; parameter in the documentation for both the addEventListener and removeEventListener methods. I have no idea what this does.)

## Managing Memory

One last tip with event aggregators and evented objects: **You are responsible for memory management with observable / evented objects.** While this may not play out the same way that C++ forces you to allocate / deallocate memory, it&#8217;s still very true. If you allow a function to be triggered by an event, and that function is a method, then the object that holds a reference to the method runs the risk of becoming a memory leak. 

Fortunately the solution to this is easy: **remove your event bindings when you&#8217;re done with them**.

I&#8217;ve written about this a lot [in context of Backbone](http://lostechies.com/derickbailey/2011/09/15/zombies-run-managing-page-transitions-in-backbone-apps/) and in [JavaScript in general](http://lostechies.com/derickbailey/2012/03/19/backbone-js-and-javascript-garbage-collection/). The same rules apply to WinJS as well. In fact, I&#8217;ve had this notion in the back of my mind already, that I need to create an EventBinder object for WinJS the same way [I did for Backbone.Marionette](https://github.com/derickbailey/backbone.marionette/blob/master/docs/marionette.eventbinder.md), as a core part of my own application&#8217;s memory management. We&#8217;ll see if I ever get a chance to do this, but I think it is something that needs to be done.

Just remember: it&#8217;s your responsibility as a developer to understand that this is the nature of the observer pattern and references. And just because you&#8217;re running a managed / garbage collected language, doesn&#8217;t mean you can&#8217;t create memory leaks and zombies.
