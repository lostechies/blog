---
wordpress_id: 885
title: Avoid many-to-many mappings in ORMs
date: 2014-03-12T13:30:17+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=885
dsq_thread_id:
  - "2414074576"
categories:
  - EntityFramework
  - NHibernate
---
Going through and reviewing the [Contoso University codebase](http://www.asp.net/mvc/tutorials/getting-started-with-ef-using-mvc), really to get caught up on EF 6 features, I found a relationship between two tables that resulted in a many-to-many mapping. We have these tables:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2014/03/image_thumb2.png" width="541" height="386" />](http://lostechies.com/jimmybogard/files/2014/03/image2.png)

A Course can have many Instructors, and a Person (Instructor) can have many Courses. The EF code-first mapping for this relationship looks like:

[gist id=9506231]

The NHibernate mapping would look similar, with a .[ManyToMany](http://nhforge.org/doc/nh/en/index.html#collections-ofvalues)() mapping on one or both sides of the relationship. From the Course and Person entities, I treat the one-to-many direction as a normal collection:

[gist id=9506329]

From each direction, we don’t ever interact with the [junction table](http://en.wikipedia.org/wiki/Junction_table), we just follow a relationship from each direction as if it were a one-to-many. There are a few reasons why I don’t like this sort of modeling. Many-to-many relationships are normal in databases, but in my entity model I don’t like treating these relationships as if the junction table doesn’t exist. Some of the reasons include:

  * No place to put behavior/data concerning the relationship. There is no CourseInstructor class to add properties to
  * In order to navigate a direction, I have to query through the originating entity, instead of starting with the junction table
  * It’s not obvious as a developer that the many-to-many relationship exists – I have to look and compare both sides to understand the relationship
  * The queries that result in this model often don’t line up to the SQL I would have written myself

For these reasons, I instead always start with my junction tables modeled explicitly:

[gist id=9506628]

From each side of the relationship, I can decide (or not) to model each direction of this relationship:

[gist id=9506687]

Many times, I’ll even avoid creating the collection properties on my entities, to force myself to decide whether or not I’m constraining my selection or if I really need to grab the entities on the other side. I can now build queries like this:

[gist id=9506800]

I can skip going through other side of the many-to-many relationship altogether, and start straight from the junction table and go from there. It’s obvious to the developer, and often times the ORM itself has an easier time constructing sensible queries.

I do lose a bit of convenience around pretending the junction table doesn’t exist from the Course and Instructor entities, but I’m happy with the tradeoff of a little convenience for greater flexibility and explicitness.