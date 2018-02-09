---
wordpress_id: 1194
title: 'Service discovery &#8211; part 2'
date: 2016-02-18T14:15:27+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1194
dsq_thread_id:
  - "4591310270"
categories:
  - Architecture
  - containers
  - continuous deployment
  - docker
  - How To
---
# Introduction

This post is part of a series on implementing a CI/CD pipeline. Please refer to [this post](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/ "Implementing a CI/CD pipeline") for an overview and the table of content. In the [first part](https://lostechies.com/gabrielschenker/2016/01/27/service-discovery/ "Service discovery") of service discovery I discussed what service discovery is and how it can be implemented. In this post I want to show how we can configure a system to use consul for service discovery.

#  Consul Master

Consul knows the concept of a master and an agent. The master node is where the data is stored. The agent works as a proxy on the node where it is installed and only forwards all calls to the master. In a production system everything has to be redundant. Thus we need to have at least 2 master nodes. Please note that if I am talking of a node this is either a physical server or a VM. Normally we would want 3 master nodes. Consul master is NOT recommended to run on Windows at this time, thus we will run all our consul masters on Linux. We will run consul inside a Docker container on Linux. Of course we need to run the 3 instances of consul master on 3 different nodes (that is not just 3 container instances on the same node), but that should be obvious. How can we do this?

Since we are running Consul in a Docker container we want to use Docker Swarm to create and manage a cluster of nodes. I am assuming you have installed Docker Toolbox on your system. If not, then download it from [here](https://www.docker.com/products/docker-toolbox "Docker Toolbox").

## Creating a cluster

Please refer to the Docker documentation here for the details about how to create a multi-host cluster. In this section I just want to give a brief summary of the steps needed and show the commands that I use to create such a cluster of nodes. First we need to have a key-value store that contains all the data about the cluster. We use Consul for this. Having VirtualBox installed on our system we can use Docker-Machine to create a VM for this key-value store. Open the **Docker Quickstart** console. We can use this command

{% gist d701cc1fcbb2505d4773 %}

This will create a new VM called **my-keystore**. You can run the **Oracle VM VirtualBox** GUI to see the new node as it is created and started. Once the VM is up and running we can download and run the consul Docker container with the following command

{% gist 07b4272baeb2fbee8b19 %}

To double check whether or not the container is running as expected we can used the docker ps command.

<img class="alignleft  wp-image-1200" title="DockerPS" src="https://lostechies.com/gabrielschenker/files/2016/02/DockerPS.png" alt="" width="815" height="74" />

We can then use the ID of the container to also look into the log of the container using

{% gist cca59630826279325dfb %}

where {container-id} is the ID of the container. Tip: We only need to provide the first few characters of the ID for it to work. In our case it would be: **docker logs 933c**.

<img class="alignleft size-full wp-image-1204" title="DockerLogs" src="https://lostechies.com/gabrielschenker/files/2016/02/DockerLogs.png" alt="" width="1012" height="536" />

Now we can start to create VMs that represent the nodes of our cluster. We can use this command to generate the cluster master node which at the same time represents our swarm that we want to build

{% gist 2bb63a9be03243dcf0d9 %}

We want to add 2 more VMs to the cluster (you can add as many as you want&#8230;) using the following commands

{% gist 861154485a18d9961c46 %}

OK, now we&#8217;re all set. Now we can list all nodes to confirm that they are up and running as expected.

{% gist 8dba5d06c404b7751806 %}

We should see this:

<img class="alignleft size-full wp-image-1211" title="DockerLS" src="https://lostechies.com/gabrielschenker/files/2016/02/DockerLS.png" alt="" width="1125" height="110" />

We can use this command to set our environment to the Swarm master

{% gist 887b159accaebed3a465 %}

Having done so we can use the **docker info** command to view the details of our cluster.

[<img class="alignleft size-full wp-image-1217" title="Dockerinfo" src="https://lostechies.com/gabrielschenker/files/2016/02/Dockerinfo.png" alt="" width="1157" height="757" />](https://lostechies.com/gabrielschenker/files/2016/02/Dockerinfo.png)

## Running the consul master containers

Now let&#8217;s run an instance of Consul Master on each of the 3 nodes of our Swarm. Let&#8217;s start with the first node which happens to be the Swarm Master. First we need to find out what is the private IP-address of the node as well as the bride IP-address used for the swarm. To do this we can e.g. ssh into the node and run the command **ifconfig**.

{% gist 85746c38c6640446b448 %}

we should see something in the line of

[<img class="alignleft size-full wp-image-1212" title="ifconfig" src="https://lostechies.com/gabrielschenker/files/2016/02/ifconfig1.png" alt="" width="803" height="586" />](https://lostechies.com/gabrielschenker/files/2016/02/ifconfig1.png)

The bridge IP-address we can find under the **docker0** section. The private IP-address is in the **eth1** section. We can do that for the other nodes too. The bridge IP-address will be the same for all nodes but the private IP-address will change. In my case the other two nodes have 192.168.99.108 and 192.168.99.109.

Make sure you have set the environment to the master node and then run this command

{% gist 77415142705a38499eca %}

This will run the first instance of Consul Master. We indicate that we want to create a cluster of 3 Consul Master nodes with the parameter -bootstrap-expect 3. Note how we use the internal IP-address 192.168.99.103 to publish ports 8xxx for tcp and udp and the bridge IP-address 172.17.0.1 to publish port 53 for udp. We are also using the internal IP-address to advertise.

Now switch the environment to the **my-demo1** node and run

{% gist 1fbffac175b06e753637 %}

Note how we again use the private IP-address to publish ports 8xxx and the bridge IP-address for port 53. We also use the bridge IP-address to tell this second Consul node which Consul cluster/network to join.

Finally switch the environment to the **my-demo2** node and run

{% gist f98d15f5a5f3568282c4 %}

Now if we look into the logs of the Consul Master on the node my-demo0 we should see something in the line of

[<img class="alignleft size-full wp-image-1214" title="ConsulLogs" src="https://lostechies.com/gabrielschenker/files/2016/02/ConsulLogs.png" alt="" width="1153" height="902" />](https://lostechies.com/gabrielschenker/files/2016/02/ConsulLogs.png)

# 

# Consul Agent

Now we want to run a Consul Agent directly on the Windows host. Since Docker does not yet run on Windows we have to install the binaries directly on Windows. Download and install the Consul Agent e.g. using [Chocolatey](https://chocolatey.org/) as follows

{% gist 10274265f122b6a57df7 %}

Create a config file calle **consul-Config.json** in the folder **c:\ProgramData\consul\config** with the following content

{% gist 1b612af630b1bb0674d7 %}

Note that the IP-address corresponds to the publicly visible IP-address of my Windows host. Now start the Consul Agent as Windows service using this command

{% gist 4130e3cdcef397d2a664 %}

and then join the agent to the Consul network using this command

{% gist da3f794373ebf1a7492f %}

Now let&#8217;s have a look into the log files to see whether or not everything is OK. We can find the log for the Consul Agent on our Windows Host in the folder c:\ProgramData\consul\logs. Open the file consul-output.log. We should see something along the line of

{% gist 8668bf2ead2bdd781e42 %}

Note how the agent has been added to the network of the 3 existing Consul Master nodes.

If we look at the tail of the log of one of the Consul Master nodes we should see something like

{% gist 0ad516903c22da64c91e %}

Which confirms that the agent (in my case DESKTOP-BFQ652M which happen to be the hostname of my Laptop) has successfully joined the network.

We can now use the UI to analyze what&#8217;s going on in our Consul network. Open the browser at <http://localhost:8500/ui> and you should see something like

[<img class="alignleft size-full wp-image-1228" title="ConsulUI" src="https://lostechies.com/gabrielschenker/files/2016/02/ConsulUI.png" alt="" width="837" height="588" />](https://lostechies.com/gabrielschenker/files/2016/02/ConsulUI.png)

# Summary

I have shown in detail how to setup a Consul network with 3 master nodes running in Docker on Linux as well as a Consul Agent running on my Windows host. In the next post I will show how to register services with consul and how to monitor their health.