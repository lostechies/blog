---
id: 169
title: Profiling a legacy app
date: 2008-04-16T11:53:47+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/04/16/profiling-a-legacy-app.aspx
dsq_thread_id:
  - "264715656"
categories:
  - LegacyCode
---
Approaching a legacy application can be a daunting task.&nbsp; You may or may not have access to the original developers (if they even still work for the company), and the domain experts might not be able to commit to teaching you the software full time.&nbsp; If you&#8217;re lucky enough to have access to true domain experts, it&#8217;s rare that they know the system from a technical standpoint, or are familiar with the entire system.&nbsp; It&#8217;s more likely they have intimate knowledge of one piece, and cursory knowledge of the rest.

We&#8217;ve gone with an approach that&#8217;s allowed us to glean quite a bit of information about the domain in a fairly short period of time.&nbsp; It can be overwhelming trying to see where to start, especially if you&#8217;re looking at a codebase with hundreds of thousands, if not over one million lines of code.

### Pitfalls

Some pitfalls we wanted to avoid were:

  * Getting bogged down in code
  * Worrying/complaining about code quality
  * Searching for a pot o&#8217; gold (magical class that gives you complete insight into the system)

The biggest one is the complaining.&nbsp; Many very successful systems are built with duck tape and baling wire.&nbsp; It&#8217;s rather pointless to vilify an application or system that&#8217;s netted a company millions of dollars.&nbsp; Lack of structure or tests might be bogging down the company now, but it&#8217;s put a lot of food on people&#8217;s tables.

When seeing code that I wouldn&#8217;t necessarily write, I like to step back and ask myself, &#8220;how many meals did this code buy for a family?&#8221;&nbsp; I&#8217;ve written my share of stinkers over the years, so who am I to point fingers?

### Getting started

The absolute first step is to get access to:

  1. A working application
  2. Its outputs

Without a working application, we&#8217;re forced to comb through a codebase.&nbsp; That&#8217;s hardly productive as without an original developer, we have to make educational guesses about how it works and what&#8217;s important.

Also vital is insight to the outputs of the application, whether it be files, web service calls or a database.&nbsp; We want to **treat the application like a black box.**&nbsp; We&#8217;re going to poke and prod the application, so it&#8217;s necessary to see what pops out the other side.

If the application writes to a database, get access to a profiler so you can watch traffic.&nbsp; If it makes network calls, use a port sniffer or something like Fiddler to watch the traffic.&nbsp; If it writes to files or to MSMQ, again, **find a profiler so you can watch traffic.**

### Collect some stats

Chances are your legacy app writes to some kind of database.&nbsp; The older the system, the more variety you&#8217;ll see in design, or more alien the design will seem to you.&nbsp; Modern databases haven&#8217;t been around too long considering the timeline of mainframes, and these designs were much different than the databases you&#8217;re probably used to.

Don&#8217;t be surprised if you don&#8217;t find any referential integrity.&nbsp; You might not be able to run a dependency analysis tool (like [RedGate&#8217;s](http://www.red-gate.com) excellent [Dependency Tracker](http://www.red-gate.com/products/SQL_Dependency_Tracker/index.htm)) and find anything connected.&nbsp; If the application uses SQL Server, do yourself a favor and get one of RedGate&#8217;s bundles.

What worked well for us was not the _diagrams_ from the legacy app, which can have more orphans than a Dickens novel, but a simple listing of tables with some important extra data.&nbsp; We created another &#8220;Analysis&#8221; database with two tables:

  * TableInformation
  * ColumnInformation

The TableInformation contained columns for Database, TableName, ColumnCount, RowCount, create/modify dates, and anything else we could glean from the metadata information.&nbsp; RowCount is important as you can query TableInformation, sort by RowCount, and have a good idea of what the most important tables are.&nbsp; Chances are a table with 10 million rows is fairly important.&nbsp; Tables with zero rows can be crossed off the list immediately, as your database probably has tables that were created but never used.

By seeing a list of all of the tables with their RowCount, you can get an idea of which tables are Transactional (lots of reads/writes), Lookup (written once, now just for lookup values, like states or country lists), or Unused (one or fewer rows).&nbsp; The number of &#8220;important&#8221; tables is now a fraction of the original number of tables you were looking at.

The ColumnInformation contained columns for Database, TableName, ColumnName, as well as data type information.&nbsp; Collecting column information is extremely useful when your database doesn&#8217;t have any relationships explicitly defined.&nbsp; You can perform queries like &#8220;SELECT * FROM ColumnInformation WHERE ColumnName = &#8216;ORDER_NUM'&#8221;.&nbsp; This can give you a great indication of what is related to what.

### Poke and watch

Finally, with a running application and some base stats, we&#8217;re ready to profile the application.&nbsp; The basic idea is to **perform a concrete operation and examine the traffic**.&nbsp; Pull up that Customer page, and with the profiler open, capture a slice of traffic related to your operation.&nbsp; It helps if no one else is using the system at the time, as you don&#8217;t want to collect false data.

For each operation we find, we&#8217;ll:

  * Start the profiler
  * Perform the operation
  * Stop the profiler
  * Archive/examine the profiler results

By doing something like examining a product, looking up a (valid) customer, we can see not only what the main Entity table is, but any ancillary tables are.&nbsp; Most SQL profilers (such as SQL Server&#8217;s) allow you to copy the actual SQL script being used.&nbsp; We can then paste this SQL script into our query tool to re-run the script to examine the data returned.

Finally, as we&#8217;re noting relationships between the tables, we **create a completely new database that contains only the tables and relationships**.&nbsp; We can&#8217;t add relationships to the existing database, as referential integrity probably wasn&#8217;t enforced (maybe it was only suggested or encouraged).&nbsp; This allowed us to create a very descriptive diagram that contained all of the tables and relationships of the legacy database, just without all of the other stuff that gets in the way.

We keep the original names of the tables and columns too, as it let us go back to our stats database and do additional queries.&nbsp; As soon as we can determine what the main &#8220;Customer&#8221; table is (and its primary key or identifier column), we can query to see if any other tables reference it in some way.&nbsp; Testing the connection through counts and joins lets us confirm the relationship.

### Don&#8217;t get discouraged

It can be easy to get bogged down and discouraged when a legacy app falls on your lap.&nbsp; A application with millions of lines of code and hundreds, if not thousands of database tables can be completely overwhelming.

But often the goal is **not to understand the codebase, but the entities, relationships and business processes**.&nbsp; Focus on key scenarios with domain experts, and profile the results.&nbsp; With any application, importance is not equally distributed to all features.&nbsp; With some targeted analysis and heavy conversation with the domain experts, you&#8217;ll be able to gain a deep insight into the business behind the legacy application.