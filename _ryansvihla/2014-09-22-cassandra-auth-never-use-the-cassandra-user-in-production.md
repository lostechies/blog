---
id: 143
title: 'Cassandra Auth: Never use the cassandra user in production!'
date: 2014-09-22T08:42:34+00:00
author: Ryan Svihla
layout: post
guid: http://lostechies.com/ryansvihla/?p=143
dsq_thread_id:
  - "3042604396"
categories:
  - Cassandra
tags:
  - Cassandra
---
Normal best practice for security with applications is never to use the default admin user. In Sql Server this is manifested by the recommendation not to use the “sa” user. Likewise in Cassandra the default Cassandra user has full rights to all tables and operations. This is needless to say bad security from an application design perspective, but there is yet another consideration that I see people in larger organizations run into, performance & availability.

## QUORUM versus LOCAL_ONE

The default cassandra username is a special case for authentication, since it’s used to modify initial [user permissions uses QUORUM consistency when logging in](https://issues.apache.org/jira/browse/CASSANDRA-5310). In a production use case this has important performance implication for multiple data center scenarios (hereafter referered to as MDC) which means if you have 3 data centers, all with system_auth set to a replication factor of 3 (or 9 replicas total), QUORUM consistency will query 6 nodes, some of which going over high latency network links! Worse, if you were to lose 1 data center and 1 other node, you’d be unable to login! 

This is why for all other users besides the default cassandra user, logins are performed with LOCAL_ONE consistency. Which means as long as a single local replica of that user is available login can succeed.

## Takeways

For security and performance reasons always for production apps do the following

  1. Create a new user for a given application to login
  2. Restrict rights of user as appropriate for security, don&#8217;t allow access to other keyspaces for example.
  3. For good measure create a new superuser and use this for backup in multi-dc scenarios where you have an outage in the remote data center.