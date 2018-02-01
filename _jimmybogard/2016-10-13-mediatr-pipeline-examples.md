---
id: 1229
title: MediatR Pipeline Examples
date: 2016-10-13T19:02:02+00:00
author: Jimmy Bogard
layout: post
guid: https://lostechies.com/jimmybogard/?p=1229
dsq_thread_id:
  - "5220840957"
categories:
  - MediatR
---
A while ago, I blogged about [using MediatR to build a processing pipeline](https://lostechies.com/jimmybogard/2014/09/09/tackling-cross-cutting-concerns-with-a-mediator-pipeline/) for requests in the form of commands and queries in your application. [MediatR](https://github.com/jbogard/mediatr) is a library I built (well, extracted from client projects) to help organize my architecture into a CQRS architecture with distinct messages and handlers for every request in your system.

So when processing requests gets more complicated, we often rely on a mediator pipeline to provide a means for these extra behaviors. It doesn’t always show up – I’ll start without one before deciding to add it. I’ve also not built it in directly to MediatR&nbsp; &#8211; because frankly, it’s hard and there are existing tools to do so with modern DI containers. First, let’s look at the simplest pipeline that could possible work:

[gist id=771c99ae40345ebea0f21b8f04207932]

Nothing exciting here, it just calls the inner handler, the real handler. But we have a baseline that we can layer on additional behaviors.

Let’s get something more interesting going!

### Contextual Logging and Metrics

Serilog has an interesting feature where it lets you define contexts for logging blocks. With a pipeline, this becomes trivial to add to our application:

[gist id=fb02edc5387ce53b1ad91ec370c504ea]

In our logs, we’ll now see a logging block right before we enter our handler, and right after we exit. We can do a bit more, what about metrics? Also trivial to add:

[gist id=b5eec3ffe7cf21819c7ebbec5340a30a]

That Time class is just a simple wrapper around the .NET Timer classes, with some configuration checking etc. Those are the easy ones, what about something more interesting?

### Validation and Authorization

Often times, we have to share handlers between different applications, so it’s important to have an agnostic means of cross-cutting concerns. Rather than bury our concerns in framework or application-specific extensions (like, say, an action filter), we can instead embed this behavior in our pipeline. First, with validation, we can use a tool like Fluent Validation with validator handlers for a specific type:

[gist id=e4bc511dba4304d39b0aa6abc45c1612]

What’s interesting here is that our message validator is contravariant, meaning I can have a validator of a base type work for messages of a derived type. That means we can declare common validators for base types or interfaces that your message inherits/implements. In practice this lets me share common validation amongst multiple messages simply by implementing an interface.

Inside my pipeline, I can execute my validation my taking a dependency on the validators for my message:

[gist id=473abe269278a3f8d9b55b8913f39d3e]

And bundle up all my errors into a potential exception thrown. The downside of this approach is I’m using exceptions to provide control flow, so if this is a problem, I can wrap up my responses into some sort of Result object that contains potential validation failures. In practice it seems fine for the applications we build.

Again, my calling code INTO my handler (the Mediator) has no knowledge of this new behaviors, nor does my handler. I go to one spot to augment and extend behaviors across my entire system. Keep in mind, however, I still place my validators beside my message, handler, view etc. using feature folders.

Authorization is similar, where I define an authorizer of a message:

[gist id=a423976c9a0dc914183f7354c19003df]

Then in my pipeline, check authorization:

[gist id=2e119767eb28b3d6f17b373c5aa709fa]

The actual implementation of the authorizer will go through a series of security rules, find matching rules, and evaluate them against my request. Some examples of security rules might be:

  * Do any of your roles have permission?
  * Are you part of the ownership team of this resource?
  * Are you assigned to a special group that this resource is associated with?
  * Do you have the correct training to perform this action?
  * Are you in the correct geographic location and/or citizenship?

Things can get pretty complicated, but again, all encapsulated for me inside my pipeline.

Finally, what about potential augmentations or reactions to a request?

### Pre/post processing

In addition to some specific processing needs, like logging, metrics, authorization, and validation, there are things I can’t predict one message or group of messages might need. For those, I can build some generic extension points:

[gist id=d08bf6fb52b79f05f2cbcef702ec09d6]

Next I update my pipeline to include calls to these extensions (if they exist):

[gist id=1459a48f7203c33b6ea9f856c684259d]

So what kinds of things might I accomplish here?

  * Supplementing my request with additional information not to be found in the original request (in one case, barcode sequences)
  * Data cleansing or fixing (for example, a scanned barcode needs padded zeroes)
  * Limiting results of paged result models via configuration
  * Notifications based on the response

All sorts of things that I could put inside the handlers, but if I want to apply a general policy across many handlers, can quite easily be accomplished.

Whether you have specific or generic needs, a mediator pipeline can be a great place to apply domain-centric behaviors to all requests, or only matching requests based on generics rules, across your entire application.