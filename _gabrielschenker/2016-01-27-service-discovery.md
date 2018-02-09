---
wordpress_id: 1163
title: 'Service discovery &#8211; part 1'
date: 2016-01-27T18:16:12+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1163
dsq_thread_id:
  - "4529293364"
categories:
  - Architecture
  - containers
  - continuous deployment
  - docker
  - How To
  - introduction
  - Micro services
  - Patterns
  - Setup
---
# Introduction

This post is part of a series of post on how to implement a continuous deployment pipeline for a micro services based application. The overview and table of content can be found [here](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/ "Implementing a CI/CD pipeline").

In a micro service based architecture one micro service might depend on the work of one to many other micro services. If the application requires zero downtime then each micro service needs to be redundant, that is at least two instances of a specific micro service need to be running at all times, ideally on different nodes of a cluster.

# Patterns of service discovery

<a style="color: #ff4b33; line-height: 21.8182px; font-size: 16px;" href="https://lostechies.com/gabrielschenker/files/2016/01/HardWired.png"><img class="wp-image-1176 alignright" title="HardWired" src="https://lostechies.com/gabrielschenker/files/2016/01/HardWired.png" alt="" width="350" height="140" /></a>

Let&#8217;s assume micro service A requires micro service B then technically we could hard wire A to B. In this case A knows where to find B. This information would probably be stored somewhere in a configuration file for A.

If the location of B changes then we would have to update this configuration file so that A can find the new instance of micro service B. But this is not a very scalable solution and a maintenance nightmare in an application that consists of many micro services.

[<img class="alignleft  wp-image-1177" title="Registry" src="https://lostechies.com/gabrielschenker/files/2016/01/Registry.png" alt="" width="392" height="230" />](https://lostechies.com/gabrielschenker/files/2016/01/Registry.png)A much better solution is to establish a registry where we collect the information about all services that run in our system. This registry is managed by some specialized service that offers the ability to register and de-register a service. If we have established such a registry service A can now ask the registry (service) about the availability and whereabouts of micro service B. With this information from the registry it can then call B. Thus we have introduced a level of indirection into our communication between micro services.

How does this work? Whenever a micro service instance comes live and is initializing itself (= bootstrapping) it makes a call to the registry service to register itself. The service instance knows where it runs &#8211; it can get the IP address of its host &#8211; and on which port it listens (if it is a micro service e.g. exposing a RESTful API). If the service is well behaving it also makes a call to the registry service to de-register itself if it stops.

[<img class="alignleft  wp-image-1178" title="HealthCheck" src="https://lostechies.com/gabrielschenker/files/2016/01/HealthCheck.png" alt="" width="328" height="261" />](https://lostechies.com/gabrielschenker/files/2016/01/HealthCheck.png)But what happens if the micro service instance crashes? Obviously then it will not be able to de-register itself and we have an orphaned entry in the registry which is bad. To deal with such a situation a registry service should perform periodical health checks on the registered services. A possibility to do so would be to e.g. ping each service on a pre-defined endpoint every few seconds. If the micro service instance does not reply the entry in the registry is marked as critical. If the same service instance cannot be reached several times in a row then the corresponding entry can be removed from the registry. When now micro service A asks the registry service for the list of known instances of micro service B it will not return the information of the instances marked as critical. Thus A will never try to connect to an unhealthy instance of B.

#  Consul

[<img class="alignright  wp-image-1179" title="Consul" src="https://lostechies.com/gabrielschenker/files/2016/01/Consul.png" alt="" width="390" height="258" />](https://lostechies.com/gabrielschenker/files/2016/01/Consul.png)[Consul](https://www.consul.io/) by HashiCorp is an open source implementation of a distributed key value store which on top also provides functionality that make it an ideal candidate for service discovery. Consul can run either as master or as agent. The master orchestrates the whole network and maintains the data. The Consul agent is only a proxy to the master and forwards all requests to the master. In a cluster we want to install an agent on each node so that all services that run on the respective node have a local proxy. That makes it very easy for any micro service to talk to its Consul agent on localhost.

In a production environment we want to run at least 2 instances of Consul master on different nodes. Consul runs on Linux and Windows although it is recommended for production to only run the Consul master on Linux.

<span style="line-height: 21.8182px;">On Linux it is advisable to run Consul (master or agent) as a Docker container. On Windows this option is not yet available and we have to run Consul agent as a Windows service. </span>First we have to startup an instance of Consul master. We can do this on our Linux VM that was created by the [Docker Toolbox](https://www.docker.com/docker-toolbox). We&#8217;re using the [gliderlabs/consul](https://hub.docker.com/r/gliderlabs/consul/) image from [Docker hub](https://hub.docker.com).

{% gist 7cde655f27dc8754b434 %}

Once the master is up and running we can test it and access it&#8217;s API. To e.g. see what nodes are in the current Consul cluster we can use this command

{% gist e4963abc90896ccfa295 %}

and we should see an answer similar to this

{% gist d8bb90ce7cf61420139d %}

# What&#8217;s next?

In my [next](https://lostechies.com/gabrielschenker/2016/02/18/service-discovery-part-2/ "Service discovery – part 2") post I will show how we can run a Consul agent on Linux and on Windows and join them to the Consul network. Furthermore we will also learn how we can use Registrator to auto register services running in Docker containers with Consul and lastly how we can use Consul.Net to register Windows services with Consul. Keep tuned