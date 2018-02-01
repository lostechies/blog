---
id: 226
title: Lambda+ or Event Sourcing with TTLs
date: 2015-09-17T13:00:02+00:00
author: Ryan Svihla
layout: post
guid: https://lostechies.com/ryansvihla/?p=226
dsq_thread_id:
  - "4139086351"
categories:
  - Cassandra
  - Event sourcing
  - Lambda
tags:
  - Cassandra
  - Data Modeling
  - Event Sourcing
  - Lambda
---
<p id="bdaf">
  <span style="font-size: 16px;">Some people are worried about the data volume that a strategy like Lambda+ or Event Sourcing implies. As a disclaimer,</span><em style="font-size: 16px;"> by giving up the historical data you have, you risk losing useful data layer and you lose the ability to have bi-temporal data or go back in time. </em><span style="font-size: 16px;">However, if you still don’t care about that, please continue reading.</span>
</p>

### Transaction Log Lessons {#d7ae}

<p id="8f76">
  If we think of Event Sourcing as a transaction log we can borrow some valuable lessons. How is it like a transaction log you ask?
</p>

<li id="42d1">
  I have all updates
</li>
<li id="f06b">
  I have all deletes
</li>
<li id="f37f">
  I have all initial writes
</li>
<li id="1427">
  I can use it to replay and repair other parts of my data base (derived views)
</li>

<p id="f6fe">
  Ok so it’s like a transaction log so what? We can borrow the idea of check points or a “known good state” to get us where we can safely apply a TTL to our events.
</p>

### Checkpoints {#da2b}

<p id="4d3a">
  Using <a href="https://msdn.microsoft.com/en-us/library/ms189573.aspx" rel="nofollow" data-href="https://msdn.microsoft.com/en-us/library/ms189573.aspx">Microsoft’s definition for checkpoints</a>
</p>

<blockquote id="46c4">
  <p>
    A checkpoint creates a known good point from which the SQL Server Database Engine can start applying changes contained in the log during recovery after an unexpected shutdown or crash.
  </p>
</blockquote>

<p id="70e2">
  So to apply to our use case, a checkpoint will be represented by a rollup of all events that occurred before the date range of that rollup.
</p>

<div>
  <div>
  </div>
  
  <p>
    <img src="https://cdn-images-1.medium.com/max/884/1*UR4r2jnZxnN0WoSiB8NSDw.png" alt="" data-image-id="1*UR4r2jnZxnN0WoSiB8NSDw.png" data-width="884" data-height="516" data-action="zoom" data-action-value="1*UR4r2jnZxnN0WoSiB8NSDw.png" data-scroll="native" /></div> 
    
    <p id="a1b0">
      The writes that are after the checkpoint but before TTL will be ignored, and will not affect batch jobs to generate data.
    </p>
    
    <h4 id="3dc1">
      Entity Checkpoints
    </h4>
    
    <p id="932f">
      Let’s take a look at an entity type rollup (the simple case)
    </p>
    
    <pre name="0022">CREATE TABLE my_keyspace.events ( bucket timestamp,
 event_id timeuuid, entity_id uuid, attribute text, 
value text, PRIMARY KEY( bucket, event_id,
 entity_id, attribute ));</pre>
    
    <pre name="8360">CREATE TABLE mykeyspace.checkpoints ( bucket timestamp, 
entityId uuid, attribute text, value text, 
PRIMARY KEY(bucket, entityId, attribute))</pre>
    
    <p id="ae00">
      If we take this approach say for a user account, with 3 events, one where the user gets married:
    </p>
    
    <pre name="8cef">INSERT INTO mykeyspace.checkpoints (bucket, 
event_id, entity_id, attribute, value)
 VALUES ('2014-01-10 11:00:00.000',
 2d3c8090-5cab-11e5-885d-feff819cdc9f<strong>, 
</strong>ebe46228-402c-4efe-b377-62472fb55684, 
'First Name', 'Jane')</pre>
    
    <pre name="44eb">INSERT INTO mykeyspace.checkpoints (bucket, 
event_id, entity_id, attribute, value) 
VALUES ('2014-01-10 11:00:00.000',
<strong> </strong>a6a105d2-5cab-11e5-885d-feff819cdc9f,
 2d3c8090-5cab-11e5-885d-feff819cdc9f,
 'Last Name', 'Smith')</pre>
    
    <pre name="3824">INSERT INTO mykeyspace.checkpoints (bucket,
 event_id, entity_id, attribute, value) 
VALUES ('2015-02-12 09:00:00.000', 
8bc4046c-5cab-11e5-885d-feff819cdc9f,
 2d3c8090-5cab-11e5-885d-feff819cdc9f, 'Last Name', 'Zuma')</pre>
    
    <p id="f421">
      The checkpoint for this same record would look like the following
    </p>
    
    <pre name="ffcd">INSERT INTO mykeyspace.checkpoints (bucket,
 entityId, attribute, value) VALUES 
( '2015-06-01 10:00:00', 
8bc4046c-5cab-11e5-885d-feff819cdc9f,
 'Last Name', 'Zuma' )</pre>
    
    <p id="0b4b">
      In this case you’ve lost the original data, so as long as you later do not need to get “initial last name” then you’re fine.
    </p>
    
    <h4 id="128e">
      Aggregation Checkpoints
    </h4>
    
    <p id="3817">
      You could go also the really easy route and rely on your existing computed views.
    </p>
    
    <pre name="e4af">CREATE TABLE mykeyspace.clicks_by_city 
(city text, country text, clicks bigint,
 PRIMARY KEY((city, country)) )</pre>
    
    <pre name="9d04">CREATE TABLE mykeyspace.batch_runs 
( table_name text, newest_bucket_run_against timestamp,
 PRIMARY KEY(table_name) )</pre>
    
    <p id="e08c">
      Then it becomes easy enough to ignore all records older than that timestamp when rolling up later on.
    </p>
    
    <h3 id="a97b">
      Replay Caveats
    </h3>
    
    <p id="c535">
      Once you’ve chosen to ignore any events older than X you cannot safely replay them. You’ll have to blow away previous checkpoints and views and start over back to the point you replay and your replay will have to be complete.
    </p>