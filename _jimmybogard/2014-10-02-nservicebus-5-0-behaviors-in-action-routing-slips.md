---
wordpress_id: 963
title: 'NServiceBus 5.0 behaviors in action: routing slips'
date: 2014-10-02T12:57:50+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=963
dsq_thread_id:
  - "3075680326"
categories:
  - NServiceBus
---
I’ve wrote in the past how [routing slips can provide a nice alternative to NServiceBus sagas](https://lostechies.com/jimmybogard/2013/04/26/saga-alternatives-routing-slips/), using a stateless, upfront approach. In NServiceBus 4.x, it was quite clunky to actually implement them. I had to plug in to two interfaces that didn’t really apply to routing slips, only because those were the important points in the pipeline to get the correct behavior.

In NServiceBus 5, these behaviors are much easier to build, because of the new behavior pipeline features. Behaviors in NServiceBus are similar to HttpHandlers, or koa.js callbacks, in which form a series of nested wrappers around inner behaviors in a sort of Russian doll model. It’s an extremely popular model, and most modern web frameworks include some form of it (Web API filters, node, Fubu MVC behaviors, etc.)

Behaviors in NServiceBus are applied to two distinct contexts: incoming messages and outgoing messages. Contexts are represented by context objects, allowing you to get access to information about the current context instead of doing things like dependency injection to do so.

In converting the route supervisor in my routing slips implementation, I greatly simplified the whole thing, and got rid of quite a bit of cruft.

### Creating the behavior

To first create my behavior, I need to create an implementation of an IBehavior interface with the context I’m interested in:

{% gist 05205abad861b9e4321c %}

Next, I need to fill in the behavior of my invocation. I need to detect if the current request has a routing slip, and if so, perform the operation of routing to the next step. I’ve already built a component to manage this logic, so I just need to add it as a dependency:

{% gist a838e828e9935f1d8e6f %}

Then in my Invoke call:

{% gist 969941f77e88c51e9e0a %}

I first pull out the routing slip from the headers. But this time, I can just use the context to do so, NServiceBus manages everything related to the context of handling a message in that object.

If I don’t find the header for the routing slip, I can just call the next behavior. Otherwise, I deserialize the routing slip from JSON, and set this value in the context. I do this so that a handler can access the routing slip and attach additional contextual values.

Next, I call the next action (next()), and finally, I send the current message to the next step.

With my behavior created, I now need to register my step.

### Registering the new behavior

Since I have now a pipeline of behavior, I need to tell NServiceBus when to invoke my behavior. I do so by first creating a class that represents the information on how to register this step:

{% gist 5a4610cd1b9d62855785 %}

I tell NServiceBus to insert this step before a well-known step, of loading handlers. I (actually Andreas) picked this point in the pipeline because in doing so, I can modify the services injected into my step. This last piece is configuring and turning on my behavior:

{% gist 1f8b39333ddf4b7af57a %}

I register the Router component, and next the current routing slip. The routing slip instance is pulled from the current context’s routing slip – what I inserted into the context in the previous step.

Finally, I register the route supervisor into the pipeline. With the current routing slip registered as a component, I can allow handlers to access the routing slip and add attachment for subsequent steps:

{% gist 5c70856930ff92679068 %}

With the new pipeline behaviors in place, I was able to remove quite a few hacks to get routing slips to work. Building and registering this new behavior was simple and straightforward, a testament to the design benefits of a behavior pipeline.