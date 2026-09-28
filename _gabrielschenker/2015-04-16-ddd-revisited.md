---
wordpress_id: 929
title: DDD revisited
date: 2015-04-16T20:42:43+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=929
dsq_thread_id:
  - "3688303092"
categories:
  - DDD
  - Design
  - How To
  - practices
---
## Introduction

Way too many times I encounter applications that claim to have a domain (model) and that domain driven design has been used to develop it, but in reality what I find is a collection of entities or shall I say DTOs each one having a bunch of properties but no real logic associated. Furthermore I can find a lot of services of all kind that contain a colorful mixture of business logic and/or infrastructure logic. If the application is also using some form of message bus like NServiceBus, Mass Transit or Azure Bus, to just name a few, then we certainly also will spot some messages that are sent around from one module to another or many others. Unfortunately the messages often have very generic names that contain the words &#8220;update&#8221;, &#8220;modify&#8221;, &#8220;insert&#8221; or &#8220;delete&#8221; and the payload of the messages is really fat, dozens of properties that are sent on their way. Frequently it is not immediately clear from their respective names whether the message is a command or an event. We have to dig deep into the implementation to find those things out.

I truly wish what I just wrote above was exaggerated or would only apply for &#8220;old&#8221; applications that have grown out of control. But the sad truth is that this applies to many projects that have started on the green field and are only a few months old. Why is this the case? There are certainly many reasons &#8211; lack of knowledge is one of the more important one.

## DDD &#8211; What&#8217;s relevant?

When we want to create a new application, ideally from grounds up, and we want to use DDD then we should consider this: not everything that has been written in the blue book is equally important. Unfortunately the first 14 chapters or so deal with implementation details that have more to do with good object oriented programming and not so much with domain driven design. The last few chapters of the book contain the really interesting stuff. But a lot of developers don&#8217;t read so far and have already started to implement their applications.

### Finding the common language

When we start a new project then we need to first try to truly understand the business domain for which we build the application. We need to talk to the stake holders and domain experts (yes, normally that are representative of the client for which we build the software) and try to understand their language. We need to listen carefully what they say and how they say it. Are they using certain words that everyone working in the domain automatically understands and uses in the same way? Are these words unambiguous and intention revealing? If not then we need to ask questions and require the domain experts to describe their terminology in more detail or with other words or even use analogies. One of my favorite &#8220;games&#8221; is to ask the domain experts how they would do their tasks of which we are talking in absence of computers. What would be the actions and what the object, things, concepts or nouns?

Over time (yes this can take days or weeks to do it right) we will have a common vocabulary on which we all agree &#8211; the stakeholders, domain experts, business analysts, architects, developers, testers and QA engineers. We will call this vocabulary or &#8220;language&#8221; that we now have in common the **ubiquitous language**.

Note that the ubiquitous language is probably going to evolve over the duration of the software project as we get a deeper and deeper understanding of the problem domain including all its many subtleties and edge cases.

### Breaking down a complex problem

Once we have found or defined the ubiquitous language of the problem domain we can start to model the domain. But most often the business domain for which we are going to write the software is rather complex and hard to overlook and/or understand all at once. Thus we need to start breaking down the whole complex domain into smaller pieces of lesser complexity. It is the same approach that we use when we eat. We are not able to swallow a whole steak at once but need to cut it into pieces and then eat one piece after the other. We can do exactly that with every problem domain. With the help of the domain experts we need to identify the sub-domains or areas that we can isolate from each other and look at them individually and solve them in isolation. When we do that then we call those sub-domains **bound contexts**. A bound context is a part of the overall domain that can be solved individually and that has clear boundaries and interacts over well defined interfaces with other bound contexts.

### Defining interfaces and contracts

Now that we have broken down the complex business domain into smaller and less complex bound contexts we need to think about how these bound contexts interact with each other. Each bound context should look like a black box from the outside. Implementation details don&#8217;t matter if I am not part of the bound complex. The interaction with a bound context happens over well defined **interfaces** using carefully crafted **contracts**. Once again this wonderfully matches with our real world experience. If we want to do business with say an insurance then both parties, I and the insurance company have to agree on certain contracts. Contracts describe in detail how we do business together. There are no dis ambiguities. And once established and mutually signed it is not easy to change a contract &#8211; it is totally possible but it is not free. The same way we should think when we define the interfaces and contracts for our bound contexts. Contracts are the messages that we exchange between the bound contexts &#8211; commands and events. Here the name and payload of the contracts matter. The name gives the context of the command or event and the payload contains the delta that is needed to go from one state to the next.

