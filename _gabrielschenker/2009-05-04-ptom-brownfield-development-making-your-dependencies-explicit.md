---
wordpress_id: 23
title: PTOM – Brownfield development – Making your dependencies explicit
date: 2009-05-04T21:06:58+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2009/05/05/ptom-brownfield-development-making-your-dependencies-explicit.aspx
dsq_thread_id:
  - "264207142"
categories:
  - Brownfield
  - legacy code
  - Patterns
  - practices
  - PTOM
  - SOLID
  - TDD
redirect_from: "/blogs/gabrielschenker/archive/2009/05/05/ptom-brownfield-development-making-your-dependencies-explicit.aspx/"
---
# Introducing DI and “poor man’s DI”

## **Introduction**

**Greenfield Development** happens when you start a brand new project, as in, clean slate development. No legacy code lying around, no old development to maintain. You&#8217;re starting afresh, from scratch, from a blank slate, with no restrictions on what you&#8217;re doing (other than business rules of course).

In [Wikipedia](http://en.wikipedia.org/wiki/Greenfield_project):

> _“…a **greenfield** is also a project which lacks any constraints imposed by prior work. The analogy is to that of construction on greenfield land where there is no need to remodel or demolish an existing structure. Such projects are often coveted by software engineers for this reason, but in practice, they can be quite rare.”_

Brownfield development is given whenever one has to maintain, extend and improve an existing base of legacy code. Again in [Wikipedia](http://en.wikipedia.org/wiki/Brownfield_(software_development))

> _“**Brownfield development** is a term commonly used in the IT industry to describe problem spaces needing the development and deployment of new_ _software_ _systems in the immediate presence of existing (legacy) software applications/systems. This implies that any new_ _software architecture_ _must take into account and coexist with live software already_ _in situ__. … “_

As a developer this is probably the most common scenario that you encounter. Only very seldom we are lucky enough to start a completely new application (a greenfield project) which has no legacy (code) at all to consider during development.

## Legacy Code

Legacy code in the context of this post is code that is either _not covered by tests_, _not developed by using_ [_TDD_](http://en.wikipedia.org/wiki/Test-driven_development) or simply _not respecting the_ [_S.O.L.I.D._](https://lostechies.com/blogs/chad_myers/archive/2008/03/07/pablo-s-topic-of-the-month-march-solid-principles.aspx) _principles_. 

## Strong coupling versus weak coupling

One of the first points of friction we detect when we would like to maintain or extend a legacy application is that the code is _strongly coupled_. The different classes are tied together and thus an individual class cannot be easily decoupled from the rest of the application. But we should never add new functionality to a legacy application without testing it. To write unit tests for a class under change we have to be able to completely isolate it from the other classes. But this is only possible if the dependencies that this class has to other classes are _explicit_.

We say “a class is weakly coupled” if its dependencies are explicit and the class is not directly coupled to the implementation but rather to the abstraction of the dependencies. In this case an abstraction of a class is an interface implemented by the corresponding class.

## A sample

In this post I assume that we have to modify and/or extend an existing application which is an order entry system. Currently it is possible to place a new order. When an existing customer places a new order the legacy system does not check whether this customer has other yet unpaid orders. Our task is now to extend this order entry system such as that if a customer having unpaid orders wants to place a new order the order is only tentatively added to the system and a task is entered into the system requiring a manager to confirm or reject the order.

Of course we are developers that have been trained in TDD and we are applying the S.O.L.I.D. all the time. Thus we don’t want to make an exception when modifying this legacy application.

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> OrderService</pre>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> PlaceNewOrder(ShoppingCart shoppingCart)</pre>
    
    <pre><span style="color: #606060">   4:</span>     {</pre>
    
    <pre><span style="color: #606060">   5:</span>         <span style="color: #008000">// ... more code ...</span></pre>
    
    <pre><span style="color: #606060">   6:</span>&#160; </pre>
    
    <pre><span style="color: #606060">   7:</span>         var smtpServer = ConfigurationManager.AppSettings[<span style="color: #006080">"SMTPServer"</span>];</pre>
    
    <pre><span style="color: #606060">   8:</span>         var emailSender = <span style="color: #0000ff">new</span> EmailSender(smtpServer);</pre>
    
    <pre><span style="color: #606060">   9:</span>         emailSender.SendConfirmation(shoppingCart);</pre>
    
    <pre><span style="color: #606060">  10:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  11:</span>         var orderRepository = <span style="color: #0000ff">new</span> OrderRepository();</pre>
    
    <pre><span style="color: #606060">  12:</span>         var order = CreateOrderFromShoppingCart(shoppingCart);</pre>
    
    <pre><span style="color: #606060">  13:</span>         orderRepository.Add(order);</pre>
    
    <pre><span style="color: #606060">  14:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  15:</span>         <span style="color: #008000">// ... more code ...</span></pre>
    
    <pre><span style="color: #606060">  16:</span>     }</pre>
    
    <pre><span style="color: #606060">  17:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  18:</span>     <span style="color: #008000">// ... more methods</span></pre>
    
    <pre><span style="color: #606060">  19:</span> }</pre></p>
  </div>
</div>

<font face="Verdana" size="1"><strong>Listing 1</strong>: strongly coupled legacy code</font>

We have spotted the method **PlaceNewOrder** in the class **OrderService** as the location where we have to introduce our enhancement. Now we want to apply TDD when implementing our extension. Thus we have to be able to isolate the order service class from its dependencies. 

In the above code snippet we can already detect three locations of problems; namely in lines 7, 8 and 11. In these lines external dependencies of the class are referenced. Those are the **ConfigurationManager** class (which is part of the .NET framework), the **EmailSender** class and the **OrderRepository** class.

When analyzing the **EmailSender** class we notice that this class uses the **SmtpClient** class of the .NET framework (namespace System.Net.Mail) to send emails to the receiver. The **OrderRepository** class in turn is coupled to a specific database. And finally the **ConfigurationManager** class expects the existence of a configuration file having an entry “SMTPServer”.

If we would have to test this class **as is** then we had to build up the required context in our development environment. That is we would have to have access to a SMTP server, have access to a database and provide the correct configuration file amongst other things. This is certainly to much of a requirement. If we could not change these requirements then we would certainly decide **not to apply TDD at all** and just implement the new code in a quick and dirty way…

What can we do to improve the situation?

The first step is to make our dependencies **explicit**. What does that mean? Well, maybe I first explain the contrary. What is an **implicit** dependency? 

“An implicit dependency of a give class is a dependency that is not discoverable from the outside of this class. The corresponding dependency is never appearing in the contract (or interface) of the class.”

## Do not couple to the implementation

The legacy code snippet shown in listing 1 is strongly coupled to the implementation of the dependencies. To be able to mock the dependencies for testing purposes we have to break up this strong coupling. We can do this by referencing interfaces instead of the implementation. As an example we define an interface **IOrderRepository** which contains at least a method **Add** as used in line 13 of listing 1. 

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IOrderRepository</pre>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">void</span> Add(Order order);</pre>
    
    <pre><span style="color: #606060">   4:</span>     <span style="color: #008000">// other members...</span></pre>
    
    <pre><span style="color: #606060">   5:</span> }</pre></p>
  </div>
</div>

<font face="Verdana" size="1"><strong>Listing 2</strong>: defining an interface for the order repository</font>

This interface is then implemented by the order repository class.

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> OrderRepository : IOrderRepository</pre>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #008000">// ... code ...</span></pre>
    
    <pre><span style="color: #606060">   4:</span> }</pre></p>
  </div>
