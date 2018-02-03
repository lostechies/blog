---
wordpress_id: 228
title: Some IoC Container guidelines
date: 2008-09-12T12:10:20+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/09/12/some-ioc-container-guidelines.aspx
dsq_thread_id:
  - "266390923"
categories:
  - StructureMap
---
So Derick Bailey asked me <strike>the other day</strike> a few weeks ago to describe how we use our IoC container.&nbsp; I wouldn&#8217;t call it &#8220;best practices&#8221;, though some of these tips came from the creator of our container of choice, StructureMap (Jeremy Miller).&nbsp; Although IoC containers are everywhere these days, you don&#8217;t see many instructions on where and how to use them.&nbsp; We&#8217;ve developed a consistent approach to using our favorite container of choice, StructureMap.&nbsp; The basic ideals behind our approach are:

  * Keep the framework at a distance
  * Focus on the [dependency inversion principle](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/03/31/ptom-the-dependency-inversion-principle.aspx)

### Hiding the framework

If you look through one of our projects that use StructureMap, you&#8217;ll be hard pressed to find any usages of StructureMap.&nbsp; In fact, one recent project had exactly one file that used StructureMap.

Just like any framework, littering your code with references and usages can make it nearly impossible to change to a different container.&nbsp; I&#8217;ve heard this quite a bit, that it&#8217;s nice to change the framework you use at any time.&nbsp; This has never actually happened with me, so I&#8217;m still dubious that anyone designing their application to be able to change frameworks at any time, actually has.&nbsp; However, the less we litter our code with the framework, the less impact the framework has on our code. Bending design to accommodate usage can spoil benefits of the framework.

Looking at StructureMap, hiding the framework means preferring the fluent configuration or the xml configuration.&nbsp; With fluent configuration, I get compile-time safety of all my types, and it plays well with refactoring tools like ReSharper.

### Minimize calls to the container

Following the first rule, we shouldn&#8217;t have a lot of calls to our container to instantiate things.&nbsp; Ideally, we would like to reduce our interaction with the service locator (ObjectFactory in StructureMap) to one call to get an instance.&nbsp; We like to relegate the ObjectFactory calls to infrastructure-level code, such as the [IInstanceProvider for WCF](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/07/29/integrating-structuremap-with-wcf.aspx).

Reducing calls to the container from our code also greatly eases the burden in our tests.&nbsp; It&#8217;s possible, but just annoying, to configure the container just for a unit test because our class calls directly into the container.&nbsp; When the ObjectFactory call resides in some infrastructure piece, our entire domain layer can be completely free of any knowledge of the container.&nbsp; While nice from a swappability perspective, its true value lies in a higher cohesion and greater separation of concerns.&nbsp; If I don&#8217;t have to worry about StructureMap calls when I need to change a class, I can focus more on its core purpose.

### Prefer constructor injection

Dependency injection comes in (basically) two flavors:

  * Property injection
  * Constructor injection

Property injection should be used only with optional dependencies.&nbsp; An optional dependency is one that the class will still function properly.&nbsp; Examples of optional dependencies are things like logging frameworks.&nbsp; Constructor injection should be used for required dependencies.&nbsp; A required dependency is one that the class will _not_ function properly without it.

For users of a class, constructor injection through constructor arguments conveys far more meaning for required dependencies.&nbsp; If a dependency is required, then it should be required for instantiation.&nbsp; If you can&#8217;t use a class without a dependency, don&#8217;t let anyone use the class without it.

### Prefer interfaces over abstract classes

This one is another in the &#8220;conveys more meaning&#8221; category.&nbsp; An interface is a contract that conveys a concise set of operations.&nbsp; I can do far more with interfaces than abstract classes, as interfaces support multiple inheritance, while classes do not.&nbsp; If some default behavior is needed, I&#8217;ll supply _an additional_ abstract class that implements the interface.

### Test your configuration

Just like anything else in our system, automated tests find bugs in our configuration much faster and more efficiently than manual testing.&nbsp; Automated tests are also far more reliable, of course.

Typically, we test any interesting configuration.&nbsp; This includes the top-most dependencies in our system (which will then load the entire object graph), as well as any custom configured dependencies.&nbsp; For array dependencies, we test that the class has the correct array with the items in the correct order.&nbsp; Before we tested our configuration, we would get burned with error messages after running the software.&nbsp; With automated tests in place, we have confidence that our container is configured correctly.

### No calls to the container in a test

Unless you&#8217;re testing the container, the container should not show up in your unit test.&nbsp; If we&#8217;re following the first two rules laid out, we don&#8217;t have any work to do.&nbsp; If I need to configure the container for a unit or integration test, it&#8217;s a good sign that I&#8217;m doing something wrong.&nbsp; Configuring the container inside a test is possible, but it muddies the intent of the test.&nbsp; The container then becomes another opaque dependency, which defeats the purpose of using an inversion of control container.

### Guidelines aren&#8217;t rules

Of course, there are always exceptions here.&nbsp; But I always take a second look at my code if I feel it&#8217;s necessary to not follow the above guidelines.&nbsp; It&#8217;s a smell that I&#8217;m probably doing something wrong.