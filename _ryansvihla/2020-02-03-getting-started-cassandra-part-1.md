---
title: 'Getting started with Cassandra: Setting up a Multi-DC environment'
date: 2020-02-03T20:23:00+00:00
author: Ryan Svihla
layout: post
categories:
  - cassandra
---
# Getting started with Cassandra: Setting up a Multi-DC environment

This is a quick and dirty opinionated guide to setting up a Cassandra cluster with multiple data centers.

## A new cluster

* In cassandra.yaml set `endpoint_snitch: GossipingPropertyFileSnitch`, some prefer PropertyFileSnitch for the ease of pushing out one file. GossipingPropertyFileSnitch is harder to get wrong in my experience.
* set dc in cassandra-rackdc.properties. Set to be whatever dc you want that node to be in. Ignore rack until you really need it, 8/10 people that use racks do it wrong the first time, and it's slightly painful to unwind.
* finish adding all of your nodes.
* if using authentication,  set `system_auth` keyspace to use NetworkTopologyStrategy in cqlsh with RF 3 (or == number of replicas if less than 3 per dc) for each datacenter you've created `ALTER KEYSPACE system_auth WITH REPLICATION= {'class' : 'NetworkTopologyStrategy', 'data_center_name' : 3, 'data_center_name' : 3};`, run repair after changing RF
* `nodetool repair -pr system_auth` on each node in the cluster on the new keyspace.
* create your new keyspaces for your app with RF 3 in each dc (much like you did for the `system_auth` step above).
* `nodetool repair -pr whatever_new_keyspace` on each node in the cluster on the new keyspace.

## An existing cluster

This is harder and involves more work and more options, but I'm going to discuss the way that gets you into the least amount of trouble operationally.

* make sure _none_ of the drivers you use to connect to cassnadra are using DowngradingConsistencyRetryPolicy, or using the maligned withUsedHostsPerRemoteDc, especially allowRemoteDCsForLocalConsistencyLevel, as this may cause your driver to send requests to the remote data center before it's populated with data.
* switch `endpoint_snitch` on each node to GossipingPropertyFileSnitch
* set dc in cassandra-rackdc.properties. Set to be whatever dc you want that node to be in. Ignore rack until you really need it, 8/10 people that use racks do it wrong the first time, and it's slightly painful to unwind.
* bootstrap each node in the new data center.
* if using authentication,  set `system_auth` keyspace to use NetworkTopologyStrategy in cqlsh with RF 3 (or == number of replicas if less than 3 per dc) for each datacenter you've created `ALTER KEYSPACE system_auth WITH REPLICATION= {'class' : 'NetworkTopologyStrategy', 'data_center_name' : 3, 'data_center_name' : 3};`, run repair after changing RF
* `nodetool repair -pr system_auth` on each node in the cluster on the new keyspace.
* alter your app keyspaces for your app with RF 3 in each dc (much like you did for the `system_auth` step above), 
* `nodetool repair -pr whatever_keyspace` on each node in the cluster on the new keyspace.

enjoy new data center

### how to get data to new dc

#### Repair approach

Best done with if your repair jobs can't be missed or stopped, either because you have a process like opscenter or repear running repairs. It also has the advantage of being very easy, and if you've already automated repair you're basically done.

* let repair jobs continue..that's it!

#### Rebuild approach

Faster less resource intensive, and if you have enough time to complete it while repair is stopped. Rebuild is easier to 'resume' than repair in many ways, so this has a number of advantages.

* run `nodetool rebuild` on each node in the new dc only, if it dies for some reason, rerunning the command will resume the process.
* run `nodetool cleanup`

#### YOLO rebuild with repair

This will probably overstream it's share of data and honestly a lot of folks do this for some reason in practice:

* leave repair jobs running
* run `nodetool rebuild` on each node in the new dc only, if it dies for some reason, rerunning the command will resume the process.
* run `nodetool cleanup` on each node

## Cloud strategies

There are a few valid approaches to this and none of them are wrong IMO.

### region == DC, rack == AZ

Will need to get into racks and a lot of people get this wrong and imbalance the racks, but you get the advantage of more intelligent failure modes, with racks mapping to AZs.

### AZ..regardless of region == DC

This allows things to be balanced easily, but you have no good option for racks then. However, some people think racks are overated, and I'd say a majority of clusters run with one rack.
