---
wordpress_id: 278
title: Crafting wicked domain models with Components in DDD
date: 2009-02-03T03:30:01+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/02/02/crafting-wicked-domain-models-with-components-in-ddd.aspx
dsq_thread_id:
  - "264716072"
categories:
  - DomainDrivenDesign
---
Domain-Driven Design can help focus development efforts into crafting a strong, expressive domain model.&#160; In Evans’ book, he dives in to a series of patterns which, when combined, form that strong domain model.&#160; These patterns include Entity, Value Object, Service, Factory, Repository, Aggregates and Roots.&#160; I think one of the biggest mistakes of someone learning and applying DDD is assuming that our entire model needs to fit into those few definitions.

When you do so, you wind up in spots where you’re trying to use a Repository from inside an Entity, or violating other more basic OO design principles.&#160; When you’re feeling like you’re bending over backwards to fit everything into one paradigm, it’s time to stop, take a step back, and try a different angle.&#160; The GoF design patterns book introduced a lot more patterns than described in Evans’ book, and all are valid inside the domain.&#160; We shouldn’t artificially limit ourselves to the patterns in Evans’ book, as it was never meant to be an exhaustive domain patterns library.&#160; Many times, what looks like a DDD problem is just an OO problem hiding in plain sight.

One example I’ve seen of a powerful OO design concept not explicitly called out is the Component pattern.&#160; Before we get hopelessly derailed in pattern mumbo-jumbo, let’s explore how, on a recent project, we came to know and love this pattern.

### Quick domain rundown

In this project, we were designing a service layer on top of an existing legacy application.&#160; This legacy application contained about 3 million lines of code, roughly evenly split between VB.NET, SProcs, and COBOL.NET (yes, you read that right).&#160; This application was the heart and soul of a very large corporation, but needed to be adapted to work in another, more larger corporation that just bought them out.&#160; Long story short, our team was there to implement this service layer.

This company specialized in selling one thing: Software Licenses.&#160; Of course, nothing was simple, but we were able to use NHibernate to interface with the legacy database (which was ported from a mainframe application), and design our domain model with ZERO compromises.

In this simplified view of Software Licenses, there are two types of products a Customer can purchase:

  * VLA Products
  * Non-VLA Products (such as retail, OEM, etc.)

To purchase a Non-VLA Product, you could be anyone, Joe Schmoe off the street.&#160; To purchase a VLA Product, you needed to have a Contract set up with a Publisher, usually that you would agree to purchase so many licenses a year, and so on.

