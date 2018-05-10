---
wordpress_id: 1005
title: 'Backbone.EventBinder: Better Event Management For Your Backbone Apps'
date: 2012-10-01T08:22:17+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1005
dsq_thread_id:
  - "866623076"
categories:
  - Backbone
  - Backbone.EventBinder
  - JavaScript
  - Marionette
---
One of my most popular blog posts in recent history is my [Zombies! RUN!](https://lostechies.com/derickbailey/2011/09/15/zombies-run-managing-page-transitions-in-backbone-apps/) post where I outline the possibility and problem of memory leaks and &#8220;zombie&#8221; views and other objects in Backbone applications. There&#8217;s a good chance, in fact, that if you&#8217;ve built a Backbone application, you&#8217;ve read this article already. It seems to get more traffic and more &#8220;THANK YOU!!!!&#8221; responses than any other blog post (and rightfully so, IMO). 

Down in the comments of that post, [Johnny Oshika](https://lostechies.com/derickbailey/2011/09/15/zombies-run-managing-page-transitions-in-backbone-apps/#comment-323591119) posted a link to [his solution for managing events](http://stackoverflow.com/questions/7567404/backbone-js-repopulate-or-recreate-the-view/7607853#7607853). I fell in love with that approach almost as soon as I saw it, and baked it in to [Backbone.Marionette](http://marionettejs.com). Over the last year, then, it has grown and evolved a little and become a solution that I rely on to help me manage events in Marionette and in my backbone app development. I even baked it&#8217;s use directly in to every Marionette view, to handle the zombie view problems. I&#8217;ve had a lot of people ask how I manage zombies in Marionette, and I always point them to this solution. I&#8217;ve also had a number of people ask if they could use that solution outside of Marionette &#8211; YES! definitely. You should use this solution in any Backbone application that attached to events! 

And now it&#8217;s even easier to use this in your app, even if you&#8217;re not using Marionette.

## Backbone.EventBinder

I recently extracted [**Backbone.EventBinder**](https://github.com/marionettejs/backbone.eventbinder) from Marionette and turned it in to it&#8217;s own repository in [the MarionetteJS Github org](https://github.com/marionettejs), so that anyone and everyone building Backbone applications can take advantage of this without having to re-write it in their app.

From [the EventBinder wiki](https://github.com/marionettejs/backbone.eventbinder/wiki):

## When To Use [Backbone.EventBinder](https://github.com/marionettejs/backbone.eventbinder)

The general guidelines is that any time you have an object that is created and destroyed throughout the life of the application, and that object needs to bind to events from some other object, you should use the \`EventBinder\`.

### Views And Memory Leaks

Views are the perfect example of this. Views get created and destroyed all the time. They also bind to a lot of different events from both the \`model\` and \`collection\` on the view. When the view is destroyed, those events need to be cleaned up. By using the built-in \`bindTo\` method on the view, the event handlers will be cleaned up for you. If you don&#8217;t use \`bindTo\` and instead use \`on\` directly, you&#8217;ll have to manually call \`off\` to unbind the events when the view is closed / destroyed. If you don&#8217;t, you&#8217;ll end up with zombies (memory leaks).

If you haven&#8217;t read them yet, check out these articles:

  * [Zombies! RUN!](https://lostechies.com/derickbailey/2011/09/15/zombies-run-managing-page-transitions-in-backbone-apps/)
  * [Garbage Collection And Memory Management In JavaScript And Backbone](https://lostechies.com/derickbailey/2012/03/19/backbone-js-and-javascript-garbage-collection/)

### Custom Event Groupings

Views are not the only place that this applies, though, and not the only use case for \`EventBinder\`.

If you are working with handful of objects, binding to their events, and those objects can be replaced with other object instances, then an \`EventBinder\` would be useful. In this case, think of the EventBinder as a collection or group of events for related objects.

Let&#8217;s say you have ObjA, ObjB and ObjC. Each of these fires some events, and you want to make sure you clean up the event handlers when your code is done. This is easy with an \`EventBinder\`:

{% gist 3812055 1.js %}

Calling \`stop\` in this code will properly clean up all the event handlers for this use.

### When To Use on/off Directly

The converse to all of this, is to say that you don&#8217;t always need to use an \`EventBinder\`. You can get away without it, always. But you need to remember to clean up your events when necessary.

In situations that do not need event handlers to be cleaned up, there is no need to use an \`EventBinder\`, as well. This may be an event that a router triggers, or that the \`Marionette.Application\` object triggers. For those application lifecycle events, or events that need to live throughout the entire life of the app, don&#8217;t bother with an \`EventBinder\`. Instead, just let the event handlers live on. When the person refreshes the browser window, or navigates to a different site, the handlers will be cleaned up at that point.

But when you need to manage your memory and event handlers, cleaning up references and closing things down without refreshing the page or navigating away from it, then \`EventBinder\` becomes important as it simplifies event management.

## Marionette & EventBinder

The [**EventBinder**](https://github.com/marionettejs/backbone.eventbinder) is still a critical and foundational part of Marionette, of course. We&#8217;re in the process of changing up how Marionette&#8217;s build and deployment process works, slightly, to account for this being an external resource. But Marionette will still make heavy use of the EventBinder, as it always has. We&#8217;re also working to make sure these changes are as simple as possible for everyone &#8211; for those who just want to use some of Marionette&#8217;s building blocks, for those contributing to Marionette, for those that are new to it and want an all-in-one download of Marionette, and for the advanced users of Marionette who want piece everything together and upgrade different parts as needed.

It&#8217;s a bit of a challenge to do this, but I think we have a good plan. Be sure to keep an eye on the [Marionette website](http://marionettejs.com) in the next month or so as we head toward this.
