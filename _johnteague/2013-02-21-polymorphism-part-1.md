---
wordpress_id: 160
title: 'Polymorphism: Part 1'
date: 2013-02-21T19:49:27+00:00
author: John Teague
layout: post
wordpress_guid: http://lostechies.com/johnteague/?p=160
dsq_thread_id:
  - "1097287979"
categories:
  - Uncategorized
---
_Note: I am teaching a course in Austin TX on <a href="http://oop-c-sharp-march-2013.eventbrite.com/" target="_blank">Object Oriented Programming</a> in March. I&#8217;ll also be speaking at the Austin .Net Users Group on this topic._

To say that understanding polymorphism is critical to understanding how to effectively utilize an object-oriented language is a bit of an understatement.  It’s not just a central concept, it’s _the concept_ you need to understand in order to build anything of size and scope beyond the trivial.  Yet, as important as it is I feel it is often quickly glossed over in most computer science curriculums.  From my own experience, I took two courses that focused on OOP, undergraduate and graduate, but I don’t think I truly understood its importance until later.[[1]](#_ftn1 "") [[2]](#_ftn2 "")

In C#, there are actually two forms of polymorphism available; Subtype Polymorphism through inheritance, and Parametric Polymorphism through the use of Generics. Generics is an important concept and deserves it’s own discussion.   But we are going to focus on Subtype for now.

> Polymorphism lets you have different behavior for sub types, while keeping a consistent contract.

Now that sentence hides a lot of nuances and potential.  What exactly does this do for you?

  * Reduces coupling in your application
  * Reduces complexity by separating logic into smaller, more manageable pieces
  *  Increases the flexibility of your application by letting you change behavior by creating new classes to handle new functionality

## The Mechanics:

Let’s go through a real simple example, just to describe the mechanics of how to use this.  Don’t worry, we’ll take the training wheels off real fast.  There are three basic steps necessary at this point: 1) define the contract, 2) create concrete implementations, 3) leverage the abstraction.

### Step 1: Define the Contract

You need to define the contract that will define abstraction the rest of your system will interact with. In C# you can use either an Interface or a Class.  The class can either be an abstract class or a concrete class.  The only different between a concrete class and an abstract class is that you can’t directly use the abstract class, only concrete classes that inherit from it.  You also cannot create an instance of an Interface either.  The difference between an Interface and an abstract class is that an interface can only define the contract; you cannot implement any of the fields on an interface.  With an abstract class however you can define a method and implement it, so that all subtypes inherit the same behavior.

We’re going to create a component the sends messages to users.  We’ll start with the contract.  In this case we’ll use an interface to define the contract.

[gist id=&#8221;4998293&#8243; file=&#8221;IMessenger.cs&#8221;]

It’s a very simple abstraction and only includes what we need it to do.  Now what we’ll do is create some concrete implorations of the interface.

[gist id=&#8221;4998293&#8243; file=&#8221;EmailMessenger.cs&#8221;]

[gist id=&#8221;4998293&#8243; file=&#8221;SMSMessenger.cs&#8221;]

Now we’ve got two different behaviors with the same while keeping a consistent contract for send a message.  Now we’ll leverage the abstraction somewhere else in our application.

[gist id=&#8221;4998293&#8243; file=&#8221;OrderProcessor.cs&#8221;]

Notice that the constructor takes a parameter of ISendMessages, not a concrete implementation.  The OrderSender is not concerned with determining what type of message should be sent or the implementation details of sending the message.  It only needs to know that the contract requires a Message object.   This is known as the Inversion of Control Principle.  By using only the abstraction and not the concrete types in the OrderProcessor the OrderProcessor has _inverted control_ of how to send the message to the originator.  When the OrderProcessor is created, it must be told what implementation to use.

Also notice that because the contract in both concrete implementations, we can substitute any subtype for the base type (in this case the interface).  This is another of the design principle: Liskov Substitution Principle.  Let’s change the implementation a bit that will break LSP.

[gist id=&#8221;5007533&#8243;]

Now that we need to set the Carrier on the SMSMessenger, we have to change what the order processor to set the carrier in the case of SMSMessager.  As you can see it really complicates using the messenger.  Now the OrderProcessor must have specific knowledge on how use a concrete type, and so will every other component that needs to send a message.  In this case there are several ways to solve this problem will still maintaining the LSP and we’ll discuss some of them later.

<div>
  <hr align="left" size="1" width="33%" />
  
  <div>
    <p>
      <a title="" href="#_ftnref1">[1]</a> To be fair I took the graduate level course after a couple of years of experience, but I felt that I had a better grasp of the material than my professor did.
    </p>
  </div>
  
  <div>
    <p>
      <a title="" href="#_ftnref2">[2]</a> While I don’t think I learned much about OOP in graduate school, I learned a lot of other things that would never have been exposed too otherwise and overall I think the experience is worthwhile.
    </p>
  </div>
</div>