</div>

<font face="Verdana" size="1"><strong>Listing 3</strong>: implementing the interface in the order repository</font>

The same we do for the email sender class.

## Decoupling from static classes and/or members

But we cannot define and implement an interface for the **ConfigurationManager** class since this class is defined in the .NET framework. More over the member used in our code is a _static_ member. In such a situation the best thing we can probably do is to define a (thin) wrapper class around the **ConfigurationManager** class where the wrapper then implements an interface. Our modified code will then reference the interface of the wrapper class

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IConfigurationManager</pre>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <pre><span style="color: #606060">   3:</span>     NameValueCollection AppSettings{ get; }</pre>
    
    <pre><span style="color: #606060">   4:</span> }</pre>
    
    <pre><span style="color: #606060">   5:</span>&#160; </pre>
    
    <pre><span style="color: #606060">   6:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ConfigurationManagerWrapper : IConfigurationManager</pre>
    
    <pre><span style="color: #606060">   7:</span> {</pre>
    
    <pre><span style="color: #606060">   8:</span>     <span style="color: #0000ff">public</span> NameValueCollection AppSettings</pre>
    
    <pre><span style="color: #606060">   9:</span>     {</pre>
    
    <pre><span style="color: #606060">  10:</span>         get { <span style="color: #0000ff">return</span> ConfigurationManager.AppSettings; }</pre>
    
    <pre><span style="color: #606060">  11:</span>     }</pre>
    
    <pre><span style="color: #606060">  12:</span> }</pre></p>
  </div>
</div>

<font face="Verdana" size="1"><strong>Listing 4</strong>: wrapping a static class or a class that we cannot modify</font>

We will notice however that we will not need the **ConfigurationManager** any more in the order service class once we have made its dependencies explicit. But we will need the above wrapper class once we want to modify and decouple the **EmailSender** class. 

