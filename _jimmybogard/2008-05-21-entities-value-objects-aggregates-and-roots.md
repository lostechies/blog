---
wordpress_id: 186
title: Entities, Value Objects, Aggregates and Roots
date: 2008-05-21T02:59:35+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/05/20/entities-value-objects-aggregates-and-roots.aspx
dsq_thread_id:
  - "264715703"
dsq_needs_sync:
  - "1"
categories:
  - DomainDrivenDesign
redirect_from: "/blogs/jimmy_bogard/archive/2008/05/20/entities-value-objects-aggregates-and-roots.aspx/"
---
Taking a small detour before I deliver the first installment in the [Domain-Driven Design: Supple Design Patterns](https://lostechies.com/blogs/jimmy_bogard/archive/2008/05/15/domain-driven-design-supple-design-patterns-series.aspx) series, I&#8217;d like to cover the basic elements of Domain-Driven Design modeling:

  * Entities
  * Value Objects
  * Aggregates and Roots

I&#8217;d like to cover these aspects partially because these ideas play a large role in the later ideas, but also because [Rob asked me to](http://blog.wekeroad.com/mvc-storefront/mvc-store-intermission2-over/) (see comments).&nbsp; If you&#8217;d like an in-depth discussion of these topics, just check out Eric Evans&#8217; Domain-Driven Design, chapters 5 and 6.

### Entities

From Evans:

> Many objects are not fundamentally defined by their attributes, but rather by a thread of continuity and identity.

In traditional object-oriented design, you might start modeling by identifying nouns and verbs.&nbsp; In DDD modeling, I try to key in on terms coming out of our Ubiquitous Language that exhibit a thread of identity.

For example, consider a Person concept.&nbsp; If I have two Person objects, with the same Name, are they same Person?&nbsp; Bob Smith from Cheyenne, Wyoming and Bob Smith from Tallahassee, Florida might not agree.&nbsp; A popular gimmick I&#8217;ve seen is interviewing a Person with a famous name (but different identity).&nbsp; So if Name isn&#8217;t a Person&#8217;s distinguishing attribute, what is?&nbsp; Address?&nbsp; Social Security Number?&nbsp; Not for non-US citizens, what about a Kiwi Bob Smith?

In each of these examples, a Person is identified by more than their attributes, such as Name, Address, PhoneNumber, etc.&nbsp; A Person has a unique identity that manifests itself if different ways in different systems.&nbsp; Each system has their own attributes they&#8217;re concerned with, but the Person is always the same entity (not class, that&#8217;s different).

My &#8220;litmus test&#8221; for Entities is a simple question:

**If two instances of the same object have different attribute values, but same identity value, are they the same entity?**

If the answer is &#8220;yes&#8221;, and I care about an identity, then the class is indeed an entity.&nbsp; I model entities with reference objects (classes), and I give them a surrogate identity (i.e., probably a GUID).&nbsp; Additionally, my model must include what it means to have the same identity.&nbsp; That means overriding Equals, looking solely at the identity and not attributes.

### Value Objects

From Evans:

> Many objects have no conceptual identity.&nbsp; These objects describe characteristics of a thing.

When I don&#8217;t care about some object&#8217;s identity, I carefully consider making the concept a value object.&nbsp; For example, if I have a system that models Paint buckets, the Color is a great candidate for a Value Object.&nbsp; I care about one specific PaintBucket or another, as I paint with individual PaintBuckets that will eventually be drained of their paint.

But when checking the Color of a specific PaintBucket, the Color has no identity in an of itself.&nbsp; If I have two Colors with the exact same pigmentation values, I consider them to be the same.

When designing Value Objects, I want to keep them away from the trappings of Entity life cycles, so I make the Value Object immutable, and remove any concept of identity.&nbsp; Additionally, I&#8217;ll override Equals to compare attributes, so that attribute equality is represented in my model.

By making my Value Object immutable, many operations are greatly simplified, as I&#8217;m immediately led down paths to Side-Effect Free Functions.&nbsp; I don&#8217;t create a type with a bunch of read-write properties and call it a Value Object.&nbsp; I make it immutable, put all of the attributes in the constructor, and enforce attribute equality.

Value Objects, like any other pattern, can be over-applied if you go hunting for opportunities.&nbsp; Value Objects should represent concepts in your Ubiquitous Language, and a domain expert should be able to recognize it in your model.

### Aggregates and Roots

In real life, many concepts have relationships to each other.&nbsp; I have a set of credit cards, and each credit card has an owner (me).&nbsp; Each credit card has a billing institution, and each banking institution has a set of credit accounts, each of which may or may not be a credit card.&nbsp; If I were to represent all of these concepts as classes, what would the relationships be?

Should I represent every conceivable relationship possible in my object model?&nbsp; Where do I draw the line between whether or not to create a reference?&nbsp; If I have a reference between two entities, how should I handle persistence?&nbsp; Do updates cascade?&nbsp; Suppose an Employer has reference to their Manager directly.&nbsp; If I change the Employee.Manager.Name, and save the Employee, does the Manager&#8217;s Name get changed?

Object modeling is complex as it is.&nbsp; Invariants need to be enforced not only in an Entity, but in all the Entities that are referenced as well.&nbsp; That gets tough to maintain, and quick!

Aggregates draw a boundary around one or more Entities.&nbsp; An Aggregate enforces invariants for _all_ its Entities for any operation it supports.&nbsp; Each Aggregate has a Root Entity, which is the only member of the Aggregate that any object outside the Aggregate is allowed to hold a reference to.&nbsp; From Evans, the rules we need to enforce include:

  * The root Entity has global identity and is ultimately responsible for checking invariants
  * Root Entities have global identity.&nbsp; Entities inside the boundary have local identity, unique only within the Aggregate.
  * Nothing outside the Aggregate boundary can hold a reference to anything inside, except to the root Entity.&nbsp; The root Entity can hand references to the internal Entities to other objects, but they can only use them transiently (within a single method or block).
  * Only Aggregate Roots can be obtained directly with database queries.&nbsp; Everything else must be done through traversal.
  * Objects within the Aggregate can hold references to other Aggregate roots.
  * A delete operation must remove everything within the Aggregate boundary all at once
  * When a change to any object within the Aggregate boundary is committed, all invariants of the whole Aggregate must be satisfied.

That&#8217;s a lot of rules!&nbsp; All of them just come from the idea of creating a boundary around our Aggregates.&nbsp; The boundary simplifies our model, as it forces us to consider each relationship very carefully, and within a well-defined set of rules.&nbsp; Maintaining bi-directional associations is difficult enough without persistence thrown into the mix, so by modeling our relationships around real-world use cases, we can greatly simplify our model.

Not all relationships need to be represented through associations.&nbsp; In the Employee/Manager relationship, I can have a Manager directly off the Employee, but to get a Manager&#8217;s DirectReports, I&#8217;ll ask the EmployeeRepository.&nbsp; Since Employee is an Aggregate Root, it&#8217;s fine to have an Employee reference its Manager.

### Modeling and simplification

One of my favorite quotes from Evans&#8217; book is:

> Translation blunts communication and makes knowledge crunching anemic.

To avoid translation, we&#8217;ll represent real-world concepts in our conceptual model, and our conceptual model expressed as code through Entities and Value Objects (and Services).&nbsp; To simplify our model, we&#8217;ll use Aggregates and Roots, enforcing invariants at each operation.&nbsp; In all cases, I should be able to represent our conceptual model in our code, and it should make sense to our domain expert, as they&#8217;ll see the Ubiquitous Language represented.

When the conceptual model we create with the domain expert is realized effectively in code, we&#8217;ll find that not only to technical refactorings become easier, but enhancements to our model as well.&nbsp; Entities and Value Objects are but a slice in the DDD world, but a core concept which many other ideas are built upon.