---
wordpress_id: 631
title: Mixing async and sync in distributed systems
date: 2012-05-15T13:21:28+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/05/15/mixing-async-and-sync-in-distributed-systems/
dsq_thread_id:
  - "690379993"
categories:
  - DomainDrivenDesign
---
One of the more difficult transitions when moving from a synchronous UI to an inherently async/CQRS-based UI is the burden of figuring out what to do with all these synchronous operations. Especially when dealing with existing systems, users that expect everything to be synchronous don’t really appreciate what used to tell them success right away now.

The problem really exacerbates itself when too much was happening at once, and the need to break things out to improve throughput requires a different protocol for integration.

Consider going to the grocery store. When you place an item in your basket, it’s inherently a synchronous operation. Either the jar of pickles makes it into your cart, or it doesn’t, there is no middle ground there. If you drop the jar of pickles onto the ground, you don’t wait for some async process to come by and let you know by email, “sorry, it seems there was a problem with your request to add the item to your shopping cart.”

### Blending async in

Consider another system that requires to you to register with the site, using a local database for “who is registered” and a web service for downstream email communication:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2012/05/image_thumb.png" width="314" height="340" />](https://lostechies.com/content/jimmybogard/uploads/2012/05/image.png)

In this system, we block the registration of the user against both the local database and the 3rd party web service. We need to check the local database to make sure the username/email is not already used, but what about that web service? What happens when that web service is slow, or unavailable?

We’ve coupled the availability of our system with a system we don’t own, which is potentially disastrous. In the real-world system that the above diagram is based on, when that 3rd party system goes into scheduled maintenance, the web application is brought down for maintenance too! Not a good user experience by any means. Are we really going to turn users away based on the availability of a downstream service?

But there’s another way – shifting the protocol of how this system is built. Let’s make sure what needs to be synchronous is, what what doesn’t need to be, isn’t. Instead of coupling the web service and local database calls together, let’s separate the two out with messaging:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2012/05/image_thumb1.png" width="638" height="340" />](https://lostechies.com/content/jimmybogard/uploads/2012/05/image1.png)

Instead of performing the web service call in the same thread of the UI request, we instead send an asynchronous command as a message to perform the downstream operation. We’ve now decoupled the operation of calling the web service (what doesn’t need to be synchronous) with what does need (registering the user). The downstream operations of registering the user in the 3rd party email provider doesn’t need to happen at the same time.

To put it another way – does it affect the user’s registration if the email service provider rejects the message? No! Instead, that’s likely an administrative operation to figure out what happened, but the user is still successfully registered.

### Defining the boundaries

When it comes time to figure out what should be synchronous and what shouldn’t, the key is to figure out what information, operations and behaviors your system owns versus are owned by someone else. If you own the UI and the database, then synchronous is a good possibility. If you _don’t_ own the system (like our web service above), then async is a good possibility.

Next time: sync, async and CQRS.