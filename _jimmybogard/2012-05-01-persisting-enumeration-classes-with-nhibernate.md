---
wordpress_id: 625
title: Persisting enumeration classes with NHibernate
date: 2012-05-01T13:31:40+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/05/01/persisting-enumeration-classes-with-nhibernate/
dsq_thread_id:
  - "671493115"
categories:
  - DomainDrivenDesign
  - NHibernate
---
As part of my “[Crafting Wicked Domain Models](http://youtu.be/GubLNJL47K8)” talk, I walk through the concept of [enumeration classes](http://lostechies.com/jimmybogard/2008/08/12/enumeration-classes/), yanked from Java and on Jon Skeet’s [list of biggest C# mistakes](http://vimeo.com/17151234) (or missing features). In my talk, I leave out how to bridge the gap from your domain model to an ORM, simply because it’s just out of scope for that talk to address persistence concerns. Besides, the ORM I use these days to persist relational domain models (NHibernate) handles all the crazy cases an more, so I don’t feel like looking at anything else.

But what I leave out of a talk, I can certainly blog about! Suppose we have one of our enumeration classes (available [here on NuGet](http://nuget.org/packages/Enumeration)):

[gist id=2567716]

When it comes time to persisting this enumeration class, we want to make sure that the database schema uses the integer value as what gets persisted. When it writes, we want the value to persist, and when it reads, we want the correct enumeration value (Red/Blue) to be hydrated.

To do this in NHibernate, we’ll first need a custom type:

[gist id=2567876]

This class is the bridge between our ORM (NHibernate) and our enumeration class. NHibernate is fantastic in its ability to provide easy ways to bridge to value objects. Value objects help avoid primitive obsession, but is only useful if you can actually use them when you’re mapping to your persistence layer.

To instruct NHibernate to use our custom types when reading/writing, the easiest way to do so is with a [Fluent NHibernate convention](https://github.com/jagregory/fluent-nhibernate/wiki/Conventions):

[gist id=2567888]

This convention walks the type hierarchy for each property type given, and checks to see if the property type’s type hierarchy is a generic type that closes the open generic type of our enumeration class. Finally, we just need to hook our convention up to [Fluent NHibernate](http://www.fluentnhibernate.org/), but that really depends on how we have Fluent NHibernate hooked up. We don’t have to use Fluent NHibernate to hook up our custom user type, but it’s _much_ easier this way.

With NHibernate, we get the benefits of using Java-style enumeration classes, and have it seamlessly plug in to our persistence layer, which is the whole point of ORMs, right?