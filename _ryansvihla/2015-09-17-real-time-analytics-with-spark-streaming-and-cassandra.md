---
wordpress_id: 3491
title: Real Time Analytics With Spark Streaming and Cassandra
date: 2015-09-17T12:28:25+00:00
author: Ryan Svihla
layout: post
wordpress_guid: https://lostechies.com/ryansvihla/?p=210
dsq_thread_id:
  - "4138990898"
categories:
  - Cassandra
  - Spark
tags:
  - Cassandra
  - Spark
  - Spark Streaming
---
<p id="2c8c">
  <a style="font-size: 16px;" href="http://spark.apache.org/streaming/" rel="nofollow" data-href="http://spark.apache.org/streaming/">Spark Streaming</a><span style="font-size: 16px;"> is a good tool to roll up transactions data into summaries as they enter the system. When paired with an easily idempotent data store like Cassandra you get a high performance low hassle approach to getting your work done.</span>
</p>

### Useful Background {#2967}

<li id="b8ca">
  <a href="https://medium.com/@foundev/retry-not-rollback-9a0412fe63c4" data-href="https://medium.com/@foundev/retry-not-rollback-9a0412fe63c4">Retry Not Rollback: Idempotent Data Models in Cassandra</a>
</li>
<li id="242c">
  <a href="https://medium.com/@foundev/event-sourcing-and-system-of-record-b919714512b8" data-href="https://medium.com/@foundev/event-sourcing-and-system-of-record-b919714512b8">Event Sourcing and System Of Record</a> (addresses <em>Message Replay </em>and <em>System Of Record</em>)
</li>
<li id="ef49">
  <a href="http://docs.datastax.com/en/cql/3.1/cql/cql_using/use_counter_t.html" rel="nofollow" data-href="http://docs.datastax.com/en/cql/3.1/cql/cql_using/use_counter_t.html">Cassandra CQL Docs on Counters</a>
</li>
<li id="9da8">
  <a href="https://databricks.com/blog/2015/01/15/improved-driver-fault-tolerance-and-zero-data-loss-in-spark-streaming.html" rel="nofollow" data-href="https://databricks.com/blog/2015/01/15/improved-driver-fault-tolerance-and-zero-data-loss-in-spark-streaming.html">WAL: Write Ahead Logging</a>
</li>
<li id="1d95">
  <a href="https://databricks.com/blog/2015/03/30/improvements-to-kafka-integration-of-spark-streaming.html" rel="nofollow" data-href="https://databricks.com/blog/2015/03/30/improvements-to-kafka-integration-of-spark-streaming.html">Direct API in Spark Streaming</a>
</li>

### General Best Practice {#48a2}

<p id="a9a5">
  The safe choice will be an<em> Idempotent Data Model</em> that you can safely retry,<em>Aggregate with Spark Streaming</em><strong> </strong>and use <em>Message Replay</em> driven by a <em>System Of Record</em> to handle any lost messages.
</p>

### Anti-Pattern {#dabb}

<p id="366d">
  <em>Counters</em> with <em>Spark Streaming</em>, this will likely exacerbate over counting which is the nature of incrementing a number in a system where retries are the normal approach to a failed write.
</p>

### Cheat Sheet: What‘s the correct approach for you? {#5832}

<p id="d584">
  <strong>I care about speed and can allow some temporary but not permanent inaccuracy and using Kafka. </strong><em>Spark Streaming Aggregation</em> and <em>Idempotent Data Model</em><strong> </strong>+ <em>Direct API </em>with a <em>System of Record </em>that can facilitate message replay. This should be almost the identical speed to the same model without a Direct API.
</p>

<p id="bcc3">
  <strong>I care about speed and can allow some temporary but not permanent inaccuracy but not using Kafka. </strong><em>Spark Streaming Aggregation</em> and<em>Idempotent Data Model</em> with a <em>System of Record </em>that can facilitate message replay.
</p>

<p id="f123">
  <strong>I’m willing to give up speed and can allow some temporary but not permanent inaccuracy but no Kafka. </strong><em>Spark Streaming Aggregation</em> and<em>Idempotent Data Model</em><strong> </strong>+ <em>WAL </em>with a <em>System of Record </em>that can facilitate message replay<em>.</em> This will work with any message queue or network server, but all records will be written by Spark to a distributed network share first.
