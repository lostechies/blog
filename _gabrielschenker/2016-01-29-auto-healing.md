---
id: 1185
title: Auto Healing
date: 2016-01-29T11:20:42+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1185
dsq_thread_id:
  - "4534300913"
categories:
  - Architecture
  - continuous deployment
  - Design
  - How To
  - introduction
  - Micro services
  - Patterns
---
# Introduction

This post is part of a series dedicated to the topic of building a fully automated delivery and/or deployment pipeline. Please refer to [this post](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/ "Implementing a CI/CD pipeline") for an introduction and the table of content.

In the following I am going to talk about auto healing and what this means in the context of an application based on the [micro service architecture](https://lostechies.com/gabrielschenker/2016/01/23/micro-service-based-architecture/ "Micro service based architecture").

# What is auto healing

In an application implemented using a micro service based architecture we have many components that contribute in some way to the overall functionality of the application. If we compare this to a monolithic application then the situation at run time is much more complex. A monolith is relatively simply to run in production. In the simplest case the monolith is either up and running or it is down and not available. We thus have a trivial on/off situation. This is easy to monitor and relatively easy to fix in case things go wrong and the monolith goes down due to e.g. a crash of the system. In this case we &#8220;only&#8221; have to restart the application on the same or maybe a different node.

_Yes, I am of course neglecting here that the downtime might still be significant and that it might take a while until the new instance of the monolith is up and running again. Often complex applications require a lengthy warm-up time. But this is not the point I want to discuss here. In this post we&#8217;re interested in the DevOps effort only to keep a system up an running all the time&#8230;_

A micro service based application on the other hand has many moving parts. They all need to play together nicely to guarantee correct behavior of the application. Where there are many parts involved the chance of failure increases. One or many components can malfunction or become unavailable almost at any time. And it is not only about code quality here; even if you have very robust code covered by many meaningful tests the system can still misbehave. There are a lot of elements involved which we as developers have no control over. Some of them are the network connections between the individual components; maybe the available bandwidth all of a sudden drops significantly or the connection totally drops. Where a monolith lives and runs on a single node, components of a micro service based application live on different nodes that are hosted on different physical boxes potentially separated by a significant physical distance. As we can see, all of a sudden latency becomes an important factor in our application. Not only the network connection between 2 components can drop, it is also very likely that a whole node of the cluster on which the application runs might go down. There are many more factors that might affect the health of our system. But since in production we need to be up and running all the time and since the system is so complex that manual intervention is unrealistic and very error prone we need to automate the healing of the system.

# How can we achieve auto healing

If we use service discovery as described in [this](https://lostechies.com/gabrielschenker/2016/01/27/service-discovery/ "Service discovery") post then we can use a registry service that not only keeps track of the network topology (i.e. where which components run and how they can be accessed) but also executes periodical health checks on each registered component. Typically this is an endpoint of the component that the registry service can ping at a predefined time interval. If the component that is checked does not respond in a timely manner then the registry service marks the component as critical. If the component does not recover for a long time and thus is not responding the registry service can even de-register the service completely. If a consumer queries the registry service for a list of available instance of a given service the registry service only returns information about those instances that are not critical at the time of inquiry. In such a way the consumer is not tempted to access an unhealthy or crashed instance.

<img class="alignleft  wp-image-1190" title="AutoHealing" src="https://lostechies.com/gabrielschenker/files/2016/01/AutoHealing.png" alt="" width="322" height="337" />

It is of course possible that although the registry service returns one instance it believes is healthy but when the consumer wants to access this instance it just crashed. We need to remember that the registry service only does health checks on each registered component say every 30 seconds or so. And in 30 seconds a lot of things can happen. Thus we still need to code defensively when accessing any external component &#8211; hope for best but expect the worst. We need to provide fallback mechanisms which allows us to provide a degraded experience when this happens. But this is a topic for a future post&#8230;

If the registry service realizes that one of its registered components is not responding it can trigger an action (e.g. run a script) that tries to deploy and run another instance of the failed component. If we use [Consul](http://www.consul.io) as our registry service then it offers this possibility of health checking and notifications in case of problems out of the box.

# Summary

A complex system consisting of many individual components that tolerates zero downtime needs to have the inherent ability to heal itself in case some components become unhealthy or go down completely. It is not possible to manage such a system manually and thus everything needs to be automated. The use of a registry service that is able to perform periodical health checks on all registered components and can trigger external actions in case failing components are discovered is an ideal solution to the problem. [Consul](http://www.consul.io) is a popular and wildly used OSS implementation of such a registry service.