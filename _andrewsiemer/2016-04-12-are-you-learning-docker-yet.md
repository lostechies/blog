---
wordpress_id: 149
title: Are you learning Docker yet
date: 2016-04-12T20:17:53+00:00
author: Andrew Siemer
layout: post
wordpress_guid: http://lostechies.com/andrewsiemer/?p=149
dsq_thread_id:
  - "4742079582"
categories:
  - docker
---
I went to a docker meetup <del>last week</del> many weeks ago (just now hitting publish).  It was sort of a town hall panel discussion where four guys with loads of docker experience were fielding questions and responding from their experience.  As they were chatting I was jotting down all the different terms I was hearing for the first time or that I have heard but that had been mentioned often enough that I felt I should get to know that tech a little more deeply.  Figured I would share my list from that night.  This is just a brain dump&#8230;

This post is a collection of &#8220;what is it&#8221;, &#8220;why do I need it&#8221;, copied from the sites mentioned.  Consider this a collection of tools you should know about when thinking of entering into the world of docker.

## Docker Compose

<p style="padding-left: 30px;">
  &#8220;Compose is a tool for defining and running multi-container Docker applications.&#8221;
</p>

Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a Compose file to configure your application’s services. Then, using a single command, you create and start all the services from your configuration.

Compose is great for development, testing, and staging environments, as well as CI workflows. You can learn more about each case in [Common Use Cases](https://docs.docker.com/compose/#common-use-cases).

Using Compose is basically a three-step process.

  1. Define your app’s environment with a `Dockerfile` so it can be reproduced anywhere.
  2. Define the services that make up your app in `docker-compose.yml` so they can be run together in an isolated environment.
  3. Lastly, run `docker-compose up` and Compose will start and run your entire app.

For more information about the Compose file, see the [Compose file reference](https://docs.docker.com/compose/compose-file/)

Compose has commands for managing the whole lifecycle of your application:

  * Start, stop and rebuild services
  * View the status of running services
  * Stream the log output of running services
  * Run a one-off command on a service

## Apache Mesos

<p style="padding-left: 30px;">
  &#8220;Program against your datacenter like it&#8217;s a single pool of resources&#8221;
</p>

[Apache Mesos](http://mesos.apache.org/) abstracts CPU, memory, storage, and other compute resources away from machines (physical or virtual), enabling fault-tolerant and elastic distributed systems to easily be built and run effectively.

Mesos is built using the same principles as the Linux kernel, only at a different level of abstraction. The Mesos kernel runs on every machine and provides applications (e.g., Hadoop, Spark, Kafka, Elastic Search) with API’s for resource management and scheduling across entire datacenter and cloud environments.

  * Scalability to 10,000s of nodes
  * Fault-tolerant replicated master and slaves using ZooKeeper
  * Support for Docker containers
  * Native isolation between tasks with Linux Containers
  * Multi-resource scheduling (memory, CPU, disk, and ports)
  * Java, Python and C++ APIs for developing new parallel applications
  * Web UI for viewing cluster state

## Set up Mesos with Compose

[As it turns out you can easily set up Mesos using Compose.](https://dzone.com/articles/1-command-to-mesos-with-docker-compose)

## Docker Swarm

<p style="padding-left: 30px;">
  &#8220;Docker Swarm is native clustering for Docker.&#8221;
</p>

Docker Swarm is native clustering for Docker. It turns a pool of Docker hosts into a single, virtual Docker host. Because Docker Swarm serves the standard Docker API, any tool that already communicates with a Docker daemon can use Swarm to transparently scale to multiple hosts. Supported tools include, but are not limited to, the following:

  * Dokku
  * Docker Compose
  * Krane
  * Jenkins

And of course, the Docker client itself is also supported.

Like other Docker projects, Docker Swarm follows the “swap, plug, and play” principle. As initial development settles, an API will develop to enable pluggable backends. This means you can swap out the scheduling backend Docker Swarm uses out-of-the-box with a backend you prefer. Swarm’s swappable design provides a smooth out-of-box experience for most use cases, and allows large-scale production deployments to swap for more powerful backends, like Mesos.

## Kubernetes by Google

<p style="padding-left: 30px;">
  &#8220;Kubernetes is an open-source platform for automating deployment, scaling, and operations of application containers across clusters of hosts.&#8221;
</p>

With [Kubernetes](http://kubernetes.io/), you are able to quickly and efficiently respond to customer demand:

  * Scale your applications on the fly.
  * Seamlessly roll out new features.
  * Optimize use of your hardware by using only the resources you need.

Our goal is to foster an ecosystem of components and tools that relieve the burden of running applications in public and private clouds.

## Ansible

<p style="padding-left: 30px;">
  &#8220;Ansible is a radically simple IT automation engine that automates cloud provisioning, configuration management, application deployment, intra-service orchestration, and many other IT needs.&#8221;
</p>

Being designed for multi-tier deployments since day one, [Ansible](http://www.ansible.com/) models your IT infrastructure by describing how all of your systems inter-relate, rather than just managing one system at a time.

It uses no agents and no additional custom security infrastructure, so it&#8217;s easy to deploy &#8211; and most importantly, it uses a very simple language (YAML, in the form of Ansible Playbooks) that allow you to describe your automation jobs in a way that approaches plain English.

## etcd

<p style="padding-left: 30px;">
  &#8220;etcd is a distributed key value store that provides a reliable way to store data across a cluster of machines.&#8221;
</p>

[etcd](https://coreos.com/etcd/) is a distributed key value store that provides a reliable way to store data across a cluster of machines. It’s open-source and available on GitHub. etcd gracefully handles master elections during network partitions and will tolerate machine failure, including the master.

Your applications can read and write data into etcd. A simple use-case is to store database connection details or feature flags in etcd as key value pairs. These values can be watched, allowing your app to reconfigure itself when they change.

Advanced uses take advantage of the consistency guarantees to implement database master elections or do distributed locking across a cluster of workers.

## Consul

<p style="padding-left: 30px;">
  &#8220;Consul has multiple components, but as a whole, it is a tool for discovering and configuring services in your infrastructure.&#8221;
</p>

[Consul](https://www.consul.io/) has multiple components, but as a whole, it is a tool for discovering and configuring services in your infrastructure. It provides several key features:

  * Service Discovery: Clients of Consul can _provide_ a service, such as <a name="api"></a>[`api`](https://www.consul.io/intro/index.html#api) or`mysql`, and other clients can use Consul to _discover_ providers of a given service. Using either DNS or HTTP, applications can easily find the services they depend upon.
  * Health Checking: Consul clients can provide any number of health checks, either associated with a given service (&#8220;is the webserver returning 200 OK&#8221;), or with the local node (&#8220;is memory utilization below 90%&#8221;). This information can be used by an operator to monitor cluster health, and it is used by the service discovery components to route traffic away from unhealthy hosts.
  * Key/Value Store: Applications can make use of Consul&#8217;s hierarchical key/value store for any number of purposes, including dynamic configuration, feature flagging, coordination, leader election, and more. The simple HTTP API makes it easy to use.
  * Multi Datacenter: Consul supports multiple datacenters out of the box. This means users of Consul do not have to worry about building additional layers of abstraction to grow to multiple regions.

Consul is designed to be friendly to both the DevOps community and application developers, making it perfect for modern, elastic infrastructures.

##  TerraForm

## Orchestrating Docker with Consul and Terraform

Poking around TerraForm and Docker [I found this slideshare](http://www.slideshare.net/Docker/orchestrating-docker-with-terraform-and-consul-by-mitchell-hashimoto).