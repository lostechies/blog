---
wordpress_id: 123
title: 'Cassandra: Batch loading without the Batch keyword'
date: 2014-08-28T13:10:55+00:00
author: Ryan Svihla
layout: post
wordpress_guid: http://lostechies.com/ryansvihla/?p=123
dsq_thread_id:
  - "2967471614"
categories:
  - Cassandra
tags:
  - Cassandra
---
ATTENTION:

_This post is intentionally simplistic to help explain tradeoffs that need to be made. If you are looking for some production level nuance go [read this afterwords.](https://lostechies.com/ryansvihla/?p=334)_

Batches in Cassandra are often mistaken as a performance optimization. They can be but only in rare cases. First we need to discuss the different types of batches:

## Unlogged Batch

A good example of an unlogged batch follows and assumes a partition key of date. The following batch is effectively one insert because all inserts are sharing the same partition key. Assuming a partition key of date the above batch will only resolve to one write internally, no matter how many there are as long as they have the same date value. This is therefore the primary use case of an unlogged batch:

[gist id=8702d333918b8daa5c4edd3d45910098]

A common anti pattern I see is:

[gist id=a84a6c1979138f335015340627ec5791]

Unlogged batches require the coordinator to do all the work of managing these inserts, and will make a single node do more work. Worse if the partition keys are owned by other nodes then the coordinator node has an extra network hop to manage as well. The data is not delivered in the most efficient path.

## Logged Batch (aka atomic)

A good example of a logged batch looks something like:

[gist id=10f9ed1a1ae51191a555feff7b09b5af]

This is keeps tables in sync, but at the cost of performance. A common anti pattern I see is:

[gist id=9ab65bd99ac855a14e0182c2a5bcf6e1]

This ends up being expensive for the following reasons. Logged batches add a fair amount of work to the coordinator. However it has an important role in maintaining consistency between tables. When a batch is sent out to a coordinator node, two other nodes are sent batch logs, so that if that coordinator fails then the batch will be retried by both nodes.

This obviously puts a fair a amount of work on the coordinator node and cluster as a whole. Therefore the primary use case of a logged batch is when you need to keep tables in sync with one another, and NOT performance.

## Fastest option no batch

I’m sure about now you’re wondering what the fastest way to load data is, allow the distributed nature of Cassandra to work for you and distribute the writes to the optimal destination. The following code will lead to not only the fastest loads (assuming different partitions are being updated), but it’ll cause the least load on the cluster. If you add retry logic you’ll only retry that one mutation while the rest are fired off.

For code samples go [read the article I mentioned above.](https://lostechies.com/ryansvihla/?p=334)