---
wordpress_id: 349
title: Partially closed generic types
date: 2009-09-01T22:23:26+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/09/01/partially-closed-generic-types.aspx
dsq_thread_id:
  - "264716292"
categories:
  - 'C#'
---
If you swallow enough of the generic pills, you may run into situations where a not-quite closed and a not-quite open generic type would be nice.&#160; It’s in situations where decisions based on types are prevalent, such as in IoC containers.&#160; An open generic type is simply a generic type whose type parameters have not been specified.&#160; For example, IEnumerable<> is an **open generic type**, and IEnumerable<int> (or string or whatever) is a **closed generic type**, as its type parameter has been specified.

Recently I ran into a situation where I wanted my cake and eat it too, with a partially closed generic type.&#160; First, I had a generic type I wanted to work with:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IRequestHandler</span>&lt;TMessage&gt;
{
    <span style="color: blue">void </span>Handle(TMessage message);
}</pre>

[](http://11011.net/software/vspaste)

Nothing too exciting here, except I wanted to match up, using an IoC container, TMessage to handlers of that message (IRequestHandler<TMessage>).&#160; Modern IoC containers provide easy ways of doing this, so something like StructureMap is something along the lines of:

<pre>cfg.ConnectImplementationsToTypesClosing(<span style="color: blue">typeof</span>(<span style="color: #2b91af">IRequestHandler</span>&lt;&gt;));</pre>

[](http://11011.net/software/vspaste)

This one line of code connects all implementations of IRequestHandler<> to the closed interfaces.&#160; For example, the closed implementation AddCustomerHandler gets connected to IRequestHandler<AddCustomer> (assuming the class implements that interface).&#160; This was working for me great, until I ran into a little more advanced scenario – messages to delete entities.&#160; I only had one implementation of that, and the message itself was generic:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IDeleteMessage</span>&lt;TEntity&gt;
    <span style="color: blue">where </span>TEntity : <span style="color: #2b91af">Entity
</span>{
    TEntity Entity { <span style="color: blue">get</span>; }
}</pre>

[](http://11011.net/software/vspaste)

The handler could handle any delete message, by supplying an additional generic parameter:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DeleteRequestHandler</span>&lt;TEntity&gt; : <span style="color: #2b91af">IRequestHandler</span>&lt;<span style="color: #2b91af">IDeleteMessage</span>&lt;TEntity&gt;&gt;
    <span style="color: blue">where </span>TEntity : <span style="color: #2b91af">Entity
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IRepository</span>&lt;TEntity&gt; _repository;

    <span style="color: blue">public </span>DeleteRequestHandler(<span style="color: #2b91af">IRepository</span>&lt;TEntity&gt; repository)
    {
        _repository = repository;
    }

    <span style="color: blue">public void </span>Handle(<span style="color: #2b91af">IDeleteMessage</span>&lt;TEntity&gt; message)
    {
        <span style="color: green">// delete the message.Entity
    </span>}
}</pre>

[](http://11011.net/software/vspaste)

So this DeleteRequestHandler could handle all sorts of delete messages, so long as it was an IDeleteMessage<TEntity>.&#160; It could be IDeleteMessage<Customer> or IDeleteMessage<Order>, and so on.&#160; This proved to be a problem with StructureMap, since there was no concrete implementation defined for a delete message.&#160; Instead, the open DeleteRequestHandler<> type needs to be closed for a specific entity type before I can use an implementation.

### Partially closed weirdness

This led me to want to do this:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Wont_compile()
{
    <span style="color: blue">var </span>type = <span style="color: blue">typeof </span>(<span style="color: #2b91af">IRequestHandler</span>&lt;<span style="color: #2b91af">IDeleteMessage</span>&lt;&gt;&gt;);
}</pre>

[](http://11011.net/software/vspaste)

However, I got a compile error of:

<pre>error CS1031: Type expected</pre>

[](http://11011.net/software/vspaste)

So the compiler does not let me close a generic type with another open generic type.&#160; I want to define the type “IRequestHandler of IDeleteMessage of IDontCareRightNowJustYet”, maybe I can do this with type objects directly?&#160; Here’s what I had in that vein:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Compiles_but_useless()
{
    <span style="color: blue">var </span>openRequestType = <span style="color: blue">typeof </span>(<span style="color: #2b91af">IRequestHandler</span>&lt;&gt;);
    <span style="color: blue">var </span>openMessageType = <span style="color: blue">typeof </span>(<span style="color: #2b91af">IDeleteMessage</span>&lt;&gt;);

    <span style="color: blue">var </span>partiallyClosedType = openRequestType.MakeGenericType(openMessageType);

    <span style="color: #2b91af">Debug</span>.WriteLine(partiallyClosedType);
}</pre>

[](http://11011.net/software/vspaste)

The really interesting output is the name of the type:

<pre>PartiallyClosedGenerics.IRequestHandler`1[PartiallyClosedGenerics.IDeleteMessage`1[TEntity]]</pre>

[](http://11011.net/software/vspaste)

It _looks_ like a partially closed type, as you can see that IRequestHandler is closed type, but closed with an open generic type.&#160; Unfortunately, you can’t actually do anything with this type, as Type.IsGenericTypeDefinition is **false**, meaning I can’t create a completely closed type.&#160; Calling MakeGenericType with something like typeof(Customer) doesn’t work, and you can’t really poke around the generic type parameter to try and coerce it.&#160; So although you can create partially closed generic Type objects, you can’t _do_ anything with them.&#160; Activator.CreateInstance fails, for example.

This is because a partially closed type is a fully open type.&#160; If a type contains any unassigned type parameters, anywhere in its hierarchy, the type is an open constructed type.&#160; Unfortunately, MakeGenericType only works with types that are generic type definitions, so I’ve created a descriptive, but useless type.&#160; More information than I ever, ever cared to know about generics, but good to know that the CLR team really covered their bases when they implemented generics.