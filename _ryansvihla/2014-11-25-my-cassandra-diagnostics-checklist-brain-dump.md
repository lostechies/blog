---
wordpress_id: 171
title: My Cassandra 2.0 Diagnostics Checklist (Brain Dump)
date: 2014-11-25T21:33:44+00:00
author: Ryan Svihla
layout: post
wordpress_guid: http://lostechies.com/ryansvihla/?p=171
dsq_thread_id:
  - "3263339991"
categories:
  - Cassandra
tags:
  - Cassandra
---
UPDATE:
  
This list needs to be updated and as of today only has been verified with Cassandra 2.0.

Original Blog Post:

This isn&#8217;t remotely complete, but I had a colleague ask me to do a brain dump of my process and this is by and large usually it. I&#8217;m sure this will leave more questions than answers for many of you, and I&#8217;d like to follow up this post at some point with detail of the why and the how of a lot of it so it can be more useful to beginners. Today this is in a very raw form.

# Important metrics to collect

  * logs
  * cassandra.yaml
  * cassandra-env.sh
  * histograms
  * tpstats
  * schema of all tables
  * nodetool status
  * ulimit -a as user that cassandra is running as (make sure it matches our settings)

# Import facts to collect

  * heap usage under load, is it hitting 3/4 of MAX_HEAP ?
  * Pending compactions (opscenter, will have to look up JMX metric later)
  * size of writes/reads
  * max partition size (histograms will say)
  * tps per node
  * list of queries run against the cluster

# Bad things to look for in logs

  * ERROR
  * WARN
  * dropped
  * GCInspector (see parnews over 200ms and CMS )
  * Emergency
  * Out Of Memory

# Typically screwed up cassandra-env.sh settings

  * heap not set to 8gb
  * parnew no more than 800mb (unless using tunings from https://issues.apache.org/jira/browse/CASSANDRA-8150)

# Typically screwed up cassandra.yaml settings

  * row cache being enabled (unless 95% read with even width rows)
  * vnodes set with solr
  * system_auth keyspace still with RF 1 and SimpleStrategy
  * flush_writers set to crazy high level (varies by disk configuration, follow documentation advice, double digits is suspect)
  * rcp_address: 0.0.0.0 (slows down certain versions of the driver)
  * multithreaded_compaction: true (almost always wrong)

# Typically bad things in histograms

  * double hump
  * long long tail
  * partitions with cell count over 100k
  * partitions with size over in\_memory\_compaction_limit (default 64mb)

# Typically bad things in tpstats

  * dropped (anything) especially mutations.
  * blocked flush writers (if all time is in the 100s it&#8217;s usually a problem)

# Typically screwed up keyspace settings

  * STC compaction in use on SSD when customers have a low read SLA (or no defined one).
  * Using RF less than 3 per DC
  * Using RF more than 3 per DC
  * Using SimpleStrategy with multiDC

# Typically screwed up CF settings

  * read\_repair\_chance and dclocal\_read\_repair_chance adding up to more than 0.1 is usually a bad tradeoff.
  * Secondary indexes in use (on writes think write amplification, and on reads think synchronous full cluster scan).
  * Is system_auth replicated correctly? And has it has repair run after this was changed? If you see auth errors in the log..the answer is probably no

# Typically bad things in nodetool status

  * use of racks is not even (4 in one rack and 2 in another..that&#8217;s a no no)
  * use of racks is not enough to fulfil muliple of RF (if you have 2 racks of 2 and RF 3..how will that get evenly laid out?).
  * if load is wildly off. may not mean anything, but go look on disk, if the cassandra data files are really imbalanced badly figure out why.

# Performance tuning Cassandra for write heavy workloads

  * Run cstress as a baseline
  * Run cstress with appications write size this will often identify bottlenecks
  * Do math on writes and desired TPS. Are the writes saturating the network? Don&#8217;t forget bits and bytes are different 🙂
  * Lower ParNew for lower _peak_ 99th, now this flies in the face of what is happening with this Jira (https://issues.apache.org/jira/browse/CASSANDRA-8150), but until I&#8217;ve worked through all of that ParNew lower than 800MB is generally a good way to tradeoff throughput for smaller ParNew GCs.
  * Run Fio with the following profile https://gist.github.com/tobert/10685735 (adjusted to match users system). Using these as baseline (http://tobert.org/disk-latency-graphs/). 

# Performance Tuning Code for write heavy workloads

Once you&#8217;ve established the system is awesome. Review queries and code.

  * Things to look for BATCH keyword for bulk loading (fine for consistency, but has to take into account SLA hit if the writes are larger than BATCH can handle).
  * If using batches what is the write size?
  * Are you using a thrift driver and destroying one or two nodes because of bad load balancing?
  * Are you using the DataStax driver, is it using the token aware policy (shuffle on with 2.0.8 ideally)?
  * If using the DataStax driver, is it the latest 2.0.x Lots of useful fixes in each release, it really matters.
  * Using LWT? They involve 4 round trips and so ..while they&#8217;re awesome they&#8217;re slower.