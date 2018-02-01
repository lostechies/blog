---
id: 108
title: Buffer Cache Makes Slow Disks Seem Fast, Till You Need Them.
date: 2014-04-20T15:39:29+00:00
author: Ryan Svihla
layout: post
guid: http://lostechies.com/ryansvihla/?p=108
dsq_thread_id:
  - "2626355770"
categories:
  - Sysadmin
tags:
  - Buffer Cache
  - Disk IO
  - Linux
---
Linux has this wonderful thing called the buffer cache (for more detail read [here](http://www.tldp.org/LDP/sag/html/buffer-cache.html) ). In summary, it uses all your free ram as a cache for file access. Because of buffer cache you can easily get under 1 millisecond response times.

However, this sets a lot of people up for a trap. Imagine you buy a “database server” with a 5400RPM hard disk at Best Buy, while you’re there you pick up an extra 8 gigs of RAM. After loading the latest Ubuntu and restoring a 1 gig customer database backup. You check to see how much RAM you’re using and you have 2 gigs free. You test the new server out and records are coming off that server at an unbelievable speed, your happy, your boss is happy, you look like a genius.

Later that month your company acquires a new firm, you write a script to load their 3 gigs worth of customer data into your same customer database. The next thing you know your server is **behind**, your website is timing out, your data takes forever to come back, but when you go to access a common page you use for testing the responses are instant. What gives?

Before your files were all getting accessed in RAM effectively, maybe on initial restart of the server things were slow, but eventually all data was stored in RAM and the workload of the computer never exceeded the latencies provided by RAM, once you could only cache part of your frequently accessed data you entered a weird world where some data is coming back in 1 millisecond and some data is coming back in 2 seconds, because the disk is never able to catch up, nor normally would have been able to catch up under normal workloads if you had no buffer cache. However, you’ve never encountered this scenario previously so you never realized your server could never hope to keep up without having a ton of RAM to throw at the problem. You call your original Linux mentor and he has you go buy some good SSDs, install them in your server and once you restore from backup everything is running fine, not as fast as before but no one can tell the difference. Why the big difference?

**Because the buffer cache was hiding the bad disk configuration from the get go**, and once that little 5400 RPM hard disk had to get some real work done it quickly fell behind and was never able to catch up.

This happens more frequently than you’d think and I’ve seen people who are super happy with their 6 figure SANs until they have an application that exceeds their buffer cache and they quickly find to their horror, their expensive SAN is really terrible for latency sensitive workloads which most databases are ( a good background lesson on the importance of latency is [here](http://recoverymonkey.org/2012/07/26/an-explanation-of-iops-and-latency/)).

The lesson here is if you ever want to benchmark how a system will do at times of stress, start with a dataset that you can’t fit into buffer cache so you’ll know how it performs when using the disk directly.