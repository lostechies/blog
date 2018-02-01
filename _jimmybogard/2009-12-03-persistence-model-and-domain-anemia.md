---
id: 372
title: Persistence model and domain anemia
date: 2009-12-03T18:26:36+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/12/03/persistence-model-and-domain-anemia.aspx
dsq_thread_id:
  - "264716374"
categories:
  - DomainDrivenDesign
---
Domain anemia is a term thrown around like it’s a horrible disease.&#160; However, a while back, Greg Young talked about an intentional decision to create an [anemic domain model](http://codebetter.com/blogs/gregyoung/archive/2009/07/15/the-anemic-domain-model-pattern.aspx).&#160; In some contexts, an anemic domain model is an [anti-pattern](http://martinfowler.com/bliki/AnemicDomainModel.html).&#160; Instead, I see a rather different issue going on here.&#160; For the vast majority of systems built that I’ve encountered, a true domain model is overkill.&#160; But what is the domain model pattern?&#160; It could be all the way to a [CQRS system](http://blog.fohjin.com/blog/2009/11/12/CQRS_a_la_Greg_Young), or it could be a system where your entities are more than containers of data, but containers of behavior.

The real problem is the assumption from folks doing an anemic domain model that they’re doing DDD or doing a domain model pattern.&#160; But if **your entities only expose data, it’s not a domain model.**&#160; This isn’t necessarily a _bad_ thing though.&#160; It’s more important that this decision is intentional.

Anemic domain model has a negative connotation, so I’d like to get rid of that term used to describe the intentional decision to create an anemic model.&#160; Instead, I like the term **Persistence Model** or **Persistent Object Model** to describe an intentionally anemic domain model.

### The Persistence Model Pattern

In the Persistence Model pattern, entities are designed with names matching the ubiquitous language.&#160; They represent real concepts in the model, and a domain expert can communicate about these entities with the developers.&#160; However, in a Persistence Model, entities can be talked about synonymously with the backing database tables that hold the persisted information.&#160; Relationships drawn between entities represent foreign keys, and “Entity” and “Table” are interchangeable in every day communication.

Designing of a Persistence Model can be accomplished through model-driven design or database modeling, as the entities have a one-to-one relationship to the backing database.&#160; The structure of the entities will still benefit from POCO design guidelines, as the separation of concerns between the actual mapping in and out of the database is easily solved by ORMs.&#160; The impedance mismatch from objects in an OO language and set-based data in a database is still large enough that an ORM provides immense value.&#160; Additionally, ORMs that provide model-driven design capabilities (such as the EF entity designer) are optimized for the Persistence Model pattern.

The Persistence Model pattern can be recognized because the entities themselves are largely not responsible for their own consistency.&#160; For example, you will likely see public mutators (setters) and collections exposed directly.&#160; Entities are used for querying and visualizing data, and for capturing user input and persistence.&#160; Entities do not react to events or “when” things occur, but rather they are largely brainless, strongly-typed data containers.

Because many systems do not have much complexity around their domains, it is far less often that a system needs to do something as a result of an entity changing.&#160; In forms-over-data and records management applications, the system is primarily concerned with getting data and in and out.

### 

### Context is king

So when is the Persistence Model pattern appropriate?&#160; If you’ve already ruled out using straight-up datasets or reading straight from a persistence layer, this pattern is worth looking at.&#160; If you can’t or don’t need a full-on domain model, a persistence model will still help with the impedance mismatch with the persistence mechanism.

Times when you can’t do a full domain model can include situations where you don’t have access to a domain expert, your team isn’t experienced with OO, or time constraints limit the conversations and analysis needed to build a decent domain model.&#160; If the domain isn’t complex, or is largely data-in, data-out, then those are contexts where a full domain model likely isn’t needed as well.

Domain models are usually persistent, but I’d like to separate the definition of an attempted domain model that ends up being anemic, versus creating a persistent object model that is intentionally anemic because there is no need for anything more.&#160; The anemic domain model anti-pattern is well-known and described, but it shouldn’t be applied to all contexts of a behavior-less persistent object model.