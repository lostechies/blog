---
wordpress_id: 912
title: 'Missing EF Feature Workarounds: Filters'
date: 2014-05-29T16:42:34+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=912
dsq_thread_id:
  - "2721687911"
categories:
  - EntityFramework
  - NHibernate
---
Filters are one of those ORM features that when you need it, you REALLY need it. [NHibernate has had this feature](http://www.nhforge.org/doc/nh/en/#objectstate-filters) for quite a long time, but it still doesn’t exist in EF. What are filters? In NHibernate, a filter is

> a global, named, parameterized filter that may be enabled or disabled for a particular NHibernate session

The scenarios for this feature are pretty extensive:

  * Soft deletes
  * Multi-tenancy (with a tenant ID column)
  * Security
  * Active/inactive records
  * Logical data partitions

Basically, any time you want to apply a predicate to a set of entities when queried, but not force the developer to “remember” to add that clause. The typical approach in EF is with extension methods or base DbContext/Repository classes, but both of these approaches are limited.

Fortunately, EF exposes an extension point to alter the DB query before it goes out the door and gets executed in the [form of interceptors](https://entityframework.codeplex.com/wikipage?title=Interception). There are two levels of interception:

  * DbCommand
  * DbCommandTree

With the DbCommand, you’re at the SQL level, not where I want to be. Instead, we can work with an expression tree and alter it accordingly. And because this was a bit extensive, I wound up creating an OSS extension for EF to accomplish filters:

[https://github.com/jbogard/EntityFramework.Filters](https://github.com/jbogard/EntityFramework.Filters "https://github.com/jbogard/EntityFramework.Filters")

[https://www.nuget.org/packages/EntityFramework.Filters/](https://www.nuget.org/packages/EntityFramework.Filters/ "https://www.nuget.org/packages/EntityFramework.Filters/")

I used the NHibernate design for EF, in that you define your filters with the entity metadata, and the parameters of the filter on an instance of your DbContext:

{% gist d8b5b36c38d4136826d6 %}

There are some limitations and the queries aren’t as powerful as what you can do in NHibernate, but the basic scenarios are there. Because filter parameter values are scoped against an instance of a DbContext, you can effectively partition the filter values based on specific scenarios/contexts. Behind the covers, I translate the LINQ expression passed in via filter configuration to a DbExpression, substitute the contextual parameter values appropriately, and append the result as an additional filter to your query.

For example, different users in a multi-tenant environment will have their tenant filter applied based on their specific tenant:

{% gist ffc76e80068320dcc972 %}

The GitHub readme has more details, and the code can at least provide an inspiration for those that want to do something a bit more dynamic than [what was shown at Tech Ed](http://channel9.msdn.com/Events/TechEd/NorthAmerica/2014/DEV-B417#fbid=).

It was an interesting exercise implementing pretty complicated extension to EF, one that was greatly helped by having access to the actual source code, but hindered when nearly all the interesting work happening in EF is marked “internal”. In order to facilitate easy development, I wound up forking EF, replacing all “internal” modifiers with “public”, getting my solution working, then reverting back to the original EF version. Strong-naming may be a pain to OSS development, but highly conservative use of “public” is far more limiting in my experience.