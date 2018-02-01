---
id: 305
title: 'AutoMapper feature: interfaces and dynamic mapping'
date: 2009-04-15T02:39:58+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/04/14/automapper-feature-interfaces-and-dynamic-mapping.aspx
dsq_thread_id:
  - "264716117"
categories:
  - AutoMapper
---
In this post, I’ll highlight two features new in the 0.3 release: mapping to interfaces and dynamic mapping.&#160; Both of these come up in rather interesting scenarios.

### Mapping to interface destinations

In some messaging scenarios, the message itself is not a DTO type, but rather an interface.&#160; In these cases, it’s rather annoying to create a derived type just for every interface-based message in your system.&#160; Instead, we can use AutoMapper to do the work for us.&#160; Suppose we have these source types:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">OrderForm
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">Customer </span>Customer { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}

<span style="color: blue">public class </span><span style="color: #2b91af">Customer
</span>{
    <span style="color: blue">public string </span>Name { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

These can be from a complex domain model, external system, or business objects.&#160; We now need to interface with some external system, but they’ve defined their message contracts as interfaces.&#160; It’s not completely out of the question, but I run into this from time to time.&#160; It might require some message like:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">ICreateOrderMessage
</span>{
    <span style="color: blue">string </span>CustomerName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

In this case, the destination type is an interface, and its member is a flattened version of our domain model.&#160; Here’s our mapping code:

<pre><span style="color: #2b91af">Mapper</span>.CreateMap&lt;<span style="color: #2b91af">OrderForm</span>, <span style="color: #2b91af">ICreateOrderMessage</span>&gt;();

<span style="color: #2b91af">Mapper</span>.AssertConfigurationIsValid();

<span style="color: blue">var </span>order = <span style="color: blue">new </span><span style="color: #2b91af">OrderForm
    </span>{
        Customer = <span style="color: blue">new </span><span style="color: #2b91af">Customer </span>{Name = <span style="color: #a31515">"Bob Smith"</span>}
    };

<span style="color: blue">var </span>message = <span style="color: #2b91af">Mapper</span>.Map&lt;<span style="color: #2b91af">OrderForm</span>, <span style="color: #2b91af">ICreateOrderMessage</span>&gt;(order);

message.CustomerName.ShouldEqual(<span style="color: #a31515">"Bob Smith"</span>);</pre>

[](http://11011.net/software/vspaste)

I create a type map from the source type (OrderForm) to the destination interface type.&#160; An implementation ICreateOrderMessage **doesn’t exist anywhere in our system**.&#160; I create the order form, and map to the message with the Mapper.Map call.&#160; At runtime, AutoMapper creates a dynamic proxy type for ICreateOrderMessage, using the default property behavior for getters and setters.&#160; Underneath the covers, I used LinFu to create the proxy type.&#160; Using this feature does not require any additional references, however, as the LinFu assembly is merged into the AutoMapper assembly.

### Dynamic mapping

In most mapping scenarios, we know the type we’re mapping to at compile time.&#160; In some cases, the source type isn’t known until _runtime_, especially in scenarios where I’m using dynamic types or in extensibility scenarios.&#160; To support these scenarios, but still preserve the safety of configuration validation, AutoMapper 0.3 includes a way to dynamically map from a source to a destination type.&#160; No configuration is needed, just one call to AutoMapper.&#160; I’ll still try to map to the interface destination:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">ICreateOrderMessage
</span>{
    <span style="color: blue">string </span>CustomerName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

And instead of creating a OrderForm in the previous example, I’ll use a dynamic type:

<pre><span style="color: blue">var </span>order = <span style="color: blue">new </span>{CustomerName = <span style="color: #a31515">"Bob Smith"</span>};

<span style="color: blue">var </span>message = <span style="color: #2b91af">Mapper</span>.DynamicMap&lt;<span style="color: #2b91af">ICreateOrderMessage</span>&gt;(order);

message.CustomerName.ShouldEqual(<span style="color: #a31515">"Bob Smith"</span>);</pre>

[](http://11011.net/software/vspaste)

The DynamicMap call creates a configuration for the type of the source object passed in to the destination type specified.&#160; If the two types have already been mapped, AutoMapper skips this step (as I can call DynamicMap multiple times for this example).&#160; To be safe, AutoMapper will validate the configuration for a dynamic map the first time executed, as it tends to give better messages than a mapping exception.

With DynamicMap, you don’t have the luxury of configuring the mapping, but at this point, you’ve also lost the benefits of a single AssertConfigurationIsValid call.&#160; In the DynamicMap side, I could lower the bar quite a bit and not do any mapping validation, but I’d rather not as its intended use is a very specific scenario.&#160; The ideal case is to configure your mappings up front, for much better testability.