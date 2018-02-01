---
id: 107
title: 'Intention-concealing interfaces: blob parameters'
date: 2007-11-29T15:27:59+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/11/29/intention-concealing-interfaces-blob-parameters.aspx
dsq_thread_id:
  - "264715445"
categories:
  - 'C#'
  - DomainDrivenDesign
  - Patterns
---
When someone is using your code, you want your code to be as explicit and easy to understand&nbsp;as possible.&nbsp; This is achieved through Intention-Revealing Interfaces.&nbsp; [Evans](http://domainlanguage.com/about/ericevans.html) describes the problems of opaque and misleading interfaces in [Domain-Driven Design](http://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215):

> If a developer must consider the implementation of a component in order to use it, the value of encapsulation is lost.&nbsp;&nbsp;If someone other than the original developer must infer the purpose&nbsp;of an object or operation based on its implementation, that new developer may infer a purpose that the operation or class fulfills only by chance.&nbsp; If that was not the intent, the code may work for the moment, but the conceptual basis of the design will have been corrupted, and the two developers will be working at cross-purposes.

His recommendation is to create Intention-Revealing Interfaces:

> Name classes and operations to describe their effect and purpose, without reference to the means by which they do what they promise.&nbsp; This relieves the client developer of the need to understand the internals.&nbsp; The name should conform to the Ubiquitous Language so that the team members can quickly infer their meaning.&nbsp; Write a test for a behavior before creating it, to force your thinking into client developer mode.

Several times now I&#8217;ve run into blob parameters (I&#8217;m sure there are other names for them).&nbsp; Blob parameters are amorphous, mystery parameters used in constructors and methods, usually of type ArrayList, HashTable, object[], or even params object[].&nbsp; Here&#8217;s an example:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> OrderProcessor
{
    <span class="kwrd">public</span> <span class="kwrd">void</span> Process(<span class="kwrd">object</span>[] args)
    {
        Order order = (Order) args[0];
        Customer customer = (Customer) args[1];

        <span class="rem">// etc.</span>
    }
}
</pre>
</div>

The intentions behind this code are good, but the results can lead to some frustrating results.&nbsp; Furthermore, this pattern leads to &#8220;**Intention-Concealing Interfaces**&#8220;, which is style completely opposite from the Intention-Revealing style Eric proposes.&nbsp; Clients need to know the intimate details of the internal implementation of the component in order to use the blob parameters.

### Wrong kind of extensibility

Blob parameters lead to the worst kind of coupling, beyond just &#8220;one concrete class using another concrete class&#8221;.&nbsp; When using blob parameters, the client gets coupled to the internal implementation of unwinding the blob.&nbsp; Additionally, new client code must have intimate knowledge of the details, as the correct order of the parameters is not exposed by the blob method&#8217;s interface.

When a developer needs to call the &#8220;Process&#8221; method above, they are forced to look at the internal implementation.&nbsp; Hopefully they have access to the code, but otherwise they&#8217;ll need to pop open Reflector&nbsp;to determine the correct parameters to pass in.&nbsp; Instead of learning if the parameters are correct at **compile-time**, they have to wait until **run-time**.

### Alternatives

Several alternatives exist&nbsp;before resorting to blob parameters:

  * Explicit parameters
  * Creation method
  * Factory patterns
  * IoC containers
  * Generics

Each of these alternatives can be used separately or combined together to achieve both Intention-Revealing Interfaces and simple code.

#### Explicit Parameters

Explicit parameters just means that members should ask explicitly what they need to operate through their signature.&nbsp; The Process method would be changed to:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> OrderProcessor
{
    <span class="kwrd">public</span> <span class="kwrd">void</span> Process(Order order, Customer customer)
    {
        <span class="rem">// etc.</span>
    }
}
</pre>
</div>

The Process method takes exactly what components it needs to perform whatever operations it does, and clients of the OrderProcessor can deduce this simply through the method signature.

If this signature needs to change due to future requirements, you have&nbsp;a few choices to deal with this change:

  * Overload the method to preserve the existing signature
  * Just break the client code

People always assume it&#8217;s&nbsp;a big deal to break client code, but in many cases, it&#8217;s not.&nbsp; Unless you&#8217;re shipping public API libraries as part of your product, backwards compatibility is something that can be dealt with through Continuous Integration.

#### Creation Method/Factory Patterns/IoC Containers

When blob parameters start to invade constructors, it&#8217;s a smell that you need some encapsulation around object creation.&nbsp; Instead of dealing with changing requirements through blob parameters, encapsulate object creation:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> OrderProcessor
{
    <span class="kwrd">private</span> <span class="kwrd">readonly</span> ISessionContext _context;

    <span class="kwrd">public</span> OrderProcessor() : <span class="kwrd">this</span>(ObjectFactory.GetInstance&lt;ISessionContext&gt;())
    {
    }

    <span class="kwrd">public</span> OrderProcessor(ISessionContext context)
    {
        _context = context;
    }
}
</pre>
</div>

Originally, the ISessionContext was a hodgepodge of different object that I needed to pass in to the OrderProcessor class.&nbsp; Since these dependencies became more complex, I encapsulated them into a [parameter object](http://www.refactoring.com/catalog/introduceParameterObject.html), and introduced a factory method (the &#8220;ObjectFactory&#8221; class) to encapsulate creation.&nbsp; Client code no longer needs to pass in a group of complex objects to create the OrderProcessor.

#### Generics

Sometimes blob parameters surface because a family of objects needs to be created or used, but all have different needs.&nbsp; For example, the [Command pattern](http://www.dofactory.com/Patterns/PatternCommand.aspx) that requires data to operate might look like this before generics:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">interface</span> ICommand
{
    <span class="kwrd">void</span> Execute(<span class="kwrd">object</span>[] args);
}

<span class="kwrd">public</span> <span class="kwrd">class</span> TransferCommand : ICommand
{
    <span class="kwrd">public</span> <span class="kwrd">void</span> Execute(<span class="kwrd">object</span>[] args)
    {
        Account source = (Account) args[0];
        Account dest = (Account) args[1];
        <span class="kwrd">int</span> amount = (<span class="kwrd">int</span>) args[2];

        source.Balance -= amount;
        dest.Balance += amount;
    }
}
</pre>
</div>

The ICommand interface needs to be flexible in the arguments it can pass to specific implementations.&nbsp; We can use generics instead of blob parameters to accomplish the same effect:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">interface</span> ICommand&lt;T&gt;
{
    <span class="kwrd">void</span> Execute(T args);
}

<span class="kwrd">public</span> <span class="kwrd">struct</span> Transaction
{
    <span class="kwrd">public</span> Account Source;
    <span class="kwrd">public</span> Account Destination;
    <span class="kwrd">public</span> <span class="kwrd">int</span> Amount;

    <span class="kwrd">public</span> Transaction(Account source, Account destination, <span class="kwrd">int</span> amount)
    {
        Source = source;
        Destination = destination;
        Amount = amount;
    }
}

<span class="kwrd">public</span> <span class="kwrd">class</span> TransferCommand : ICommand&lt;Transaction&gt;
{
    <span class="kwrd">public</span> <span class="kwrd">void</span> Execute(Transaction args)
    {
        Account source = args.Source;
        Account dest = args.Destination;
        <span class="kwrd">int</span> amount = args.Amount;

        source.Balance -= amount;
        dest.Balance += amount;
    }
}
</pre>
</div>

Each ICommand implementation can describe its needs through the generic interface, negating the need for blob parameters.

### No blobs

I&#8217;ve seen a lot of misleading, opaque code, but blob parameters take the prize for &#8220;**Intention-Concealing Interfaces**&#8220;.&nbsp; Instead of components&nbsp;being extensible,&nbsp;they&#8217;re inflexible, brittle, and incomprehensible.&nbsp; Before going down the path of creating brittle interfaces, exhaust all alternatives before doing so.&nbsp; Every blob parameter I&#8217;ve created I rolled back later as it quickly&nbsp;becomes difficult to deal with.