So, two types of Products.&#160; VLA and Non-VLA.&#160; A VLA Product by itself is worthless in our domain, you can’t purchase that.&#160; Once you have a Contract set up, now we’re in business, and I can find details on your Contract that lock you in to certain pricing buckets.&#160; Our final domain model looked something like this:

 ![](http://grabbagoftimg.s3.amazonaws.com/VolLicExample.png)

All Products were defined as a Product in our model, but VLA Products were linked to a base Product, plus the licensing Program Option you signed a contract for.&#160; The combination of these two pieces (MS Office for the MS Select Plus program) ultimately defined what your final price was.&#160; A single VLA Product would have one Product, plus a bunch of VLA Product entries defined for each option level defined for the licensing Program.

Confusing, I know, it took us quite a while for it to sink in.

The bottom line came to when we actually needed to be able to purchase one of these things.&#160; If you’re buying a Non-VLA Product, you just have our Product object.&#160; If you’re buying a VLA Product, you have a VlaProduct object.

### 

### Complicating matters

Things were going to get even more complicated.&#160; On top of a base purchase price that may come from one of two places (Product or VlaProduct), this software had all sorts of custom pricing logic designed for sales guys to pull different levers and switches to seal a deal or make some extra cash.&#160; Things like running a special on any Spreadsheet product type, or any Adobe published software.&#160; Maybe the final price is base price plus a percentage, or targeted to a certain margin, or just some explicit, hard-coded price.&#160; All this came out of another place.&#160; On top of all of that, you had pricing limits in place so that you couldn’t give crazy sweetheart deals that made your quota but killed the bottom line.

Going even further, you had many different billing options, depending on your program and contract…and product.&#160; Annual billing, proration, annual combined with proration.&#160; We counted about two dozen different ways someone could get billed, all affecting the price you see on your screen.

We were at a crossroads.&#160; Should our Entities (Product and VlaProduct) know about the myriad of ways its final price could be calculated?&#160; Or do we spread this logic around haphazardly in a dozen Services, leading to domain anemia?

Neither, of course.&#160; This was an OO problem, to be solved with basic OO concepts.&#160; At its heart, we went with Composition over Inheritance.

### Crafting our Components

Since a Product by itself really wasn’t purchasable by itself, we crafted the idea of a PurchasableProduct.&#160; This would be composed of two pieces: a BaseProduct that contained base price and cost calculations, such as UnitCost, ListPrice, etc.&#160; We had one unified view into “something that had a name, a SKU, price and cost”.&#160; This wasn’t a row in any database, but an abstraction needed to conceptualize our model.

The other piece was a PricingStrategy, which was able to take a BaseProduct and give you a final purchase price.&#160; The kicker was that this PurchasableProduct was neither an Entity nor a Value Object.&#160; It had no identity, so it clearly wasn’t an Entity.&#160; But on the Value Object side, it wasn’t really an object defined by attributes.&#160; The PurchasableProduct is an Aggregate Component, from Framework Design Guidelines:

> An aggregate component ties multiple lower-level factored types into a higher-level component to support common scenarios.

This is just a fancy definition for favoring composition into a single class:

 ![](http://grabbagoftimg.s3.amazonaws.com/VolLicExample2.png)

Our PurchasableProduct Component combines the concept of a BaseProduct (which could be a VLA or Non-VLA Product) and a PricingStrategy, which could be absolutely anything.&#160; The PurchasableProduct has real domain-heavy behavior, as its cost and price calculations combine the BaseProduct and PricingStrategy objects to something and end-user can purchase.

In this case, the only kind of identity I care about is referential identity.&#160; The building of a PurchasableProduct is obviously quite complex, as it has to create a dynamic pricing strategy plus some kind of Product.&#160; This object is a snapshot in time, as a Customer’s pricing can change at any time.&#160; However, the price can never change on a PurchasableProduct, as there are certain guarantees on prices that they won’t go up or down after a Customer has chosen to buy this Product.

The really great part about this pattern is that the PurchasableProduct concept became part of the ubiquitous language of our team (devs plus domain experts).&#160; It used composition, meaning that each piece could vary without affecting the other.&#160; Complexity of pricing strategies was kept completely separate from base product pricing and costing, but finally combined into one model that everyone could talk about in a meaningful way.

### 

### How we got there

It became clear very early on that our Entities by themselves did not have enough behavior for them to stand alone at time of purchase.&#160; Customers purchased Products, but they also had a lot more that went into exactly what price they paid.&#160; But this extra information was dynamic, determined only when requested and never persisted.&#160; Pricing rules were persisted, but the results of their calculations against products were not calculated until a PurchasableProduct was requested by a Customer.&#160; At that point, pricing was locked and final price was determined by a transient PurchasableProduct.

If we put all of our logic around a bunch of surrounding Services, we would notice that groups of behavior tended to clump together, and wanted a home.&#160; Not to mention, we needed a way to group a Product requested with a snapshot of pricing logic.&#160; Additionally, when we first had price and cost just attributes on PurchasableProduct, we found an awfully anemic domain model where lots of services concerned with the PurchasableProduct were very far away from it.&#160; It became an exercise in fixing the [Inappropriate Intimacy](http://wiki.java.net/bin/view/People/SmellsToRefactorings) smell to get towards a solid OO design.

A very bad turn would have been to make the Products be responsible for determining dynamic price and cost strategies.&#160; The problem with that concept is that it didn’t reflect the reality of our conceptual model – that PurchasableProducts were _snapshots_ in time, and should give the exact same result every time I ask for the Cost and Price.

This design didn’t come easy, nor overnight.&#160; It came after months of learning and tweaking, until we had a huge breakthrough in about a week of time.&#160; We felt exactly what Evans described in his “Refactoring Towards Deeper Insight” parts of his book – that refactoring a domain model can be both small and incremental, or a sea change.&#160; These sea change refactorings can only come after a long and deep knowledge of the big picture of the domain, as our earlier efforts were fairly close to clutching at straws, in the dark.

### Power of composition

If I could point to one strength in our design, it was our choice of composition over inheritance.&#160; Because we allowed individual pieces to vary independently from each other, we were far more prepared for dealing with complexity.&#160; When we first broke into our PricingStrategy idea, we only had a couple of pricing strategies.&#160; As we took on more and more of the underlying legacy system’s design, we were able to handle that new complexity through simple, independent changes.

This design wasn’t accidental, nor was it perfect the first time around.&#160; But if we stuck strictly to the patterns listed in DDD without using the full breadth of OO knowledge and patterns at our hands, we wouldn’t have nearly as elegant of a design as where we arrived.

We could have stuffed all of these calculations into Services or Entities, but that wouldn’t have fit into a model we could communicate about with our domain experts.&#160; Don’t artificially constrain yourself to the five or six patterns listed in the DDD book, the OO world is too huge to not take advantage of.