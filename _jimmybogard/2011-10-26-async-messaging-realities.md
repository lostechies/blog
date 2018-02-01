---
id: 544
title: Async messaging realities
date: 2011-10-26T13:17:12+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2011/10/26/async-messaging-realities/
dsq_thread_id:
  - "453696856"
categories:
  - Architecture
---
I got a bit of a chuckle from Ayende’s [post on time traveling emails](http://ayende.com/blog/128002/time-traveling-emails-and-async-operations). In it, he shows messages in his email inbox received out of order chronologically from when they actually occurred in the real world.

That’s one of the pillars of message-based architectures, that you don’t guarantee when messages arrive, or what order they arrive in. There are a couple of ways we can deal with this, such as the NServiceBus concept of sagas to orchestrate long-running business processes/transactions, where you can keep track of what messages have been received and react accordingly.

One of the difficulties of moving from a synchronous-based message architecture and an async version is that you lose all of these guarantees of synchronous message processing. That’s why it’s not really advisable to view async as a switch to get turned on, since message-based architectures are an architectural approach or style, not an implementation detail. Lots of assumptions get made when you’re writing synchronous code that don’t fly with an async model.

Testing scenarios that involve more than one message getting processed also get more interesting, since testing frameworks are inherently synchronous processes. It’s why you typically see message handlers tested in isolation, rather than a grand end-to-end scenario. Putting a synchronous end-to-end test on an asynchronous process doesn’t really test a production scenario, so its value is at best misleading.

Putting it succinctly – message-based architectures are more than replacing synchronous with async. It’s a mind-shift to a completely different architectural style where your normal rules of engagement are thrown out the window.