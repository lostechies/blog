---
wordpress_id: 377
title: 'Advanced StructureMap: connecting implementations to open generic types'
date: 2009-12-18T04:03:41+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/12/17/advanced-structuremap-connecting-implementations-to-open-generic-types.aspx
dsq_thread_id:
  - "264716377"
categories:
  - StructureMap
redirect_from: "/blogs/jimmy_bogard/archive/2009/12/17/advanced-structuremap-connecting-implementations-to-open-generic-types.aspx/"
---
One pattern we’re starting to see more and more is the idea of connecting messages to handlers.&#160; These messages might be domain command messages, [ActionResult messages](https://lostechies.com/blogs/jimmy_bogard/archive/2009/12/12/enabling-ioc-in-asp-net-actionresults-or-a-better-actionresult.aspx), and more.&#160; Beyond messaging implementations, we start to see a more basic pattern start to emerge.&#160; We have some interface describing a contract that happens to be generic:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IFooService</span>&lt;T&gt;
{
    <span style="color: blue">void </span>DoSomething(<span style="color: blue">int </span>value, T foo);
}</pre>

[](http://11011.net/software/vspaste)

Now, if we weren’t doing IoC, and we needed a specific FooService for some type T, we’d have to know which type to get.&#160; But you might start to see situations where you need an IFooService<T>, but you don’t really care about the T specifically:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">SomethingThatUsesFoo</span>&lt;T&gt;
{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IFooService</span>&lt;T&gt; _service;

    <span style="color: blue">public </span>SomethingThatUsesFoo(<span style="color: #2b91af">IFooService</span>&lt;T&gt; service)
    {
        _service = service;
    }

    <span style="color: blue">public void </span>SomethingSpecific(T value)
    {
        _service.DoSomething(4, value);
    }
}</pre>

[](http://11011.net/software/vspaste)

As you start to build more and more generic components, building out common infrastructure components, you’ll start to build more common services like these, that coordinate between a messages and their handlers.&#160; In most cases like these, we’re not using generics for type safety, but rather for metadata to match up input types to output services.&#160; A more concrete example on a real project looks like this:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IHandler</span>&lt;TEvent&gt; 
{
    <span style="color: blue">void </span>Handle(TEvent args);
}</pre>

[](http://11011.net/software/vspaste)

This is an interface for [domain events](http://www.udidahan.com/2009/06/14/domain-events-salvation/), where we’ll have handlers like:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">OrderCanceledEvent
    </span>: <span style="color: #2b91af">IHandler</span>&lt;<span style="color: #2b91af">OrderCanceledMessage</span>&gt;
{
    <span style="color: blue">public void </span>Handle(<span style="color: #2b91af">OrderCanceledMessage </span>args)
    {
        <span style="color: green">// send an email or something
    </span>}
}</pre>

[](http://11011.net/software/vspaste)

Now the trick is, how do we instruct our Inversion of Control container to locate the right handler for the right event?&#160; If you’re using StructureMap, it’s dirt, dirt simple.

### Configuring StructureMap

Because we’re using StructureMap, we’ll be using a custom Registry to do our configuration.&#160; To connect implementations, we want to make sure that any time we ask StructureMap for an IHandler<T>, it finds the concrete type of handler T.&#160; In the above example, our common message routing code will ask for an IHandler<OrderCanceledMessage>, and the type located needs to be OrderCanceledEvent, because OrderCanceledEvent implements the IHandler<OrderCanceledMessage>.

Our Registry winds up being very simple:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">HandlerRegistry </span>: <span style="color: #2b91af">Registry
</span>{
    <span style="color: blue">public </span>HandlerRegistry()
    {
        Scan(cfg =&gt;
        {
            cfg.TheCallingAssembly();
            cfg.IncludeNamespaceContainingType&lt;<span style="color: #2b91af">OrderCanceledEvent</span>&gt;();
            cfg.ConnectImplementationsToTypesClosing(<span style="color: blue">typeof</span>(<span style="color: #2b91af">IHandler</span>&lt;&gt;));
        });
    }
}</pre>

[](http://11011.net/software/vspaste)

To connect implementations to our open generic type of IHandler<T>, we use the ConnectImplementationsToTypesClosing method.&#160; The other two are just directions telling StructureMap where to look for my handlers.&#160; Typically, my registration code lives in the same assembly as the actual interfaces I’m registering, but you can also register by name.

But that’s it!&#160; Very simple, one line to connect all of the handlers to their implementations.&#160; I can verify this with a simple test:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_connect_types()
{
    <span style="color: #2b91af">ObjectFactory</span>.Initialize(init =&gt;
    {
        init.AddRegistry&lt;<span style="color: #2b91af">HandlerRegistry</span>&gt;();
    });

    <span style="color: #2b91af">ObjectFactory</span>.AssertConfigurationIsValid();

    <span style="color: #2b91af">Debug</span>.WriteLine(<span style="color: #2b91af">ObjectFactory</span>.WhatDoIHave());

    <span style="color: blue">var </span>handler = <span style="color: #2b91af">ObjectFactory</span>.GetInstance&lt;<span style="color: #2b91af">IHandler</span>&lt;<span style="color: #2b91af">OrderCanceledMessage</span>&gt;&gt;();

    handler.ShouldBeInstanceOf&lt;<span style="color: #2b91af">OrderCanceledEvent</span>&gt;();
}</pre>

[](http://11011.net/software/vspaste)

This test passes, and all is well in IoC land.

### Embracing the container

At some point, users of IoC learn to stop caring and love the <strike>bomb</strike> container.&#160; In our system, we have no less than _ten_ usages of this method, meaning we have refactored a lot of common plumbing and coordinators into our infrastructure layer.&#160; We can easily add new handlers, mappers, repositories, providers, commands, builders, invokers, etc., all with one line of configuration for each open type (NOT one per derived type/implementation).&#160; It certainly opens the doors to new possibilities of separation of concerns between different pieces, we just happen to lean on the type system to route our information around.

Something to note here is that at no time did I need to describe the implementors.&#160; StructureMap’s scanner merely found implementations of types closing IHandler<T>, and connected that concrete type to the requested type of IHandler<SpecificType>.&#160; I’ve taken a look at the other containers, and frankly, I haven’t found any that match this level of simplicity in configuration.&#160; But I’m not an expert on the other containers, so I’d love to be proven wrong!

Regardless, I absolutely love this pattern of usage in IoC.&#160; It promotes a level of SOLID design that’s pretty tough to beat.&#160; When folks talk about IoC only being useful in large or complex projects, I just don’t understand it.&#160; Usages like this give me Separation of Concerns from the get-go, at almost zero cost.&#160; If only [other frameworks](http://www.asp.net/mvc/) were [built with this in mind](http://code.google.com/p/fubumvc/)…