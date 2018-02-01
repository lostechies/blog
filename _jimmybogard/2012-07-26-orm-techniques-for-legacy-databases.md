---
id: 650
title: ORM techniques for legacy databases
date: 2012-07-26T15:17:55+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2012/07/26/orm-techniques-for-legacy-databases/
dsq_thread_id:
  - "780901457"
categories:
  - Architecture
  - NHibernate
  - SQL
---
One of the reasons folks typically go with a hand-rolled ORM (i.e., using ADO.NET by hand) is the assumption that ORMs don’t work well with legacy databases or databases designed in isolation from any sort of object model used to interact with that database.

From my experience, I have yet to see a legacy database that can’t use an off-the-shelf ORM as its mapping layer. And I’ve seen some craaaaaazy databases. Fixed width columns. Character data types representing monetary values. A junction table whose foreign keys to the other two tables were joined together in ONE COLUMN. And in every case, I’ve been able to successfully use an off-the-shelf ORM to encapsulate our access to whatever was underneath the covers.

But (and this is a big BUT), I had to use different techniques than I normally would against a greenfield database where the database more or less matched my underlying database schema.

Situations and examples can vary, so I’ll walk through some of the most heinous insanity I’ve found.

### Sprocs, sprocs everywhere

In organizations that mandate stored procedures . The only really valid case being for security, and only that because they’ve decided to enforce security at the database layer, which it turns out falls down fairly quickly in chained-trust scenarios etc. However, it’s likely that you can’t change that any time soon. Or, the application was developed before ORMs were fairly full-featured and stable (before 2004 or so).

No worries! You still don’t need to do crazy IDataReader/SqlCommand jockeying. Both NHibernate and micro-ORMs easily support stored procedures for executing SELECTs and INSERT/UPDATE/DELETEs. Micro ORMs provide a thinner layer to work with, so I typically use those. Here’s an example of using PetaPoco:

[gist id=3176033]

Compare with ADO.NET, you’d have to create a SqlCommand, execute a data reader, loop through the results…well, you get the idea.

For the mutating DML statements, it really depends on what you want. If you want the full features of an ORM, like change tracking, identity maps etc., then you can configure the ORM to use stored procedures instead of generated SQL (and there is no performance benefit of doing one over the other).

You don’t have to use one way for one, either. For entity-based interactions, you can use the entity-based features of NHibernate. For report/adhoc-queries, you can use that part.

### Mainframe conversion wizard fiascos

The craziest database I’ve seen was one where it looked like someone used some sort of conversion wizard to convert an old AS400 mainframe database into SQL Server – as-is. Pretty terrible. The things we saw here included:

  * Multi-thousand-line stored procedures
  * Fixed-width columns
  * Very loose types (CHARs for everything, dates, numbers, everything)
  * Compound keys compounded together

For stored procedures, that was pretty easy. Most ORMs support using sprocs, so it was really just a matter of using those. If not that, most ORMs have much nicer wrappers around ADO.NET than the quite difficult to use SqlCommand and the like.

When we had problems with the underlying data types not being what we wanted, or just shaped horribly, we used two different techniques. The first technique is to use the ORM’s hooks for coercing data types back and forth. For example, it’s fairly trivial in NHibernate to configure a column to be stored as a CHAR(10) but read as a decimal. This lets your object model have a sane look, and the ORM layer take care of complexities of the underlying DB schema

If that doesn’t work, we instead resort to SQL views on the underlying database tables to coerce data accordingly. Even in cases where foreign keys were jammed together into one column with the primary key, we used an indexed view to efficiently keep a sane look to the underlying store.

### Screaming naming conventions

Esoteric naming conventions are another sore spot when dealing with legacy databases. In many older databases and Oracle, column names could only be a certain length or were forced to be uppercase, or both.

Luckily, many ORMs are designed for this exact scenario. We can use the ORM to configure entity-based mappings to have particular column/table names.

Alternatively, you can use the view trick to sanitize names of things, and even allow updates back to the source tables. If you’re just reading data, you can always craft your SQL to alias columns to have more sane names. We would then just use the SQL –> DTO features of the ORM at that point.

### SQL-specific Features

Some things exist only in the database and don’t really get surfaced to your ORM layer. In those cases, we just don’t really care that they exist, it doesn’t affect our ORM. It might affect our strategy for building a query, but building queries is mostly orthogonal to building entity-based interactions. Things that don’t really matter inside your ORM include:

  * Index creation
  * Triggers
  * Security
  * SQL query optimization

ORMs have a bit of a stigma to them in that many folks assume that the purpose of an ORM is to hide SQL. It’s not – it’s only meant to encapsulate mapping of SQL to objects. All the SQL-specific features of databases are still important to know and learn and apply, but they’re just outside the scope of ORMs. ORMs are about mapping, but you’re still responsible for the SQL being used, auto-generated or not.

### Unsupported databases

This one can be tough. I’ve never really needed to access a database that doesn’t have out-of-the-box support from some ORM on the market. But most ORMs have hooks to support multiple databases. EF for example supports several major databases out of the box, with abstractions defined to support things like SQLite, PostgreSQL, MySQL and others. All you have to do is look.

If there really is no option, well, I think you probably have more problems than what ORM to use. But I’d love to hear about those cases!

### Making the informed decision

Although I haven’t had to use an ORM against an unsupported database, I used them against some of the wackiest databases I’ve heard people had to use. Any all cases, I was successfully able to use an ORM to map.

But was it easier than rolling my own? In all cases – yes. ADO.NET code is hard to get right, and I see over and over again people getting it wrong. Don’t chance it – let the tool do what it does best and focus on your business problem at hand. If you’re having trouble with one avenue, try going another. ORMs support a variety of different approaches, and not every approach is right for every scenario.

But a good understanding of what options you have will help you figure out what direction to go. ORMs can be complex, as it’s a tough problem. Dealing with a legacy database is rarely an easy problem, but ORMs can provide the support needed to let you focus on what’s important.