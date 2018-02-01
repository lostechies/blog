---
id: 389
title: 'Strengthening your domain: a primer'
date: 2010-02-04T02:41:42+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2010/02/03/strengthening-your-domain-a-primer.aspx
dsq_thread_id:
  - "264781121"
categories:
  - DomainDrivenDesign
---
Posts in this series:

  * [A primer](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/02/03/strengthening-your-domain-a-primer.aspx)
  * [Aggregate Construction](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/02/23/strengthening-your-domain-aggregate-construction.aspx)
  * [Encapsulated Collections](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/03/10/strengthening-your-domain-encapsulated-collections.aspx)
  * [Encapsulated Operations](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/03/24/strengthening-your-domain-encapsulating-operations.aspx)
  * [Double Dispatch Pattern](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/03/30/strengthening-your-domain-the-double-dispatch-pattern.aspx)
  * [Avoiding Setters](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/03/31/strengthening-your-domain-avoiding-setters.aspx)
  * [Domain Events](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/04/08/strengthening-your-domain-domain-events.aspx)

Recently, I talked some about the idea of an intentionally anemic domain model, under the name of “[Persistence Model](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/12/03/persistence-model-and-domain-anemia.aspx)”.&#160; While a Persistence Model is great for a large percentage of projects, you may eventually want to move more behavior into the domain.&#160; That doesn’t mean a bevy of domain services doing the actual work, however.&#160; A strong domain means that our objects become more behavioral, and less as solely data-holders.

But before we get into some of the patterns, what are some of the goals we want to achieve with a stronger domain?&#160; And how do we get there, what should we be looking for?

### Code smells

A lot of DDD is just plain good OO programming.&#160; Unit tests and code smells are the best indication that our domain is wrong, along with conversations with our domain experts.&#160; In systems that start to move beyond merely CRUD, specific code smells start to surface that should indicate that our system is starting to accumulate behavior, but it just might not be in the right place.&#160; In a behavior-rich, but anemic domain, the domain is surrounded by a multitude of services that do the actual work, and fiddle with state on our domain objects.&#160; The domain objects contain state to be persisted, but it’s not the domain objects themselves exposing any operations.

But this is just code smell!&#160; Lots of code smells indicate that our domain is not as rich as at could be.&#160; The behavior is out there, but just needs to be moved around.&#160; Some smells I look for include:

  * Primitive Obsession 
  * Data Class 
  * Inappropriate Intimacy 
  * Lazy Class 
  * Feature Envy 
  * Middle Man 

All these are smells between classes, where usually a domain service is waaaay to concerned with a set of entities, when behavior could just be moved down into those entities

### 

### Aggregate Roots

One of the most quoted, but most misunderstood ideas in DDD is the concept of aggregate roots.&#160; But what is this aggregate root?&#160; Is it just an entity with a screen in front of it?&#160; A row in a database?&#160; Evans defined a set of rules for Aggregates:

  * The root Entity has global identity and is ultimately responsible for checking invariants 
  * Root Entities have global identity.&#160; Entities inside the boundary have local identity, unique only within the Aggregate. 
  * Nothing outside the Aggregate boundary can hold a reference to anything inside, except to the root Entity.&#160; The root Entity can hand references to the internal Entities to other objects, but they can only use them transiently (within a single method or block). 
  * Only Aggregate Roots can be obtained directly with database queries.&#160; Everything else must be done through traversal. 
  * Objects within the Aggregate can hold references to other Aggregate roots. 
  * A delete operation must remove everything within the Aggregate boundary all at once 
  * When a change to any object within the Aggregate boundary is committed, all invariants of the whole Aggregate must be satisfied. 

It’s a lot, but I generally think of Aggregate roots as consistency boundaries.&#160; When I interact with an Aggregate, its invariants must _always_ be satisfied.&#160; Keeping invariants satisfied strengthens the design and responsibility of the objects, as the logic that defines the Aggregate is then self-contained.

### Strategic Design

We may not like it, but not all of our system’s model will ever reach our vision of perfection.&#160; Which is fine, as a perfect model across our entire system would be prohibitively expensive, with little ROI on all that work.&#160; Instead, we have to focus on specific areas of the core domain that provide the most value to the customer.&#160; The better our core domain model, the better our system represents the conceptual model we’ve defined with our customers, and the better we will be able to serve their needs.

Unfortunately, all the interesting Strategic Design chapters are after the basic DDD patterns in the book, so that many folks get lost discussing repositories, entities, aggregates and so on.&#160; But in recent interviews, Evans mentions that these later discussions are more important than the earlier ones.&#160; The bottom line is that we have to choose carefully where we spend our time refining our domain model.&#160; Some areas will not be as refined as others, but that’s perfectly acceptable.&#160; The trick is to find which areas will give us the most value for our time spent in refactoring, refinement and modeling.

Finally, it’s worth noting that there is no “best” design.&#160; There is only the “best design given our current understanding”.&#160; Software development is a process of discovery, where concepts that seemed unimportant or hidden may suddenly become obvious and critical later.&#160; That’s still normal, and not a negative thing.&#160; Lots of concepts around an idea will be thrown around, but only the most important ones will rise to the top, and sometimes that just takes time.

### Looking ahead

So you’ve decided to do DDD, but all you’ve done is establish good names for objects that sit on top of database tables.&#160; Not really an improvement, and probably a lot of work.&#160; You look at some DDD sample applications, but they all seem overly complex for what seems like over-engineered CRUD applications.&#160; The last true DDD system I handed off to another team, they would have been at a loss if I just gave them software to look at.&#160; Instead, software diagrams, code, whiteboarding, and a lot of conversation about the core domain were what allowed us to have a successful handoff.&#160; With sample applications built on things like the Northwind or AdventureWorks database, you won’t see that critical tipping point of domain complexity that makes DDD required for long-term success.

In the next few posts, I’ll highlight some common DDD patterns that can help move your core domain model from one of data-driven, anemic models, to rich, behavioral models.