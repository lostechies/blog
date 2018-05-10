---
wordpress_id: 902
title: Missing NHibernate features in Entity Framework
date: 2014-05-05T18:18:17+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=902
dsq_thread_id:
  - "2662959248"
categories:
  - EntityFramework
  - NHibernate
---
Recently I blogged about [migrating to EF from NHibernate](https://lostechies.com/jimmybogard/2014/04/22/migrating-from-nhibernate-to-entity-framework/) and how easy it is to create [fully encapsulated models mapped to EF](https://lostechies.com/jimmybogard/2014/04/29/domain-modeling-with-entity-framework-scorecard/). In this particular project, migrating was relatively painless, as it was a fairly new schema and quite amenable to code-first mapping in EF. The migration was successful in that I didn’t have to undo it and there were relatively few changes that I had to make to the underlying model.

However, there are still reasons why I’d stick to NHibernate, mainly around missing features that exist in NHibernate but don’t exist (yet) in Entity Framework. How important these features are varies from project to project, so while one project might be best using a micro-ORM, one might be best using NHibernate or EF. My punch list of missing features (so far):

  * Unique constraints
  * [Cascade delete orphan](http://www.nhforge.org/doc/nh/en/#manipulatingdata-graphs)
  * [One-to-one mapping](http://www.nhforge.org/doc/nh/en/#mapping-declaration-onetoone) (because unique constraints)
  * [Global filters](http://www.nhforge.org/doc/nh/en/#objectstate-filters)
  * [Mapping to fields](http://www.nhforge.org/doc/nh/en/#d0e3588)
  * [Encapsulated collections](http://entityframework.codeplex.com/wikipage?title=Design%20Meeting%20Notes%20-%20February%2020%2c%202013)
  * [Semantic collections](http://www.nhforge.org/doc/nh/en/#collections) (List, Dictionary etc)
  * [Custom user types](http://nhforge.org/wikis/howtonh/tags/IUserType/default.aspx)
  * [Primitive collections](http://www.nhforge.org/doc/nh/en/#collections)
  * [Immutable/readonly entities](http://www.nhforge.org/doc/nh/en/#readonly)
  * [Computed columns](http://www.nhforge.org/doc/nh/en/#mapping-declaration-property) (not defined in SQL server)
  * [Schema generation](http://elliottjorgensen.com/nhibernate-api-ref/NHibernate.Tool.hbm2ddl/SchemaExport.html)
  * [2nd-level caching](http://www.nhforge.org/doc/nh/en/#performance-cache)
  * [Future queries](http://ayende.com/blog/3979/nhibernate-futures)
  * [Actual client-generated IDs](http://www.nhforge.org/doc/nh/en/#mapping-declaration-id-generator) &#8211; Comb Guid & HiLo
  * Robust support for other DBs
  * [Session.Load instead of mapping the FK separately](http://www.nhforge.org/doc/nh/en/#manipulatingdata-loading)

A pretty long list to be sure, but not all of these items carry equal weight on any given project, and many of them are available via workarounds or extensions to EF (like the [EntityFramework.Extended](https://github.com/loresoft/EntityFramework.Extended) project). But what about NHibernate? What does EF have (that’s actually useful) but NHibernate doesn’t?

  * Anything moderately interesting with LINQ
  * Migrations
  * Async

Those aren’t small features, so while you might be slightly annoyed by a lack of bidirectional one-to-one mapping, not having async might be a big deal for you.

This is a somewhat hasty list generated from projects in which I’ve actually used these NH features in production, but is certainly not an exhaustive list. Let me know in the comments what I’ve missed!