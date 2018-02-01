---
id: 1071
title: Reliable database tests with Respawn
date: 2015-02-19T17:21:05+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=1071
dsq_thread_id:
  - "3530138398"
categories:
  - Testing
---
Creating reliable tests that exercise the database can be a tricky beast to tame. There are many [different sub-par strategies](http://lostechies.com/jimmybogard/2013/06/18/strategies-for-isolating-the-database-in-tests/) for doing so, and most of the documented methods talk about resetting the database at teardown, either using rolled back transactions or table truncation.

I’m not a fan of either of these methods – for truly reliable tests, the fixture must have a known starting point at the start of the test, not be relying on something to clean up after itself. When a test fails, I want to be able to examine the data during or after the test run.

That’s why I created [Respawn](https://github.com/jbogard/respawn), a small tool to reset the database back to its clean beginning. Instead of using transaction rollbacks, database restores or table truncations, Respawn intelligently navigates the schema metadata to build out a static, correct order in which to clear out data from your test database, at fixture setup instead of teardown.

Respawn is [available on NuGet](http://www.nuget.org/packages/respawn), and can work with SQL Server or Postgres (or any ANSI-compatible database that supports INFORMATION_SCHEMA views correctly).

You create a checkpoint:

[gist id=fe857eb3d206abd9092a]

You can supply tables to ignore and schemas to exclude for tables you don’t want cleared out. In your test fixture setup, reset your checkpoint:

[gist id=b1e69710ba4239d183e4]

Or if you’re using a database besides SQL Server, you can pass in an open DbConnection:

[gist id=4c32e325061b2a4e6936]

Because Respawn stores the correct SQL in the right order to clear your tables, you don’t need to maintain a list of tables to delete or recalculate on every checkpoint reset. And since table truncation won’t work with tables that include foreign key constraints, DELETE will be faster than table truncation for test databases.

We’ve used this method at [Headspring](http://www.headspring.com) for the last six years or so, battle tested on a dozen projects we’ve put into production.

Stop worrying about unreliable database tests – respawn at the starting point instead!