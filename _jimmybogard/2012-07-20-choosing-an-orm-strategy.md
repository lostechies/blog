---
id: 648
title: Choosing an ORM strategy
date: 2012-07-20T02:25:25+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2012/07/20/choosing-an-orm-strategy/
dsq_thread_id:
  - "772643350"
categories:
  - Architecture
---
One of the mistakes I see people make (and have made myself) is assuming that you must choose exactly one ORM strategy for an entire database/application/system. It’s simply not the case. You can (and should) tailor your ORM strategy to your use case, and make sure you’re picking the right tool (or feature of the tool) for the job.

First things first – 99.9% of the time, you should never use ADO.NET classes directly, including IDbCommand and IDataReader. If you’re still doing “dataReader.MoveNext” – you are writing code that you should not write, ever again. There are better options for what you’re trying to do.

Now, there are lots of folks who don’t like ORMs, and from listening on how those folks chose their ORM strategies, I would agree. Fowler said on [OrmHate](http://martinfowler.com/bliki/OrmHate.html) that:

> much of the frustration with ORMs is about inflated expectations

**We have to move past the idea that ORMs are bad or ugly or bloatware**. ORMs are meant to solve a problem, with many different options for doing so. But before we look at options, let’s look at the problem space. What is the problem we’re trying to solve?

### 

### Bridging the gap

If you have to push/pull data to/from SQL and .NET, you have to map your .NET data types to SQL. In .NET, this means using ADO.NET to communicate SQL commands to a SQL database. At some point, mapping has to happen between SQL data types and .NET data types. SQL dates are different than .NET dates, and so on.

ADO.NET helps with this, but leaves the work up to you for taking raw result sets and populating objects. And ultimately, that’s what we want to do – work with objects and types in .NET, and let something flow our objects/data back and forth to SQL.

ORMs are meant to help solve this problem, by applying layers on top of ADO.NET of various abstractions and weight. But there are many different strategies for doing so, used to solve this problem in many different ways.

Let’s look at each of these in turn and see where they might fit.

### Entity-based relational mapping

In entity-based relational mapping, tables are more or less 1:1 with entities in your object design. When you add a property to an object, a column is added to the database. Usage of entity-based relational mapping centers around loading up an entity (or aggregate) by its identifier, manipulating that object and perhaps child objects, and saving that object back through the ORM.

The ORM in this case provides many features, like:

  * Change tracking
  * Lazy-loading
  * Eager fetching
  * Cascades
  * [Identity map](http://martinfowler.com/eaaCatalog/identityMap.html)
  * [Unit of work](http://martinfowler.com/eaaCatalog/unitOfWork.html) tracking

If I’m working with effectively one entity or aggregate at a time, tools like NHibernate use mapping configuration to keep track of entities loaded and automatically flush changes upon committing the transaction. This is nice because we don’t have to transport a data access gateway around, it’s just managed for us.

When loading up an item by Id for manipulation purposes, this option works great. It removes quite a bit of code I would otherwise need to write to keep track of adding objects, saving them and so on. I would have to “remember” to save things and the like.

The downside is that the ORM does not immediately know that you’re just reading objects, or loading up an entity to manipulate it. We often see folks stumble when not understanding that change tracking is turned on by default, and when you load up entities, the assumption is that we need to check to see if it’s changed.

If you’re looking at loading up an entity in order to manipulate it and persist changes (or create a new entity to manipulate), this pattern allows a greater deal of freedom of keeping data access concerns into infrastructure layers, and let your entity types be relatively persistent-ignorant. Persistence ignorance is not that my C# model and DB model can diverge, but more that data access concerns don’t leak into my object model, which I’d rather be more concerned with business rules.

[Active Record](http://martinfowler.com/eaaCatalog/activeRecord.html) is another flavor of entity-based usage, except data access concerns are embedded with my object model.

### Result-set-based relational mapping

In most applications, the demands for reads greatly outstrips the instances of writes. We’ve seen ratios of 100:1 looking at the profiler of SELECTs to INSERT/UPDATE/DELETEs in one recent application. When looking at what SQL is very good at, it’s great at working with data in sets. To return sets back to the application, it often makes zero sense to try and use an entity-based approach for simply returning sets of data.

But we still would like to not work with very raw SQL objects like IDataReader or DataTables. These are very loosely-typed objects, not easily transferable to upper layers of the application.

Instead, we often build objects who are tailor-made for data. These are often called Data-Transfer Objects, or Read Models. These are types we craft for individual SQL SELECT queries, not to be re-used across other queries.

Many ORMs have features optimized for these scenarios. In NHibernate, you can use projections to skip any sort of tracked Entity objects to map straight to DTOs, you can use SQL queries to map straight to DTOs and skip needing to configure mapping. Or you can use micro-ORMs like PetaPoco.

These reads can also stream objects as they are read. Both NHibernate and several micro-ORMs let you map individual DTO instances as each row is read from the underlying result set, minimizing the amount of objects kept around in memory.

In our applications, we often still use NHibernate for reads, but skip any kind of entity objects and instead craft our raw SQL, relying on NHibernate’s optimized mappers to simply supply a DTO type and the results are mapped automatically.

This approach does not work well if we have to apply business rules and persist information back, as these models usually map to result sets, not database tables.

### DML-based relational mapping

If you know what you want to do in SQL for CRUD operations, and would rather not have a tool figure it out for you, you’re really looking for something to effectively abstract DML commands at a step higher than ADO.NET.

This is the arena of micro ORMs. Tools like [PetaPoco](http://www.toptensoftware.com/petapoco/), [Dapper](http://code.google.com/p/dapper-dot-net/), [Massive](https://github.com/robconery/massive/) and others work to solve the problem of the pain of working with raw ADO.NET. These typically still allow us to work with objects, but our interactions are greatly simplified and SQL is brought to the forefront. We only need a connection, and these tools can let us work with all the CRUD operations in a manner that offers much simpler code that ADO.NET

In cases where you don’t already have an entity-based relational mapper in the application, micro-ORMs provide a much lighter approach. Because types and mappings are not configured ahead of time, these tools rely on lazily-evaluated optimized reflection caching techniques to on-the-fly map parameters and result sets.

Many applications can start out with DML-based mappings, graduating to a full-fledged ORM when certain relationships or entities demand it.

### Bulk loading tools

One that holds a dear place in my heart – sometimes you don’t want to push/pull data in an object-based manner. Instead, you’d rather push and pull data in bulk. Tools like SQL Bulk Copy allow you to pull data out in a delimited or tabular format, or push data in.

Bulk loading tools typically work as a sort of bazooka, blasting data out or blasting data in, but not providing much beyond that. You won’t be able to do updates or deletes, but for getting large amounts of data in and out of SQL, bulk loading tools are what you need.

In many integration scenarios where you provide delimited files to partners, or delimited files are supplied to you, bulk loaders allow you to treat files as tables and load them directly against the database, skipping past layers of abstractions both in mapping objects and even in the database.

These tools are tuned to be much, much quicker than traditional methods of extracting/loading data. In some of our tests, we’ve seen orders of magnitude differences of time between row-by-row loading versus bulk load. In one case, we saw a difference between several hours and less than a minute to load.

The downside is that options are quite limited, and you’re really only limited to INSERT and SELECT. Everything else requires different tools.

### Right tool for the job

In one recent project, I’ve used every single one of these approaches against a single database and a single codebase. NHibernate for entity/aggregate-based mapping, result-set for reading sets of data (and building messages/exports/views from the results), DML-based mappings for simple tables and modules, and bulk loading tools for those nightly drops of million-row files from partners.

The key is to not tie yourself down to a specific tool or approach. No single ORM strategy works for every situation, and nor should it. NHibernate can work for a variety of scenarios beyond entity-based mappings, but doesn’t do everything. Complexity often arises from trying to use the same approach for every situation.

Every application written outside of SQL uses an ORM. Whether it’s hand-rolled ADO.NET code, or NHibernate, you have to bridge the gap from .NET to SQL. Bridging this gap is a hard problem to solve, and nothing solves the entire problem set perfectly. Nor should it!

Choose the approach that fits the problem at hand, and don’t worry about having multiple approaches in a single solution. That’s not to say haphazard decisions are appropriate, but informed, educated decisions based on knowledge of all choices at hand are always a good idea.