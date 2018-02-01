---
id: 574
title: Multiple messages and transport messages in NServiceBus
date: 2012-01-31T14:11:59+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2012/01/31/multiple-messages-and-transport-messages-in-nservicebus/
dsq_thread_id:
  - "558999868"
categories:
  - NServiceBus
---
[Andreas Öhlund](http://andreasohlund.net/) posted recently on [the concept of the “transport message”](http://andreasohlund.net/2012/01/31/the-difference-between-messages-and-messages/) in [NServiceBus](http://nservicebus.com/). One of the mistakes I often see (and made myself) was misunderstanding the boundary of the unit of work NServiceBus applies to messages, especially around sending multiple messages.

In many of our systems, we consume flat files from third party integration partners. We take these flat files and deserialize each line of the file into a distinct message, so we first tried to do something like this:

[gist id=1710630]

The problem we hit was that the unit of work boundary in NServiceBus is around the _transport_ message, not the _logical_ message. In a file of a million lines, that’s a million logical messages bundled together into one single transport message, and one transaction boundary! We had assumed that the overload for sending multiple messages was simply a helper method that encapsulated a “foreach”. Well, no, it doesn’t. All the messages are wrapped in an envelope known as a “transport message”, and it’s the transport message that defines the unit of work boundary (since that’s the physical message sitting in the queue).

Needless to say, we saw database connection timeouts pretty much immediately. Instead, we modified our use of the bus to instead send one logical message per physical transport message, with our friend the “foreach”:

[gist id=1710651]

So when would you use the overloads for sending multiple messages? I’m not sure, but I’ll update if I find out!