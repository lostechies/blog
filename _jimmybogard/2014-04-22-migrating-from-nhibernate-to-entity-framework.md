---
wordpress_id: 897
title: Migrating from NHibernate to Entity Framework
date: 2014-04-22T13:19:50+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=897
dsq_thread_id:
  - "2630373299"
categories:
  - EntityFramework
  - NHibernate
---
I’ve been a supporter and user of NHibernate for nearly 10 years. While not part of the original [NHibernate Mafia](http://codebetter.com/scottbellware/2007/04/09/on-being-the-nhibernate-mafia/), I’ve long enjoyed NHibernate’s ability to rich, behavioral domain models. I wasn’t happy with the initial designs of Entity Framework, but since it’s been many years since that [vote of no confidence](http://efvote.wufoo.com/forms/ado-net-entity-framework-vote-of-no-confidence/) thing, I wanted to revisit EF6, especially after the [6.1 release](http://msdn.microsoft.com/en-us/data/jj574253.aspx) and rich code-first model. For the 99% case, it looked very similar to how I used NHibernate.

NHibernate is still a more mature product, and includes features that it’s had for literally a decade that EF doesn’t have, but for a couple of reasons I wanted to give EF a go on a real project and real domain model that was already using NHibernate successfully. Surprisingly, it only took me a few days to completely make the transition and have all tests pass. So why am I looking to make the switch? Two big reasons:

  * With a couple big committers leaving the project, there’s a void in the leadership and direction of the project
  * Bugs that I’ve run into have been open for years with no fix in sight

A project as large as NHibernate needs a strong OSS community to back it up, or barring that, corporate sponsorship. EF is OSS and has corporate sponsorship.

> As&nbsp; side note, OSS as it currently stands in .NET is only currently successful if the project is small and targeted in scope, or has a company backing it, as seen by [reading the tea leaves](http://www.nuget.org/packages).

A lot of my opinions on Entity Framework were based on the 5 and 4 releases, so it was time to revisit a lot of my assumptions.

### Migrating

In my solution, I was already using the code-based mapping in NHibernate, making the switch in my configuration was relatively straightforward. Additionally, most of my configuration that was originally building up a Configuration class simply moved to my derived DbContext EF class.

Migrating my class mappings and usage was mainly an exercise in regular expressions. One of the reasons why I’m never too worried about switching out infrastructure components who have large feature parity is you find that the differences are mainly API differences, and those are easy to switch out. I don’t like abstracting my ORM, that’s largely a waste of time, and yet it still only took me in a code base of around 60-70 entities about a day to get a compiling solution. I did replacements of:

  * ISession –> DbContext
  * session.QueryOver<T> –> dbContext.Set<T>
  * session.Query<T> –> dbContext.Set<T>
  * Query<T>.Fetch() –> Set<T>.Include()
  * session.CreateSQLQuery –> dbContext.Database.SqlQuery
  * ClassMapping<T> –> EntityTypeConfiguration<T>
  * etc

If you can write decent regular expressions including substitutions, you can perform 90% of the migration just by simple “Find and Replace” across the entire solution. And after 3 days, the entire solution was migrated from NHibernate to EF6.

I did have some problems I ran into. First, one-to-one associations are possible in EF6, but typically require…strange hoops to go through. Things like adding a FK to both tables, or creating combination keys. In NH, a two-way [one-to-one association](http://ayende.com/blog/3960/nhibernate-mapping-one-to-one) are possible with only one FK. Other things I ran into that don’t exist:

  * Unique constraints (also the limiting factor in one-to-one mapping)
  * [Cascade-delete-orphan](http://ayende.com/blog/1890/nhibernate-cascades-the-different-between-all-all-delete-orphans-and-save-update)
  * Sophisticated second-level caches
  * Read-only entities
  * [Global filters](http://ayende.com/blog/3993/nhibernate-filters)

Some of these are possible to work around, some aren’t. Global filters, for example, is very difficult to implement unless you have hooks in the infrastructure. With NHibernate, it was brain-dead simple to implement multi-tenancy with a [tenant discriminator column](http://msdn.microsoft.com/en-us/library/aa479086.aspx#mlttntda_sdshs). The good news is that these are all on the EF team’s radar and I didn’t need that specific feature in this codebase.

So why did I ultimately want to make the switch? It came down to a pattern of usage I’ve taken with regards to [LINQ and AutoMapper](https://lostechies.com/jimmybogard/2014/04/03/using-automapper-to-prevent-select-n1-problems/). With NHibernate, anything beyond a very simple projection in LINQ wouldn’t work, but does work in EF. Given a choice of never having to worry about lazy loading problems ever, ever again without resorting to document databases and its baby-with-the-bathwater approach, I’ll go with EF.