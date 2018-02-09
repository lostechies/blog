---
wordpress_id: 277
title: Logging The Generated CQL from the Spark Cassandra Connector
date: 2016-04-07T08:43:37+00:00
author: Ryan Svihla
layout: post
wordpress_guid: https://lostechies.com/ryansvihla/?p=277
dsq_thread_id:
  - "4762601170"
categories:
  - Cassandra
  - Spark
tags:
  - Cassandra
  - Spark
---
<p id="b9fd">
  This has come up some in the last few days so I thought I’d share the available options and the tradeoffs.
</p>

### Option 1: Turn ON ALL THE TRACING! nodetool settraceprobability 1.0 {#354c}

<p id="8ada">
  Probabilistic tracing is a handy feature for finding expensive queries in use cases where there is little control over who has access to the cluster IE most enterprises in my experience (ironic considering all the process). However, it’s too expensive to turn it up too high in production, but in development it’s a good way to give you an idea of what a query turns into. Read more about probalistic tracing here:
</p>

<div id="76f7">
  <a title="http://www.datastax.com/dev/blog/advanced-request-tracing-in-cassandra-1-2" href="http://www.datastax.com/dev/blog/advanced-request-tracing-in-cassandra-1-2" rel="nofollow" data-href="http://www.datastax.com/dev/blog/advanced-request-tracing-in-cassandra-1-2">Advanced request tracing in Cassandra 1.2<br /> In my first post on request tracing in Cassandra, you may have noticed some extra output from cqlsh like this: Tracing…www.datastax.com</a>
</div>

<p id="0049">
  and the command syntax:
</p>

<div id="0f24">
  <a title="http://docs.datastax.com/en/cassandra/2.1/cassandra/tools/toolsSetTraceProbability.html" href="http://docs.datastax.com/en/cassandra/2.1/cassandra/tools/toolsSetTraceProbability.html" rel="nofollow" data-href="http://docs.datastax.com/en/cassandra/2.1/cassandra/tools/toolsSetTraceProbability.html">nodetool settraceprobability<br /> Sets the probability for tracing a request. |docs.datastax.com</a>
</div>

### Option 2: Trace at the driver level {#42c9}

<p id="3d7c">
  Set TRACE logging level on the java-driver request handler on the spark nodes you’re curious about.
</p>

<p id="82de">
  Say I have a typical join query:
</p>

{% gist 69b7ba6b51e4b6e00624328a89ef074c %}

<p id="3ce6">
  On the spark nodes now configure the DataStax java driver RequestHandler.
</p>

<p id="9069">
  In my case using the tarball this is dse-4.8.4/resources/spark/conf/logback-spark-executor.xml. In that file I just added the following inside the <configuration> element:
</p>

{% gist c1043ac25df9db068a03e1d7e1d56b4d %}

<p id="884a">
  On the spark nodes in the executor logs you’ll now have. In my case /var/lib/spark/worker/worker-0/app-20160203094945–0003/0/stdout, app-20160203094945–0003 is the job name.
</p>

{% gist 28b0688802bdcc7f014550f5295c4c08 %}

<p id="48a0">
  You’ll note this is a dumb table scan that is only limited to the tokens that the node owns. You’ll note the tokens involved are not visible, I leave it to the reader to repeat this exercise with pushdown like 2i and partitions.
</p>