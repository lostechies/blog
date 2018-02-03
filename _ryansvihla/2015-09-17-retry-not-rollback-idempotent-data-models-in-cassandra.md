---
wordpress_id: 202
title: 'Retry not Rollback: Idempotent Data Models in Cassandra'
date: 2015-09-17T11:49:05+00:00
author: Ryan Svihla
layout: post
wordpress_guid: https://lostechies.com/ryansvihla/?p=202
dsq_thread_id:
  - "4138896457"
categories:
  - Cassandra
---
###  {#737a}

### Naive Consistency {#d037}

<p id="fad8">
  Often the first error handling code I see from new Cassandra users is the client side rollback in an attempt to replicate database transactions from the ACID world. This is typically done when a write to multiple tables fail, or a write is not able to meet requested Consistency Level. Unfortunately, client side rollbacks, while well intentioned, generally create more problems than they solve. Let’s discuss how this will end up
</p>

### Distributed Problem Set of Rollbacks {#7850}

<p id="c7fd">
  This is a sample of the type of code I see (obviously not with hardcoded values).
</p>

<pre name="511f">session.execute("INSERT INTO my_db.events 
(id, text, ts) 
values (1, 'added record', 2015-01-23 11:00:01.923'");
try{
  session.execute("INSERT INTO my_db.user_events 
(user_id, id) values (100, 1)");
}catch(Exception e){
  //bad idea 
  session.execute("DELETE FROM my_db.events 
where id=1")
}</pre>

<p id="e4b6">
  The problem with this is, there are several servers responsible for this source of truth, and in a working system, this code will usually work fine with a sleep in between the operations. However, Thread.sleep(100) is rarely a safe approach in practice or remotetly professional. What do you do?
</p>

### Retry, The Distributed Alternative To Rollbacks {#177d}

<p id="df6d">
  However, the typical approach for experienced Cassandra users is to retry the transactions and most drivers will even do this by default for timeouts. Conceptually, if done by hand the code would look more like:
</p>

<pre name="ace3">String query = "INSERT INTO my_db.user_events 
(user_id, id) values (100, 1)";
try{
  session.execute(query);
}catch(Exception e){
  session.execute(query)
  // optionally you can even attempt a
  // circuit breaker pattern
  // and write a backup location such as a
  //  queue to retry later
  // only useful in the most extreme cases 
// or most limited          
// configurations
}</pre>

<p id="bb2d">
  So lets talk about the practical application of these theories in our data model.
</p>

### Practical Idempotent Data Models {#5622}

#### Client Side Ids + Buckets {#34d6}

<pre name="95d4">CREATE TABLE my_keyspace.users ( user_id uuid,
 first_name text, last_name text, 
PRIMARY KEY(user_id));
<span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">
INSERT INTO my_keyspace.users ( user_id, first_name,
 last_name) values ( 
e785e49a-996d-4df0-b378-4404798ce088, 
'Ryan', 'Smith' )</span></pre>

<p id="b272">
  <strong>Approach</strong>
</p>

<p id="ccb9">
  Ids are generated on the client or from an external system and therefore are not tied to anything server side.
</p>

<p id="8d7e">
  <strong>Caveats</strong>:
</p>

<li id="d463">
  Safe to retry a dozen times if it’s safe to retry one time
</li>
<li id="2661">
  Must still respect order. So if I have another update to this user_id say a last name change, it must not come AFTER the logically later name change.
</li>

#### Immutable {#95cf}

<pre name="ac4d">CREATE TABLE my_keyspace.users (user_id uuid, ts timeuuid,
 attribute_name text, attribute_value text, 
PRIMARY KEY(user_id, ts, attribute_name))

<span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">INSERT INTO my_keyspace.users ( user_id, ts, 
attribute_name, attribute_value) values 
( e785e49a-996d-4df0-b378-4404798ce088, 
'2015-01-10 09:56:01.000', 'first_name', 'Ryan')</span></pre>

<p id="692d">
  <strong>Approach</strong>
</p>

<p id="bc09">
  There are no updates to any writes beyond retries, another name for this is<a href="http://martinfowler.com/eaaDev/EventSourcing.html" rel="nofollow" data-href="http://martinfowler.com/eaaDev/EventSourcing.html">Event Sourcing</a>. The number of updates will determine how effective this is and there are a whole raft of other considerations when it comes to partition sizing. This will work really well with the Lambda Architecture as different analytics tools can combine down these separt
</p>

<p id="b495">
  Retries of the same value will have the same result no matter what. This is safely idempotent and free from race conditions that result in permanently inconsistent state.
</p>

<p id="96e0">
  <strong>Caveats:</strong>
</p>

<li id="e643">
  Your timestamps should be based on the time of the update, this will allow to retry with huge time difference and still have an accurate result.
</li>
<li id="c22a">
  Must be aware of partition key width. An upcoming blog post will discuss partition sizing for now rule of thumb is limit it to 100k items and 32megs. While these are not remotely hard and fast rules and more recent versions of Cassandra are happy with a lot more, and different query styles are able to tolerate larger partitions than this, these are good guidelines to start out with if you’re new. Use nodetool cfhistograms <keyspace> <table> to get these numbers on a given node.
</li>

### Non-idempotent Anti-Pattern Example {#22b2}

<pre name="e8cb">CREATE TABLE my_keyspace.users ( user_id timeuuid,
 first_name text, last_name text,
 PRIMARY KEY(user_id));</pre>

<pre name="d1f2">INSERT INTO my_keyspace.users ( user_id, first_name,
 last_name) values ( now(), 'Ryan', 'Smith' )</pre>

<p id="f203">
  Because it uses a server side generated timeuuid a retry will result in LOTS of different timeuuids and will never give you the same result twice.
</p>

### Summary {#b77b}

<p id="c159">
  I hope this has given the reader enough ammo to start building out Idempotent data models that fit in line with distributed principles and lead to a well understood and well behaving application that is tolerant of all sorts of failure modes in a consistent and easy to understand way.
</p>