We should clearly distinguish between commands and events. A command always has a target. It is exactly one target. The target of the command can either accept or reject a command. The result of a command usually is a change in the system. Something has been done that changed the state of the model. On the other hand an event can have zero to many listeners. Yes that&#8217;s right, events can be ignored&#8230; but events can never be rejected since they tell us what has already happened. To clearly distinguish commands from events we should use names written in imperative for commands and names written in past tense for events. The names should reflect the ubiquitous language that we have established.

## DDD &#8211; what we should avoid

If we want to use domain driven design while developing a solution for the problem domain we&#8217;re working in then we should avoid a few pitfalls.

### A data-centric world

In the past most line of business applications were data-centric applications. The data model was the first thing that architects and engineers would design. Everything else would follow. People would say &#8220;&#8230; at the end of the day data is what&#8217;s counting. The data that we collect is our asset. Applications that collect and/or use the data come and go but data remains&#8230;&#8221;. And although data remains&#8230; it is just plain wrong to claim that data is all what counts! Data on its own is meaningless. Data alone is dead. Only logic gives the data a meaning. And the very same data has different meaning in different contexts. Thus we should always start with the context and the logic.

A data-centric view of the world also lead to the fact that databases are often used as integration point. Many different applications access the same database. This leads to a lot of problems in the long run. To give you a good analogy of what I am talking about let&#8217;s imagine that I have a wallet with some money in my pocket. Now my friend ran out of cash and wants to borrow 10 bucks. How does our world work in this case? a) my friend politely asks we for 10 bucks and I open my wallet and hand him out the money or b) my friend takes my wallet out of my pocket (without me realizing it) and takes a 10$ bill out. Thus: in a LOB application never use a database as integration point.

When I am implementing an application the ERD is one of the least important things to me. I do not let myself and my domain model be driven by the choice of a data store or data model. For me LOB application does not automatically mean that I have to use an RDBMS and that my data model needs to be in 3rd normal form!

### Talking about implementation details

DDD is NOT primarily about entities, value objects, services, repository or factory pattern and the like. These are all implementation details. They have no real meaning until we have done our homework and defined the ubiquitous language, the bound contexts and the interfaces and contracts. If we start too early with the implementation then the result is an anemic domain consisting of a collection of DTOs surrounded by an awful lot of services and business logic that is spread over all places.

### Using techno babble

In our application we should never use concepts or words like save, update, insert, delete, handle, manage, etc. These are either very technical terms or abstract concepts with no specific meaning. If I have a saying then one of the first things I do is ban the &#8220;Save&#8221; button from the UI of the application. Save is not a business concept. Imagine a world without computers doing business &#8211; do the involved people ever use a sentence like this &#8220;&#8230; on, let me save this&#8230;&#8221; (one exception is saving money on a bank account). Also in a real business we never &#8220;Delete&#8221; or &#8220;Insert&#8221; or &#8220;Update&#8221; something. Do we delete an employee when he is no longer required in the company?

Very generic terms like &#8220;manager&#8221; need to also be avoided. What does a manager do? What does &#8220;manage&#8221; mean? No, no, we need more context please!

### Database transactions

Although DB transactions are a good thing on its own, it is wrong to overuse them. Much more important than DB transactions are business transactions. Whilst by definition DB transactions are fully consistent (and short running) business transactions are not. A sample of a business transaction that you probably are very familiar with is what&#8217;s happening at Starbucks when in the morning you order your favorite coffee. This is a &#8220;long&#8221; running process with many possible &#8220;inconsistent&#8221; intermediate states and asynchronous tasks. Yet this is what works, is scalable, and wildly accepted by everyone.

Thus when modeling your domain using DDD don&#8217;t think about DB transactions (or even worse &#8220;distributed transactions&#8221;) at all. Think about possible actions, their outcome and about compensating actions if something fails. And you will see that you will solve mainly business relevant problems and that you do not fight with technical problems.

## Conclusion

Using domain driven design successfully means that we need to do a few things very well from the beginning, mainly define a common vocabulary called the ubiquitous language, break down the overall complex problem domain in to smaller sub domains called bound context and to carefully define the boundaries and contracts used between the individual bound contexts. On the other hand we need to avoid certain practices that are all too common among software developers. These are using a data centric view when modeling the problem domain, focusing on implementation details like entities, value objects, services, etc. instead on the core concepts discussed above, using generic and developer specific terms and concepts when implementing the application and finally overrating DB transactions instead of focusing on the business processes or transactions.