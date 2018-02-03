---
wordpress_id: 946
title: Tackling cross-cutting concerns with a mediator pipeline
date: 2014-09-09T16:17:49+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=946
dsq_thread_id:
  - "3002479506"
categories:
  - Architecture
  - Design
  - DomainDrivenDesign
---
> Originally [posted on the Skills Matter website](http://blog.skillsmatter.com/2014/08/29/one-model-in-one-model-out/)

In most of the projects I’ve worked on in the last several years, I’ve put in place a mediator to manage the delivery of messages to handlers. I’ve covered the [motivation behind such a pattern in the past](http://lostechies.com/jimmybogard/2013/12/19/put-your-controllers-on-a-diet-posts-and-commands/), where it works well and where it doesn’t.

One of the advantages behind the [mediator pattern](http://en.wikipedia.org/wiki/Mediator_pattern) is that it allows the application code to define a pipeline of activities for requests, as opposed to embedding this pipeline in other frameworks such as Rails, node.js, ASP.NET Web API and so on. These frameworks have many other concerns going on besides the very simple “one model in, one model out” pattern that so greatly simplifies conceptualizing the system and realizing more powerful patterns.

As a review, a mediator encapsulates how a series of objects interact. Our mediator looks like:

[gist id=d0e6dd08f6f9042d3715]

This is from a simple library ([MediatR](https://github.com/jbogard/MediatR)) I created (and borrowed heavily from others) that enables basic message passing. It facilitates loose coupling between how a series of objects interact. And like many OO patterns, it exists because of missing features in the language. In other functional languages, passing messages to handlers is accomplished with features like pattern matching.

Our handler interface represents the ability to take an input, perform work, and return some output:

[gist id=c6c28bdf8051a04dcfb9]

With this simple pattern, we encapsulate the work being done to transform input to output in a single method. Any complexities around this work are encapsulated, and any refactorings are isolated to this one method. As systems become more complex, isolating side-effects becomes critical for maintaining overall speed of delivery and minimizing risk.

We still have the need for cross-cutting concerns, and we’d rather not pollute our handlers with this work.

These surrounding behaviors become implementations of the [decorator pattern](http://en.wikipedia.org/wiki/Decorator_pattern). Since we have a uniform interface of inputs and outputs, building decorators around cross-cutting concerns becomes trivial.

### Pre- and post-request handlers

One common request I see is to do work on the requests coming in, or post-process the request on the way out. We can define some interfaces around this:

[gist id=f1686afbddea1cbea282]

With this, we can modify inputs before they arrive to the main handler or modify responses on the way out.

In order to execute these handlers, we just need to define a decorator around our main handler:

[gist id=c2e33d125c4a1eab40e5]

And if we’re using a modern IoC container (StructureMap in this case), registering our decorator is as simple as:

[gist id=bddd83786f08dc26b1bf]

When our mediator builds out the handler, it delegates to our container to do so. Our container builds the inner handler, then surrounds the handler with additional work. If this seems familiar, many modern web frameworks like [koa](http://koajs.com/) include a similar construct using continuation passing to define a pipeline for requests. However, since our pipeline is defined in our application layer, we don’t have to deal with things like HTTP headers, content negotiation and so on.

### Validation

Most validation frameworks I use validate against a type, whether it’s validation with attributes or delegated validation to a handler. With [Fluent Validation](https://fluentvalidation.codeplex.com/), we get a very simple interface representing validating an input:

[gist id=f769d5a25b0ea5164f23]

Fluent Validation defines base classes for validators for a variety of scenarios:

[gist id=141ee2df995a7451443a]

We can then plug our validation to the pipeline as occurring before the main work to be done:

[gist id=1cad86869b41a954aec2]

In our validation handler, we perform validation against Fluent Validation by loading up all of the matching validators. Because we have generic variance in C#, we can rely on the container to inject all validators for all matching types (base classes and interfaces). Having validators around messages means we can remove validation from our entities, and into contextual actions from a task-oriented UI.

### Framework-less pipeline

We can now push a number of concerns into our application code instead of embedded as framework extensions. This includes things like:

  * Validation 
      * Pre/post processing 
          * Authorization 
              * Logging 
                  * Auditing 
                      * Event dispatching 
                          * Notifications 
                              * Unit of work/transactions</ul> 
                            Pretty much anything you’d consider to use a Filter in ASP.NET or Rails that’s more concerned with application-level behavior and not framework/transport specific concerns would work as a decorator in our handlers.
                            
                            Once we have this approach set up, we can define our application pipeline as a series of decorators around handlers:
                            
                            [gist id=e6bb5c513846a9d889b0]
                            
                            Since this code is not dependent on frameworks or HTTP requests, it’s easy for us to build up a request, send it through the pipeline, and verify a response:
                            
                            [gist id=b8e7bc7b0e20c6561d18]
                            
                            Or if we just want one handler, we can test that one implementation in isolation, it’s really up to us.
                            
                            By focusing on a uniform interface of one model in, one model out, we can define a series of patterns on top of that single interface for a variety of cross-cutting concerns. Our behaviors become less coupled on a framework and more focused on the real work being done.
                            
                            All of this would be a bit easier if the underlying language supported this behavior. Since many don’t, we rely instead of translating these functional paradigms to OO patterns with IoC containers containing our glue.