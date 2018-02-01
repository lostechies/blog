---
id: 665
title: CQRS and user experience
date: 2012-08-23T14:57:01+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2012/08/23/cqrs-and-user-experience/
dsq_thread_id:
  - "815818369"
categories:
  - CQRS
---
CQRS as a concept is relatively easy to grasp, as it’s really just two objects where there was once one (plus all the stuff underneath the covers to make that happen). Where I see most teams struggle to apply these concepts is when they get to building the user experience around a CQRS system.

In a typical N-Tier architecture, commands and queries are served by the same persistent records. When you do this, barring any kind of back-end replication, users see changes to what they’re modifying immediately. Often, the workflow presented is something like:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2012/08/image_thumb2.png" width="594" height="83" />](http://lostechies.com/jimmybogard/files/2012/08/image2.png)

When moving to CQRS, the “View” side of things is in a separate store than the “Form” side of things. I elaborated [earlier on UI designs when you chose eventual consistency](http://lostechies.com/jimmybogard/2012/06/26/eventual-consistency-cqrs-and-interaction-design/), but there is a choice beforehand. In cases where we’re introducing CQRS, it can be fairly difficult to wrest the above synchronicity away from users and try to replace every screen with:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2012/08/image_thumb3.png" width="444" height="83" />](http://lostechies.com/jimmybogard/files/2012/08/image3.png)

This works when the user actually expects some sort of “background” work to happen, or that we present this to the user in a meaningful way.

But when doing CQRS, eventual consistency is an orthogonal choice. They are two completely separate concerns. Going back to our new CQRS design:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2012/08/image_thumb4.png" width="454" height="237" />](http://lostechies.com/jimmybogard/files/2012/08/image4.png)

We have many choices here on what should be synchronous, and what should not. It can all be synchronous, all be async, it’s just a separate decision.

What I have found though that is if we build asynchronous denormalization in the back-end, but try to _mimic_ synchronous results in the front end, we’re really just choosing async where it’s not needed. Not in all cases of course, but for most of the ones I’ve seen.

Some async-sync mimicry I’ve seen includes:

  * Using Ajax from the server to ping the read store to see if denormalization is “done”
  * Using SignalR to notify the client when the denormalization is “done”
  * Writing to the read store synchronously, but then allowing eventual consistency to fix any mistakes

All of these seem a little bizarre to me, as there’s a clear difference in my mind between managing an asynchronous process that is temporally decoupled from the UI and being able to supply synchronous updates to the user.

That’s why I start with a synchronous denormalizer in CQRS systems – where users already expect to see their results immediately. When the user expects immediate results, jumping through hoops to mimic this expectation is just swimming upstream.

### Synchronicity of the web

The web is inherently synchronous request/response. When we’re building interactions in a CQRS system, we have to work within those boundaries. With every action the user takes, there is some synchronous activity that takes place.

We just need to make sure that our interaction design respects this fundamental constraint, and doesn’t confuse users. If the expectation is fire-and-forget, that’s fine, but often we will still need some way for the user to see the status of their request (just like Amazon orders).

Eventual consistency in CQRS can be a powerful tool, but it can’t confuse users. Build the user experience around whatever path you choose.