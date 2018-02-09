---
wordpress_id: 369
title: Hitting the upper limit of foreign key constraints
date: 2009-11-24T01:59:43+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/11/23/hitting-the-upper-limit-of-foreign-key-constraints.aspx
dsq_thread_id:
  - "264716354"
categories:
  - SQL
redirect_from: "/blogs/jimmy_bogard/archive/2009/11/23/hitting-the-upper-limit-of-foreign-key-constraints.aspx/"
---
There are bugs, and then there are _bugs_.&#160; We recently hit one that fell directly in crazy-town category.&#160; What exactly would you do if you get this fun message:

> The query processor ran out of stack space during query optimization. Please simplify the query.

We got this from a DELETE query without a where clause.&#160; Thinking it might be an NHibernate issue, NHProf didn’t show any issues.&#160; Looking at the stack trace, that’s where we saw that this exception came from System.Data.SqlClient classes, not NHibernate.&#160; Popping over to SSMS, doing the same query there got the same exception.

For a while, it looked like DELETE was broken.&#160; But looking closer, we saw something interesting about this specific query.&#160; It was only one table in our system that would get this message, and it was our root User table.&#160; It’s nothing exciting, looks something like this:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_74453717.png" width="206" height="138" />](http://lostechies.com/jimmybogard/files/2011/03/image_54965D4F.png) 

But the more interesting piece came from a requirement that every entity keep track of:

  * Create date
  * Creator (User)
  * Update date
  * Updater (User)

It didn’t matter about history, just who updated it last and when.&#160; We used this information on a little widget on each of our entity view screens (for those entities that had a simple view screen).&#160; But the issue came in how we modeled this relationship: directly on each entity.&#160; Supposing we had a product entity, the resulting DB schema would be:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_659A8B32.png" width="504" height="180" />](http://lostechies.com/jimmybogard/files/2011/03/image_7AF8409A.png) 

We show things like the user’s full name and so on in this widget, so we thought that linking back to the original user table would work best.&#160; It’s fairly trivial to do this in NHibernate (without resorting to things like triggers).&#160; However, that’s two foreign key constraints _per entity_.&#160; One limitation of SQL Server we learned the hard way however is that:

> SQL Server does not have a predefined limit on either the number of FOREIGN KEY constraints a table can contain (which reference other tables), or the number of FOREIGN KEY constraints owned by other tables that reference a specific table. Nevertheless, the actual number of FOREIGN KEY constraints is limited by your hardware configuration and by the design of your database and application. We recommend that a table contain no more than 253 FOREIGN KEY constraints, and that it be referenced by no more than 253 FOREIGN KEY constraints. Consider the cost of enforcing FOREIGN KEY constraints when you design your database and applications.

We went along happily for about 150 or so entities in our system, until we hit around 300 foreign keys against the LoginUser table, causing build failures on a couple of our branches in the exact same sprint.&#160; It was rather surreal, to have separate feature branches encounter the problem at the same time.&#160; The only piece we found in common between these branches was that they all added a new entity, breaking some threshold on all of our boxes (and the server).

So how did we fix this problem?&#160; For now, we just run a script to blast through our entity tables to drop constraints.&#160; In the future, we’ll likely take another design route to store the pseudo-audit information in another table.

And I really thought DELETE was broken…