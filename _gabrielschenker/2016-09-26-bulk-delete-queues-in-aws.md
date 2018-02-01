---
id: 1735
title: Bulk Delete Queues in AWS
date: 2016-09-26T08:13:56+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1735
dsq_thread_id:
  - "5174711955"
categories:
  - AWS
  - How To
tags:
  - AWS
  - script
  - SQS
---
This is a post to myself. Due to a faulty application we have a lot of dead queues in AWS SQS. To get rid of them I wrote the following script that I executed in a container that has the AWS CLI installed

[gist id=fa08cb31c1a968d9570777dd22f01d62]

The script is quick and dirty and deals with the fact that the AWS CLI returns the list of queues as a JSON array.