---
id: 889
title: Using AutoMapper to prevent SELECT N+1 problems
date: 2014-04-03T13:13:47+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=889
dsq_thread_id:
  - "2583268078"
categories:
  - AutoMapper
  - EntityFramework
  - NHibernate
---
Back in my post about efficient querying with AutoMapper, LINQ and future queries, one piece I glossed over was how View Models and LINQ projection can prevent [SELECT N+1 problems](http://www.hibernatingrhinos.com/products/nhprof/learn/alert/selectnplusone). In the original controller action, I had code like this:

[gist id=9485068]

See that “Include” part? That’s because the view shows information from navigation and collection properties on my Instructor model:

[gist id=9953643]

If I just use properties on the Instructor/Person table, only one query is needed. However, if my view happens to use other information on different tables, additional queries are needed. If I’m looping through a collection association, I could potentially have a query issued for each loop iteration. Probably not what was expected!

ORMs let us address this by eagerly fetching associations, via JOINs. In EF this can be done via the “Include” method on a LINQ query. In NHibernate, this can be done via Fetch (depending on the query API you use). This is addresses the symptom, but is not a good long-term solution.

Because our domain model exposes all data available, it’s easy to just show extra information on a view without batting an eye. However, unless we keep a database profiler open at all times, it’s not obvious to me as a developer that a given association will result in a new query. This is where AutoMapper’s LINQ projections come into play. First, we have a View Model that contains only the data we wish to show on the screen, and nothing more:

[gist id=9953755]

At this point, if we used AutoMapper’s normal Map method, we could still potentially have SELECT N+1 problems. Instead, we’ll use the LINQ projection capabilities of AutoMapper :

[gist id=9953786]

Which results in exactly one query to fetch all Instructor information, using LEFT JOINs to pull in various associations. So how does this work? The LINQ projection is quite simple – it merely looks at the destination type to build out the Select portion of a query. Here’s the equivalent LINQ query:

[gist id=9954017]

Since Entity Framework recognizes our SELECT projection and can automatically build the JOINs based on the data we include, we don’t have to do anything to Include any navigation or collection properties in our SQL query – they’re automatically included!

With AutoMapper’s LINQ projection capabilities, we eliminate any possibility of lazy loading or SELECT N+1 problems in the future. That, I think, is awesome.