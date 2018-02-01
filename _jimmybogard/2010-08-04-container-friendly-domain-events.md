---
id: 425
title: Container-friendly domain events
date: 2010-08-04T02:40:23+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2010/08/03/container-friendly-domain-events.aspx
dsq_thread_id:
  - "264716567"
categories:
  - DomainDrivenDesign
---
A lot of times an operation on a single aggregate root needs to result in side effects that are outside the aggregate root boundary.&#160; There are several ways to accomplish this, such as:

  * A return parameter on the method
  * A collecting parameter
  * [Domain events](http://www.udidahan.com/2009/06/14/domain-events-salvation/)

We’ve used the default implementation of domain events for quite a while, but with some recent applications I’ve worked on, we’ve noticed one small design issue:

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">DomainEvents
</span></pre>

[](http://11011.net/software/vspaste)

It’s that big ol’ “static” piece.&#160; Domain events are then raised explicitly by calling this static method, Raise:

<pre><span style="color: blue">public static </span><span style="color: #2b91af">IHandlerContainer </span>Container { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }

<span style="color: blue">public static void </span>Raise&lt;TEvent&gt;(TEvent args) <span style="color: blue">where </span>TEvent : <span style="color: #2b91af">IDomainEvent
</span>{
    <span style="color: blue">if </span>(Container != <span style="color: blue">null</span>)
        Container.GetAllHandlers&lt;TEvent&gt;()
            .Cast&lt;<span style="color: #2b91af">IHandler</span>&lt;TEvent&gt;&gt;()
            .ForEach(x =&gt; x.Handle(args));</pre>

[](http://11011.net/software/vspaste)

Where Container in this case is just a facade over an IoC container.&#160; The silly Cast is from this being C# 3.0 code, the contravariance of C# 4.0 would fix this.&#160; Again, another design issue here.&#160; The reference to the container is static.&#160; This means that more powerful container patterns such as nested containers are out of the picture.&#160; This is too bad, because nested containers are another great tool in the toolbox that lets us delete a lot of code that sets up contexts for things.

The problem here is that I still want to raise events in a static manner from an entity.&#160; I don’t want to have to reference some event pipeline object thingy in my domain objects, and I’m really not keen to start injecting things.&#160; Instead, I want a true, fire-and-forget event.

### 

### Contextual containers and disposable actions

What I need to do is allow this static method to work with a contextual, scoped piece of code.&#160; But that’s _exactly_ what the “using” statement allows us to do – create a scoped piece of code, that executes something at the beginning (whatever creates the IDisposable) and something at the end (the Dispose method).

To help us create this scoped context to slip in our nested container, we can take advantage of Ayende’s most brilliant piece of code ever written, the [DisposableAction](http://ayende.com/Blog/archive/2005/12/07/TheUltimateDisposable.aspx):

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DisposableAction </span>: <span style="color: #2b91af">IDisposable
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">Action </span>_callback;

    <span style="color: blue">public </span>DisposableAction(<span style="color: #2b91af">Action </span>callback)
    {
        _callback = callback;
    }

    <span style="color: blue">public void </span>Dispose()
    {
        _callback();
    }
}</pre>

[](http://11011.net/software/vspaste)

I can then just implement a simple method on the DomainEvents class to allow me to swap out – and then restore – the container reference:

<pre><span style="color: blue">public static </span><span style="color: #2b91af">IDisposable </span>CreateContext(<span style="color: #2b91af">IHandlerContainer </span>container)
{
    <span style="color: blue">var </span>existingContainer = Container;
    Container = container;

    <span style="color: blue">return new </span><span style="color: #2b91af">DisposableAction</span>(() =&gt;
    {
        Container = existingContainer;
    });
}</pre>

[](http://11011.net/software/vspaste)

I keep a reference around to the previous container, then swap out the DomainEvents’ container for the one passed in.&#160; When this CreateContext is finished, the DisposableAction restores the previous container with a handy closure.

So how do I use this in real code?&#160; Something like:

<pre><span style="color: blue">public void </span>Process&lt;T&gt;(T message) <span style="color: blue">where </span>T : <span style="color: #2b91af">IMessage
</span>{
    <span style="color: blue">using </span>(<span style="color: blue">var </span>nestedContainer = _container.GetNestedContainer())
    <span style="color: blue">using </span>(<span style="color: blue">var </span>unitOfWork = <span style="color: blue">new </span><span style="color: #2b91af">UnitOfWork</span>(_sessionSource))
    <span style="color: blue">using </span>(<span style="color: #2b91af">DomainEvents</span>.CreateContext(<span style="color: blue">new </span><span style="color: #2b91af">HandlerContainer</span>(nestedContainer)))</pre>

[](http://11011.net/software/vspaste)

I have several scoped items I’m using to process a message (part of a batch processing program).&#160; Each line in a file gets processed as a single message, with its own unit of work, its own container etc.&#160; It’s now very plain to see the context I create to process the message because I just use the C# feature that creates bounded, self-cleaning contexts: the “using” statement.

This method still isn’t thread-safe, as it still has static elements.&#160; I’ve just allowed a scoped, nested container to be used instead of a single, global static ontainer.&#160; Some folks mentioned patterns like event aggregators, so there are likely other patterns that can help out with the static nature of this domain events pattern.&#160; But for now, I can harness the power and simplicity of nested containers, and keep my handy domain events around as well.