---
wordpress_id: 887
title: Successful IoC container usage
date: 2014-03-20T14:08:16+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=887
dsq_thread_id:
  - "2469202537"
categories:
  - DependencyInjection
  - OO
---
Every now and again I here the meme of IoC containers being bad, they lead to bad developer practices, they’re too complicated and on and on. IoC containers – like any sharp tool – can be easily abused. Dependency injection, as a concept, is here to stay. Heck, it’s even in [Angular](http://docs.angularjs.org/guide/di).

Good usage of IoC containers goes hand in hand with good OO design. Dependency injection won’t make your design better, but it can enable better design.

So what do I use IoC containers for? First and foremost, dependency injection. If I have a 3rd-party dependency, I’ll inject it. This enables me to swap implementations or isolate that dependency behind a [façade](http://www.dofactory.com/Patterns/PatternFacade.aspx). Additionally, if I want to provide different configurations of that component for different environments, dependency injection allows me to modify that behavior without modifying services using that component.

I am, however, very judicious in my facades. I don’t wrap 3rd party libraries, like a Repository does with your DbContext or ISession. If a library needs simplification or unification (Adapter pattern), that’s where wrapping the dependency helps.

I also don’t create deep compositional graphs. I don’t get stricken with service-itis, where every function has to have an IFooService and FooService implementation.

Instead, I focus on capturing concepts in my application. In one I’m looking at, I have concepts for:

  * Queries
  * Commands
  * Validators
  * Notifications
  * Model binders
  * Filters
  * Search providers
  * PDF document generators
  * Search providers
  * REST document readers/writers

Each of these has multiple implementers of a common interface, often as a generic interface. These are all examples of the good OO design patterns – the behavioral patterns, including:

  * Chain of responsibility
  * Command
  * Mediator
  * Strategy
  * Visitor

I strive to find concepts in my system, and build abstractions around those concepts. The [IModelBinderProvider](http://msdn.microsoft.com/en-us/library/system.web.mvc.imodelbinderprovider(v=vs.118).aspx) interface, for example, is a chain of responsibility implementation, where we have a concept of providing a model binder based on inputs, and each provider deciding to provide a model binder (or not).

The final usage is around lifecycle/lifetime management. This is much easier if you have a container and ecosystem that provides explicit scoping using child/nested containers. Web API for example has an “[IDepedencyScope](http://www.asp.net/web-api/overview/extensibility/using-the-web-api-dependency-resolver)” which acts as a [composition root](http://blog.ploeh.dk/2011/07/28/CompositionRoot/) for each request. I either have singleton components, composition root-scoped components (like your DbContext/ISession), or resolve-scoped components (instantiated once per call to Resolve).

Ultimately, successful container usage comes down to proper OO, limiting abstractions and focusing on concepts. Composition can be achieved in many forms – often supported directly in the language, such as pattern matching or mixins – but no language has it perfect so being able to still rely on dependency injection without a lot of fuss can be extremely powerful.