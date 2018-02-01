---
id: 41
title: Initial Thoughts on Microservices
date: 2015-05-10T00:06:54+00:00
author: Andrew Siemer
layout: post
guid: http://lostechies.com/andrewsiemer/?p=41
dsq_thread_id:
  - "3758464786"
categories:
  - Microservices
---
I have spent quite a bit of time teaching cqrs, ddd, strong boundaries, document data stores, and all sorts of other methods for taming complexity in either wide applications (lots of features/complexity) or  high volume systems (both have different issues).  Microservices has been very interesting to me on the side for a while.  But since working on a few massive projects at {insert big commerce company name here} and seeing some of the complexities around trying to mash up massive monolithic systems, I am compelled to look at microservices as an upfront solution for addressing the day to day complexities of even some of the smaller systems we build.

There are all sorts of trade-offs with microservices as you probably all know.  The first rule of any distributed system being don’t do it!  Of course.  But there are also issues such as chattiness on your network, more moving pieces to be managed in production, more complexity around deployment processes. The list goes on.

But I have found myself wondering quite a bit lately if it shouldn’t be the norm for many medium complexity systems?  I am not making that statement here and now.  Instead I figured I would explore the concept in the open over the course of a few posts and perhaps we can have a great conversation along the way. I have no agenda to push microservices one way or the other.  Just curious!

## Single Responsibility Principle Everywhere?

Most of us are aware of the SOLID principles.  If you aren’t aware of them… stop reading my dribble and head over to Wikipedia to learn about SOLID ([http://en.wikipedia.org/wiki/SOLID\_%28object-oriented\_design%29](http://en.wikipedia.org/wiki/SOLID_%28object-oriented_design%29)).  As with most “best practices” do keep in mind that you can’t apply any of the solid principles 100% of the time to 100% of your code.

The single responsibility principle to me is an interesting one.  It basically states that there should be only one reason for something to change at the class or module level. This idea leads to stability in the system. Unless I am changing the contract of a class or module, all changes should be internal.  The surface area for testing that one thing is small and easy to understand.  A change here shouldn’t necessitate full stack testing…little impact should be felt.

This usually means that we have an orgy of classes in our code base.  And those classes tend to have long but meaningful names. If you have ReSharper or similar tooling installed, having lots of characters in a class name shouldn’t bother you. Nor should have a lot of classes bother you. Yet these two facts keep people from embracing SRP even in their current monolithic systems…I always wonder why?

What if we were able to apply SRP to the various components of higher level SDLC concepts? What if I had one github repository for each component in my system?  What if I could use “whatever technology best fit the problem” for each component of the system? What if the scope of each component of the system was so small I didn’t have any complexity to manage in code, and therefore didn’t need CQRS or DDD?

This sounds pretty good to me as someone that is involved with staffing teams. I could start to hire folks that didn’t need to be overly skilled at managing complexity. I could have one or two really skilled folks involved with contract definitions.  And an army of folks building lego blocks.

In theory I could build a mashup of components instead of a monolithic system.  Each component with a single reason to change.  A small surface area to test. Its own versioning story. It’s own deployment story (no more managing deployments across teams of monolithic highly coupled systems over the course of several days). That sounds easier in many ways.  But it also sounds like it adds complexity in other new and interesting ways.

## Managing Code Complexity by Building Something Small

I so often come across big code bases that struggle to manage the complexity of the business features (price vs. product vs. search etc.) and the complexities of lots of code coexisting with other code (UI vs. business concerns vs. data access vs. offline processing etc.).  There are usually a whole bunch of architectural complexities and design patterns injected to solve some of these problems.  But usually injected in the form of the shiniest hammer the implementer had in their tool box at the time (I am so guilty of this – be honest…).

Following the SRP concept above, if we spent two weeks building a microservice, focused on only what was needed in a LEAN/MVP way, there should be next to no complexity to manage.  And if we did it just good enough for now, it would be cheap to throw it away and build another once we learned more about our needs.

It’s so very odd to me that the best thing I learned from Udi’s 5 day course on advanced distributed systems (years ago) was this same statement of “get the contract right, build just enough to achieve the business goal, use an entry level guy to build it, throw it away when you need something better” – is now a labeled way of doing things.

## Managing Code Complexity with Hard Boundaries

One of the mechanisms we use to manage complexity in code is through defining healthy logical and physical boundaries that map to the concepts of business.  An example of this is the idea of a “product”.  I have seen so many projects that have one class that is named product.  But when interviewing the company the Marketing Department would define a product as something different from what the folks in the Inventory Department would tell you which might also be different from the folks in the Accounting Department.  If each of these departments have a product concept why not model three different forms of product?

Usually the answer comes down to our issues with efficiency around typing three classes that are all product oriented – we don’t like to repeat ourselves (keep it DRY).  We like the OOP concept of defining a base class and extending it into multiple forms.  But we usually shouldn’t do that if we really paid attention and heard the business.  Marketing’s product is the virtual thing that needs to have well-spoken text around it and lots of pretty pictures.  Inventory cares about how many of those products we have in a warehouse, how big they are, how many are on a boat this very second and about to arrive any day “where are we going to put those?”  Accounting doesn’t really care about any of that.  Instead they want to know what we paid for it vs. what we sold it for.  Did we make a profit?

Defining a hard boundary allows each of these product concepts to have their own life cycle.  Changing some aspect of a product for one department shouldn’t have any potential to break the concept of product anywhere else.  Each boundary should manage its own state. And provide views around its state to other consumers as necessary. In some cases it may even provide UI elements to ensure consistency at all times.

What about groups of domain objects that are all related?  Which one is important (entity)? Which one can’t exist on its own vs. needing its peers to make sense (value objects)?  How do we consistently manage the state of those things (aggregate roots)?  And how do we manage the physical presence of these things in the real world (autonomous components) vs. a larger logical boundary in our code (bounded context)?  All of these concepts are required to manage the complexity of a code base that lives in an uber solution all next to one another (commonly referred to as monolithic…aka spaghetti).  But what if it all didn’t live next to each other?  Wouldn’t we be less likely to create a monolithic system that accidentally starts to take short cuts and couple itself to itself…mistakenly? Enter the senior/junior code review relationship could be reduced to some degree.  People processes to manage accidental complexity could start to be reduced all around.

## Just Getting Started

While this has interested me for many years now – I am starting to see how this could help many teams either building products or servicing clients. Not for cool architectural reasons but for the ability to really focus on delivering just enough – and no more.  And the ability to continuously deliver just enough at a very rapid rate. Instead of having a team whose velocity slows as the complexity of the system increases over time.  Also for the ability to scale a software factory where the needs of the client tend to grow and contract (not forgetting the 9 mother 1 month baby analogy of course).

Please feel free to pose questions here around this topic.  I will do my best to address them in follow up articles and talks.