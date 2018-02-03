---
wordpress_id: 44
title: MySQL 5 Performance Tuning Toolkit
date: 2010-07-02T02:57:00+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2010/07/01/mysql-5-performance-tuning-toolkit.aspx
dsq_thread_id:
  - "1070352376"
categories:
  - MySQL
---
Recently we’d played with table partitioning and because of the limitations of it and some decisions we’d made a very long time ago we ended up spending a couple of days tracking down hotspots. In the process I picked up a few tricks, I’m not even an authority on any of this but I figured it’d help out others in the same spot.

### Logging Toolkit

If you have a slow loading page or test and have no idea which one of the thirty or so queries going on is the cause how to do you find it.&#160; Slow query log and logging queries that are not using indexes. Adding the following to your my.ini, my.cnf or whatever your mysql config file is named on your system and you’ll be able to get a list of offenders to further investigate.

### MySQL Console Toolkit

SHOW INNODB STATUS – gives tons of useful information on what the current state of deadlocks, transactions and all sorts of information.

SHOW FULL PROCESSLIST – shows the current threads and queries running on them. running this over and over again can show you queries that are hanging.

EXPLAIN <QUERY>– Just in place of query type your full query statement, particularly in sub-queries, this is great for pointing out potential problems, in my most recent case I had an uncacheable sub-query, pointing out quickly something that was just not going to work no matter what. 

### 

### Final Notes

Anyway this is only a smidgen of the useful stuff you need in your toolkit and I’m certainly no expert. I want to plug [High Performance MySQL: Optimization, Backups, Replication, and More](http://www.amazon.com/gp/product/0596101716/ref=s9_simh_gw_p14_i1?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=center-http://www.amazon.com/High-Performance-MySQL-Optimization-Replication/dp/0596101716/ref=pd_sim_b_1) and the <http://www.mysqlperformanceblog.com/> for it’s help and as a reference for those wanting to go into deeper study.