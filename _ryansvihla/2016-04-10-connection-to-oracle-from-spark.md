---
wordpress_id: 289
title: Connection to Oracle From Spark
date: 2016-04-10T08:51:54+00:00
author: Ryan Svihla
layout: post
wordpress_guid: https://lostechies.com/ryansvihla/?p=289
dsq_thread_id:
  - "4661588863"
categories:
  - Spark
tags:
  - Oracle
  - Spark
---
<p id="9b2b">
  For some silly reason there is a has been a fair amount of difficulty in reading and writing to Oracle from Spark when using DataFrames.
</p>

<p id="8d92">
  SPARK-10648 — <a href="https://issues.apache.org/jira/browse/SPARK-10648" rel="nofollow" data-href="https://issues.apache.org/jira/browse/SPARK-10648">Spark-SQL JDBC fails to set a default precision and scale when they are not defined in an oracle schema.</a>
</p>

<p id="819b">
  This issue manifests itself when you have numbers in your schema with no precision or scale and attempt to read. They added the following dialect here
</p>

[gist id=2a4c1225cb64a02d173342bfc2ba8c58]

<p id="537e">
  This fixes the issue for 1.4.2, 1.5.3 and 1.6.0 (and DataStax Enterprise 4.8.3). However recently there is another issue.
</p>

<p id="77e1">
  SPARK-12941 — <a href="https://issues.apache.org/jira/browse/SPARK-12941" rel="nofollow" data-href="https://issues.apache.org/jira/browse/SPARK-12941">Spark-SQL JDBC Oracle dialect fails to map string datatypes to Oracle VARCHAR datatype</a>
</p>

<p id="e294">
  And this lead me to t<a href="http://stackoverflow.com/questions/31287182/writing-to-oracle-database-using-apache-spark-1-4-0" rel="nofollow" data-href="http://stackoverflow.com/questions/31287182/writing-to-oracle-database-using-apache-spark-1-4-0">his SO issue</a>. Unfortunately, one of the answers has a fix they claim only works for 1.5.x however, I had no issue porting it to 1.4.1. The solution in Java looked something like the following, which is just a Scala port of the SO answer above ( This is not under warranty and it may destroy your server, but this should allow you to write to Oracle.)
</p>

[gist id=c9b8c5b17fa002ba01aba38838ffa30b]

<p id="3c04">
  In the future keep an eye out for more official support in <a href="https://issues.apache.org/jira/browse/SPARK-12941" rel="nofollow" data-href="https://issues.apache.org/jira/browse/SPARK-12941">SPARK-12941</a> and then you can ever forget the hacky workaround above.
</p>