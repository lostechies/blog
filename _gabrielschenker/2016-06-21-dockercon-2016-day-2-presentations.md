---
wordpress_id: 1568
title: 'DockerCon 2016 &#8211; Day 2, Presentations'
date: 2016-06-21T16:31:35+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1568
dsq_thread_id:
  - "4928757093"
categories:
  - containers
  - docker
  - presentation
---
In my last two post ([here](https://lostechies.com/gabrielschenker/2016/06/19/dockercon-2016-day-of-arrival/) and [here](https://lostechies.com/gabrielschenker/2016/06/20/day-1-workshop-and-registration/)) I talked about the first 2 days I spent here in beautiful Seattle WA for the [DockerCon 2016](http://2016.dockercon.com). In this post I am giving a quick review about the first day of presentations. And just to make it clear, there were some amazing new features announced for the new version of Docker.

The day started with a nice breakfast in the Expo hall at the [WSCC](http://www.wscc.com/). The General Session started at 9:00 am and it didn&#8217;t take long until some exciting news were announced.

# What&#8217;s new in Docker 1.12

Docker will release a stable version 1.12 in a few weeks. This new version has [built-in orchestration](https://blog.docker.com/2016/06/docker-1-12-built-in-orchestration/). Part of this new release will be the swarm kit. Yes, you heard it right, Docker Swarm will now be part of Docker and with it some new concepts. The Docker CLI has the new capability of creating a (new) swarm

`docker swarm init`

This implicitly creates a swarm manager &#8211; here called `node-1` &#8211; which at the same time is also a certificate authority (CA). That is, this manager will be able to generate certificates for all nodes of the swarm. And the communication between all nodes of the swarm will be secured via TLS. Yes that&#8217;s right, there is no more unsecured swarm possible anymore. Security will be completely transparent for us developers/engineers creating and using a swarm.

Now the CLI also has new commands to join a node to the swarm. I can now e.g. `ssh` into my `node-2` and execute the following command

`docker swarm join node-1:2377`

This will add the node as a worker to the swarm. If I want to add a node as a manager I just use the parameter `--manager`. That&#8217;s all we have to do. No need to copy and install certificates, it just works. Great! (Note that I assumed we have DNS name resolution working and are not forced to use IP-addresses in this sample)

I can repeat the above command for all the other nodes I want to add to the swarm. Note that a node has a role of either being a `manager` or a `worker`. A worker can be promoted to a manager and a manager can be demoted to a worker role. Managers use the [RAFT](https://raft.github.io/raft.pdf) protocol to elect a leader and get to a consensus. The workers on the other hand use a gossip protocol to communicate their respective state among each other. Interestingly we now don&#8217;t need any external entities or key-value stores anymore to keep track of the topology of the swarm. This is now all built-in into Docker.

# Logical Services

New to Docker is the concept of a (logical) service. This concept has been inspired by what has been already available in [Docker Cloud](http://cloud.docker.com) for a while. A service consists of 1 to many container instances. The introduction of this logical view makes management of services much easier. One can create, update and scale a service which results in containers being deployed, updated or destroyed. Read more [here](https://blog.docker.com/2016/06/docker-1-12-built-in-orchestration/)

# Docker for Mac & Docker for Windows

The two products Docker for Mac and Docker for Windows have been available in a private beta for a few months. Docker has done a great job and listened to the feedback of the early adopters and steadily improved those products. Both products offer a seamless integration of Docker into OS-X or Windows. Both products are now generally available and replace the Docker Toolkit. Grab them [here](https://www.docker.com/) will they&#8217;re hot!

# Docker for AWS & Docker for Azure

To simplify the life of operations engineers Docker has created two new products providing a deep integration with Amazon AWS and Microsoft Azure. These products are currently in beta and are called **Docker for AWS** and **Docker for Azure**. You can find more detailed information in [this blog post](https://blog.docker.com/2016/06/azure-aws-beta/).

# Stateful Containers

In some of the presentations during the day the topic of stateful containers was addressed by presenters of well known companies like Dell and EMC. They discussed how containers can be ephemeral yet still be stateful. In a nutshell, we need a &#8220;data volume scheduler&#8221; that is able to keep track which container is using which data volume such that if the container dies and another container takes its place (probably in another location) the volume can follow this (new) container and automatically be attached. EMC and Dell of course offer the necessary underlying storage technology which is not bound to a single host but distributed in nature. This all is enabled by the fact that Docker introduced (in version 1.7) support for volume drivers.

# Summary

Today we got to know of a lot of exciting new features and products that Docker makes available to us. Version 1.12 of Docker contains now its own scheduling features. Docker for Mac and Windows are now publicly available and new cloud integration tools aka Docker for AWS and Docker for Azure are available in beta for operations engineers. I will test all these new features and tools and write about my experience in upcoming posts. It&#8217;s an exciting time for containers&#8230;