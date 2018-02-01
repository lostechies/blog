---
id: 381
title: 'Advanced StructureMap: custom registration conventions for partially closed types'
date: 2010-01-07T16:59:23+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2010/01/07/advanced-structuremap-custom-registration-conventions-for-partially-closed-types.aspx
dsq_thread_id:
  - "264995067"
categories:
  - StructureMap
---
A while back, I highlighted an issue we ran into where I had basically [partially closed generic types](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/09/01/partially-closed-generic-types.aspx).&#160; A common pattern in message- and command-based architectures is the concept of a handler for a message:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IHandler</span>&lt;TEvent&gt;
{
    <span style="color: blue">void </span>Handle(TEvent args);
}</pre>

[](http://11011.net/software/vspaste)

It’s a pattern with many names, but the basic concept is to separate the execution of a command from the representation of a command.&#160; We use it with our ActionResult objects, command messages and lots of other places where creating a parameter object separate from the method _using_ the parameter object provides a great benefit.&#160; But as we used this pattern more and more, we would start to see duplication around certain types of commands.&#160; For example, we might have a command to delete a customer:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DeleteCustomerCommand
</span>{
    <span style="color: blue">public </span>DeleteCustomerCommand(<span style="color: #2b91af">Customer </span>customer)
    {
        Customer = customer;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">Customer </span>Customer { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

And the implementation is fairly straightforward:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DeleteCustomerCommandHandler </span>: <span style="color: #2b91af">IHandler</span>&lt;<span style="color: #2b91af">DeleteCustomerCommand</span>&gt;
{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICustomerRepository </span>_customerRepository;

    <span style="color: blue">public </span>DeleteCustomerCommandHandler(<span style="color: #2b91af">ICustomerRepository </span>customerRepository)
    {
        _customerRepository = customerRepository;
    }

    <span style="color: blue">public void </span>Handle(<span style="color: #2b91af">DeleteCustomerCommand </span>args)
    {
        _customerRepository.Delete(args.Customer);
    }
}</pre>

[](http://11011.net/software/vspaste)

That’s all fine and dandy, but now I have to create another handler for every. single. entity. type. in. the. world.&#160; That’s duplication I’d like to avoid, especially since it provides absolutely zero value (other than extra code I have to maintain).&#160; Instead, I’d like to define a generalized command:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DeleteCommand</span>&lt;TEntity&gt;
{
    <span style="color: blue">public </span>DeleteCommand(TEntity entity)
    {
        Entity = entity;
    }

    <span style="color: blue">public </span>TEntity Entity { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

Now I only need to define a generic handler for this command:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DeleteEntityCommandHandler</span>&lt;TEntity&gt; : <span style="color: #2b91af">IHandler</span>&lt;<span style="color: #2b91af">DeleteEntityCommand</span>&lt;TEntity&gt;&gt;
{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IRepository</span>&lt;TEntity&gt; _repository;

    <span style="color: blue">public </span>DeleteEntityCommandHandler(<span style="color: #2b91af">IRepository</span>&lt;TEntity&gt; repository)
    {
        _repository = repository;
    }

    <span style="color: blue">public void </span>Handle(<span style="color: #2b91af">DeleteEntityCommand</span>&lt;TEntity&gt; args)
    {
        _repository.Delete(args.Entity);
    }
}</pre>

[](http://11011.net/software/vspaste)

Up to this point, I’ve shown nothing new that I didn’t already have in that previous open generics post.&#160; The trick now is to hook up the right handler to the right message.&#160; In the [last StructureMap post](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/12/17/advanced-structuremap-connecting-implementations-to-open-generic-types.aspx), I showed how to hook up IHandler<T> to the concrete implementation.&#160; But in this case, I don’t have a concrete implementation.&#160; I will request an IHandler<DeleteEntityCommand<Customer>> or Order or whatever, and I need to wire up a new concrete type, DeleteEntityCommandHandler<Customer> (or Order or whatever).

Because I have the issue where I don’t know the concrete type until it’s requested, I need to tell my IoC Container of choice (StructureMap) how to handle these requests.

### 

### Creating a custom registration convention

Quick note on StructureMap – internally, concrete types are matched up to requested types through configuration.&#160; StructureMap does a great job at reducing the amount of configuration through registration conventions, registries and configuration, but I still have to match up every concrete service type to a requested type.&#160; StructureMap (I believe) doesn’t let you wait until a type is requested to find its implementation, it already needs to know it beforehand.

So how does that affect me?&#160; For one, I only have one implementation, but it’s generic.&#160; I could literally have as many closed generic implementations as there are entities in my system, because each will get its own (correct) repository implementation.

The interesting thing about the “ConnectImplementationsToTypesClosing” method I highlighted last time is that this is actually just a helper method to use an existing IRegistrationConvention (previously TypeScanner in 2.5.3 and earlier).&#160; The IRegistrationConvention is a fairly simple interface:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IRegistrationConvention
</span>{
    <span style="color: blue">void </span>Process(<span style="color: #2b91af">Type </span>type, <span style="color: #2b91af">Registry </span>registry);
}</pre>

[](http://11011.net/software/vspaste)

During the scanning process, StructureMap will call any convention I add, passing in the type to check and a Registry object.&#160; If the type seems interesting to me, I’ll register the interface and implementation in the Registry object.&#160; So what do we need to do here?

Basically, we want to look for all subclasses of Entity, and register the delete command handler for that entity type.&#160; To do so, it will require some open generics magic:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DeleteCommandRegistrationConvention </span>: <span style="color: #2b91af">IRegistrationConvention
</span>{
    <span style="color: blue">private static readonly </span><span style="color: #2b91af">Type </span>_openDeleteCommandType = <span style="color: blue">typeof</span>(<span style="color: #2b91af">DeleteEntityCommand</span>&lt;&gt;);
    <span style="color: blue">private static readonly </span><span style="color: #2b91af">Type </span>_openHandlerInterfaceType = <span style="color: blue">typeof</span>(<span style="color: #2b91af">IHandler</span>&lt;&gt;);
    <span style="color: blue">private static readonly </span><span style="color: #2b91af">Type </span>_openDeleteCommandHandlerType = <span style="color: blue">typeof</span>(<span style="color: #2b91af">DeleteEntityCommandHandler</span>&lt;&gt;);

    <span style="color: blue">public void </span>Process(<span style="color: #2b91af">Type </span>type, <span style="color: #2b91af">Registry </span>registry)
    {
        <span style="color: blue">if </span>(!type.IsAbstract && <span style="color: blue">typeof</span>(<span style="color: #2b91af">Entity</span>).IsAssignableFrom(type))
        {
            <span style="color: #2b91af">Type </span>closedDeleteCommandType = _openDeleteCommandType.MakeGenericType(type);
            <span style="color: #2b91af">Type </span>closedHandlerInterfaceType = _openHandlerInterfaceType.MakeGenericType(closedDeleteCommandType);
            <span style="color: #2b91af">Type </span>closedDeleteCommandHandlerType = _openDeleteCommandHandlerType.MakeGenericType(type);

            registry.For(closedHandlerInterfaceType).Use(closedDeleteCommandHandlerType);
        }
    }
}</pre>

[](http://11011.net/software/vspaste)

First, I create some static members for all the open generic types I care about.&#160; Notably, the open command type, the open handler interface type, and the open command handler type.&#160; What I want to do is hook up all requests for IHandler<DeleteEntityCommand<Foo>> to the closed type DeleteEntityCommandHandler<Foo>.&#160; In the Process method, I look for all non-abstract subclasses of Entity, and close all the open types.&#160; Finally, I instruct StructureMap to wire up the closed interface (IHandler<>) to the closed implementation (DeleteEntityCommandHandler<>).

### Hooking up our custom registration convention

In the last article, I hooked up the IHandler implementations.&#160; We’ll need to keep that, but additionally register not only the convention we created, but the repositories we use as part of the concrete handler:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">HandlerRegistry </span>: <span style="color: #2b91af">Registry
</span>{
    <span style="color: blue">public </span>HandlerRegistry()
    {
        Scan(cfg =&gt;
        {
            cfg.TheCallingAssembly();
            cfg.IncludeNamespaceContainingType&lt;<span style="color: #2b91af">OrderCanceledEvent</span>&gt;();
            cfg.ConnectImplementationsToTypesClosing(<span style="color: blue">typeof</span>(<span style="color: #2b91af">IHandler</span>&lt;&gt;));
            cfg.ConnectImplementationsToTypesClosing(<span style="color: blue">typeof</span>(<span style="color: #2b91af">IRepository</span>&lt;&gt;));
            
            cfg.Convention&lt;<span style="color: #2b91af">DeleteCommandRegistrationConvention</span>&gt;();
            cfg.WithDefaultConventions();
        });
    }
}</pre>

To add a convention, I use the “Convention” method and pass in the convention type.&#160; To hook up the repositories, I add both the line to connect implementations for IRepository<>, as well as the “WithDefaultConventions”, which matches up ICustomerRepository to CustomerRepository.&#160; I don’t need that last part for this example, but is almost always included in most of my scanning operations.

With this in place, my test now passes:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_connect_delete_handler()
{
    <span style="color: #2b91af">ObjectFactory</span>.Initialize(init =&gt;
    {
        init.AddRegistry&lt;<span style="color: #2b91af">HandlerRegistry</span>&gt;();
    });

    <span style="color: #2b91af">ObjectFactory</span>.AssertConfigurationIsValid();

    <span style="color: blue">var </span>handler = <span style="color: #2b91af">ObjectFactory</span>.GetInstance&lt;<span style="color: #2b91af">IHandler</span>&lt;<span style="color: #2b91af">DeleteEntityCommand</span>&lt;<span style="color: #2b91af">Customer</span>&gt;&gt;&gt;();

    handler.ShouldBeInstanceOf&lt;<span style="color: #2b91af">DeleteEntityCommandHandler</span>&lt;<span style="color: #2b91af">Customer</span>&gt;&gt;();
}</pre>

[](http://11011.net/software/vspaste)

It’s a lot of angle-bracket tax, but you never actually _see_ this many angle-brackets.&#160; My application will push commands out, and a rather brainless command processor will locate handlers for the command, and execute them.&#160; With StructureMap (and IoC in general), I can start to really reduce duplication when that duplication is around the _type_ varying, by prudent application of generics.&#160; Here, I’m not using generics for type safety, but to reinforce the DRY principle.

With a powerful IoC tool, I don’t have to compromise on my command processing design just because I have complex message/handler shapes.&#160; Instead, the command processor stays simple, and lets my IoC registration encapsulate all of the wiring.