---
id: 1777
title: 'Docker and Swarm Mode &#8211; Part 2'
date: 2016-09-11T12:40:03+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1777
dsq_thread_id:
  - "5136627994"
dsq_needs_sync:
  - "1"
categories:
  - containers
  - docker
  - How To
  - introduction
tags:
  - containers
  - Docker
  - network
  - service
  - swarm
  - task
---
In [part 1](https://lostechies.com/gabrielschenker/2016/09/05/docker-and-swarm-mode-part-1/) of this post series about Docker SwarmKit I showed how we can quickly create a cluster of nodes (VMs) using VirtualBox and configure a Docker Swarm on this nodes. I then showed how we can run a private registry in the swarm which contains the images we want to use. Finally I showed how the swarm masters behave if the leader node fails.

In this second part we want to deploy and run a complex, microservices based application in our swarm. Without further adue let&#8217;s dive into the topic.

If you are interested in more Docker and container related post written by me, then [here is the link](https://lostechies.com/gabrielschenker/2016/08/26/containers-an-index/) to an index of all post.

# Key Concepts of a Swarm

Before we start with code I want to give a short explanation about some key concepts of a Docker swarm. It gives us the 30 thousand feet view and helps us to better understand how things relate to each other. But don&#8217;t worry, this post is not going to be a purely theoretical one, we will dive into concrete code samples further down.

## Node

In my last post I showed how we can easily create 5 VMs using Virtualbox on our devleoper machine and configure them as **nodes** in a swarm. According to Docker

> A node is an instance of Docker Engine participating in a swarm.

In a swarm we distinguish between manager and worker nodes.

## Service

Starting with Docker v1.12 some new concepts were introduced. One of them is **services**. A service is the logical definition of a component running in a swarm. A service defines a set of **tasks**. Or expressed a bit differently, according to Docker

> A service is the definition of the tasks to execute on the worker nodes. It is the central structure of the swarm system and the primary root of user interaction with the swarm.

OK, evidently a **service** is a very important concept in the context of a Docker swarm since it is the primary point of interaction for us with the swarm. We will see in detail further down what that means in reality.

## Task

> A **task** carries a Docker container and commands to run inside the container. It is the atomic scheduling unit of swarm.

A **task** in this sense is a unit of work. At this time a task always is associated with a container (instance). But conceptually that is not the only possibility. When Docker first introduced the SwarmKit at DockerCon 2016 in Seattle they also made it clear that a task can be associated with other types of unit of work, e.g. a VM.

## Swarm

So, now that we have **nodes** and **services** we can define what a **swarm** is

> A swarm is a cluster of Docker Engines (nodes) where you deploy services.

Any Docker Engine (node) can run in two modes, standard and Swarm mode. If the node participates in a swarm, then the Docker Engine runs in Swarm Mode.

When we run a Docker Engine outside of a swarm we execute container commands like `docker build ...` or `docker run ...`. If the Docker Engine participates in a swarm then we **orchestrate services**; e.g. `docker service [service-name] --replicas 3`.

# Application, Services and Networks

When we talk about an application we always have (at least) two view points. We talk about the logical and the physical view of the application or we can also say the logical and the physical architecture of the application. Let&#8217;s first talk about the logical view.

## Logical View

In the context of Docker and Docker Swarm, an application is made up of 1 to many services running on 1 to multiple of software defined networks (SDN). Those services collaborate with each other by exchanging messages or calling each other in an RPC like style. Each service can be &#8220;attached&#8221; to one or many networks. The communication between the services happens over a network. In this regard a network can be regarded like a wire that connects services or maybe a channel through which the water (messages) flows from service to service. Only services that are attached (or have a connection to) the same network are able to communicate with each other. There is no way that two services can see each other or connect with each other if they are on different networks. Let&#8217;s illustrate this with an image. As always images say more than a thousand words

[<img src="https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-10-at-10.00.34-AM.png" alt="" title="Screen Shot 2016-09-10 at 10.00.34 AM" width="593" height="442" class="alignnone size-full wp-image-1815" />](https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-10-at-10.00.34-AM.png)

In the above image we have the application in orange which encompasses 3 services A, B and C (blue). In the application we also have 2 networks SDN-1 and SDN-2 defined (gray). Service A is connected to SDN-1, service B is connected to both, SDN-1 and SDN-2 whilst service C is connected to SDN-2. Thus service B can see A and C while services A and C cannot see or communicate with each other.

## Physical View

In the logical view we wouldn&#8217;t care about nodes, tasks, containers or the swarm at all. In a physical view the latter enter the picture. We have a cluster of nodes, called a swarm onto which we want to deploy an application consisting of several services. For reasons like high availability we want to deploy more than one instance of each service in the cluster, such that if one service instance fails or crashes the application is continuing to work with the other remaining instances of the same service. We also want to make sure that the instances of an individual service get deployed to different nodes such as that if a whole node goes down our application can continue to work. When I talk about an instance of a service I really mean a **task**. Again, a picture can say more than a thousand words

[<img src="https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-11-at-10.38.22-AM.png" alt="" title="Screen Shot 2016-09-11 at 10.38.22 AM" width="585" height="570" class="alignnone size-full wp-image-1833" />](https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-11-at-10.38.22-AM.png)

In the above image we have a swarm consisting of 3 nodes. One node is a master and the other two are worker nodes. The application we have deployed consists of 2 services A and B and a database which is not part of the swarm (e.g. a SaaS solution like AWS RDS or Mongo Labs). Service A runs in two instances A1 and A2 on nodes node-1 and node-2 whilst service 3 runs in 3 instances, one on every node.

# Creating Services

By default a task represents a container or instance of the service. The service thus is like a blueprint with information such as which image to use for a container, how many instances to run, etc. Docker swarm tries to always maintain the desired state of which services are the most important part. Thus if a service defines 3 instances but only 2 are currently running then the swarm manger tries to start a new instance to fulfill the desired state.

We saw in part 1 how to create a service when we created the private registry. Let&#8217;s try another sample and run 3 instances of Nginx in our swarm. The command for this is

`docker service create --name Web --publish 80:80 --replicas=3 nginx:latest`

We can now use the following command to list all instances of the service

`docker service ps Web`

and will see something similar to this

[<img src="https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-07-at-3.23.27-PM.png" alt="" title="Screen Shot 2016-09-07 at 3.23.27 PM" width="797" height="120" class="none size-full wp-image-1785" />](https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-07-at-3.23.27-PM.png)

In the above list we can see that 3 instances are running. We can also see on which nodes of the swarm they are running as well as the `Desired State` and the `Current State`. At the time of the snapshot the `Current State` was in `Preparing...` mode. If we wait a few moments and try the command again we should see the `Current State` being `Running`.

## Publishing Ports

Another interesting and important fact is that when we `publish` a port of a service, this port is published to all nodes of the swarm. That is, even if I have a single instance of the Web service running say on node1 I can reach this service from any node in the swarm on `localhost:80`. The swarm manager will automatically reroute my request to the correct node. We can test that by SSH-ing into a node _other_ than the ones on which Nginx now runs (node1 and node4 in my case). There we can execute this command

`curl localhost:80`

And the response should be the HTML with the welcome message generated/served by Nginx.

# Services and Desired State

If we have defined a service with a desired state of 3 replicas then the swarm manager will make sure that this state is always maintained even if a container goes away. In this case the manager will schedule a new instance of the service to a node with sufficient resources. Let&#8217;s try this and stop one of the Nginx containers. To do this I will open another terminal and SSH into node2 where one of my containers runs

`docker-machine ssh node2`

and now I can stop this container

`docker kill [container ID]`

note that I got the [container ID] by executing `docker ps` and identifying the ID of my Nginx container.

If in my session in node1 I now execute

`docker service ps Web`

again, then I should see something like this

[<img src="https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-07-at-3.34.09-PM2.png" alt="" title="Screen Shot 2016-09-07 at 3.34.09 PM" width="487" height="65" class="alignnone size-full wp-image-1797" />](https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-07-at-3.34.09-PM2.png)

which tells me that one instance (Web.1) has been lost on node2 and a new one has been created on node4 instead.

# Scaling a Service

At any time I can scale an existing service up and down. Let&#8217;s scale our Nginx to 5 instances

`docker service update Web --replicas 5`

and after a few seconds I have 2 additional instances running. The same works of course to scale down. I can even scale down to zero instances

`docker service update Web --replicas 0`

this is the outcome (I remain with 5 shutdown instances)

[<img src="https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-07-at-3.49.42-PM.png" alt="" title="Screen Shot 2016-09-07 at 3.49.42 PM" width="726" height="155" class="alignnone size-full wp-image-1799" />](https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-07-at-3.49.42-PM.png)

# Upgrading a service

Before we dive into this section let&#8217;s remove the previous service

`docker service rm Web`

Upgrading a running service is one of the most important and exciting features of a service. Specifically upgrading the version of the Docker image used by the service. Docker SwarmKit allows us to do a rolling upgrade such as that our services remain operational at all the time. Let&#8217;s do that with a sample. First we run a specific version of Nginx

`docker service create --name nginx --publish 80:80 --replicas 3 nginx:1.10.1`

then we upgrade the service to the newer version 1.11.3

`docker service update nginx --image nginx:1.11.3`

after a while we should see somthing similar to this

[<img src="https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-07-at-4.36.19-PM.png" alt="" title="Screen Shot 2016-09-07 at 4.36.19 PM" width="854" height="154" class="alignnone size-full wp-image-1803" />](https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-07-at-4.36.19-PM.png)

Please notice the timing in the column `Current State` above. We can see that the service was updated in a rolling fashion. One task or container after the other was upgraded. The scheduler waits until one instance is upgraded successfully until the it starts the upgrade of the next one. This guarantees that we do not have a service interruption ever.

Worst case scenario: the scheduler fails to upgrade a task. It will retry the upgrade over and over again until it succeeds. At this time there is no direct way to tell the scheduler to stop after x unsuccessful attempts. We have to go and explicitly stop the upgrade.

# Running a Service globally

Another important feature is the possibility to declare a service as global which means that the swarm master schedules a task/container on each and every node of the swarm. This is very useful for such situations as running some containers like log collectors, etc. We will see a sample of this later when we discuss the use of the ELK stack and other logging providers.

Another sample where sometimes global services are used is for debugging purposes. We can schedule a lightweight container globally in sleep mode, e.g.

`docker service create --name debug --mode global alpine sleep 1000000000`

Here we use the `alpine` image since it is small. We use the `--mode` flag to declare the service as global. If we now do a

`docker service ps debug`

We&#8217;ll see that we have an instance running on every single node of our swarm. We can now `SSH` into any node and the `exec` into this `debug` container and use it for our debugging purposes; e.g. to test service discovery, etc.

# Dealing with failing Nodes

If a node of our swarm fails the swarm manager automatically reschedules all tasks (or containers) that were running on that node to another node with free resources. To achieve this we can simply shutdown one of the nodes of our swarm which has some tasks running on it. We can then monitor one of the affected services and see how the task from the &#8220;failing&#8221; node is rescheduled onto a different node having free resources.

Note that if the failing node comes up again it stays empty. Tasks that were previously running on it are not automatically transferred back to the node.

# Servicing Nodes

From time to time we might need to service the nodes of our swarm, e.g. to update the version of Docker Engine. To achieve this we can first `drain` a node. The swarm manger will then automatically stop all tasks instances on this node and reschedule them onto another node. Once the node is &#8220;empty&#8221; it is marked as inactive and can now be upgraded or serviced without compromising the services running in our swarm. We can achieve this using the following command

`docker node update --availability drain`

# Removing Nodes from the Swarm

In [part 1](https://lostechies.com/gabrielschenker/2016/09/05/docker-and-swarm-mode-part-1/) we have seen how to join a new node to an existing swarm. Sometimes we want to remove a node from the swarm. This is easy. SSH into the node and execute this command

`docker swarm leave`

The above command will fail if the node is a master. In this case we have two options, we can

  * demote the node and then have it leave the swarm or
  * force it to leave with the `--force` flag

**Note:** If at a later stage the same node joins the swarm again it will have a different node ID.

# Networks

As soon as we have to deal with multiple services running in a swarm we need to define (overlay) networks. To create a new network in our swarm we can use this command

`docker network create [network name] --driver overlay`

Here I have selected the `overlay` driver for our network which spans across multiple hosts. When we create a service we need to assign it to a network. A service can be attached to many different networks. Only services residing in the same network can communicate with each other and leverage service discovery as discussed in the next section.

# Service Discovery and Load Balancing

The Docker Swarm provides us service discovery and load balancing. If an instance of service `foo` needs to access an instance of service `bar` running in the same network of our swarm then `foo` can use the name `bar` to identify and reach out to service `bar`. Let&#8217;s make a more specific sample. Let&#8217;s define the two services. First we create a network

`docker network create test --driver overlay`

then we create the service `foo`

`docker service create --name foo --replicas 1 --network test nginx`

and finally we create service `bar`

`docker service create --name bar --replicas 3 --network test --publish 8000:8000 jwilder/whoami`

Note how I use the image [jwilder/whoami](https://hub.docker.com/r/jwilder/whoami/) for service `bar`. A container of this image simply returns the information about on which node it is running (the hostname) back to the caller. It is an ideal image for this demonstration.

We can find out where our `foo` instance (Nginx) is running with

`docker service ps foo`

Once we have identified the node we can SSH into it. There we can `exec` into the nginx container

`docker exec -it [container ID] /bin/bash`

Once we&#8217;re inside the Nginx container we can install `curl` using this command

`apt-get update && apt-get install -y curl`

and then we can then use the name `bar` as the DNS name for the `bar` service in our `curl` command

`curl bar:8000`

If we do this multiple times then we can see that not only is service `bar` discovered for us but we are also load-balanced in a round robin fashion among the (3) instances of `foo`, as is evident in the below image

[<img src="https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-07-at-5.26.34-PM.png" alt="" title="Screen Shot 2016-09-07 at 5.26.34 PM" width="300" height="223" class="alignnone size-full wp-image-1807" />](https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-07-at-5.26.34-PM.png)

Note that if we scale `bar` up to say 5 instances, load balancing will automatically add the new instances to the round robin as soon as they are running.

# Summary

In part 2 of this series I have introduced some of the new concepts that are new since Docker version 1.12. These are swarm mode, services and tasks. Services are a core concept of swarm mode and are the primary interaction point of us with the swarm. In a swarm we have master and worker nodes. Master nodes schedule services in our swarm and make sure that the desired state of the cluster is always maintained. The swarm also provides services like service discovery, rescheduling of containers from failing nodes and much more.

In the next part we will finally learn how to deploy our complex application into the swarm. Stay tuned.