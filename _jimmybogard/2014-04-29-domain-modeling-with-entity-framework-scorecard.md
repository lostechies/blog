---
wordpress_id: 900
title: Domain modeling with Entity Framework scorecard
date: 2014-04-29T20:08:56+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=900
dsq_thread_id:
  - "2648493457"
categories:
  - DomainDrivenDesign
  - EntityFramework
  - NHibernate
---
A long, long time ago I had a series on [strengthening your domain](https://lostechies.com/jimmybogard/2010/02/04/strengthening-your-domain-a-primer/), highlighting how simple refactoring tools and code smells can help guide your models to push behavior down into your core domain model/business objects/whatever. All the techniques highlighted are things I did on every project, persisting using NHibernate. But what about Entity Framework? How can it handle a fully encapsulated domain model?

In some cases well, in others not. Let’s look at some of the techniques used and see how EF can handle them, and how it differs from NHibernate.

### Constructors requiring invariants

**Verdict: Pass**

EF can handle constructors just like NHibernate handles constructors. If you define a constructor that includes the “invariants” of an entity, you are still required to create a no-arg constructor so that the ORM tool can still instantiate your object (and support lazy loading):

{% gist 11409455 %}

Remember – persistence ignorance is a valid approach up until you run into fundamental limitations of the underlying platform. Both NH and EF require “virtual” for lazy loading, but that’s just a side effect of Java being virtual-by-default, and C#, well, not.

### Private setters

**Verdict: Pass**

EF can handle private setters without any issues:

{% gist 11409540 %}

If you want lazy loading, you might have to make some navigation properties protected. One issue I ran into with EF is that if lazy loading isn’t possible because something isn’t virtual or visibility is incorrect, it will silently fail.

### Private fields, no setters

**Verdict: Fail**

If you fully encapsulate the member, marking the field readonly, Entity Framework cannot map your field. EF still maps to properties, so this doesn’t work:

{% gist f403520ab6c5c366f9b8 %}

This isn’t truly a show-stopper, however, as you can always convert back to a property with a private setter (and live with having a field that can be modified after construction).

### Encapsulated collections

**Verdict: Fail**

Since EF can’t map to fields, you can’t build a fully encapsulated collection:

{% gist e0e75ad7295f081a8c29 %}

I’m trying to create a collection where I don’t publicly expose Add, Remove etc methods. These only exist on the private field. [Julie Lerman details some workarounds](http://msdn.microsoft.com/en-us/magazine/dn342868.aspx), but those are a lot of work for not much gain.

Another option is to create a custom ICollection implementation where your mutating methods are marked with an Obsolete attribute, also ugly.

Unless you want to support these wonky solutions going forward, it’s a lot easier just to expose your collections as…collections and provide explicit methods for operations that mutate the collection. Nothing else really possible here. Is this a showstopper? Not really, but it is annoying:

{% gist a980918524acb4903e7a %}

Anyone can modify that attached collection without following the “rules”.

### Encapsulated primitives (aka the NodaTime/Enumeration class problem)

**Verdict: Fail, Pass with workaround**

Let’s say that instead of a string to represent an Email, you wanted to create an Email class that wraps a primitive with more behavior. This is possible in NHibernate because we can add custom persistable primitives, but not so much in EF. Instead, I need to create a buddy property to represent the mapped primitive:

{% gist c993b065e6c40c406fb6 %}

For querying/persisting purposes, I use that “Value” property. If I need the version with the behavior, I use the property without the “Value” suffix.

Until custom primitive type persisters are supported in EF, the workarounds will have to do. In the meantime, I’m starting to use regular enum’s instead of [enumeration classes](https://lostechies.com/jimmybogard/2008/08/12/enumeration-classes/) until it’s proven that the enum needs associated behavior, like you can do with this persistable strategy pattern:

{% gist cf90481798f8aef96ae8 %}

### Value objects

**Verdict: Don’t use them anyway**

Value objects are possible using Complex Types in EF and Composite objects in NH, but don’t use them. There’s all sorts of weird behavior around null values, and ultimately you’re going to run into friction that your domain model is at fundamental odds with your persistence model. Other databases can handle this sort of thing better (document, other NoSQL databases), so you’re better off not attempting it and running into limitations down the road.

If you need a true Value Object, and it’s not just an encapsulated primitive, you’re much, much better off treating it as an entity in EF and managing the visibility/mutability/navigation yourselves.

### Final Verdict

The only real annoyance here is the collection issue, all others aren’t going to prevent us from building reasonably encapsulated domain models. But NH didn’t let us do that either, it still required us to add code in some scenarios, breaking that “POCO” illusion.

Since we’re not building an object database, some compromise is needed, and so far, I haven’t seen anything that forces an anemic domain model upon us.