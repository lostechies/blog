---
wordpress_id: 220
title: DDD, Repositories and ORMs
date: 2008-08-20T02:31:22+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/08/19/ddd-repositories-and-orms.aspx
dsq_thread_id:
  - "264715868"
categories:
  - DomainDrivenDesign
---
One of the confusing aspects of those new to DDD is the concept of a Repository.&nbsp; From Fowler&#8217;s Patterns of Enterprise Application Architecture, a Repository:

> Mediates between the domain and data mapping layers using a collection-like interface for accessing domain objects.

Paraphrasing the various DDD sources, a Repository provides the ability to obtain a reference to an [Aggregate root](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/05/20/entities-value-objects-aggregates-and-roots.aspx).&nbsp; Not Entity, Value Object, but Aggregate root.&nbsp; Each Save operation encapsulates the entire operation for saving a single Root and all of its child entities.&nbsp; For example, given the model of a Root Person entity with child Address entities, a Save operation will save Person and Address, all in one operation, from the perspective of the client of the Repository.

From the client perspective, how an object is persisted is unimportant.&nbsp; From the developer perspective, persistence is very important!&nbsp; Many who follow DDD choose to use various ORMs to provide the persistence logic inside the Repository.

Because DDD does not prescribe a persistence technology, nor even a storage medium, **using an ORM like NHibernate does not indicate you doing DDD**.&nbsp; Conversely, **doing DDD does not predestine you into an ORM technology like NHibernate**.&nbsp; I could use the Cargo Cult metaphor, were it not for the Cargo Cult of folks using the Cargo Cult metaphor.

You can do DDD with stored procedures.&nbsp; You can create Repositories for in-memory databases, all the LINQ implementations (including EF).&nbsp; A Repository is a pattern, not a technology prescription.&nbsp; It&#8217;s far more important to learn the concepts than jump to a technology, that&#8217;s the short bath to a bad experience.