---
wordpress_id: 511
title: MSMQ and cached DNS
date: 2011-08-18T12:19:54+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/08/18/msmq-and-cached-dns/
dsq_thread_id:
  - "389560790"
categories:
  - NServiceBus
---
A couple of weeks ago, one of our hosting providers switched a number of our hosted servers from DHCP to use NAT internally, but kept the same external IP addresses. Evidently we had exhausted the IPv4 addresses internally, and a new server we were bringing online forced a change. 

Our systems were minimally affected, and the only real change was in our DB connection strings. I deployed a change for all of our services to use machine names instead of IP addresses, so that the DB connection strings wouldn&#8217;t know the difference, and DNS would do the rest. Trying to resolve the external IP address internally would fail, so machine names and DNS should do what it&#8217;s supposed to do. 

Our NServiceBus configuration was already like that, using the &#8220;queuename@machinename&#8221; notation. It turns out that when the internal IP addresses changed, our DB connections worked, but P2P MSMQ connections failed, causing thousands of messages to stack up in outgoing queues. The outgoing queue had a status of “Waiting to connect”, but reported no other errors. My only clue was that the “Next hop” showed the incorrect _external_ IP address. 

The issue was that [MSMQ actually caches IP addresses for resolved machine names](http://blogs.msdn.com/b/johnbreakwell/archive/2007/02/06/msmq-prefers-to-be-unique.aspx), and it was caching the incorrect IP address&#8230;on the recipient machine. The recipient machine was rejecting connections from the sender, which could only be confirmed by observing raw TCP traffic using [WireShark](http://www.wireshark.org/). The recipient machine was listening to traffic on the incorrect IP address, which I also confirmed using &#8220;[netstat -anb](http://technet.microsoft.com/en-us/library/bb490947.aspx)&#8220;. 

The resolution was to **restart the MSMQ service on both the sender and the receiver machines**. That really flushed the cached DNS, and messages went through (ipconfig /flushdns did nothing). 

So just an ops lesson in MSMQ kiddies, if your internal IP addresses change on your servers, just DNS alone is not enough to protect against connection failures.