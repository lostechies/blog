---
wordpress_id: 440
title: Case study in mixing system concerns
date: 2010-11-30T13:53:29+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/11/30/case-study-in-mixing-system-concerns.aspx
dsq_thread_id:
  - "264716601"
categories:
  - Architecture
---
For the vast majority of systems I’ve been involved with, transaction isolation levels were never something I really had to worry about too much.&#160; The number of reads on these systems overwhelmingly outnumbered the number of writes.&#160; But every once in a while, you work on a system where it’s actually the opposite, and you have just about an equal number of writes as reads.

In these cases, things like resource contention and database locks start to matter.&#160; You start caring about phantom reads, lost updates, dirty reads and the like.&#160; You run into a situation where some critical piece of data needs a higher level of [transaction isolation](http://en.wikipedia.org/wiki/Isolation_(database_systems)).

Suppose we have a critical set of data that we don’t want to allow dirty reads.&#160; In this case, we follow the normal guidelines of:

  * Create a transaction with the higher isolation level (SERIALIZABLE in this case)
  * Keep the transaction window as absolutely short as possible

This fixes someone reading dirty data for the row that’s being updated.&#160; However, sometimes not all reads are the same.&#160; In this case, a higher isolation level guarantees that there aren’t dirty/phantom reads.&#160; But I now have the issue that anyone reading any of the data can potentially time out.&#160; In those cases, I now have to do a lot more explicit configuration the _other_ way, setting the isolation level lower on certain sets of reads so that “unimportant” reads can go through and don’t time out.

### An alternate approach

Looking at this design, a highly centralized, normalized view of data, you can start to see the problems of a **lack of Separation of Concerns at the system level**.&#160; The fact that I have certain sets of data in the same row with different isolation level concerns should be a signal that I’ve mixed concerns.&#160; If some pieces of my system care about certain pieces of data, and some pieces others, then why should they all be mangled in to one database table?

In this case, I did need elevated isolation levels for the data I was modifying often.&#160; However, lots of other data in that table doesn’t get modified often.&#160; If these two concerns were split in to different tables, the timeout issues I was running in to with the reads would have simply gone away.

Moral of the story – **architecture doesn’t solve problems, it eliminates them**.