---
wordpress_id: 318
title: CASSANDRA LOCAL_QUORUM SHOULD STAY LOCAL
date: 2016-04-21T07:45:10+00:00
author: Ryan Svihla
layout: post
wordpress_guid: https://lostechies.com/ryansvihla/?p=318
dsq_thread_id:
  - "4765168114"
categories:
  - Cassandra
---
<p id="0479">
  A couple of times a week I get a question where someone wants to know how to “failover” to a remote DC in the driver if the local Cassandra DC fails or even if there is only a couple of nodes in the local data center that are down.
</p>

<p id="32eb">
  Frequently the customer is using LOCAL_QUORUM or LOCAL_ONE at our suggestion to pin all reads and writes to the local data center often times at their request to help with p99 latencies. But now they want the driver to “do the right thing” and start using replicas in another data center when there is a local outage.
</p>

## Here is how (but you DO NOT WANT TO DO THIS) {#hereishowbutyoudonotwanttodothis}

[gist id=ce907d1d53a9a3735ecdccffa2a44516]

However you may end up with more than you bargained for.

![failed](http://i.imgur.com/isSMZbs.jpg)failed

## Here is why you DO NOT WANT TO DO THIS {#hereiswhyyoudonotwanttodothis}

### Intended case is stupidly rare {#intendedcaseisstupidlyrare}

The common case I hear is “my local Cassandra DC has failed” Ok stop..so your app servers in the SAME DATACENTER are up but your Cassandra nodes are all down.

I’ve got news for you, if all your local Cassandra nodes are down one of the following has happened:

  1. The entire datacenter is down including your app servers that are supposed to be handling this failover via the LoadBalancingPolicy
  2. There is something seriously wrong in your data model that is knocking all the nodes off line, if you send this traffic to another data center it will also go off line (assuming you have the bandwidth to get the queries through)
  3. You’ve created a SPOF in your deployment for Cassandra using SAN or some other infrastructure mistake..don’t do this

So on the off hand that by dumb luck or just neglect you hit this scenario, then sure go for it, but it’s not going to be free (I cover this later on so keep reading).

### Common failure cases aren’t helped {#commonfailurecasesaren’thelped}

A badly thought out and unproven data model is the most common reason outside of SAN I see widespread issues with a cluster or data center, failover at a datacenter level will not help you in either case here.

### Failure is often transient {#failureisoftentransient}

More often you may have a brief problem where a couple of nodes are having a problem. Say one expensive query happened right before, or you restarted a node, or you made a simple configuration change. Do you want your queries bleeding out to the other data center because of a very short term hiccup? Instead you could have had just retried the query one more time, the local nodes would have responded before the remote data center had time to receive the query.

TLDR More often than not the correct behavior is just to retry in the local data center.

### Application SLAs are not considered {#applicationslasarenotconsidered}

Electrons only move so fast, and if you have 300 ms latency between your London and Texas data centers, while your application has a 100ms SLA for all queries, you’re still basically “down”.

### Available bandwidth is not considered {#availablebandwidthisnotconsidered}

Now lets say the default latency is fine, how fat is that pipe? Often on long links companies go cheap and stay in the sub 100mb range. This can barely keep up with replication traffic from Cassandra for most use cases let alone shifting all queries over. That 300ms latency will soon climb to 1 second or eventually just out and out failure as the pipe totally jams full. So you’re still down.

### Operational overhead of the “failed to” data center are not considered {#operationaloverheadofthe“failedto”datacenterarenotconsidered}

I’ve mentioned this in passing a few times, but lets say you have fast enough pipes, can your secondary data center handle not only it’s local traffic but also the new ‘failover’ traffic coming in? If you’ve not allowed for that operational overhead you maybe taking down all data centers one at a time until there is none remaining.

### Intended consistency is not met {#intendedconsistencyisnotmet}

Now lets say you have operational overhead, latency and bandwidth overhead to connect to that remote data center HUZZAH RIGHT!

Say your app is using LOCAL_QUORUM. This implies something about your consistency needs AKA you need your model to be relatively consistent. Now if you recall above I’ve mentioned that most failures in practice are transient and not permanent.

So what happens in the following scenario?

  * Node A and B are down restarting because a new admin got overzealous.
  * A write logging a user’s purchase is destined for A and B in DC1 instead go to their partners in DC2 and the write quietly completes successfully in the remote dc.
  * Node A and B and DC1 start responding but do not yet have the write from DC2 propagated back to them.
  * The user goes back to read his purchase history which goes to nodes A and B but no does not yet have it.

Now all of this happened without an error and the application server had no idea it should retry. I’ve now defeated the point of LOCAL_QUORUM and I’m effectively using consistency level of TWO without realizing it

## What should you do? {#whatshouldyoudo}

Same thing you were before. Use technology like Eureka, F5, whatever customer solution you have or want to use.

I think there is some confusion in terminology here, Cassandra data centers are boundaries to lock in queries and by extension provide some consistency guarantee (some of you will be confused by this statement but it’s a blog post unto itself so save that for another time) and potentially to pin some administrative operations to a set of nodes. However, new users expect the Cassandra data center to be a driver level failover zone.

If you need queries to go beyond a data center then use the classic QUORUM consistency level or something like SERIAL, it’s globally honest and provides consistency at a cluster level in exchange for latency hits in the process, but you’ll get the right answer more often than not that way (SERIAL especially as it takes into account race conditions)

So lets step through the above scenarios:

  * Transient failure. Retry is probably faster.
  * SLAs are met or the query can just fail at least on the Cassandra side. If you swap at the load balancer level to a distant data center the customer may not have a great experience still, but dependent queries won’t stack up.
  * Inter DC bandwidth is largely unaffected.
  * Application consistency is maintained.

One scenario that still isn’t handled is having adequate capacity in the downstream data centers. But it’s still something you have to think about either way. On the whole uptime and customer experience are way better with failing over using a dedicated load balancer than trying to do Multidc failover with the Cassandra client.

## So is there any case I can use allowRemoteHosts? {#soisthereanycaseicanuseallowremotehosts}

Of course but you have to have the following conditions:

  1. Enough operational overhead to handle application servers from multiple data centers talking to a single Cassandra data center
  2. Enough inter DC bandwidth to support all those app servers talking across the pipe
  3. High enough SLAs or data centers close enough to hit SLA still,
  4. Weak consistency needs but a preference for more consistency than what ONE would give you
  5. Prefer local nodes to remote ones still even though you have enough load, bandwidth and low enough latency to handle all of these queries from any data center.

Basically the use of this feature is EXTRAORDINARILY minimal and at best only gives you a minor benefit over just using a consistency level of TWO.