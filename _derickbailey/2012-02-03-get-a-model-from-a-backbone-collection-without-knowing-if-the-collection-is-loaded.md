---
id: 799
title: Get A Model From A Backbone Collection Without Knowing If The Collection Is Loaded
date: 2012-02-03T09:51:52+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=799
dsq_thread_id:
  - "563123595"
categories:
  - Async
  - Backbone
  - JavaScript
  - Marionette
---
In working with a client recently, we ran in to a rather sticky situation. We were setting up a route to &#8220;persons/:id&#8221;, and as you would expect, we wanted to load the person in question and display the details of that person. The trick, though, is that we needed to wait until the persons collection was loaded to be able to retrieve the person from the collection. If we navigate to this route from somewhere else in the application, this isn&#8217;t an issue. The persons collection was already loaded and everything goes on normally. If we use a bookmark to get to this url directly, though, then there was no guarantee that the persons collection was loaded because we had not previously run any code to load the collection.

Depending on how the application is architected, and when the persons collection is expected to be loaded, there are a few options that I can see for solving this problem.

<span style="font-size: 18px; font-weight: bold;">Option: Fetch The Model From The Server</span>

The most basic option, and probably the easiest to deal with, is just to fetch the model from the server based on the id parameter that you get from the route.

In this case you just need to create a new model instance, set the \`id\` attribute on the model directly and then call \`.fetch\` on the model. It will make the trip to the server to get the data. You can either listen to a &#8220;change&#8221; event on the model or provide a &#8220;success&#8221; callback in the fetch method, to know when the data has been returned so that you can load it in to your view and display it as needed.

[gist id=1730803 file=1.js]

The major problem here is that you have not loaded the persons collection at all. If the persons collection is expected to be loaded because it&#8217;s being used for something related to displaying or working with the individual person model, then this option might not work for you. You could run some additional code to load the collection separately (asynchronously, since it works that way by default). This might help get around any potential issues of needing the collection.

## Option: Use The Collection&#8217;s &#8220;reset&#8221; Event

Another easy option may be to load the collection when the request for the route is made. You would set up a new collection instance, bind a callback function to the collection&#8217;s &#8220;reset&#8221; event, and then call \`.fetch\` on the collection. The callback method would be responsible for retrieving the specific model from the collection and then creating and displaying the view.

[gist id=1730803 file=2.js]

There are some potential issues with this solution, though. If you already have the persons collection loaded, then you&#8217;re going to load it a second time just to get the one model from it. To mitigate this problem, you would need two different entry points in to the display of the person: one for when you hit the route directly through a bookmark, and one for when the user is already in the app and navigates to the person display through other means.

Having two different entry points in to this part of the app may not be a bad idea. This largely depends on how the application is architected. You wouldn&#8217;t want to duplicate all of the code that sets up the display of the person&#8217;s details in both of the entry points, but you wouldn&#8217;t want to have a bunch of ugly if-statements in that code to determine how to set things up, either. Some simple abstractions of the common bits would help keep this code manageable.

## Option: Building An &#8220;onReset&#8221; Callback

**UPDATE:**

FYI &#8211; I have an updated version of this code available in my [Backbone.Marionette](https://github.com/derickbailey/backbone.marionette) plugin, as Backbone.Marionette.Callbacks. It [reduces the code and complexity significantly](http://lostechies.com/derickbailey/2012/02/07/rewriting-my-guaranteed-callbacks-code-with-jquery-deferred/), and also eliminates the race condition issues that I mention below. Be sure to use that Callbacks object instead of the code I&#8217;ve listed here.

**:END UPDATE**

**  
** 

The third option that I can think of &#8211; and the one that I implemented for this particular client project &#8211; is a variation of using the collection&#8217;s reset event. The idea is to build an &#8220;onReset&#8221; callback system that is aware of whether or not the collection has already been loaded or is still waiting to be loaded.

If you have the persons collection being loaded from some other application initialization code, then you don&#8217;t necessarily have the ability to use a simple reset event as shown above. You could try to use the reset event, but there&#8217;s a race condition that is introduced in low-latency, high speed networks (i.e. your local development machine).

If you don&#8217;t control when the \`.fetch\` method is called, then you may end up binding to the reset event after the collection has already been reset. In that scenario &#8211; which is very likely to happen when working in a local development environment &#8211; your view for the specific person model will never get displayed.

The solution I came up with is to have a callback mechanism built in to the collection, that pays attention to the collection&#8217;s reset event and knows to either wait for the reset event to be fired, or to fire the callbacks immediately because the collection has already been loaded. I&#8217;m calling this an &#8220;onReset&#8221; callback, for lack of a better description at this point.

The code to use the onReset callbacks would look something like this:

[gist id=1730803 file=3.js]

In this setup, adding an onReset callback guarantees the callback&#8217;s execution. If the collection has not yet been loaded, then it stores the callback and waits for the reset event to fire. If the reset event has already been fired, then it simply executes the callback immediately. Either way, your callback will be executed and you will have the collection available when it does.

## Race Condition Reduced. Eliminated?

Here&#8217;s the implementation for the onReset code. It&#8217;s generally functional and I haven&#8217;t yet run in to any problems, yet.

[gist id=1730803 file=4.js]

You can then extend from OnResetCollection instead of Backbone.Collection to get this functionality.

I still worry that there&#8217;s a potential race condition in between the logic and the pop&#8217;ing of items off the array. I&#8217;ve travelled every logical path of execution for the asynchronous call and onReset call that I can think of, and I can&#8217;t find any issue. I would love to hear from someone more experienced with race conditions in JavaScript, though.