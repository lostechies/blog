---
wordpress_id: 678
title: Isolating database data in integration tests
date: 2012-10-18T19:50:05+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/10/18/isolating-database-data-in-integration-tests/
dsq_thread_id:
  - "890740413"
categories:
  - Testing
---
Databases in tests is an annoying, yet necessary component if you truly want to create accurate integration tests. I’m not too much of a fan of employing alternate databases in tests (SQLite in place of SQL Server), simply because I don’t trust that my tests will pass in a production environment. However, I have seen folks use SQLite locally and SQL Server on the server. I’m just not a fan personally.

Assuming we go with a common database technology for our tests, we typically hit a problem that **our database is shared between tests**, leading to failures in our tests because of data existing from previous tests.

So what are some ways to isolate databases in integration tests? Let’s first set some guiding principles:

  1. Developers should be using isolated databases for development and testing
  2. Tests should be isolated in the data they create and query from other tests

If I want reliable tests, I need to make sure that we’re not employing any sort of shared database amongst our developers and that one test’s data is completely isolated from other tests.

Once we have some ground rules, we can look at a few options for dealing with databases in our tests. Namely, **how do we isolate data between tests**?

### Rollback transactions

One popular method is to simply create a transaction at the beginning of a test and roll it back at the end of the test:

{% gist 3914135 %}

In the above pseudo-code, we just make sure we roll back our transaction at the end of the test. We’ll also need to make sure that all of the code executed in our test actually _uses_ this transaction, but that’s really up to your environment how that transaction gets disseminated to your fixtures and so on.

In our systems, we rely on dependency injection and child containers to inject our transaction (or unit of work, whatever we’re using for transaction management).

This works well for a lot of cases, and it is quite effective at isolating changes between tests. However, if you’re relying on a committed transaction to tell you changes succeeded, it’s not a good fit. For example, uniqueness constraints wouldn’t get caught until the committing of the transaction. But, if your set up is simple, this is a good route.

### Drop and recreate database

Another option is to have the database dropped and re-created between each test. This one’s a bit trickier, but not too bad to manage. If you’re already doing database migrations (**you ARE doing database migrations, RIGHT?!?!?!**) then it’s not too bad to just blast through the scripts to recreate the DB each time around:

{% gist 3914246 %}

The upside is that you’re wiping the slate clean each time, so you have an absolute known begin state for each test.

The downside is that it’s dog slow. You could also look at using script creation from your favorite ORM, if available. NHibernate, for example, can spit out creation scripts that you can just re-run at the beginning of each test. But even with this, it’s pretty slow.

### Delete all data

An option I tend to like best is just to simply delete all the data. Instead of dropping tables (slow), you can just delete data from tables. I’ve seen people only delete tables they’re interested in, but that can be tricky to manage. I like to just delete from all tables instead.

Now there’s a couple of ways we could go about this. What people typically run into here are foreign key constriants. I can’t just delete data in tables in any old order, I need to be smart about it.

We could do something like:

  * Disable all constraints
  * Delete all tables (in any order)
  * Re-enable all constraints

This will work, but it’s 3 times slower than if I just happened to know the order of the tables to delete. **But what if we could just know the right order to delete**? If I had a list to maintain, that would also not be too fun, but luckily, it’s not too difficult just to figure out the order by examining SQL metadata:

{% gist 3914345 %}

Assuming I’m using NHibernate (only to get a SQL connection and execute scripts), we query to get the list of tables and list of foreign keys. Based on this graph, we just order our deletion in terms of grabbing leaf nodes first, removing them from of foreign keys, and repeat ad nauseum until we’ve eliminated all the tables.

I can’t remember if this works for self-referencing tables or not, those might need a special script to do the disable/enable constraint business.

The advantage to this approach is that it works regardless of your ORM – it goes straight against SQL metadata, not ORM metadata. If you have tables outside your ORM, this will pick them up, too. And it’s fast – only one query per table, and the script generation is only done once and cached for the remainder of the tests.

These are the 3 different approaches I’ve taken for effectively isolating database test data. What other strategies have you used?