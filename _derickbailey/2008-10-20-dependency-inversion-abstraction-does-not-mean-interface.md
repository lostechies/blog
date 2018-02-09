---
wordpress_id: 12
title: 'Dependency Inversion: &#8216;Abstraction&#8217; Does Not Mean &#8216;Interface&#8217;'
date: 2008-10-20T20:04:54+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2008/10/20/dependency-inversion-abstraction-does-not-mean-interface.aspx
dsq_thread_id:
  - "262067916"
categories:
  - .NET
  - Agile
  - Analysis and Design
  - Domain Driven Design
  - Lambda Expressions
  - Philosophy of Software
  - Principles and Patterns
  - Refactoring
redirect_from: "/blogs/derickbailey/archive/2008/10/20/dependency-inversion-abstraction-does-not-mean-interface.aspx/"
---
A coworker recently asked if we should always abstract every object into an interface in order to fulfill the <a href="http://en.wikipedia.org/wiki/Dependency_inversion_principle" target="_blank">Dependency Inversion Principle</a> (DIP). The question stunned me at first, honestly. I knew in my head that this was a bad idea &#8211; abstracting into interfaces for the sake of abstraction leads down the path of needless complexity. However, I wasn&#8217;t able to clearly answer his question with specific examples of when you would not want to do this, at the time. I&#8217;ve been thinking about this for a few days now and I think I have a good, albeit very long winded, answer.

Before the question is answered, though, we need to step back and look at what DIP is all about. I&#8217;ve previously shown <a href="http://www.lostechies.com/blogs/derickbailey/archive/2008/10/07/di-and-ioc-creating-and-working-with-a-cloud-of-objects.aspx" target="_blank">how to implement DIP</a> and <a href="http://www.derickbailey.com/2008/09/03/ObjectOrientedDevelopmentViaTheSOLIDSoftwareDevelopmentPrinciples.aspx" target="_blank">talked about why it&#8217;s beneficial</a>, so I won&#8217;t be repeating that here. Rather, I want to talk about the language that describes DIP and what it really means. 

<a href="http://www.objectmentor.com/resources/articles/dip.pdf" target="_blank">Robert Martin&#8217;s original definition of DIP</a> is this:

> _A. High level modules should not depend upon low level modules. Both should depend upon abstractions.   
>_ _B. Abstractions should not depend upon details. Details should depend upon abstractions._

The word &#8216;abstraction&#8217; is used three times in the definition for DIP. So, in order to understand DIP, we have to first understand some of the basics of Abstraction. 

### Some Background On Abstraction

<a href="http://en.wikipedia.org/wiki/Abstraction_(computer_science)" target="_blank">From Wikipedia</a> (emphasis mine):

> 
> _&#8220;In computer science, abstraction is a mechanism and practice to **reduce and factor out details** so that one can focus on a few concepts at a time&#8221;_

I can&#8217;t say it any better than this. 

Abstraction can very directly lead to a system that is more understandable by helping us ignore the detail and implementation specifics, allowing us to focus on something at a higher level. This <a href="http://www.derickbailey.com/2008/09/25/AbstractionAndInterfacesWhatsThePointOfQuotclassFooIFooquot.aspx" target="_blank">reduction in cognitive load</a> can benefit someone that is reading the code by not forcing them to know the detail immediately. Additionally, abstraction is a form of encapsulation or information hiding, which again helps us to reduce cognitive load and produce better systems. From Wikipedia&#8217;s entry on <a href="http://en.wikipedia.org/wiki/Information_hiding" target="_blank">Information Hiding</a>:

> _&#8220;In computer science, the principle of information hiding is the hiding of design decisions in a computer program that are most likely to change, thus protecting other parts of the program from change if the design decision is changed.&#8221;_

At the heart of abstraction and information hiding, we find the ability to change the system. The ability to change is an absolute requirement in software development and produces <a href="http://www.lostechies.com/blogs/chad_myers/archive/2008/08/18/good-design-is-not-subjective.aspx" target="_blank">good design that is easier to work with, modify, and put back together as needed</a>. The inability to change is directly called &#8220;bad design&#8221; by Robert Martin, in the DIP article. 

