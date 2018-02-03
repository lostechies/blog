---
wordpress_id: 1739
title: 'Docker and Swarm Mode &#8211; Part 1'
date: 2016-09-05T17:42:11+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1739
dsq_thread_id:
  - "5122047471"
categories:
  - containers
  - docker
  - Elasticsearch
  - How To
tags:
  - containers
  - Docker
  - logging
  - swarm
---
[<img src="https://lostechies.com/gabrielschenker/files/2016/09/docker-swarm.png" alt="" title="docker-swarm" width="300" height="411" class="alignleft size-full wp-image-1780" />](https://lostechies.com/gabrielschenker/files/2016/09/docker-swarm.png)

In the following few posts I am going to demonstrate how we can use the new SwarmKit that is part of Docker 1.12 to manage a cluster of nodes (VMs) as a Docker Swarm. To not depend on any cloud provider we will be using VirtualBox on our developer machine to generate such a swarm. I will show how easy it is to get a completely working swarm in place and how to run an application consisting of a bunch of services on this swarm. The application that we&#8217;re going to use is borrowed from [Jérôme Petazzo](https://github.com/jpetazzo) from Docker. This application is a good sample for a microservices based application using various different frameworks and languages to implement individual services. It would be a nightmare to have to run this application natively on a host due to all the different technologies involved. But with Docker and a Docker Swarm it is a breeze and straight forward.

Let&#8217;s start with part 1 and let&#8217;s immediately dive into this adventure&#8230;

# Generate a cluster

In this post I will use Virtualbox to be able to work with multiple VMs. Please make sure you have Docker and Virtualbox installed on your system. The easiest way to do so is by installing the [Docker Toolbox](https://www.docker.com/products/docker-toolbox).

Docker Toolbox by default installs a tiny VM called `default` in Virtualbox. Let&#8217;s stop this VM (and any other that might be running) to have sufficient resources for our cluster. Open a terminal (e.g. Docker Quickstart) and execute the following command

`docker-machine stop default`

We now want to create a cluster of 5 nodes. We can do that manually using `docker-machine` or use a small script to quickly generate a bunch of nodes in VirtualBox

`for N in 1 2 3 4 5; do docker-machine create --driver virtualbox node$N; done`

The above command might take a few minutes, please be patient. Once done, double check that all nodes are up and running as expected

`docker-machine ls`

You should see something similar to this

[<img src="https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-05-at-1.01.42-PM1.png" alt="" title="Screen Shot 2016-09-05 at 1.01.42 PM" width="765" height="174" class="alignnone size-full wp-image-1759" />](https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-05-at-1.01.42-PM1.png)

`ssh` into the first node with the help of `docker-machine` using this command

`docker-machine ssh node1`

Once logged into node1 verify that Docker is in the latest version by issuing the command

`docker info`

# Docker-Compose

Our nodes on Virtualbox consist of a minimal Linux installation with Docker and do not have `docker-compose` installed which we will need in our exercise. Fortunately that&#8217;s no big deal, we can use a container image which has `docker-compose` installed and use this instead of having `docker-compose` directly installed on the node. Thankfully Docker has created [such an image](https://hub.docker.com/r/docker/compose/). Make sure to use the latest version of it which at the time of writing is 1.8.0. We can pull this image like

`docker pull docker/compose:1.8.0`

and then we can run a container with compose like this

[gist id=97bd2faec269dc0de6b671117e94bf62]

Note how I mount the `docker.sock` to have direct access to Docker on the host from within the container and I also mount the working directory into the container to have access to the files on the host like the `docker-compose.yml` file, etc. If I run the above command the version of docker-compose will be printed. To simplify my life I can define an alias as follows

`alias docker-compose='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/app --workdir /app docker/compose:1.8.0'`

and then we can use it like this

`docker-compose --version`

to e.g. print the version or

`docker-compose up`

to use the `docker-compose.yml` file in the current directory and run the application described in there.

# Working with the Swarmkit

Now we&#8217;re ready to create a new Docker swarm. Note that Docker (starting from version 1.12) can run in two modes, **classical** and **swarm mode**. The former is there for backwards compatibility and the latter uses the new swarm kit that is now part of Docker Engine. To initialize a new swarm use this command on node1:

`docker swarm init --advertise-addr [ip-address]`

where `[ip-address]` is the public IP address of the node (e.g. 192.168.99.101). The above command will tell us in the output which command to use to join other worker nodes to the swarm. In my case this looks like this

[gist id=ce79cd887cb316dc1c16f0e94bb93395]

Don&#8217;t worry if you forget this command. At any time we can retrieve it again using

`docker swarm join-token worker`

to get the join command for a worker or

`docker swarm join-token manager`

to get the equivalent for a node that should join as a manager.

Open another terminal window and `ssh` into `node2`

`docker-machine ssh node2`

and run the join command needed for a worker (in my case this is)

[gist id=02def3a0df1db9941e637d60c01ee842]

In your case you will of course have another swarm token and probably a different IP address.

Now, we can do the very same for nodes 3 to 5 but that&#8217;s a bit tedious, especially if we don&#8217;t have 5 but 10 or more nodes. Let&#8217;s automate this

[gist id=471fb50bb0bb2b5b00f53ef5a24b1278]

OK, so now we have a 5 node swarm as we can easily test by running the command

`docker node ls`

on `node1`. We should see something similar to this

[<img src="https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-05-at-1.20.37-PM.png" alt="" title="Screen Shot 2016-09-05 at 1.20.37 PM" width="628" height="140" class="alignnone size-full wp-image-1762" />](https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-05-at-1.20.37-PM.png)

We can see that we have one master node (node1) that is also the leader in a quorum of master nodes. The other 4 nodes are all worker nodes. Worker nodes can be promoted to master nodes and vice versa. In a production environment we should have at least 3 master nodes for high availability since master nodes store all the information about the swarm and its state. Let&#8217;s promote `node2` and `node3` to **master** status using this command

`docker node promote node2 node3`

and then double check the new status with `docker node ls` where we should see this

[<img src="https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-05-at-1.39.35-PM.png" alt="" title="Screen Shot 2016-09-05 at 1.39.35 PM" width="612" height="145" class="alignnone size-full wp-image-1768" />](https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-05-at-1.39.35-PM.png)

Evidently `node2` and `node3` are now also master nodes and are &#8220;reachable&#8221;. `node1` still remains the leader, but **if** for some reason it goes away then `node2` or `node3` will take the leader position. Let&#8217;s try that and use `docker-machine` to stop `node1`

`docker-machine stop node1`

by doing this we are of course kicked out of our ssh session on node1. Let&#8217;s ssh into node2, one of the other leaders and again use `docker node ls` to check the new status. You might need to give it some time to reach the final state

[<img src="https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-05-at-1.44.26-PM.png" alt="" title="Screen Shot 2016-09-05 at 1.44.26 PM" width="621" height="125" class="alignnone size-full wp-image-1771" />](https://lostechies.com/gabrielschenker/files/2016/09/Screen-Shot-2016-09-05-at-1.44.26-PM.png)

And we see that now the former leader node1 is unreachable while node3 became the new leader. Let&#8217;s start node1 again and after it has stabilized it will be a master again but not the leader. Node3 will remain leader.

# Private Registry

When we are building Docker images we have to store them somewhere. Usually we can use [Docker Hub](http://hub.docker.com) to store public images for free or if we have a private account we can also store private images there. But if that is not OK and we want to have our own private registry for images then we can use the Docker registry in our environment. Docker registry is OSS and is run as a container. By default images are stored in the container and thus will be lost if the container is removed or crashes. But it is very easy to configure the container to use a durable storage for the images like AWS S3 or so. To run the OSS version of Docker registry as a service listening on port 5000 use this command.

`docker service create --name registry --publish 5000:5000 registry:2`

By publishing the port on the swarm we make sure the registry can be reached from each node. This is a &#8220;trick&#8221; so each node can communicate with the registry via `localhost:5000` and we don&#8217;t have to use TLS.

Once the service is running we can now (on any node of our cluster) execute the following command to get a list of all images

`curl localhost:5000/v2/_catalog`

Let&#8217;s test the registry. We can try to push e.g. the official alpine which we first want to pull from Docker hub

`docker pull alpine`

We use the alpine image since it is so small. Now to be able to push it to our private registry we first need to tag the image

`docker tag alpine localhost:5000/alpine`

and then push it

`docker push localhost:5000/alpine`

If we now query the registry we get this

[gist id=f98b4fa53675bd994ff9d663fec76da1]

# Building and pushing services

Let&#8217;s first clone the sample application

`git clone https://github.com/jpetazzo/orchestration-workshop`

cd into the source directory of the repository

`cd orchestration-workshop/dockercoins`

and then build and push all the services using this script

[gist id=e0bd034078ae89115dc7affb80244660]

If we query the registry again we should now find all the services just built in the catalog too.

# Summary

In part 1 I have demonstrated how we can easily create a new Docker swarm on our development machine using VirtualBox and the Docker SwarmKit. We have learned how we can add nodes to the swarm and promote or demote them from worker to to master status and vice versa. We have also experienced what happens if the leader of the master nodes disappears. Another master node takes its role and the swarm continues to work just normally. Finally we have installed a private Docker registry in our cluster which we&#8217;ll be using to store our Docker images that we build from the sample application.

In part 2 we will use the new `docker service` keyword to create, scale, and manipulate individual services. Stay tuned.