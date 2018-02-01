---
id: 1372
title: Zero Downtime
date: 2016-04-16T16:59:54+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1372
dsq_thread_id:
  - "4752809513"
categories:
  - Architecture
  - CI/CD
  - Micro services
  - Patterns
  - practices
---
# Introduction

This post is part of my series about [Implementing a CI/CD pipeline](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/). Please refer to [this](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/) post for an introduction and a complete table of contents. First of all we need to distinguish the types of applications that we will look at. Let&#8217;s separate them into these two: a) monolithic applications and b) highly distributed (e.g. [micro service based](https://lostechies.com/gabrielschenker/2016/01/23/micro-service-based-architecture/)) applications.

# Monolithic Applications

From a [DevOps](https://en.wikipedia.org/wiki/DevOps) or an operations perspective a monolithic application is often easier to deal with than a distributed application; it&#8217;s one single (big) application. Such an application runs on a single node (here a **node** can be either a physical server, a VM or even a container). The nice thing here is that it is quite easy to distinguish whether or not the application is up and running or down and unavailable. It either works or it doesn&#8217;t. This in contrast to a distributed application where individual pieces can be down or malfunctioning. Since an application can crash due to software bugs or due to overload and since the node on which the application runs can malfunction or crash we need to have a means to deal with it. Otherwise 100% availability of the application cannot be guaranteed. How can we achieve this? Well it is quite simple, we need to make our application redundant. Instead of running one instance of the application on a single node we can run multiple instances of the application on an equal number of nodes. We then &#8220;just&#8221; put a [load balancer](https://en.wikipedia.org/wiki/Load_balancing_%28computing%29) in front of these (say 3) nodes which distributes the traffic equally to the individual nodes. If one of the nodes dies then the load balancer will realize it and take this &#8211; now unhealthy or dead node &#8211; out of the list of target nodes. All the traffic is now routed to the remaining healthy nodes and we can take care are repair/restore the unhealthy node. One caveat that this technique implies is that the application should not store state on the node itself. State should always be stored in a data store (relational, no-sql, etc.) that is used by all instances of the application. If this cannot be achieved we need to work with e.g. a technique called [sticky sessions](http://wiki.metawerx.net/wiki/StickySessions).

# Distributed Applications

Distributed applications, as the name implies, run on many different nodes. That is, not all components or services that are part of the overall application run on a single node. Technically they can, but in practice they rarely do. Thus we have much more moving pieces in our puzzle. Whenever multiple parts have to contribute to the overall task at hand the likelihood of a problem occurring somewhere increases. In this scenario we do not only need to make sure one single node is up and running all the time to host our application but many nodes. Also the network between the many nodes needs to be stable so that the inter-component or inter-service communication can occur smoothly and efficiently. Not only does the network between the nodes need be stable but we also need to make sure that the available bandwidth remains sufficiently high and that the latency is small.

## The Infrastructure

The servers with their operating systems, network cables, routers, proxies, load balancers, storage systems, etc. we call **infrastructure**. We need infrastructure to run our application on top of it. We install software modules on servers and we communicate between the software modules using the network cables, routers, proxies etc.

### Nodes

A distributed applications is as the name implies running on more than 1 node. The likelihood that a node is failing due to a hardware problem is small but not zero. Servers or their CPUs can overheat and start to malfunction, hard disks can crash to name just a few reasons. If we have many nodes in our cluster then the probability of a failure linearly increases with the number of nodes. Thus if I run a cluster of 10 nodes it is about 10 times more likely that I will have a problem today, tomorrow or during the next month, etc, than if I only have one node at hand.

### Network

When an application is distributed and its components run on different nodes then we need a (physical) network to link the individual nodes. Logically each node needs to be connected with many other nodes in a spiderweb of connections. These connections can malfunction. Even if the likelihood of a malfunction of a single network connection is small then we still have the big number problem. The more connections we need the more likely we are affected by a malfunction &#8211; similar to what we discussed in the section about nodes.

### Latency

The time it takes to communicate between two components or services that are running on different nodes is dependent on the distance of the nodes. Signals in a network wire can travel no faster than the speed of light. That means that the farther away two components are located from each other the longer it takes them to communicate. Although the speed of light is very fast, it is still slow enough to have a noticeable effect on the communication. We have to consider this when we deploy the components of our applications. Ideally the nodes on which we run the application are located close to each other, e.g. in the same server rack or at least in the same building. Most of the time it is not advisable to distribute an application across multiple data centers or even multiple geographical regions. The time delay introduced in a communication is called [latency](https://en.wikipedia.org/wiki/Latency). High latency can lead to slow overall performance of the application. The total time for a request to execute not only depends on the performance of the services involved in the execution but also on the latency between the individual components. Thus even if it takes a service only say 10 ms seconds to perform the required task then if the latency between involved components is 100 ms we are at a total of 110 ms.

## The Application

Each component of a distributed application can potentially and most likely contain some bugs. These bugs can under certain circumstances cause the component to crash. With this the component becomes unavailable for all the other components of the application that rely on it. Under certain circumstances this can lead to a cascading failure of the whole system.

### Redundancy

To avoid an complete outage or severe degradation of the experience of an application due to the crashing of a single component or service we can instead run multiple instances of a given service. If one instance crashes the others can jump in and take on the workload instead. The application continues to work as expected. For this to work we need to decouple our components. Instead of service A being wired and communicating directly with a specific instance of service B we need to introduce some form of indirection. Service A needs to ask &#8220;someone&#8221; to connect it with an available and healthy instance of service B. Thus we have some kind of mediator in the middle. There are different ways of doing this. I will explain some of the techniques and patterns in later posts of this series.

### Auto Healing

If a service or component crashes we want the system to heal itself and recover from that crash. Either the component itself recovers from the crash (e.g. using an auto restart mechanism) or the system eliminates the crashed component and replaces it by a new instance. Please refer to my post about [Auto Healing](https://lostechies.com/gabrielschenker/2016/01/29/auto-healing/) for more details.

### Defensive Programming

If service A has successfully been connected with service B but service B crashes in the middle of the communication or becomes unresponsive then service A needs to be able to deal with this. It would not be wise to just let service A also crash. This is called a cascading failure and can ultimately bring down a whole distributed application. To avoid this scenario we need to code defensively. Service A needs to expect a possible failure of service B and deal gracefully with it. Probably we can introduce a timeout in the communication with service B and either just offer a degraded experience to the caller of service A or have service A try again to re-connect to a (different) instance of B.

# Summary

In this post I have discussed the implications of requiring zero downtime while running an application in production. This is mostly achieved by making every single piece of the software and the infrastructure on top of which the software is running redundant.