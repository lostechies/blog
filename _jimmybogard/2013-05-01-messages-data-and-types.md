---
id: 770
title: Messages, data and types
date: 2013-05-01T14:08:23+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=770
dsq_thread_id:
  - "1251518459"
categories:
  - Messaging
  - SOA
---
One concern I receive quite a bit from folks new to messaging, especially those coming from SOAP and WCF land, is how to preserve the convenience of proxy classes and data contracts that can be shared amongst multiple clients. The problem comes in when looking at coupling, especially around changes in the contract and how to upgrade clients. Clemens Vasters details many of these issues in his [screencast on data/contract coupling in messaging](http://channel9.msdn.com/Blogs/Subscribe/DataContract-Coupling-in-Messaging).

One thing that grounds all of this is what we consider the message as developers, and what our transport and messaging system considers to be the message. For example, the Azure REST services [expose contracts as XML](http://msdn.microsoft.com/en-us/library/windowsazure/jj157186.aspx). XML, by itself, and JSON make for great transport formats because the underlying technology provides a fairly universally acceptable common type system. Although your language might need to bridge from your format to theirs, people standardize on ISO formats for standard primitives to maximize interoperability (and minimize serialization mistakes).

Dealing with such large XML documents from a client API can be a pain, however. XML is notoriously finicky with respect to case sensitivity, and I can’t count how many times I’ve been bitten by this when dealing with raw XML and REST APIs. We would need to assume that documentation exists, and until [forms become common in REST APIs](https://gist.github.com/mikekelly/3808215), it’s difficult to say that [HATEOAS](http://en.wikipedia.org/wiki/HATEOAS) will simply solve all these problems of self-describing APIs.

Instead, we often see REST and other messaging clients, out of convenience, build DTOs as a means of representing the message. But first – what is a message? A [message is just data](http://www.eaipatterns.com/Message.html). It’s defined by a header and body, where the header is used by the transport/messaging system and the body is ignored (picture courtesy <http://www.eaipatterns.com>):

![](http://www.eaipatterns.com/img/MessageSolution.gif)

However, **messages aren’t types**. But what about sharing something like this?

[gist id=5495362]

That’s still not terrible, because underneath the covers our message is still just XML or JSON. We use this type as a description or blueprint of our message, because it’s simpler to describe our message in C# terms instead of a looser type like XML or JSON, which are more difficult to describe and use in C#. I’m ignoring dynamic types in .NET – those to me are a bit of a hack in this case. In WCF, proxy classes get generated on the client side, so we’re still not taking an assembly dependency. This isn’t available in REST or other messaging technologies, leaving clients reliant on documentation to “Get it right” – assuming that they don’t make mistakes translating raw XML or JSON into code building raw XML or JSON on the client side.

So what typically happens **in a homogenous environment** is that data contract assemblies are shared:

[<img title="image" style="border-top: 0px; border-right: 0px; background-image: none; border-bottom: 0px; padding-top: 0px; padding-left: 0px; border-left: 0px; display: inline; padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2013/05/image_thumb.png" width="355" height="243" />](http://lostechies.com/jimmybogard/files/2013/05/image.png)

Both client and server share a contracts assembly, and use the contracts assembly as a description for how to construct and consume the raw messages.

We introduce coupling on the client side with a raw type shared across the server boundary, but it’s up to those building the system to determine if this sort of **coupling introduces any potential risks**. When we look at coupling, we must always balance risk. If coupling introduces low risk, it might be acceptable (assuming we’re more or less prescient in our future system’s design).

From my experience, as long as the messaging infrastructure doesn’t assume that the message is built from a type and therefore leak those concerns, this sort of model can be a nice compromise in ecosystems where types as blueprints for messages ensures safety in our message construction and consumption. It’s similar to [building MVC applications around View Models](http://lostechies.com/jimmybogard/2009/06/30/how-we-do-mvc-view-models/) – they’re a blueprint for building forms, and a means of accepting raw form POSTs. Side note – I found it hilarious that the Rails folks ran into that mass assignment security problem – it’s a problem I’ve never, ever had in MVC.

But that’s the real kicker – our messaging infrastructure can’t assume types, as the message is not the type. We might use a type as a convenience to build and consume, as we do in MVC, but ultimately, our messaging infrastructure can’t assume a type. MVC handles this quite well, with model metadata and its ModelState objects. The **original request is always preserved in its raw form** (dictionary of strings), but the model provided to the controller action is an approximation of that request.

It’s only when we assume that we’ve literally shared types that we’re going to slip into real type coupling, and everything that SOAP failed to deliver comes back again.