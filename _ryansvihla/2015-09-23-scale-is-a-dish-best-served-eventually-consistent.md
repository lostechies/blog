---
id: 234
title: Scale is a Dish Best Served Eventually Consistent
date: 2015-09-23T10:58:51+00:00
author: Ryan Svihla
layout: post
guid: https://lostechies.com/ryansvihla/?p=234
dsq_thread_id:
  - "4158247130"
categories:
  - Cassandra
  - Distributed
tags:
  - Cassandra
  - Distributed
---
<p id="6c7d">
  <span style="font-size: 16px;">A lot of people new to Cassandra find the data modeling required tedious and outrageously hard. They’ll long for their RDMBS, if only </span><strong style="font-size: 16px;">i<em>nsert favorite vendor or project lead here</em></strong><span style="font-size: 16px;"> would make their RDBMS scale like Cassandra they could tell their bosses to shove off and go back to using their favorite tool. To people saying this (and I hear the echos of it in conversations often), I’ve got news for you, the problem isn’t Cassandra or your favorite tool, it’s your style of data modeling.</span>
</p>

### Scaling with your favorite RDBMS {#2c07}

<p id="bd03">
  Let’s step through what companies have to do at scale they existing databases. Some of this is helped with a favorite vendor tool of choice, but at the end of the day it’s a bolting on the same principles already in place in Cassandra, Riak and DynamoDB.
</p>

### Sharding for Horizontal Scale {#946a}

<p id="8ec2">
  This decision is driven by write throughput because you can’t cache writes. In the most simple design with 2 databases you split your dataset in half and build in query logic to correctly query the database where data lives.
</p>

`<br />
-- against server for Western US users<br />
SELECT * FROM users WHERE last_name = 'Jones'<br />
-- against server for Eastern US users<br />
SELECT * FROM users WHERE last_name = 'Jones'<br />
` 

<p id="f0a1">
  This works great, but what happens when you want to join on both servers? Most people will just do so client side and issue two queries. This works fine, but for how long? What happens when it’s 30 servers?
</p>

### Denormalization {#2522}

<p id="cd07">
  At some point you realize some queries are just way too expensive to do at runtime. So you begin by writing a batch job or two to generate simple materialized views that represent aggregations across all data sets. This brings your queries back in line.
</p>

`<br />
 CREATE TABLE work_counts ( status varchar(50), count int, PRIMARY KEY(status));<br />
` 

### Data Loss and Replication Lag {#9bfb}

<p id="d0fc">
  Somehow you lose a shard one day. This is fine as you back your data up, but the problem is you’re not getting answers on that shard during that time. Worse, you’ve corrupted your materialized views because your data is missing and you have to rerun your batch jobs again. So you setup leader/follower async replication and that way you can serve reads will the leader is down.
</p>

<p id="9881">
  However, a few days after your last automated followover, you start to find inconsistency and impossible values in your database. What happened? You have replication lag between followers and leaders, and if you’re multi-dc it can be incredibly significant and span into the hours long range. Looking at the following example will illustrate the problem set
</p>

`<br />
INSERT INTO work_queue (work_id, work, status) values ( 100898, 'data to process', 'PENDING')<br />
--against a bunch of separate servers because of sharding and probably done in a batch job<br />
-- not at write time as that may take minutes<br />
SELECT count(*) FROM work_queue where status='PENDING'<br />
--against yet another server again because of sharding<br />
INSERT INTO work_counts ( status, count) values ( 'PENDING', 1298008)<br />
` 

<p id="8788">
  You have to hop multiple servers so you can’t lock or do a transaction (and even when you can it’d be brittle and slow), you’re eventually consistent with your counts, and your followers may not even agree!
</p>

### So What {#5f0b}

<p id="630c">
  You’ve now lost the following from your favorite RDBMS:
</p>

<li id="f4ee">
  ACID on the entire dataset
</li>
<li id="3395">
  Transactions are severely limited
</li>
<li id="4d79">
  Joins are limited and of limited use
</li>

<p id="6d61">
  Several of you maybe now saying “yeah but I’m fine with all this at least I don’t have to learn data modeling with Cassandra”, actually you’ve just re-implemented Cassandra but very badly. You’re paying for the overhead of relational technology that you can’t even use, and it’s substantial overhead. Worse you have a b-tree database instead of a columnar one, and so you LOSE a ton of feautures compared to Cassandra in the process.
</p>

### Summary {#3f74}

<p id="8b49">
  Some of you may now think I’m insane and that your favorite database doesn’t work this way. You may want to check again. I’ve worked on some very large deployments and ripped out several different database technologies now built in the above fashion. Users that already get distributed ideas find Cassandra a joy to work with, those that haven’t scaled view all these constraints as Cassandra problems and not what they really are, which is to say just plain physics.
</p>