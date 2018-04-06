---
wordpress_id: 1254
title: Dealing with Duplication in MediatR Handlers
date: 2016-12-12T20:37:57+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1254
dsq_thread_id:
  - "5375406492"
categories:
  - DomainDrivenDesign
  - MediatR
---
We’ve been using MediatR (or some manifestation of it) for a number of years now, and one issue that comes up frequently is “how do I deal with duplication”. In a traditional DDD n-tier architecture, you had:

  * Controller
  * Service
  * Repository
  * Domain

It was rather easy to share logic in a service class for business logic, or a repository for data logic (queries, etc.) When it comes to building apps using CQRS and MediatR, we remove these layer types (Service and Repository) in favor of request/response pairs that line up 1-to-1 with distinct external requests. It’s a variation of the [Ports and Adapters](http://alistair.cockburn.us/Hexagonal+architecture) pattern from Hexagonal Architecture.

Recently, going through an exercise with a client where we collapsed a large project structure and replaced the layers with commands, queries, and MediatR handlers brought this issue to the forefront. Our approaches for tackling this duplication will highly depend on what the handler is actually doing. As we saw in the previous post on [CQRS/MediatR implementation patterns](https://lostechies.com/jimmybogard/2016/10/27/cqrsmediatr-implementation-patterns/), our handlers can do whatever we like. Stored procedures, event sourcing, anything. Typically my handlers fall in the “procedural C# code” category. I have domain entities, but my handler is just dumb procedural logic.

### Starting simple

Regardless of my refactoring approach, I ALWAYS start with the simplest handler that could possibly work. This is the “green” step in TDD’s “Red Green Refactor” step. Create a handler test, get the test to pass in the simplest means possible. This means the pattern I choose is a [Transaction Script](http://martinfowler.com/eaaCatalog/transactionScript.html). Procedural code, the simplest thing possible.

Once I have my handler written and my test passes, then the real fun begins, the Refactor step!

**WARNING: Do not skip the refactoring step**

At this point, I start with just my handler and the code smells it exhibits. [Code smells](https://martinfowler.com/bliki/CodeSmell.html) as a reminder are indication that the code COULD exhibit a problem and MIGHT need refactoring, but is worth a decision to refactor (or not). Typically, I won’t hit duplication code smells at this point, it’ll be just standard code smells like:

 * Large Class
 * Long Method

Those are pretty straightforward refactorings, you can use:

  * Extract Class
  * Extract Subclass
  * Extract Interface
  * Extract Method
  * Replace Method with Method Object
  * Compose Method

I generally start with these to make my handler make more sense, easier to understand and the like. Past that, I start looking at more behavioral smells:

  * Combinatorial Explosion
  * Conditional Complexity
  * Feature Envy
  * Inappropriate Intimacy
  * and finally, Duplicated Code

Because I’m freed of any sort of layer objects, I can choose whatever refactoring makes most sense.

### Dealing with Duplication

If I’m in a DDD state of mind, my refactorings in my handlers tend to be as I would have done for years, as I laid out in my (still relevant) blog post on [strengthening your domain](https://lostechies.com/jimmybogard/2010/02/04/strengthening-your-domain-a-primer/). But that doesn’t really address duplication.

In my handlers, duplication tends to come in a couple of flavors:

  * Behavioral duplication
  * Data access duplication

Basically, the code duplicated either accesses a DbContext or other ORM thing, or it doesn’t. One approach I’ve seen for either duplication is to have common query/command handlers, so that my handler calls MediatR or some other handler.

I’m not a fan of this approach – it gets quite confusing. Instead, I want MediatR to serve as the outermost window into the actual domain-specific behavior in my application:

[<img class="alignnone size-full wp-image-1255" src="https://lostechies.com/content/jimmybogard/uploads/2016/12/image.png" alt="" width="324" height="237" />](https://lostechies.com/content/jimmybogard/uploads/2016/12/image.png)

Excluding sub-handlers or delegating handlers, where should my logic go? Several options are now available to me:

  * Its own class (named appropriately)
  * Domain service (as was its original purpose in the DDD book)
  * Base handler class
  * Extension method
  * Method on my DbContext
  * Method on my aggregate root/entity

As to which one is most appropriate, it naturally depends on what the duplicated code is actually doing. Common query? Method on the DbContext or an extension method to IQueryable or DbSet. Domain behavior? Method on your domain model or perhaps a domain service. There’s a lot of options here, it really just depends on what’s duplicated and where those duplications lie. If the duplication is within a feature folder, a base handler class for that feature folder would be a good idea.

In the end, I don’t really prefer any approach to the another. There are tradeoffs with any approach, and I try as much as possible to let the nature of the duplication to guide me to the correct solution.
