---
id: 296
title: Spark job that writes to Cassandra just hangs when one node goes down?
date: 2016-04-05T17:48:16+00:00
author: Ryan Svihla
excerpt: If one node takes down your app, do you have any replicas?
layout: post
guid: https://lostechies.com/ryansvihla/?p=296
dsq_thread_id:
  - "4726220329"
categories:
  - Cassandra
  - Spark
tags:
  - Cassandra
  - Spark
---
### <span style="font-size: 16px;">So this was hyper obvious once I saw the executor logs and the database schema, but this had me befuddled at first and the change in behavior with one node should have made it obvious.</span> {#23da}

<p id="f2c8">
  The code was simple, read a bunch of information, do some minor transformations and flush to Cassandra. This was nothing crazy. But during the users fault tolerance testing, the job would just seamingly hang indefinitely when a node was down.
</p>

# If one node takes down your app, do you have any replicas? {#b2b4}

<p id="72ee">
  That was it, in fact that’s always it, if something myseriously “just stops” usually you have a small cluster and no replicas (RF 1). Now one may ask why anyone would ever have 1 replica with Cassandra and while I concede it is a very fair question, this was the case here.
</p>

<p id="a1c6">
  Example if I have RF1 and three nodes, when I wrote a row it’s only going to go to 1 of those nodes. If it dies, then how would I retrieve the data? Wouldn’t it just fail? Ok yeah wait a minute why is the job not failing?
</p>

# It’s the defaults! {#c2f8}

<p id="7582">
  This is a bit of misdirection, the other nodes were timing out (probably slow IO layer). If we read the <a href="https://github.com/datastax/spark-cassandra-connector/blob/v1.6.0-M1/doc/reference.md" rel="nofollow" data-href="https://github.com/datastax/spark-cassandra-connector/blob/v1.6.0-M1/doc/reference.md">connector docs</a> we get query.retry.count which gives us 10 retries, and the default read.timeout_ms is 120000 (which confusingly is also the write timeout), so 1.2 million milliseconds or 20 minutes to fail a task that is timing out. If you retry that task 4 times (which is the Spark default) it could take you 80 minutes to fail the job, this is of course assuming all the writes timeout.
</p>

# The Fix {#98c8}

<p id="60fd">
  Short term
</p>

<li id="8feb">
  Don’t let any nodes fall over
</li>
<li id="4870">
  drop retry down to 10 seconds, this will at least let you fail fast
</li>
<li id="0f1e">
  drop output.batch.size.bytes down. Default is 1mb, half until you stop having issues.
</li>

<p id="e35d">
  Long term
</p>

<li id="e199">
  Use a proper RF of 3
</li>
<li id="237d">
  I still think the default retry of 120 seconds is way too high. Try 30 seconds at least.
</li>
<li id="4262">
  Get better IO usually local SSDs will get you where you need to go.
</li>