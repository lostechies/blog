---
id: 434
title: Moving containers beyond testability
date: 2010-09-21T16:39:16+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2010/09/21/moving-containers-beyond-testability.aspx
dsq_thread_id:
  - "264716579"
categories:
  - DependencyInjection
---
In Derick Bailey’s [two](http://www.lostechies.com/blogs/derickbailey/archive/2010/09/10/design-and-testability.aspx) [recent](http://www.lostechies.com/blogs/derickbailey/archive/2010/09/14/a-few-thoughts-on-ioc-an-idea-for-a-different-type-of-container-and-a-lot-of-questions.aspx) posts on containers, I found a lot of déjà vu in his sentiments.&#160; In fact, it’s quite similar to the issues that I was running into a while back, trying to [move beyond top-down design](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/05/19/beyond-top-down-design.aspx).

I had become a little disenchanted with my container usage.&#160; I created top-level classes, abstracted dependencies in the form of interfaces, and then filled in implementations.&#160; It works well for test-driven development, as an interface in C# is still the easiest way to provide the shape of what’s needed, before it’s actually implemented.&#160; Classes with virtual members work, but it’s more kludgy and introduces extra steps in the process.

The problem I was running into is that following a strictly top-down approach of building classes, creating interfaces and driving downwards with design is that it still tended to create shape-less architectures.&#160; The issue I finally settled on was that I had been focusing on features, instead of [driving out concepts](http://ayende.com/Blog/archive/2009/03/06/application-structure-concepts-amp-features.aspx).

### 

### The real power of a container

For me, the use of a container really became useful once I moved past strict top-down design and I **embraced the container as a conduit for application composition**.&#160; Containers provide two things well:

  * Dependency injection
  * Inversion of control

Dependency injection is rather simple.&#160; A class specifies what it needs to work simply by exposing these dependencies as constructor arguments.&#160; You can go one step further in using interfaces to represent dependencies, helping with the [Dependency Inversion Principle](http://www.objectmentor.com/resources/articles/dip.pdf).

Inversion of control is a bit larger in its scope.&#160; Instead of just talking about exposing dependencies, IoC means that we remove responsibility for wiring up dependencies from the service requesting or needing them.&#160; We can also go one step further, where we remove responsibility for controlling lifecycle from the service.&#160; This means that if the lifecycle of hte dependency needs to change, we don’t modify the design of the service.&#160; We don’t modify the service to needing a dependency to suddenly needing an IFooFactory.&#160; **We don’t want to let the design of an _implementation_ of a dependency affect the service.**

Finally, we can fully embrace the container by designing our application around architectural concepts, and letting the container wire everything up as needed.&#160; This last piece isn’t helpful unless we start to explore architectural concepts.

### Named instances

Named instances are fantastic when you have a common engine with different plugged in instances.&#160; For example, we have a common batch agent executor.&#160; We have a lot of functionality around running batch jobs, such as logging, monitoring etc.&#160; But the batch agents themselves are not aware of all this.&#160; The IBatchJob interface itself is really just the command pattern:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IBatchJob
</span>{
    <span style="color: blue">void </span>Execute();
}</pre>

[](http://11011.net/software/vspaste)

Very simple, but we can configure StructureMap to use named instances for different implementations.&#160; From the command-line, I can just pass in the name of the instance, “batchjob.exe SomeNamedInstance”, and that specific job will execute.

I’ve separated out the execution of the batch job from the actual work being done, allowing each orthogonal design vector to grow as needed.&#160; When you can completely change the design of one aspect without affecting another, that’s an orthogonal design.&#160; It’s easy for me to add any additional logging, exception handling, health monitoring and so on without touching **any** of the batch jobs executed.

### Dependency lifecycle

Dependency lifecycle can be tricky.&#160; In many applications, some dependencies need to be tied to a certain scope, whether it’s:

  * Per-request
  * Http context
  * Singleton
  * Per-call
  * Contextual

If as my dependencies’ lifecycle changed I needed to modify every single class that _used_ that dependency, I’d run into some real problems.&#160; Most often it’s not the abstraction itself that needs a specific lifecycle, but a single implementation.&#160; One common example is around a unit of work or NHibernate’s ISession.&#160; Depending on the context (in a test, on the web, in a batch job), I have many different needs for the lifecycle of ISession.

However, I don’t want to change the design of the service just because I have different needs for the _implementation_ of ISession.&#160; Providing some kind of IFooFactory for the complications of lifecycle management leaks the concerns of specific implementations into the service.

### Abstracting procedural code

One common concept in applications is the idea of many things needing to run at startup.&#160; Whether it’s defining routes, loading up NHibernate configuration, scanning for MVC areas, these are all things that only happen once per AppDomain.

Instead of having a bunch of procedural code in the application startup area, we can instead define the concept of a startup task:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IStartupTask
</span>{
    <span style="color: blue">void </span>Execute();
}</pre>

[](http://11011.net/software/vspaste)

It’s our old friend the command pattern again.&#160; But this time, instead of requesting a specific named instance, we’ll ask our container for _all_ instances.&#160; Then it’s just a matter of looping through the instances and executing them one by one.

Similar to the batch job example, each startup task is very atomic in its responsibilities.&#160; If we need to enhance the concept of executing startup tasks, we again do not need to modify each task.

### Pluggable strategies

One common pattern we get a lot of mileage out of are self-selecting strategies.&#160; We did this in our implementation of input builders and model binders, where we defined a very simple interface:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IInputBuilder
</span>{
    <span style="color: blue">bool </span>IsMatch(<span style="color: #2b91af">InputBuilderContext </span>context);
    <span style="color: blue">string </span>Build(<span style="color: #2b91af">InputBuilderContext </span>context);
}</pre>

[](http://11011.net/software/vspaste)

The first input builder that matched was the one that got built.&#160; Unlike the MVC implementation, there was no need to hard-code the conventions or rules on which input builder was chosen.&#160; Instead, the first one that matched was chosen, and we only needed to define the precedence in a single list in our container configuration.

If we want all strategies to have a crack at processing, that’s the [chain of responsibility pattern](http://www.dofactory.com/Patterns/PatternChain.aspx), easily accomplished with a container.&#160; Instead of finding the first service that matches, we just loop through them all, executing them all in turn.

### Enrichment with decorators

One issue we ran into recently was that a message handling execution engine that didn’t have a plugin point for exception logging.&#160; It did, however, allow for a plugin point for instantiating the handlers.&#160; With a single line of configuration code, we were able to add exception logging to all implementations of IHandler<T>, without needing to change any implementation.

The logging handler was just a simple try-catch, executing the inner composed handler using a decorator pattern.&#160; But because the logging handler had _its_ own dependencies, we were again able to take advantage of the container for wiring everything up.

Another example of allowing different orthogonal design vectors to change without affecting each other.&#160; None of the handlers needed to change, but using the container to instantiate allowed me to enrich their behavior with decorators without modifying each individual handler.

### Wrapping it up

Containers provide a fantastic pinch point for composing applications together.&#160; When I started harnessing design patterns through the container, I felt I really achieved that “Inversion of Control” sweet spot that truly allowed for orthogonal design.&#160; It wasn’t anything very different in the structure of my code, I still programmed against interfaces.&#160; But by combining design patterns with container usage, I grew my use of the container far beyond just the “enabling testability” that dependency injection initially allows.