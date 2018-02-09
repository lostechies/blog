---
wordpress_id: 272
title: Synthetic Sharding with Cassandra. Or How To Deal With Large Partitions.
date: 2016-03-15T08:40:47+00:00
author: Ryan Svihla
layout: post
wordpress_guid: https://lostechies.com/ryansvihla/?p=272
dsq_thread_id:
  - "4720443444"
categories:
  - Cassandra
tags:
  - Cassandra
---
<div>
  <p id="67ee">
    Extremely overdue that I write this down as it’s a common problem, and really applies to any database that needs to scale horizontally, not just Cassandra.
  </p>
  
  <h4 id="8e61">
    Problem Statement
  </h4>
  
  <p id="c539">
    Good partition keys are not always obvious, and it’s easy to create a bad one.
  </p>
  
  <h4 id="18b9">
    Defining A Bad Partition
  </h4>
  
  <ol>
    <li id="d027">
      Uneven Access. Read OR write count is more than 2x different from one partition to another. This is a purist view and some of you using time series are screaming at me right now, but set that aside, I’ll have another blog post for you, but if you’re new to Cassandra consider it a good principle and goal to aim for.
    </li>
    <li id="61ed">
      Uneven Size. Same as above really you can run cfhistograms and if you see really tiny or empty partitions next to really large ones or ones with really high cell count, you are at least on ingest uneven. I would shoot for within an order of magnitude or two. If you’re smart enough to tell me why I’m wrong here that’s fine, I’m not gonna care, but if you’re new to Cassandra this is a good goal.
    </li>
    <li id="ef36">
      Too Many Cells. The partition cell count for a given partition is over 100k (run cfhistograms to get these numbers). This is entirely a rule of thumb and varies amazingly between hardware, tuning and column names (length matters). You may find you can add more and not hit a problem and you may find you can’t get near this. If you want to be exacting you should test.
    </li>
    <li id="2e64">
      Too Large. Your partition size is over 32mb (also in cfhisograms). This also varies like cell count. Some people tell me this matters less now (as of 2.1), and they run a lot larger. However, I’ve seen it cause problems on a number of clusters. I repeat as a new user this is a good number to shoot for, once you’re advanced enough to tell me why I’m wrong you may ignore this rule. Again you should test your cluster to get the number where things get problematic.
    </li>
  </ol>
  
  <h4 id="ad33">
    Options if you have a bad partition
  </h4>
  
  <ol>
    <li id="1f72">
      Pick a better partition key (read <a href="http://www.datastax.com/dev/blog/basic-rules-of-cassandra-data-modeling" rel="nofollow" data-href="http://www.datastax.com/dev/blog/basic-rules-of-cassandra-data-modeling">http://www.datastax.com/dev/blog/basic-rules-of-cassandra-data-modeling</a>).
    </li>
    <li id="32f4">
      Give up and use Synthetic Sharding.
    </li>
    <li id="bfd5">
      Pretend it’s not a problem and find out the hard way that it really is, usually this is at 3 am.
    </li>
  </ol>
  
  <h4 id="c16b">
    Synthetic Sharding Strategy: Shard Table
  </h4>
  
  <p id="ab05">
    Pros
  </p>
  
  <ul>
    <li id="1c7f">
      Always works.
    </li>
    <li id="a7b6">
      Easy to parallelize (can be writing to shards in parallel).
    </li>
    <li id="8f7f">
      Very very common and therefore battle tested.
    </li>
  </ul>
  
  <p id="0822">
    Cons
  </p>
  
  <ul>
    <li id="8451">
      May have to do shards of shards for particularly large partitions.
    </li>
    <li id="4f29">
      Hard for new users to understand.
    </li>
    <li id="3fce">
      Hard to use in low latency use cases (but so are REALLY large partitions, so it’s a problem either way).
    </li>
  </ul>
  
  <p id="e7d3">
    Example Idea
  </p>
  
  <p>
    {% gist a005e83ba01f1d2ea5107280da166317 %}
  </p>
  
  <h4 id="a449">
    Synthetic Sharding Strategy: Shard Count Static Column
  </h4>
  
  <p id="dda2">
    Pros
  </p>
  
  <ul>
    <li id="a29a">
      No separate shard table.
    </li>
    <li id="25fb">
      No shards of shards problem
    </li>
    <li id="6bad">
      2x faster to read when there is a single shard than the shard table option.
    </li>
    <li id="19f6">
      Still faster even when there is more more than a single shard than the shard table option.
    </li>
  </ul>
  
  <p id="95a9">
    Cons
  </p>
  
  <ul>
    <li id="2776">
      Maybe even harder for new users since it’s a little bit of a surprise.
    </li>
    <li id="59cf">
      Harder to load concurrently.
    </li>
    <li id="077b">
      I don’t see this in wide use.
    </li>
  </ul>
  
  <p id="5083">
    Example Idea
  </p>
  
  <p>
    {% gist 20c24423c17c7fb0b8d3dfdd2f6f0047 %}
  </p>
  
  <h4 id="d981">
    Synthetic Sharding Strategy: Known Shard Count
  </h4>
  
  <p id="7b42">
    Pros
  </p>
  
  <ul>
    <li id="a869">
      No separate shard table.
    </li>
    <li id="2e21">
      No shards of shards problem
    </li>
    <li id="76fc">
      Not as fast as static column shard count option when only a single shard.
    </li>
    <li id="76b6">
      Easy to grasp once the rule is explained.
    </li>
    <li id="9d27">
      Can easily abstract the shards away (if you always query for example 5 shards, then this can be a series of queries added to a library).
    </li>
    <li id="13a4">
      Useful when you just want to shrink the overall size of the partitions by a set order of magnitude, but don’t care so much about making sure the shards are even.
    </li>
    <li id="2070">
      Can use random shard selection and probably call it ‘good enough’
    </li>
    <li id="5b04">
      Can even use a for loop on ingest (and on read).
    </li>
  </ul>
  
  <p id="52c4">
    Cons
  </p>
  
  <ul>
    <li id="0f2e">
      I don’t see this in wide use.
    </li>
    <li id="19c0">
      Shard selection has to be somewhat thoughtful.
    </li>
  </ul>
  
  <p id="6a21">
    Example Idea
  </p>
  
  <p>
    {% gist cb09e4162e552199e17f3c7caee607c6 %}
  </p>
  
  <h4 id="d47a">
    Appendix: Java Example For Async
  </h4>
  
  <p id="1eb3">
    A lot of folks seem to struggle with async queries. So for example using an integer style of shards this would just be a very simple:
  </p>
  
  <p>
    {% gist 4821f86b6d9d248b550a5d7539e739ac %}
  </p>
</div>

<div>
</div>