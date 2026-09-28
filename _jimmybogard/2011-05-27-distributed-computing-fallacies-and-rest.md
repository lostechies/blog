---
wordpress_id: 494
title: Distributed computing fallacies and REST
date: 2011-05-27T13:34:59+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/05/27/distributed-computing-fallacies-and-rest/
dsq_thread_id:
  - "315283800"
categories:
  - Architecture
  - DistributedSystems
---
One item to keep in mind when investigating consuming or exposing REST APIs are the [fallacies of distributed computing](http://en.wikipedia.org/wiki/Fallacies_of_Distributed_Computing):

  1. The [network](http://en.wikipedia.org/wiki/Computer_network) is reliable. 
      * [Latency](http://en.wikipedia.org/wiki/Latency_(engineering)) is zero. 
          * [Bandwidth](http://en.wikipedia.org/wiki/Throughput) is infinite. 
              * The network is [secure](http://en.wikipedia.org/wiki/Computer_security). 
                  * [Topology](http://en.wikipedia.org/wiki/Network_topology) doesn&#8217;t change. 
                      * There is one [administrator](http://en.wikipedia.org/wiki/Network_administrator). 
                          * Transport cost is zero. 
                              * The network is homogeneous.</ol> 
                            If you’re consuming a REST API that you don’t own, or are exposing a REST API to other systems that you don’t own, in either case the distributed computing fallacies still apply. The one I see lost the most is #1 – that the network is reliable.
                            
                            If I’m relying on a 3rd party REST service to be “up”, and my business depends on that other side being up, I better have some sort of mitigation plan other than an error page for a user. You might be able to have higher bars if you own both sides of the equation, but when you don’t?
                            
                            Instead of looking at things in terms of “IF”, think instead in terms of “WHEN”. WHEN the other side is not available, how can I still provide a viable experience for the end user? Does their experience require the other side to be up, or can I look at concepts such as [Eventual Consistency](http://www.allthingsdistributed.com/2008/12/eventually_consistent.html) and [Asynchronous Messaging](http://www.eaipatterns.com/Messaging.html) to improve their experience (and improve scalability/reliability)? Have I looked at the coupling of my system to others, in terms of [Temporal and Behavioral coupling](http://iansrobinson.com/2009/04/27/temporal-and-behavioural-coupling/)?
                            
                            If I’m building mashups of multiple systems to quickly build something of potential interest, perhaps these issues aren’t necessary to look at yet. But if I’m building business-critical applications and my ability to serve customers depends on 3rd party REST APIs, I should probably revisit the above problems.
                            
                            In my systems that interact with 3rd party REST APIs, it’s pretty straightforward. Each read caches data locally, and each write is wrapped in an NServiceBus message. I can scale out very easily and am able to mitigate many of the distributed computing fallacies.
                            
                            If I’m going to expose to a 3rd party a REST API for a business-critical system, and they’re not able to mitigate these issues, it’s almost better NOT to expose an API directly and instead go through other implicitly asynchronous models, such as [straight-up FTP file drops](http://www.eaipatterns.com/FileTransferIntegration.html). It’s not ideal, but if the 3rd party doesn’t know how to integrate to a REST API and not complain when I take the server down for maintenance, then I go the file drop route.
                            
                            It’s better at that point to pick an integration strategy that accidentally addresses the distributed computing fallacies than one that 3rd parties don’t know how to address.