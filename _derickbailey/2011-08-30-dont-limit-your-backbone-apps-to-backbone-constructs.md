---
id: 527
title: 'Don&#8217;t Limit Your Backbone Apps To Backbone Constructs'
date: 2011-08-30T21:16:29+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=527
dsq_thread_id:
  - "400541078"
categories:
  - AntiPatterns
  - AppController
  - Backbone
  - JavaScript
---
I&#8217;ve noticed a pattern in Backbone sample apps, requests for help via [StackOverflow](http://stackoverflow.com/questions/tagged/backbone.js) and the [Google group](http://groups.google.com/group/backbonejs), etc, where people realize that they have a need for an object that coordinates various parts of the application. This is a great realization and something that you should do when you see the need. However, most of the examples and sample that I see end up using a Backbone construct to handle this coordination &#8211; even when there is no direct benefit.

I don&#8217;t blame the people that are posting these example and questions, though. I think the problem stems from the learning curve of something new, and wanting to build something the way you see it being done in examples. I&#8217;ve seen this problem a number of times in my career and I&#8217;ve do the same thing when I&#8217;m learning something.

Here are a few of the examples that I think are causing problems for people, when learning.

### The To-Do List&#8217;s AppView

A lot of people look at [the simple to-do list example](http://documentcloud.github.com/backbone/docs/todos.html) from Backbone, including me. It&#8217;s a great place to start if you want to see one way of building a small application with backbone. Unfortunately, when people see the AppView portion of the code, they often think that this is &#8220;the backbone way&#8221;. I thought this when I saw it at first, but I didn&#8217;t understand why it was this way. It didn&#8217;t seem right to me, but I didn&#8217;t question it as I was just learning backbone for the first time.

I built my first app with an AppView and it looked something like this (though honestly, it looked much much worse than this):

[gist id=1182708 file=1-appview.js]

Sure, this was worked for my simple app &#8211; it got things started up and running when i called \`new AppView()\`. It&#8217;s even better than putting all of that code right out in the middle of nowhere-land, where it would all become part of the global object. I was proud of myself for not pollution the global object! … but code like this shouldn&#8217;t exist in a view.

### The Truth About AppView

If you look at the AppView in the to-do list example, and really read through the sample code, you&#8217;ll notice that it really is a backbone view. It registers events through the \`events: { … }\` attribute. It uses \`this.$(…)\` to do element selection within the view. It renders things into the DOM for display, too.

The AppView in the to-do list is a legitimate backbone view. It also happens to be the place that the to-do list starts up. This isn&#8217;t because AppView is the &#8220;the backbone way&#8221; of starting up an app, though. It&#8217;s only because there is no need for anything more complex in this example application. Nothing more.

### Not Just Views

Its not just backbone views that get abused like this, though. I&#8217;ve seen examples where people build &#8220;controller&#8221; objects (which is a good idea, again) using a backbone model as the base class. In one particular example, the developer was using the events built into the model. The idea was good, but it was unnecessary to use a backbone model as a base class when backbone provides an event system that can be used anywhere.

### You Have All Of Javascript Available. Use It.

This is the crux of what I&#8217;m trying to get at, really. When you recognize the need for an object that does not appear to fit within the constructs that backbone provides, don&#8217;t force it into one.

The next time you see a need for an application object that you can kick-start the app with, build your own object to do exactly that:

[gist id=1182708 file=2-app.js]

And when you want to take advantage of backbone&#8217;s events, just use backbone&#8217;s events:

[gist id=1182708 file=3-events.js]

You&#8217;ll find your code is much more understandable, less prone to strange behavioral bugs, and generally much cleaner and easier to work with if you remember that you can use all of javascript and not just the constructs that backbone gives you.