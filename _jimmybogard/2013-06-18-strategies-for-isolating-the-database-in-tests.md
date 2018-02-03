---
wordpress_id: 800
title: Strategies for isolating the database in tests
date: 2013-06-18T15:02:04+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=800
dsq_thread_id:
  - "1409967512"
categories:
  - Testing
---
One of the keys to having maintainable tests are to make sure that tests are isolated and reproducible. For unit tests, this is easy as long as we stay away from global variables, static classes and in general global state.

This becomes a bit of a challenge with integration tests that interact with a database, where state is by definition, global and shared. In order to have maintainable suite of integration tests, we need to make sure that our tests always have a consistent starting point.

Easier said than done, but luckily there are quite a few options for us here.

### Test database per developer

One mistake I see a lot of teams make is not properly isolating databases for each developer. I’ll often see a single shared dev database instance per team:

[<img title="image" style="border-top: 0px; border-right: 0px; background-image: none; border-bottom: 0px; padding-top: 0px; padding-left: 0px; border-left: 0px; display: inline; padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2013/06/image_thumb2.png" width="275" height="227" />](http://lostechies.com/jimmybogard/files/2013/06/image2.png)

This makes testing and development frustrating for both involved, as not only do I have shared state on my own machine, but other people could be changing data out from under me. Not a good spot to be in! We can go another step further and have a local dev database per developer:

[<img title="image" style="border-top: 0px; border-right: 0px; background-image: none; border-bottom: 0px; padding-top: 0px; padding-left: 0px; border-left: 0px; display: inline; padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2013/06/image_thumb3.png" width="365" height="166" />](http://lostechies.com/jimmybogard/files/2013/06/image3.png)

Now each developer can safely make changes (you ARE doing database migrations, right?) to their local database without worrying about other developers interfering. But we want to go one step further and have a separate local dev versus test database:

[<img title="image" style="border-top: 0px; border-right: 0px; background-image: none; border-bottom: 0px; padding-top: 0px; padding-left: 0px; border-left: 0px; display: inline; padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2013/06/image_thumb4.png" width="367" height="166" />](http://lostechies.com/jimmybogard/files/2013/06/image4.png)

Our Dev database goes through schema migrations, but is never “wiped clean”. Its data remains around so that during development we don’t have to start with a blank database. Additionally, if development requires a lot of data in our dev database, we can still keep that around for normal development.

For testing, where we want deterministic setup conditions, the test database is only used for automated testing and is kept in a known state before each test. We only need to set up our migrations strategy to keep both local databases up to date locally (but this shouldn’t be a problem with today’s migrations tools).

Now that we have an appropriate local setup, let’s look at some options for keeping our test database in a reliably consistent state.

### Roll back transactions

One of the easiest ways to roll back changes made during a test is to…roll back changes made during a test. We open a transaction at the beginning of a test, do some work, and at the end of the test, we roll back that transaction.

Because databases (depending on our isolation level) include changes we’ve made inside a transaction with subsequent reads, our tests can still query for updates made. And then at the end of the test, our changes go away.

[<img title="image" style="border-top: 0px; border-right: 0px; background-image: none; border-bottom: 0px; padding-top: 0px; padding-left: 0px; border-left: 0px; display: inline; padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2013/06/image_thumb5.png" width="571" height="203" />](http://lostechies.com/jimmybogard/files/2013/06/image5.png)

In our test, we can use setup/teardown or before/after test extensions to open an ambient transaction and roll it back afterwards. Our underlying data connections/ORM needs to be aware of ambient transactions for this to work properly, however. xUnit.net includes a simple extension to do so, with the AutoRollback attribute on our tests.

One side effect from this is that because our transaction is automatically rolled back, if we need to debug our test data _after_ the test is run, we can’t since the data is gone.

Additionally, if we need to have multiple transactions for whatever reason, this approach won’t work. Occasionally I work with systems that have a single activity with multiple transactions internally, all of which might be idempotent or can be run multiple times without affecting the one test, but aren’t rolled back.

If a simple rollback won’t suffice, we need to look at simply clearing out the database before each test.

### Resetting the database before each test

This is where things get interesting because most databases don’t have any sort of “reset” switch. Instead, we have to devise interesting ways of clearing application data out of the database before each test is run. I’ve seen a number of ways to do so, including:

  * Detaching the database and restoring a known “good” backup
  * Disabling all FK constraints, truncating every table, and restoring FK constraints
  * Find the “right” order to delete data based on relationships, and delete data from each table in order

The first way only really works if my database doesn’t change often. Keeping a good backup that can be restored effectively is annoying if schema changes, and I have to keep that backup up to date. It’s only really useful in the case of using a production database as my test database, but otherwise, it’s a pain.

The next option involves just clearing every table I find in our database, regardless of order. In order to get around constraint violations, I can disable all constraints, truncate every table, then restore constraints. The problem with this approach is that it’s rather slow, with 3 database commands per table.

Finally, the option I prefer, is to examine the SQL metadata to build a graph of the tables and relationships. If I delete data in a depth-first traversal, this ensures that I don’t violate and FK constraints as I delete things.

Doing so is rather specific to your database and ORM you’re using, so I have an example using NHibernate as my backing store. I put this up on a gist:

[https://gist.github.com/jbogard/5805783](https://gist.github.com/jbogard/5805783 "https://gist.github.com/jbogard/5805783")

It’s a bit long, but the idea is that we can create the list of tables in the right order just once, and then before each test, delete all data in the right order.

Our final option is a bit exotic, but can work well in some cases.

### 

### In-memory databases

If you can, using in-memory databases is another great option at wiping your database before each test. Instead of having a global database on our dev box for each tests, we can create an in-memory version of the database with each test.

Our ability to do this depends highly on a few factors:

  * What kind of production DB we’re using
  * What features of that production DB we’re using
  * If there exists an in-memory version of the DB you’re using

With SQL Server, you might be able to use SQL CE or SQLite. But in my experience, there’s always something that doesn’t work, either in the ORM or in some edition-specific feature I use. But if it works, it’s a great option.

No matter which way you go, keep in mind that the best tests, the most reliable tests, have a consistent, known starting point. The best way to achieve this is to have a local test database that can somehow reset itself, before or after tests, to a known state. How you decide to go is up to you, but the key here is we have options!