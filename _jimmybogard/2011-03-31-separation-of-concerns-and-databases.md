---
id: 460
title: Separation of Concerns and databases
date: 2011-03-31T13:03:56+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2011/03/31/separation-of-concerns-and-databases/
dsq_thread_id:
  - "267563821"
categories:
  - Design
  - DistributedSystems
---
I’m looking at a database table this morning, looking to optimize a few queries by adding some indexes. The trouble is, this table already has many indexes, all on different columns. So now I’m thinking, is this a smell that too many processes are concerned with this one table, all for different reasons?

Starting to think so, since those indexes are only used for one query or another. This looks like a situation to de-normalize and build report/view/query-specific tables to me.

Any other smells out there for violating SOLID principles at the database layer?