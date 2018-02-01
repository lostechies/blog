---
id: 881
title: Efficient querying with LINQ, AutoMapper and Future queries
date: 2014-03-11T19:31:31+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=881
dsq_thread_id:
  - "2409245524"
categories:
  - AutoMapper
  - EntityFramework
  - LINQ
---
Even after all these years, I’m still a big fan of ORMs. One common complaint over the years is people using ORMs use the tool identically for both reads and writes. With writes, I want tracked entities, managed relationships, cascades and the like. With reads, I don’t need any of that gunk, just an efficient means of getting a read-only view of my data. If I need to make multiple queries to gather the data, this often results in queries that return lots of data over multiple round-trips.

We can do better!

Let’s say we have a controller action (taken from the [Contoso University Entity Framework sample](http://www.asp.net/mvc/tutorials/getting-started-with-ef-using-mvc)) that pulls in instructor, course, and enrollment information:

[gist id=9485068]

This doesn’t look so bad at first glance, but what isn’t so obvious here is that this involves four round trips to the database, one for each set of data, plus some wonky lazy loading I couldn’t figure out:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2014/03/image_thumb.png" width="512" height="204" />](http://lostechies.com/jimmybogard/files/2014/03/image.png)

We _could_ alter the original query to eagerly fetch with left outer joins those other two items, but that could seriously increase the amount of data we have returned. Since I’m only interested one instructor/course at a time here, I don’t really want to pull back _all_ courses and enrollees.

There’s a bigger issue here too – I’m passing around a live queryable around, making it possible to modify, iterate and otherwise make a general mess of things.&nbsp; Additionally, I pull back live entities and all entity data – again, more inefficient the wider and larger my tables become. Since the entities could be live, tracked entities, I’d want to be careful not to modify my entities on the way to the view for reading purposes.

Ideally, I’d hit the database exactly once for only the data I need, and nothing more. This is what I often see people create stored procedures for – building up the exact resultset you need at the database level, only getting what we need. First, let’s pull in AutoMapper and create a ViewModel that represents our projected data:

[gist id=9487371]

We can flatten many members out (Department.Name to DepartmentName). Next, let’s modify our controller action to project with LINQ and [AutoMapper](http://automapper.org/):

[gist id=9487421]

Finally, we’ll need to configure AutoMapper to build mapping definitions for these types:

[gist id=9493233]

With these changes, our SQL has improved (somewhat) in reducing the data returned to only what I have in my view models:

[gist id=9487643]

We’re now only selecting the columns back that we’re interested in. I’m not an EF expert, so this is about as good as it gets, SQL-wise. EF does however recognize we’re using navigation properties, and will alter the SQL accordingly with joins.

We’re still issuing three different queries to the server, how can we get them all back at once? We can do this with [Future queries](http://weblogs.asp.net/pwelter34/archive/2011/11/29/entity-framework-batch-update-and-future-queries.aspx), an extension to EF that allows us to gather up multiple queries and execute them all when the first executes. Pulling in the “[EntityFramework.Extended](https://www.nuget.org/packages/EntityFramework.Extended)” NuGet package, we only need to add “Future” to our LINQ methods in our controller:

[gist id=9492782]

Which results in all 3 queries getting sent at once to the server in one call:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2014/03/image_thumb1.png" width="491" height="275" />](http://lostechies.com/jimmybogard/files/2014/03/image1.png)

One other modification I made is I ensured that all projection occurred within the controller action, by calling “ToList” on all the IQueryable/FutureQuery objects. I’d rather not have the view be able to modify the query or otherwise introduce any potential problems.

Now, the SQL generated is…interesting to say the least, but that’s not something I can control here. What has improved is I’m now only returning exactly the data I want, into objects that aren’t tracked by Entity Framework (and thus can’t be accidentally modified and updated through change tracking), and all my data is transferred in exactly one database command. I intentionally left the model/mapping alone so that it was a simple conversion, but I would likely go further to make sure the manner in which I’m querying is as efficient as possible.

AutoMapper’s auto-projection of LINQ queries plus Entity Framework’s FutureQuery extensions lets me be as efficient as possible in querying with LINQ, without resorting to stored procedures.