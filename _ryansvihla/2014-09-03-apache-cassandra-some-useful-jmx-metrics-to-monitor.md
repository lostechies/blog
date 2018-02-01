---
id: 3490
title: 'Apache Cassandra: Some useful JMX metrics to monitor'
date: 2014-09-03T11:03:06+00:00
author: Ryan Svihla
layout: post
guid: http://lostechies.com/ryansvihla/?p=136
dsq_thread_id:
  - "2984835523"
categories:
  - Cassandra
tags:
  - Cassandra
  - JMX
---
This is not a complete list, but is this what I’ve typically had to look out for in the wild. There maybe some selection bias at play since once I’m involved with a cluster it’s not in a good place.

<sub><strong><em>org.apache.cassandra.metrics/DroppedMessage/MUTATION/Attributes/Count</em></strong></sub>

This should always be 0. This is indicative of load shedding and while there can be short term bursts where this is only a temporary problem that normal maintenance cleans up, it’s more often than not indicative that your cluster is overloaded, mistuned or just flat our running on bad hardware to begin with.

<sub><strong><em>org.apache.cassandra.internal/FlushWriter/Attributes/CurrentlyBlockedTasks</em></strong></sub>

Healthy is 0. However, if you have any it’s an indication of tuning problems (usually JVM) and or slow disk IO.

<sub><strong><em>org.apache.cassandra.metrics/Storage/TotalHints/Attributes/Count</em></strong></sub>

Ideally 0, but in practice you should have some. If this number is accumulating consistently (like a few thousand a day), then it maybe a hint to consistent network or availability issues inside your cluster. This may mean you have a flakey network link, a bad node that’s not totally dead but not functioning, or any number of problematic issues. Hints are part of Cassandra’s failure management, so by itself this is not a problem, but if you have a lot of failures consistently, it may very well point to a problem that you’ve been ignoring.

<sub><strong><em>org.apache.cassandra.metrics/Storage/TotalHintsInProgress/Attributes/Count</em></strong></sub>

Ideally 0. This measures the number of Hints currently on a given node that are actively processing (think replaying or attempting again). If this number gets into the millions expect that node to suffer some as it tries to manage all these hints. They’re on heap and also count against your total MemTable size, effectively you’re removing available space for your new requests to do their job as the hint management becomes it’s own problem. There are steps being taken to improve this situation with off heap memtables and having hints use files instead of a table as it currently does today, this of this somewhat like a commit log only for retries.

<sub><strong><em>org.apache.cassandra.db/Caches/Attributes/KeyCacheRecentHitRate</em></strong></sub>

This should be 0.85 or greater. Temporary dips below this number are expected directly after a large bulk update, but if you stay here longer term this can be a problem of data modeling issues or configuration problems, such as JNA is not correctly installed, and therefore the keycache is residing on heap. In theory, when combined with heap pressure this can end up over flushing the cache.