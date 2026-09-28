---
wordpress_id: 930
title: 'Workflow In Backbone Apps: Triggering View Events From DOM Events'
date: 2012-05-15T07:04:05+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=930
dsq_thread_id:
  - "690363709"
categories:
  - Backbone
  - JavaScript
  - Workflow
---
In my previous blog post, I talked about [modeling an explicit workflow in JavaScript and Backbone application](https://lostechies.com/derickbailey/2012/05/10/modeling-explicit-workflow-with-code-in-javascript-and-backbone-apps/). The last code sample I showed had the implementation of the workflow object itself, but omitted all of the details of the views that I was using.

Here&#8217;s the gist of that again:

{% gist 2651039 3.js %}

I&#8217;ve implemented various views and objects in various manners, in order to facilitate that workflow, but what it always comes down to is that the objects facilitating the workflow need to trigger events. 

## A Basic Implementation

The most common way of triggering an event from a Backbone.View is to have some DOM events handled, and from the event handler/callback method for that, trigger the event you want:

{% gist 2653055 1.js %}

This works well. I&#8217;ve done this more times than I can count. But there&#8217;s a lot of redundancy here. You can see that both of the DOM events that I&#8217;m handling have a callback method, and both of the callback methods do nothing more than trigger an event from the view itself so that the workflow can move forward.

We can do better than that… enter Marionette&#8217;s new &#8220;triggers&#8221;.

## Reducing Event Triggering To Configuration

With the v0.8.2 release of [Marionette](https://github.com/derickbailey/backbone.marionette), I&#8217;ve introduced the idea of [view triggers](https://github.com/derickbailey/backbone.marionette#viewtriggers) &#8211; a way to configure a DOM event to trigger a view event. So instead of having to write all of that redundant code, where the only real difference is the name of the callback method and the name of the event that&#8217;s triggered, we can write this:

{% gist 2653055 2.js %}

Must shorter. Much cleaner.

You can see that the left side of the hash is a standard Backbone.View events setup where you specify the DOM event and element selector. Then on the right hand side, specify the name of the event that you want the view to trigger when that DOM event fires. Then, when I click on the &#8220;.next&#8221; element, the view will trigger a &#8220;next&#8221; event for me. Similarly, clicking the &#8220;.previous&#8221; element will trigger a &#8220;previous&#8221; event.

## Trigger From Any Marionette View

Triggers can be used from any Marionette view. You&#8217;re not limited to the ItemView type that I showed. In fact, the trigger functionality is built in to the base Backbone.Marionette.View, so even if you are creating your own specialized view type, you only need to extend from that in order to get this functionality.

## Limitations

Of course this isn&#8217;t a &#8220;complete&#8221; solution for handling events in your views, by any means. If you need to do anything more than trigger the event by itself, you should still use a standard event handler and callback method. At this point, there&#8217;s no way for you to configure any kind of data or objects to be passed through the event itself. But this may be added at some point in the future. I wrote this fairy quickly last night, and it suits my needs right now. 

For simple scenarios where you just need to trigger an event from the view, though, this works well. I&#8217;m using it in several places where my workflow is just to display a button or a link, and have that clickable item move on to another part of the application.
