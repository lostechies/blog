---
wordpress_id: 897
title: Decoupling Backbone Apps From WebSockets
date: 2012-04-19T06:48:11+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=897
dsq_thread_id:
  - "656112627"
categories:
  - Backbone
  - JavaScript
  - Marionette
  - Pusher
  - SignalR
  - Socket.IO
  - Web Sockets
---
I&#8217;ve been doing a lot of work with web sockets lately, in my Backbone applications. And I&#8217;ve fallen in to a pattern that I really like, where my Backbone application doesn&#8217;t actually know anything about web sockets. All it knows is that I&#8217;m using an event aggregator (like I always do) and that it publishes and subscribes to various events. The web sockets, then, sit off to the side. They&#8217;re decoupled from my actual application and I can replace the socket implementation without having to worry about my app&#8217;s functionality.

## A Web Socket Library

Now you could write your own web sockets implementation. But I don&#8217;t recommend this. It&#8217;s notoriously difficult to get it to work across all of the browsers that you&#8217;ll have to support and frankly, not worth your time. Instead I&#8217;d recommend using an existing socket library. I&#8217;ve used these and can highly recommend all of them:

  * [Socket.IO](http://socket.io/): The defacto standard for web sockets libraries. It primarily runs on NodeJS, but there are back-end servers for several other languages available as well. It falls back to long-polling, AJAX, and several other implementations that work in nearly every browser.
  * [SignalR](http://signalr.net/): A long-polling, web sockets, AJAX adaptive system for .NET. It&#8217;s Socket.IO for .NET.
  * [Pusher](http://pusher.com/): A third-party web sockets server. This is great for hosted sites (like Heroku) and for high scalability, fast. I learned how to use web sockets and converted a very chatty app from AJAX calls to PusherApp in less than an hour, a few years ago. There are libraries for PusherApp in [many different development languages](http://pusher.com/docs/rest_libraries), like Ruby, .NET, Python, etc. I&#8217;ve only used the Ruby library, but it was dirt simple. They also have an article on working with [Backbone and Pusher](http://blog.pusher.com/2011/6/21/backbone-js-now-realtime-with-pusher/).

And yes, I realize that there are more libraries than just these. I&#8217;ve only used these, so they are the ones I&#8217;m mentioning. And I love all three of these web socket libraries. If I was forced to pick a favorite, it would be Socket.IO but only because I love working with NodeJS. But I do have an affinity for Pusher, since it&#8217;s the place that got me started with Websockets.

All three of these libraries are easy to use, and can easily be adapted to this example, though. Don&#8217;t feel like you&#8217;re going to make a wrong choice either. After all, the purpose of this article is to show you how the choice you&#8217;ve made doesn&#8217;t matter that much.

<span style="font-size: 18px; font-weight: bold;">Decoupling Web Sockets</span>

When I build apps with web sockets for communication, I don&#8217;t want my application to actually know anything about the sockets. I don&#8217;t want to mix that responsibility all throughout the code, for a number of reasons. If my need for sockets changes, for example, having many places to update the use of them would become a pain. If I want to get rid of sockets entirely or use another form of communication in addition to web sockets, having to go and add a bunch of extra code in all of the places that need the new communication would be awful. There&#8217;s also a high likelihood of code duplication, hidden problems and workflow, and hard to test code when we couple our web sockets implementation to our application code.

The simple solution that I&#8217;ve found for this is to abstract the web sockets away from our application. There are several ways to do this, one of which is to replace the Backbone.sync method in a Backbone app with something like [Backbone.IOBind](https://github.com/logicalparadox/backbone.iobind). This plugin replaces the sync method with a version that communicates over web sockets. That means your fetch, save and destroy methods would all move over web sockets instead of AJAX calls. If you&#8217;re using Socket.IO and you want to have your data access methods working this way, I recommend checking out Backbone.IOBind.

Another way to do this, though, is to move the web sockets code away from the application entirely. We can easily set up an adapter objects that translates between our web sockets implementation and our actual application.

## A SocketAdapter

There are two basic things that you&#8217;ll need to build a socket adapter in the manner that I like. a web sockets setup and an [event aggregator](https://lostechies.com/derickbailey/2011/07/19/references-routing-and-the-event-aggregator-coordinating-views-in-backbone-js/). Pick a web sockets library &#8211; any of them will do. For this example, I&#8217;ll be using Socket.IO. As for an event aggregator, I&#8217;ve got my default setup with [Backbone.Marionette](https://github.com/derickbailey/backbone.marionette) which provides one for us. Or you can pick any of a number of other pub/sub libraries for JavaScript.

Here&#8217;s the trick to decoupling the application code from the web sockets library: all of the events that the web socket publishes will be forwarded to the event aggregator, and your application will only pay attention to the event aggregator. For example:

{% gist 2405897 1.js %}

In this case we&#8217;re listening for an event called &#8220;someData&#8221; on the socket library. When that event fires, we&#8217;re just forwarding the event in to our application&#8217;s event aggregator. Our application listens for the necessary events from it&#8217;s event aggregator, and does it&#8217;s thing.

From there, you just extend the adapter to listen to your specific events, and continue to forward them on. In some cases, you can even create very generic socket event handlers so that you don&#8217;t have to constantly add new ones. In other cases, you might need to add a very specific event handler and have it do some manipulation of the data that it receives before forwarding it on to the application. No matter the case, though, you now have a single place in your application where this needs to happen.

Yes, it&#8217;s really that simple.

## But, Why?

Decoupling and all that, of course. But really, it just makes our lives as developers easier. Having the web sockets and application code decoupled like this does add a little bit of overhead in both the run time execution of the code, and in the mental effort to keep track of all the moving parts. But the slicing of the individual parts down in to single responsibilities makes it easier to understand each part, and in some cases can make it easier to see the machine as a whole.

We&#8217;ve also made the choice of a web sockets library somewhat irrelevant. Did you pick Socket.IO and realize that you now need something hosted so that you can scale faster? No problem &#8211; just replace the socket adapter with an implementation that uses Pusher. Did you choose Pusher and now realize that you don&#8217;t want to pay for a hosted solution in your .NET system? No problem, just replace the Pusher implementation with SignalR.

When we&#8217;re testing our applications, we don&#8217;t have to worry about mocking or stubbing the web sockets, either. Rather than going through the pain of dealing with the web sockets API that we&#8217;ve chosen, we can simply fire off events from our application&#8217;s event aggregator and verify the results of firing those events. Removing the web sockets library from our tests will make the tests easier to work with, cleaner to read and write, and probably run a little faster too.

On that note, we can also simulate web sockets events in to our application. In a recent client project, for example, I had to simulate a list of devices with addresses receiving events from Socket.IO in my development environment. This project involved some hardware integration, and the only place where the hardware was available was a server in Germany. I didn&#8217;t have access to it here in Texas, except by deploying the app and running it there. So in my development environment, I used a setInterval to publish an event through my event aggregator every 1 second. The events I published contained valid but slightly random data to simulate what I would be receiving from the actual web sockets server. With this in place, I was able to write my app and deploy it to the real server with a fair amount of confidence. It worked nearly every time (except that time where we changed how the web sockets data was being pre-processed by our adapter).

## Only One Of Many Options

There are likely a thousand or more ways that you can integrate a web sockets system in to your application. I&#8217;ve shown you how to do one of them and linked to another (Backbone.IOBind). But don&#8217;t think that you have to do it the way that I like to do it. This is my preference based on the style of event-driven architecture that I like to write. The main point that you should take away from this article is not that you can build an event aggregator adapter for web sockets, but that you should decouple your web sockets from your application in a manner that makes it easier to maintain and change both your application and the web sockets implementation, independently of each other.
