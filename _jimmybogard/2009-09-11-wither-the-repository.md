---
wordpress_id: 351
title: Wither the Repository
date: 2009-09-11T02:05:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/09/10/wither-the-repository.aspx
dsq_thread_id:
  - "264716311"
categories:
  - DomainDrivenDesign
redirect_from: "/blogs/jimmy_bogard/archive/2009/09/10/wither-the-repository.aspx/"
---
Looking at the different Repository pattern implementations, one thing really surprised me – how far off these implementations are from the original Fowler definition of the Repository.&#160; Instead, we see a transformation to the examples in the Evans description of Repository.&#160; Fowler’s definition for a Repository is:

> _Mediates between the domain and data mapping layers using a collection-like interface for accessing domain objects._

But in our original Repository pattern implementations, we see far more than Querying, but persistence as well (Create, Update and Delete).&#160; This is consistent with some of the descriptions in Evans book, where the collection-like interface also allows for modifications – adding and removing – thus completing the lifecycle of a domain object.

But is this Repository pattern needed?&#160; What exactly is the Repository buying us?&#160; In normal usage, I see the Repository pattern doing two main tasks:

  * Encapsulate the data mapping layer 
  * Encapsulating difficult queries (in the Named Query Method approach) 

In some systems, including the one I’m working on right now, each entity corresponds 1 to 1 with a repository implementation – whether or not the repository implementation is doing anything.&#160; Looking back at the Fowler PoEAA book, there is another interesting pattern at play – the [Unit of Work pattern](http://martinfowler.com/eaaCatalog/unitOfWork.html).&#160; The Unit of Work:

> _Maintains a list of objects affected by a business transaction and coordinates the writing out of changes and the resolution of concurrency problems._

A common Unit of Work implementation wraps the underlying data access layer, and provides means of creating transactional boundaries:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IUnitOfWork </span>: <span style="color: #2b91af">IDisposable
</span>{
    <span style="color: blue">void </span>Initialize();
    <span style="color: blue">void </span>Commit();
    <span style="color: blue">void </span>Rollback();
}

<span style="color: blue">public interface </span><span style="color: #2b91af">INHibernateUnitOfWork </span>: <span style="color: #2b91af">IUnitOfWork
</span>{
    <span style="color: #2b91af">ISession </span>CurrentSession { <span style="color: blue">get</span>; }
}</pre>

[](http://11011.net/software/vspaste)

The interesting piece here is the ISession interface from NHibernate.&#160; It puts several key patterns together – Unit of Work, Identity Map, as well as the Data Mapper pattern.&#160; Now, I’ve never been on a project that has wanted or needed to swap out ORM solutions (provided they chose an active, mature solution), so what is this encapsulation of the Repository buying us exactly?

A bigger issue comes into play when trying to implement Command-Query Separation throughout your application – the Repository pattern just does not support it well enough.&#160; Eventually, you’ll likely be left with a class that is Repository in name only, but not the original intent.&#160; Let’s look at some of the problems of Repository to get an idea how CQS doesn’t gel well.

### Loose aggregate boundaries

The problems Aggregate Roots solve is one of spaghetti-coded associations between entities, where I could never figure out the right place to draw the boundary.&#160; I originally assumed that a save operation meant that you would save a single aggregate root, and cascading would take care of the rest.&#160; Unfortunately, that simplicity and rigidity tends to fall flat in larger models.&#160; In an aggregate root, child entities only have identity _within the boundaries of the root_, and no outside identity.

In the web world, that would mean that anything with an Edit link is inherently an aggregate root, as it needs its own global identity to save properly.&#160; We toyed around with local identity, and always passing around the parent object to work on the child.&#160; But all that extra work didn’t buy us anything.&#160; Local identity only bought us anything when you edited an entire entity on one page, including children.

Cascading poses other issues.&#160; What we found is that cascading depends not on the entity I’m working with, but the specific operation/command I’m trying to perform.&#160; Instead, we’ve seen aggregate boundaries depend completely on the command we perform.&#160; Sometimes the root is object A, sometimes it’s B.&#160; Instead of worrying too much about aggregate boundaries, we greatly reduced the relative boundaries of roots, until it was a use-case per use-case basis that determined where we drew our boundaries.

Because roots can hold references to other roots, the concept of a boundary and local identity eventually restricted itself to basically screens where you saved the parent and children in one operation.&#160; Again, it was the C in CQS that drove boundaries.

Thus it started to become confusing how we should handle cascades and save logic.&#160; Since boundaries varied screen-to-screen, it became obvious that any custom save logic in a Repository could be handled perfectly well in the ORM layer, with cascades.&#160; Eventually, our model became extremely connected, with appropriate cascading and modification operations available only when specifically needed.

### 

### First-class queries

On virtually every screen our application, we show the exact same entity.&#160; That’s around 150 screens or so, where what you see begins with one Person, and filters down from there.&#160; This made things quite interesting from the query optimization standpoint.&#160; We had two choices – go through the root Person entity to all of its children, in one slice.&#160; Or, go from the children, and get back to the parent.&#160; But sometimes we show bits and pieces of various slices of our Person object, things that did not fit well with just one Repository call.&#160; We enabled lazy loading – but only because we wanted a well-connected object model, with the knowledge that we would optimize the access later.

When we actually got to the optimizations, we could either create a bunch of GetByIdForAbcScreen on our PersonRepository, or, encapsulate all of the fetching in a single Query object.&#160; Guess which route we went…

With first-class query objects in our system, the need for a true PersonRepository becomes much less.&#160; It doesn’t do any custom queries, those are now in distinct query objects, designed for each situation.

### Wither the Repository?

No, not yet.&#160; Complexity in a system is never uniform, and a single solution rarely fits every circumstance.&#160; The tough part is figuring where to put custom persistence or fetching logic.&#160; New query method on a Repository?&#160; Override the Save method?&#160; Is that custom save logic on _every_ save for this entity, or just for certain commands?&#160; Complexity resembles more the [picture of cosmic background radiation from the Big Bang](http://en.wikipedia.org/wiki/File:WMAP_2008.png), almost random in nature, but a predictable and expected variation.&#160; Most spots are in the middle of the complexity scale, some spots are so easy that the architecture chosen may seem too much, but other spots that bend our architecture to its limits.&#160; The Repository is one of those spots.

Personally, I see a few trends in Repositories:

  * Trend towards a Generic Method Repository, where there is no custom logic for CRUD
  * Queries externalized and encapsulated in Query objects when needed, otherwise exposed through LINQ
  * Custom persistence logic externalized and encapsulated in Commands, that utilize the one Repository implementation as needed
  * Repository becomes relegated, in NHibernate terms, as the ISessionFacade

I’m not fully ready to chuck our custom repositories, as I’m still not quite fully cognizant of what this change might mean.&#160; But the parallel inheritance hierarchies are naive and a little difficult to work with, and don’t really reflect the reality we’re trying to model in our controller level of our application – modeling Queries and Commands as first-class citizens.