</p>

<p id="5744">
  <strong>I care about speed first and foremost, but only want to count and want maximum data density. </strong>May want to investigate <em>Counters </em>without<em> Spark Streaming</em>. There is no way to correct over delivery or replay. Data model will matter. Must be using a recent version of Cassandra (2.1+) to be successful as the counters before that were prone to race conditions.
</p>

<p id="a189">
  <strong>I care about speed first and foremost, but need more than count and I want maximum data density. </strong><em>Spark Streaming Aggregation</em> is your friend. There is no way to correct for over delivery or message replay. The data model and your expectations will matter a lot how successful this is.
</p>

### Tradeoffs in Detail {#98f1}

<p id="a763">
  If you do need to dive into the depths of the different approaches, and often use cases will be degrees of comfort as opposed to a true or false.
</p>

#### Counters with No Streaming {#c4fb}

<pre name="1963">session.execute("CREATE TABLE event_counts 
( event_id uuid, us_vists counter, 
uk_visits counter, PRIMARY KEY (event_id))")</pre>

<pre name="ddf9">session.execute("UPDATE event_counts SET 
uk_visits = uk_visits + 1, us_visits = 
us_visits + 2 WHERE event_id = 
21115d6d-e908-4a82-8f05-335decedfb9b")</pre>

<p id="3fc2">
  Fast, inaccurate and simple. You cannot safely retry counters without overcounting, and there is no way to know that you overcounted later. This is hopeful accuracy at best. Typical first attempt at ‘aggregates’ in Cassandra.
</p>

#### Counters + Streaming + WAL<span style="font-size: 16px;"> </span> {#9cc6}

<pre name="e30c">val conf = new SparkConf()
.setMaster("127.0.0.1:7077")
.setAppName("Counters")
<strong>.set("spark.streaming.receiver.writeAheadLog.enable", "true")
</strong><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">val ssc = new StreamingContext(conf,
</span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">Seconds(1))
</span><strong>ssc.checkpoint(checkpointDirectory)
</strong><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">//group by first column which is Country in this case
</span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">val events = ssc.socketTextStream("localhost"</span></pre>

<pre name="f31c">, 9999)
.groupBy(e=&gt;e(0)) 
.countByKey()
.foreachRDD(rdd=&gt;rdd.foreach(i=&gt;{
 
  connector.withSessionDo(session=&gt;{

 <strong> val prepared = session.prepare("UPDATE
 events_counts SET visits = visits += ? 
WHERE country = ?")
 session.execute(prepared.
bind(i._2, i._1))</strong>
    })
   }))</pre>

<p id="d142">
  Slow, inaccurate and lots of moving parts. Requires shared storage. You cannot safely retry counters without overcounting, and there is no way to know that you overcounted later. This is hopeful accuracy at best. This just adds the extra complexity of a WAL and when combined with Spark Streaming may easily overcount.
</p>

#### Counters + Streaming + Direct API<span style="font-size: 16px;"> </span> {#b42c}

<pre name="c48c">//group by first column which is Country
// in this case
<strong>val events = KafkaUtils.createDirectStream
[String, String, StringDecoder, StringDecoder]
( ssc, kafkaParams, topicsSet)</strong>
.groupBy(e=&gt;e._2.split(","))) 
.countByKey()
.foreachRDD(rdd=&gt;rdd.foreach(i=&gt;{ 
  connector.withSessionDo(session=&gt;{
 <strong> val prepared = session.prepare("UPDATE 
events_counts SET visits = visits += ? 
WHERE country = ?")
 session.execute(prepared.bind(i._2, i._1))</strong>
    })
   }))</pre>

<p id="631f">
  Must use Kafka. Slow, inaccurate and lots of moving parts. You cannot safely retry counters without overcounting, and there is no way to know that you overcounted later. This is hopeful accuracy at best. This just adds the extra complexity of a WAL and when combined with Spark Streaming may easily overcount.
</p>

#### Spark Streaming Aggregates {#6a38}

<pre name="4083">//group by first column which is sensorId 
//in this case
val events = ssc.socketTextStream("localhost", 9999)
.groupBy(e=&gt;e(0)) 
.countByKey()
.foreachRDD(rdd=&gt;rdd.foreach(i=&gt;{ 
  connector.withSessionDo(session=&gt;{
 <strong> val prepared = session.prepare("UPDATE 
sensor_counts SET measurements = ? 
WHERE sensorId = ? and ts = ?")
 session.execute(prepared.bind(
i._2, i._1, new Date()))</strong>
    })
   }))</pre>

<p id="e86d">
  Fast, and inaccurate. It is at least retry safe inside of the process, but cannot handle message loss safely.
</p>

#### Spark Streaming Aggregates + WAL {#50fc}

<pre name="da46">val conf = new SparkConf()
.setMaster("127.0.0.1:7077")
.setAppName("sensors")
<strong>.set("spark.streaming.receiver.writeAheadLog.enable",
 "true")</strong></pre>

<pre name="f9cd">val ssc = new StreamingContext(conf,
 Seconds(1))
<strong>ssc.checkpoint(checkpointDirectory)
</strong><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">//group by first column which is sensorId
// in this case
</span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">val events = ssc.socketTextStream(
"localhost", 9999)
</span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">.groupBy(e=&gt;e(0))
</span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">.countByKey()
</span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">.foreachRDD(rdd=&gt;rdd.foreach(i=&gt;{ 
</span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">connector.withSessionDo(session=&gt;{
</span><strong> val prepared = session.prepare("UPDATE 
sensor_counts SET measurements = ? 
WHERE sensorId = ? and ts = ?")
</strong><strong> session.execute(prepared.bind(
i._2, i._1, new Date()))
</strong><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;"> })
</span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;"> }))</span></pre>

<p id="1954">
  Relatively slow, but more accurate. Any message queue but requires shared storage. Will not lose messages once it’s inside Spark, but it cannot handle message losses at the message queue safely.
</p>

#### Aggregates + Direct API<span style="font-size: 16px;"> </span> {#0bba}

<pre name="8c71">//group by first column which is sensorId 
//in this case
<strong>val events = KafkaUtils.createDirectStream
[String, String, StringDecoder, StringDecoder]
( ssc, kafkaParams, topicsSet)</strong>
.groupBy(e=&gt;e._2.split(","))) 
.countByKey()
.foreachRDD(rdd=&gt;rdd.foreach(i=&gt;{ 
  connector.withSessionDo(session=&gt;{
 <strong> val prepared = session.prepare("UPDATE sensor_counts 
SET measurements = ? WHERE sensorId = ? and ts = ?")
 session.execute(prepared.bind(i._2, i._1, new Date()))</strong>
    })
   }))</pre>

<p id="2962">
  Fast and more accurate. Must use Kafka. Will not lose messages once it’s inside Spark, but it cannot handle message losses at the message queue safely.
</p>

#### Aggregates + Idempotent Data Model + System Of Record {#a0ab}

<pre name="18eb">//group by first column which is sensorId
// in this case
val events = ssc.socketTextStream("localhost", 9999).cache()</pre>

<pre name="c031"><strong>events.saveToCassandra("keyspace", "sensors_events")</strong></pre>

<pre name="c382">events.groupBy(e=&gt;e(0)) 
.countByKey()
.foreachRDD(rdd=&gt;rdd.foreach(i=&gt;{ 
  connector.withSessionDo(session=&gt;{
 <strong> val prepared = session.prepare("UPDATE sensor_counts 
SET measurements = ? WHERE sensorId = ? and ts = ?")
 session.execute(prepared.bind(i._2, i._1, i._3))</strong>
    })
   }))</pre>

<pre name="32fa">//batch job basically does the same thing and corrects any
 temporary problems
sc.cassandraTable("keyspace", "sensor_events").groupBy(e=&gt;e(0)) 
.countByKey()
.foreachRDD(rdd=&gt;rdd.foreach(i=&gt;{ 
  connector.withSessionDo(session=&gt;{
 <strong> val prepared = session.prepare("UPDATE sensor_counts 
SET measurements = ? WHERE sensorId = ? and ts = ?")
 session.execute(prepared.bind(i._2, i._1, i._3))</strong>
    })
   }))</pre>

<p id="0868">
  Speed, temporarily inaccurate but permanently accurate, at the cost of storage. Batch or re-streaming for repair. Can lose messages but it does they can be recovered safely via<em> Message Replay</em> from the <em>System Of Record</em>.
</p>

#### Aggregates + Idempotent Data Model + System Of Record + WAL {#f894}

<pre name="f3b3">val conf = new SparkConf()
.setMaster("127.0.0.1:7077")
.setAppName("sensors")
<strong>.set("spark.streaming.receiver.writeAheadLog.enable", "true")</strong></pre>

<pre name="1ee1">//group by first column which is sensorId in this case
val events = ssc.socketTextStream("localhost", 9999).cache()</pre>

<pre name="cf90">val ssc = new StreamingContext(conf, Seconds(1))
<strong>ssc.checkpoint(checkpointDirectory)</strong></pre>

<pre name="87ed"><strong>events.saveToCassandra("keyspace", "sensors_events")</strong></pre>

<pre name="7035">events.groupBy(e=&gt;e(0)) 
.countByKey()
.foreachRDD(rdd=&gt;rdd.foreach(i=&gt;{ 
  connector.withSessionDo(session=&gt;{
 <strong> val prepared = session.prepare("UPDATE sensor_counts 
SET measurements = ? WHERE sensorId = ? and ts = ?")
 session.execute(prepared.bind(i._2, i._1, i._3))</strong>
    })
   }))</pre>

<pre name="ae4d">//batch job basically does the same thing and corrects any
 temporary problems
sc.cassandraTable("keyspace", "sensor_events").groupBy(e=&gt;e(0)) 
.countByKey()
.foreachRDD(rdd=&gt;rdd.foreach(i=&gt;{ 
  connector.withSessionDo(session=&gt;{
 <strong> val prepared = session.prepare("UPDATE sensor_counts
 SET measurements = ? WHERE sensorId = ? and ts = ?")
 session.execute(prepared.bind(i._2, i._1, i._3))</strong>
    })
   }))</pre>

<p id="b127">
  Slow, pretty accurate and with high cost of storage. Any message queue but requires shared storage. Will not lose messages once it’s inside Spark, but while messages loss is possible at the message queue, they can be recovered safely via<em> Message Replay</em> from the <em>System Of Record</em>.
</p>

#### Aggregates + Idempotent Data Model + System Of Record + Direct API<span style="font-size: 16px;"> </span> {#6aba}

<pre name="2644">//group by first column which is sensorId in this case
<strong>val events = KafkaUtils.createDirectStream
[String, String, StringDecoder, StringDecoder]
( ssc, kafkaParams, topicsSet).cache()</strong></pre>

<pre name="9f1f"><strong>events.saveToCassandra("keyspace", "sensors_events")</strong></pre>

<pre name="1a5b">events.groupBy(e=&gt;e(0)) 
.countByKey()
.foreachRDD(rdd=&gt;rdd.foreach(i=&gt;{ 
  connector.withSessionDo(session=&gt;{
 <strong> val prepared = session.prepare("UPDATE sensor_counts 
SET measurements = ? WHERE sensorId = ? and ts = ?")
 session.execute(prepared.bind(i._2, i._1, i._3))</strong>
    })
   }))</pre>

<pre name="65cd">//batch job basically does the same thing and corrects any
 temporary problems
sc.cassandraTable("keyspace", "sensor_events").groupBy(e=&gt;e(0)) 
.countByKey()
.foreachRDD(rdd=&gt;rdd.foreach(i=&gt;{ 
  connector.withSessionDo(session=&gt;{
 <strong> val prepared = session.prepare("UPDATE sensor_counts
 SET measurements = ? WHERE sensorId = ? and ts = ?")
 session.execute(prepared.bind(i._2, i._1, i._3))</strong>
    })
   }))</pre>

<p id="aead">
  Fast and highly accurate but at the cost of storage. Must use Kafka. Will not lose messages once it’s inside Spark, but while messages loss is possible at the message queue, they can be recovered safely via<em> Message Replay</em> from the <em>System Of Record</em>.
</p>

### Wrapping Up<span style="font-size: 16px;"> </span> {#10ce}

<p id="451e">
  This is all probably a lot to take in if it’s your first read, but this can be a useful guide later on as you get a better handle on the different options and their tradeoffs. Unfortunately with Big Data we’re still in a world where the best practices are widely established.
</p>