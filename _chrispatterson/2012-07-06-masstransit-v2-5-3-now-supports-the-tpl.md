---
wordpress_id: 89
title: MassTransit v2.5.3 Now Supports the TPL
date: 2012-07-06T13:12:05+00:00
author: Chris Patterson
layout: post
wordpress_guid: http://lostechies.com/chrispatterson/?p=89
dsq_thread_id:
  - "754084159"
categories:
  - masstransit
  - SignalR
---
As I&#8217;ve started to use MassTransit with SignalR, one of the things that annoyed me was the hoops I had to jump through to get a nice asynchronous request from SignalR into MassTransit. There was a lot of plumbing since the MT did not support the TPL.

Well, I&#8217;ve changed that. With version 2.5.3 (a prerelease version on NuGet), you can now get a really nice clean syntax to return tasks from server-side SignalR hubs (and other calls that expect a Task return value.

{% gist 3061985 file=First.cs %}

Shown above is a SignalR hub that sends a request message off to some service. The LocationResult handler that is added within the closure returns a Task<LocationResult>, which can be returned to SignalR allowing the server-side code to remain asynchronous. If additional work needed to be done to transform the message to another type or do perform some type of validation, a .ContinueWith() could be added to the task to return the proper result type.

{% gist 3061985 file=Second.cs %}

If the request times out, the task for the handler will be cancelled, so be sure to take that into account.

Pretty power stuff eh?