### Applying Abstraction And Encapsulation To DIP

So how does our knowledge of abstraction and information hiding play into DIP?

First and foremost, DIP never states that we should depend on explicit interfaces. Yes, in C# we have an explicit Interface as a form of abstraction. It is a separation of the implementation detail from the publicly available methods, properties, etc, of a class. Some languages, such as C++, don&#8217;t have an explicit construct for interfaces, though. From Robert Martin&#8217;s original DIP article, again:

> _&#8220;In C++ however, there is no separation between interface and implementation. Rather, in C++, the separation is between the definition of the class and the definition of its member functions.&#8221;_

### A String As An Abstraction

Abstraction doesn&#8217;t always mean explicit interface constructs, as evidenced in C++. Nor does it always mean an abstract base class, which we also have available in .NET. In fact, languages such as Ruby don&#8217;t really need either of these constructs. The <a href="http://en.wikipedia.org/wiki/Duck_Type" target="_blank">duck-type</a> nature of Ruby allows an implementation to be replaced at any point, without any special constructs. In .NET, though, there are a number of abstraction forms that we can rely on, explicitly. We have the obvious interfaces and base classes (abstract or not) &#8211; but we also have constructs like delegates and lambda expressions, and even the simple types that are built into the base class library.

Let&#8217;s look at a simple string to illustrate abstraction. As I said in my <a href="http://www.lostechies.com/blogs/derickbailey/archive/2008/10/14/thanks-adnug-attendees-slides-and-code-available.aspx" target="_blank">SOLID presentation at ADNUG</a>, we can invert our dependency on database connection information.&nbsp; Rather than putting a connection string directly into our code that calls the database, we can use the string as our dependency and our abstraction. All we need to do is follow the basic DIP principle and provide the string as a parameter to the class that calls the database. We certainly don&#8217;t need (or want, for that matter) to introduce a new interface or base class at this point. Our abstraction is simple enough to use a common type found in the .NET framework.

### Other Forms Of Abstraction

Even if we are talking about an object, who says that the interface we are depending on has to be an explicit interface construct or base class? When I write a <a href="http://en.wikipedia.org/wiki/Domain-driven_design" target="_blank">Domain Service</a> that uses an Entity from my Domain, I don&#8217;t create an explicit interface for that Entity. Rather, I use the Entity&#8217;s inherent interface &#8211; it&#8217;s public methods, properties, etc. 

I also use delegates on a regular basis. By specifying my abstraction as a delegate, I can further decouple the depending object from the dependant code that it needs to call. I&#8217;d be willing to bet you have used delegates as abstractions as well. Have you ever created an event handler for something like a button click? There&#8217;s a delegate&#8217;s abstraction at work.

### Abstract Judgement

The point is, there is not always a need to introduce an explicit interface or base class when inverting our dependencies. We still need to apply dependency inversion and provide our implementation as a constructor parameter (or setter, though I don&#8217;t like <a href="http://martinfowler.com/articles/injection.html#ConstructorVersusSetterInjection" target="_blank">setter injection</a>). But, that dependency doesn&#8217;t have to be anything more than the interface inherent to the object, or a simple type found in .NET.

You do have to be careful when making the call to not use an explicit abstraction with DIP, though. You can quickly turn your system into a ball of mud if you rely on a concrete class that is not intention revealing or well encapsulated to begin with. At the same time, too many abstractions can lead to needless complexity and make it very difficult to see the big picture of a system. Too few abstractions, though, will certainly lead to a rigid, immobile design that is hard to change. All of these problems are equally vicious &#8211; and I&#8217;ve been bitten by all of them in recent months.&nbsp; It takes good judgement calls to determine when you do and do not need an explicit abstraction for a dependency. Unfortunately, good judgement comes from experience and experience comes from bad judgement. Don&#8217;t be afraid to make bad decisions &#8211; make a decision, just be sure you can reverse that decision as easily as possible.