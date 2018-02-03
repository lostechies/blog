---
wordpress_id: 443
title: Ditching domain models for reads
date: 2010-12-06T14:43:13+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/12/06/ditching-domain-models-for-reads.aspx
dsq_thread_id:
  - "264716650"
categories:
  - DomainDrivenDesign
  - NHibernate
---
Last week was a tipping point for me.&#160; We had an issue where a production service failed because NHibernate was trying to issue thousands of UPDATE calls for domain objects that we didn’t update.&#160; It turned out that we had added a new column for an entity, but did not fill this column with values for existing objects.&#160; When we loaded up these objects for a bulk export, NHibernate detected changes for these thousands of objects.

Needless to say, trying to issue thousands of UPDATE calls in a single transaction is a fantastic way to bring down the entire system.

NHibernate wasn’t doing anything wrong here.&#160; It was just the feature of automatic dirty checking doing its job.&#160; However, unless I actually _change_ something, I don’t really want to have anything updated.

In this case, the fix was to use the projection features of NHibernate to project into a DTO, so that a persistent, tracked entity never enters into the mix.&#160; There are exceptions to this rule, as some entities like configuration or persistent metadata are just plain CRUD objects. 

But unless I intend to change an entity by processing a command, it seems to make more and more sense to separate the read and write concerns architecturally through techniques like projection, bypassing the need to load up an entity if I’m not actually intending to change it.