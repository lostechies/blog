---
wordpress_id: 1100
title: 'Saga Implementation Patterns: Singleton'
date: 2015-04-17T15:38:01+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1100
dsq_thread_id:
  - "3689803649"
categories:
  - NServiceBus
---
[NServiceBus sagas](http://docs.particular.net/nservicebus/sagas/) are great tools for managing asynchronous business processes. We use them all the time for dealing with long-running transactions, integration, and even places we just want to have a little more control over a process.

Occasionally we have a process where we really only need one instance of that process running at a time. In our case, it was a process to manage periodic updates from an external system. In the past, I&#8217;ve us[ed Quartz with NServiceBus to perform job scheduling](https://lostechies.com/jimmybogard/2012/08/13/reliable-job-scheduling-with-nservicebus-and-quartz-net/), but for processes where I want to include a little more information about what&#8217;s been processed, I can&#8217;t extend the Quartz jobs as easily as NServiceBus saga data. [NServiceBus also provides a scheduler](http://docs.particular.net/nservicebus/scheduling/) for simple jobs but they don&#8217;t have persistent data, which for a periodic process you might want to keep.

Regardless of why you&#8217;d want only one saga entity around, with a singleton saga you run into the issue of a Start message arriving more than once. You have two options here:

  1. Create a correlation ID that is well known
  2. Force a creation of only one saga at a time

I didn&#8217;t really like the first option, since it requires whomever starts to the saga to provide some bogus correlation ID, and never ever change that ID. I don&#8217;t like things that I could potentially screw up, so I prefer the second option. First, we create our saga and saga entity:

[gist id=d66d4c8c63f3dcfbc831]

Our saga entity has a property &#8220;HasStarted&#8221; that&#8217;s just used to track that we&#8217;ve already started. Our process in this case is a periodic timeout and we don&#8217;t want two sets of timeouts going. We leave the message/saga correlation piece empty, as we&#8217;re going to force NServiceBus to only ever create one saga:

[gist id=c8e7e3272b2090238397]

With our custom saga finder we only ever return the one saga entity from persistent storage, or nothing. This combined with our logic for not kicking off any first-time logic in our StartSingletonSaga handler ensures we only ever do the first-time logic once.

That&#8217;s it! NServiceBus sagas are handy because of their simplicity and flexibility, and implementing something a singleton saga is just about as simple as it gets.