---
wordpress_id: 461
title: Not an April Fool’s post
date: 2011-04-01T12:42:14+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/04/01/not-an-april-fools-post/
dsq_thread_id:
  - "268397023"
categories:
  - Design
---
Today I plan on writing a stored procedure. Not because I’m being forced to, but because the problem, as far as I can determine, requires a set-based solution. It’s a once-a-month process, doing bulk import, update and export of up to a million records, and it all needs to be completed within an hour or so. 

There are some problems that simply work better using a set-based approach. As long as I have tests around the process, I don’t really have a problem creating a solution in SQL. I could try to use some of NHibernate’s DML capabilities, but frankly, they aren’t close to touching SQL’s featureset.

I think I’ve too often ditched previous approaches to how I’ve done software development in search of the One True Way, instead of evaluating when certain approaches work well, where they don’t, and choosing the best fit for the problem space.