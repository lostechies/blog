---
wordpress_id: 259
title: Cassandra’s “Repair” Should Be Called “Required Maintenance”
date: 2015-09-25T11:38:37+00:00
author: Ryan Svihla
layout: post
wordpress_guid: https://lostechies.com/ryansvihla/?p=259
dsq_thread_id:
  - "4165347837"
categories:
  - Cassandra
tags:
  - Cassandra
  - cassandra repair
---
<p id="f577">
  <span style="font-size: 16px;">One of the bigger challenges when you go Eventually Consistent is how to reconcile data not being replicated. This happens if your using Oracle and multi-data centers with tech like Golden Gate and it happens if you’re using async replicas with MySQL and one of your replicas got out of whack. You need a way to “repair” the lost data.</span>
</p>

<p id="c3fa">
  Since Cassandra fully embraces eventually consistency repair is actually a important mechanism for making sure copies of data are shipped around the cluster to meet your specified replication factor. About now several of you have alarm bells going off and think I’m insane. Let’s step through the common objections I hear.
</p>

## What about Consistency Level? {#c682}

<p id="6d28">
  Consistency Level (from here on out CL) does effectively define your contract for how many replicas you are requiring to be ‘successful’ but that’s at write time and unless you’re doing something silly like CL ALL, you can’t be certain that you’ve got RF (replication factor) copies around the cluster. Say you’re using CL ONE for all reads and writes then that means you’re only set on having one copy of the data. This means you can lose data if that node goes down.
</p>

<p id="b1e9">
  So either write at CL ALL or use repair to make sure your cluster is spending most of it’s time at your specified RF.
</p>

## What about hinted handoffs? {#37e7}

<p id="37fc">
  They’re great, except <a href="http://www.datastax.com/dev/blog/whats-coming-to-cassandra-in-3-0-improved-hint-storage-and-delivery" rel="nofollow" data-href="http://www.datastax.com/dev/blog/whats-coming-to-cassandra-in-3-0-improved-hint-storage-and-delivery">until Cassandra 3.0 they’re not really that great</a>. Hinted Handoffs for those of you that don’t know are written on a failed write by a coordinator to a remote node. These hints are replayed later on in a separate process.
</p>

<p id="142c">
  This helps eliminate the need for repair in theory. In practice they only last a relatively short window (3 hours by default) and generating a lot of them can be a huge resource hog for the system (3.0 should help greatly with this). I’ve worked on clusters with extended outages accross data centers are very high TPS rates resulted in terabytes of just hints in the cluster.
</p>

<p id="554f">
  In summary, hints are at best a temporary fix. If you have any extended outage then repair is your friend.
</p>

## Beware Deletes If You’re Too Cool For Repair {#d5bd}

<p id="6b14">
  Another important aspect of repair is when you think about tombstones. Say I issue a delete to two nodes but it only succeeds on one. My data will look like so:
</p>

[<img class="alignnone size-full wp-image-263" title="tombstone_repair_after_gc_grace_seconds" src="/content/ryansvihla/uploads/2015/09/tombstone_repair_after_gc_grace_seconds.png" alt="" width="477" height="495" srcset="/content/ryansvihla/uploads/2015/09/tombstone_repair_after_gc_grace_seconds.png 477w, /content/ryansvihla/uploads/2015/09/tombstone_repair_after_gc_grace_seconds-289x300.png 289w" sizes="(max-width: 477px) 100vw, 477px" />](/content/ryansvihla/uploads/2015/09/tombstone_repair_after_gc_grace_seconds.png)

<div>
  <div>
    <span style="font-size: 16px;">However a few hours later compaction on that node removes the first write on node 2. Fear now when I query ttl comparison will give me the right answer and partition 1 has no last_name value.</span>
  </div>
</div>

<div>
  <div>
  </div>
  
  <p>
    <a href="/content/ryansvihla/uploads/2015/09/tombstone_repair_after_compaction.png"><img class="alignnone size-full wp-image-262" title="tombstone_repair_after_compaction" src="/content/ryansvihla/uploads/2015/09/tombstone_repair_after_compaction.png" alt="" width="692" height="495" /></a>
  </p>
</div>

<p id="cb50">
  However, when I go past gc_grace_seconds (default 10 days) that tombstone will be removed. Since I’ve never run repair (and I’m assuming I don’t have read repair to save me), I now only have partition 1 on node 1 and my deleted data comes back from the dead.
</p>

<div>
  <div>
     <a href="/content/ryansvihla/uploads/2015/09/tombstone_repair.png"><img class="alignnone size-full wp-image-261" title="tombstone_repair" src="/content/ryansvihla/uploads/2015/09/tombstone_repair.png" alt="" width="692" height="288" /></a>
  </div>
</div>

## Summary Run Repair {#3e3c}

<p id="7af8">
  So for most use cases you’ll see, you’ll really want to run repair on each node within gc_grace_seconds and I advise really running repair more frequently than that if you use CL one and use deletes or lots of updates to the same value.
</p>

<p id="14b9">
  I’ll add the one use case where repair has less importance. If you just do single writes with no updates, local_quorum consistency level, have a single data center and rely on TTLs to delete your data, you can probably not run repair until you find a need to do so such as a lost node.
</p>