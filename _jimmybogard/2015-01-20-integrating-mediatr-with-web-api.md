---
id: 1034
title: Integrating MediatR with Web API
date: 2015-01-20T17:25:16+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=1034
dsq_thread_id:
  - "3438747321"
categories:
  - MediatR
---
One of the design goals I had in mind with MediatR was to limit the 3rd party dependencies (and work) needed to integrate MediatR. To do so, I only take a dependency on [CommonServiceLocator](https://commonservicelocator.codeplex.com/). In MediatR, I need to resolve instances of request/notification handlers. Rather than build my own factory class that others would need to implement, I lean on CSL to define this interface:

[gist id=04345b1e8bed22513107]

But that wasn’t quite enough. I also wanted to support child/nested containers, which meant I didn’t want a single instance of the IServiceLocator. Typically, when you want a component’s lifetime decided by a consumer, you depend on Func<Foo>. It turns out though that CSL already defines a delegate to provide a service locator, aptly named ServiceLocatorProvider:

[gist id=bc71ea350f0ddf176cbf]

In resolving handlers, I execute the delegate to get an instance of an IServiceLocatorProvider and off we go. I much prefer this approach than defining my own yet-another-factory-interface for people to implement. Just not worth it. As a consumer, you will need to supply this delegate to the mediator.

I’ll show an example using StructureMap. The first thing I do is add a NuGet dependency to the Web API IoC shim for StructureMap:

**Install-Package StructureMap.WebApi2**

This will also bring in the CommonServiceLocator dependency and some files to shim with Web API:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2015/01/image_thumb14.png" width="310" height="135" />](http://lostechies.com/jimmybogard/files/2015/01/image14.png)

I have the basic building blocks for what I need in order to have a Web API project using StructureMap. The next piece is to configure the DefaultRegistry to include handlers in scanning:

[gist id=36db28b43b450ec6701d]

This is pretty much the same code you’d find in any of the samples in the MediatR project. The final piece is to hook up the dependency resolver delegate, ServiceLocatorProvider. Since most/all containers have implementations of the IServiceLocator, it’s really about finding the place where the underlying code creates one of these IServiceLocator implementations and supplies it to the infrastructure. In my case, there’s the Web API IDependencyResolver implementation:

[gist id=b86d35c3f466fd3baea8]

I modify this to use the current nested container and attach the resolver to this:

[gist id=3cb040e0eba4eed3bcda]

This is also the location where I’ll attach per-request dependencies (NHibernate, EF etc.). Finally, I can use a mediator in a controller:

[gist id=e1e7be4fbfcde9cf0264]

That’s pretty much it. How you need to configure the mediator in your application might be different, but the gist of the means is to configure the ServiceLocatorProvider delegate dependency to return the “thing that the framework uses for IServiceLocator”. What that is depends on your context, and unfortunately changes based on every framework out there.

In my example above, I’m preferring to configure the IServiceLocator instance to be the same instance as the IDependencyScope instance, so that any handler instantiated is from the same composition root/nested container as whatever instantiated my controller.

See, containers are easy, right?

(crickets)