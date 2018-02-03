---
wordpress_id: 279
title: Reflection Scala-2.10 and Spark weird errors when saving to Cassandra
date: 2016-04-09T08:44:49+00:00
author: Ryan Svihla
layout: post
wordpress_guid: https://lostechies.com/ryansvihla/?p=279
dsq_thread_id:
  - "4790286719"
categories:
  - Cassandra
  - Spark
tags:
  - Cassandra
  - Scala
  - Spark
---
<p id="d1a6">
  This originally started with this <a href="http://stackoverflow.com/questions/35024274/java-io-invalidclassexception-org-apache-spark-sql-types-timestamptype-and-java/35187029#35187029" rel="nofollow" data-href="http://stackoverflow.com/questions/35024274/java-io-invalidclassexception-org-apache-spark-sql-types-timestamptype-and-java/35187029#35187029">SO question</a>, and I’ll be honest I was flummoxed for a couple of days looking at this (in no small part because the code was doing a lot). But at some point I was able to isolate all issues down to dataFrame.saveToCassandra. Every 5 or so runs I’d get one or two errors:
</p>

[gist id=b3b0d2b0c8a3cc15d7c6e651425dddc0]

<p id="716c">
  or
</p>

[gist id=820a6def4f9c97dd73561dd33e84804d]

<p id="186f">
  I could write this data to a file with no issue, but when writing to a Cassandra these errors would come flying out at me. With the help of <a href="https://twitter.com/RussSpitzer" rel="nofollow" data-href="https://twitter.com/RussSpitzer">Russ Spitzer</a> (by help I mean explaining to my thick skull what was going on) I was pointed to the fact that reflection <a href="http://docs.scala-lang.org/overviews/reflection/thread-safety.html" rel="nofollow" data-href="http://docs.scala-lang.org/overviews/reflection/thread-safety.html">wasn’t thread safe in Scala 2.10</a>.
</p>

<p id="bde5">
  No miracle here objects have to be read via reflection down to the even the type checking (type checking being something writing via text that is avoided) and then objects have to be populated on flush.
</p>

### Ok so what are the fixes {#5bed}

<li id="ae55">
  Run with a version of <a href="http://spark.apache.org/docs/latest/building-spark.html#building-for-scala-211" rel="nofollow" data-href="http://spark.apache.org/docs/latest/building-spark.html#building-for-scala-211">Spark compiled against Scala 2.11</a>
</li>
<li id="e9f8">
  Use foreachPartition to write directly using the Cassandra java driver API and avoid reflection. You’ll end up giving up some performance tweaks with token aware batching if you go this route, however.
</li>
<li id="a862">
  Accept it! Spark is fault tolerant, and in any of these cases the job is not failing and it’s so rare that Spark just quietly retries the task and there is no data loss and no pain.
</li>