---
id: 564
title: Is ThreadStatic a leaky abstraction?
date: 2011-12-07T14:54:20+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2011/12/07/is-threadstatic-a-leaky-abstraction/
dsq_thread_id:
  - "496497895"
categories:
  - DependencyInjection
  - Design
---
Reading Ayende’s post on [integrating Rhino Service Bus and RavenDB](http://ayende.com/blog/143361/rhino-service-bus-amp-ravendb-integration), one thing that caught my eye was the use of the [ThreadStatic attribute](http://msdn.microsoft.com/en-us/library/system.threadstaticattribute.aspx) to control the lifecycle of a private field:

[gist]https://gist.github.com/1443003[/gist] 

One of the things that really bothers me about an implementation like this is that intimate knowledge of the threading model of Rhino Service Bus is required to properly implement an IMessageModule implementation properly. The CurrentSession property is static, yet the IDocumentStore member is an instance field. Why does an implementer of a message module need to be concerned about lifecycle of its dependencies?

I don’t really think it should – lifecycle of a dependency should at most be the responsibility of the dependency itself. Or even better, the responsibility of the container. Dependencies shouldn’t care _where_ they are used, because that knowledge would violate the whole “D” in SOLID.

Instead, I’d much rather see something like [FubuMVC](http://mvc.fubu-project.org/) behaviors. Here’s one with NHibernate to have a session always part of a request there:

[gist]https://gist.github.com/1443059[/gist] 

Note that the behavior doesn’t care about the lifecycle of itself. That’s completely managed by the FubuMVC infrastructure, it’s completely unimportant to the implementor. Then when it comes time to actually _create_ a session, it looks like:

[gist]https://gist.github.com/1443065[/gist]

In the code above, the behavior chain sets a contextual dependency on the IFubuRequest, which, through the magic of child and nested containers, ensures that subsequent behaviors in the execution pipeline have the correct injected ISession from NHibernate. Nowhere in this code do you see any sort of lifecycle management.

The most you see is things like Lazy and in code that uses the dependency, perhaps a lazy Func<T>. But these are only in place because consumers want to direct the scope, not lifecycle.

Lifecycle of dependencies is best served in the framework. Barring that, the container configuration. Consumers and dependencies do not need to change their design to accommodate the lifecycle constraints of the hosted environment. Pushing that into these pieces leaks the abstraction of the hosting environment.