## The Dependency Injection Pattern

Now that we have decoupled our order service of the strong coupling to the implementation of the references we have to provide the references to the class somehow. Most often this is done by applying the [dependency injection](http://en.wikipedia.org/wiki/Dependency_injection) pattern. The references are injected to the class from outside. Often this is done via constructor injection. That is we define a constructor for the order service class which has a parameter for each dependency needed. In our example we have two dependencies left over

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> OrderService(IOrderRepository orderRepository, IEmailSender emailSender)</pre>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">this</span>.orderRepository = orderRepository;</pre>
    
    <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">this</span>.emailSender = emailSender;</pre>
    
    <pre><span style="color: #606060">   5:</span> }</pre></p>
  </div>
</div>

<font face="Verdana" size="1"><strong>Listing 5</strong>: making dependencies explicit via construction injection</font>

We can then update the code that uses those dependencies

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> PlaceNewOrder(ShoppingCart shoppingCart)</pre>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #008000">// ... more code ...</span></pre>
    
    <pre><span style="color: #606060">   4:</span>&#160; </pre>
    
    <pre><span style="color: #606060">   5:</span>     emailSender.SendConfirmation(shoppingCart);</pre>
    
    <pre><span style="color: #606060">   6:</span>&#160; </pre>
    
    <pre><span style="color: #606060">   7:</span>     var order = CreateOrderFromShoppingCart(shoppingCart);</pre>
    
    <pre><span style="color: #606060">   8:</span>     orderRepository.Add(order);</pre>
    
    <pre><span style="color: #606060">   9:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  10:</span>     <span style="color: #008000">// ... more code ...</span></pre>
    
    <pre><span style="color: #606060">  11:</span> }</pre></p>
  </div>
</div>

<font face="Verdana" size="1"><strong>Listing 5</strong>: modified code weakly coupled to its dependencies</font>

The above code is now only weakly coupled to its dependencies. During a unit test these dependencies can be mocked and as a consequence no email is sent and no database is needed when running the test.

## Poor Man’s Dependency Injection

Since we are extending an existing application and since we cannot modify the whole code base at once we need to be able to use our modified component the same way as we did before the change was introduced. Probably the **OrderSerivce** class is used at various points in the legacy code base in the following way

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #008000">// ... </span></pre>
    
    <pre><span style="color: #606060">   2:</span> var orderService = <span style="color: #0000ff">new</span> OrderService();</pre>
    
    <pre><span style="color: #606060">   3:</span> orderService.PlaceNewOrder(shoppingCart);</pre>
    
    <pre><span style="color: #606060">   4:</span> // ... more code</pre></p>
  </div>
</div>

<font face="Verdana" size="1"><strong>Listing 6</strong>: legacy code using the order service</font>

In line 2 we can see that the default constructor of the **OrderService** class is used in the legacy code. But our modified class doesn’t provide a default constructor at the moment. We only have a constructor with parameters where the parameters correspond to the dependencies needed by the order service. What can we do?

Well, there is a simple solution – this solution is also called “poor man’s dependency injection. We can implement a **default constructor** in the class and just forward the call to the other constructor. 

And the dependencies needed?</p> 

Since this is a **brownfield** project we cannot provide the perfect solution but we can provide a decent one. We just new up instances of the required dependencies in the forward call

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> OrderService() : <span style="color: #0000ff">this</span>(</pre>
    
    <pre><span style="color: #606060">   2:</span>     <span style="color: #0000ff">new</span> OrderRepository(),</pre>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">new</span> EmailSender(ConfigurationManager.AppSettings[<span style="color: #006080">"SMTPServer"</span>])</pre>
    
    <pre><span style="color: #606060">   4:</span>     )</pre>
    
    <pre><span style="color: #606060">   5:</span> { }</pre></p>
  </div>
</div>

<font face="Verdana" size="1"><strong>Listing 7</strong>: default constructor injecting references</font>

Now our improved order service can be used by the remaining legacy code without change!

## Summary

Legacy code is most often strongly coupled. A class does have one to many implicit dependencies and can thus not be tested in isolation. To decouple a class from the rest of the application we have to make its dependencies explicit. Not the class is responsible to acquire its dependencies but those dependencies are injected from “outside”. Further more the class should never be directly coupled to the implementation of its dependencies but rather on their abstraction. That is a dependency of a class should be accessed via an interface implemented by the dependency.

In this post I have shown based on a realistic example how we can decouple a legacy class from its surroundings by making its dependencies explicit. Once the dependencies are explicit they can be mocked during a test. As a result we can apply TDD when implementing new features or maintaining existing features.