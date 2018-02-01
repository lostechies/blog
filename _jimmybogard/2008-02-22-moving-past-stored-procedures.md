---
id: 146
title: Moving past stored procedures
date: 2008-02-22T13:15:04+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/02/22/moving-past-stored-procedures.aspx
dsq_thread_id:
  - "264715562"
categories:
  - DomainDrivenDesign
  - Rant
---
On [Chad&#8217;s](http://www.lostechies.com/blogs/chad%5Fmyers/) recent [SQL-assembly comparison post](http://lostechies.com/blogs/chad_myers/archive/2008/02/21/sql-is-the-assembly-language-of-the-modern-world.aspx), a few interesting comments caught my eye proclaiming the glory of stored procedures.&nbsp; From tom (no link):

> [Stored procedures] are not only useful for speed but also for ACID and to keep business logic in a central place. (Business logic in clients is an idea as good as storing logic in js on webpages IMHO).

And [Lars Pohlmann](http://www.raum-fuer-notizen.de/):

> @tom: full ACK to your thoughts about stored-procedures. 
> 
> That goes especially for environments, where you have different clients and architectures accessing data from and writing data to the database. You&#8217;ll need the logic at a central point to avoid code-duplication, and stored-procedures are the best way to do that, even if they are not that beautiful.

I thought that the world had moved past putting domain logic in stored procedures.&nbsp; At least I had hoped so, as systems with domain behavior in the infrastructure (data) tier can be the worst systems to maintain. 

Years ago, stored procedures were the de facto standard for data access tiers.&nbsp; I remember most examples of data access coming out of Redmond using stored procedures.&nbsp; Conventional wisdom has bucked this trend, but why?&nbsp; Stored procedures seemed like a great way to encapsulate data access, so why are so many folks, both inside and outside of Redmond, putting so much energy in to ORM technologies?&nbsp; Weren&#8217;t stored procedures supposed to solve this problem? 

### Way back when

I can&#8217;t speak of all developers, but my love of stored procedures started back in ASP 3.0 and SQL 7.0/2000 days.&nbsp; Since VBScript was not an OO language, all domain behavior was expressed procedurally.&nbsp; I would use the [transaction script](http://www.martinfowler.com/eaaCatalog/transactionScript.html) pattern for all of my application needs, with everything to perform an operation like AddUser or SubmitOrder in one long method.

Developing in VBScript can be quite a pain, so why not put all of my logic in a stored procedure?&nbsp; It made sense from the application side, as it was very difficult to maintain ASP files with a bunch of VBScript everywhere.&nbsp; VBScript just wasn&#8217;t expressive enough for the model we had.

With all of the domain logic in the stored procedure, we could work much closer to what we thought represented our system: database tables.&nbsp; Since we were in an ecosystem whose primary language (VBScript) was not capable of the models in our system, like Customers, Orders, OrderItems, etc., it made perfect sense to put our logic in the system that did capture our models, the database.&nbsp; We thought of an Order as a row in a table, the OrderTotal as the sum of the OrderItems, and the Customer as the foreign key on the Order table.

When you&#8217;re in a database-centric mindset, stored procedures make all the sense in the world.

### A new modeling paradigm

With the introduction of .NET came the ability to create fully OO systems in the Microsoft world (I&#8217;m not counting C++, those guys are just plain nuts).&nbsp; No longer would applications need to be driven by large amounts of procedural code, we could now have models expressed in software.&nbsp; Clients of a system could now interact directly with our model, which provided a much greater expressiveness than SQL ever could.&nbsp; The problems of stored procedures were stacking up:

  * Difficult to test, therefore hard to maintain
  * Procedural, not OO
  * Impedance mismatch between data model and conceptual model

The last part was key for me moving away from stored procedures.&nbsp; Conversations with customers did not include a database diagram.&nbsp; If it ever did, the conversation went very poorly, as customers do not think of Orders and Customers as database tables.&nbsp; They think of them as entities with rules and behavior.&nbsp; SQL is not nearly expressive enough to describe the behavior of these entities that would in any way satisfy the customer, or even make sense to them.

Domain behavior (or business logic) could now be kept in a central location, but this location is now the software model, not the data model.&nbsp; Behavior related to an Order is actually on the Order.&nbsp; If I want to know the behavior of the system, I just need to look at the unit tests.

Since I can use the full gamut of design patterns and modeling techniques in modern OO software, why not use that system?&nbsp; Duplication is the scourge of maintainability, so why not use a system that can both model the customer&#8217;s domain and effectively eliminate duplication?

### Your application is not your data

As Tom and Lars pointed out above, the database can be a point to centrally keep domain logic.&nbsp; But they are very, very poor at expressing behavior or removing duplication.&nbsp; An application goes well beyond data, it includes behavior as well.&nbsp; Since TSQL can&#8217;t handle the rigors of OO modeling, where do we keep this logic?&nbsp; If we have many different clients wanting to interact with our system (not just data), how do we allow this?&nbsp; I&#8217;ll pick one of two ways:

  * Through objects
  * Through services

Both these options allow me to make changes to the data model without affecting clients.&nbsp; If clients want complex aggregate reporting, reporting databases are perfect for that.&nbsp; But no one is touching my data model except for systems that include the behavior behind that data.&nbsp; Since databases are so poor at expressing such behavior, I&#8217;ll pick something far more expressive and maintainable.