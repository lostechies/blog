---
id: 1979
title: 'Docker and SwarmKit &#8211; Part 5 &#8211; going deep'
date: 2016-11-11T11:52:39+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1979
dsq_thread_id:
  - "5296683624"
categories:
  - containers
  - docker
  - How To
  - introduction
tags:
  - containers
  - Docker
  - swarm
  - utility
---
In this post we will work with the SwarmKit directly and not use the Docker CLI to access it. For that we have to first build the necessary components from source which we can find on [GitHub](https://github.com/docker/swarmkit).

You can find the links to the previous 4 parts of this series [here](https://lostechies.com/gabrielschenker/2016/08/26/containers-an-index/). There you will also find links to my other container related posts.

# Build the infrastructure

Once again we will use VirtualBox to create a few virtual machines will be the members of our cluster. First make sure that you have no existing VM called `nodeX` where X is a number between 1 and 5. Otherwise used `docker-machine rm nodeX` to remove the corresponding nodes. Once we&#8217;re ready to go lets build 5 VMs with this command

    for n in $(seq 1 5); do
      docker-machine create --driver VirtualBox node$n
    done;
    

As always buildling the infrastructure is the most time consuming task by far. On my laptop the above command takes a couple of minutes. The equivalent on say AWS or Azure would also take a few minutes.

> Luckily we don&#8217;t have to do that very often. On the other hand, what I just said sounds a bit silly if you&#8217;re an oldie like me. I still remember the days when we had to wait weeks to get a new VM or even worse months to get a new physical server. So, we are totally spoiled. (Rant)

Once the VMs are built use

    docker-machine ls
    

to verify that all machines are up and running as expected

[<img src="https://lostechies.com/gabrielschenker/files/2016/11/list-of-vms.png" alt="" title="list-of-vms" width="766" height="154" class="alignnone size-full wp-image-2030" />](https://lostechies.com/gabrielschenker/files/2016/11/list-of-vms.png)

# Build SwarmKit Binaries

To build the binaries of the SwarmKit we can either use an existing GO environment on our Laptop and follow the instructions [here](https://github.com/docker/swarmkit/blob/master/BUILDING.md) or use the [golang](https://hub.docker.com/_/golang/) Docker container to build the binaries inside a container without the need to have GO natively installed

We can SSH into `node1` which later should become the leader of the swarm.

    docker-machine ssh node1
    

On our leader we first create a new directory, e.g.

    mkdir /swarmkit
    

now cd into the `swarmkit` folder

    cd swarmkit
    

we then clone the source from GitHub using Go

    docker run --rm -t -v $(pwd):/go golang:1.7 go get -d github.com/docker/swarmkit    
    

[<img src="https://lostechies.com/gabrielschenker/files/2016/11/cloning-source.png" alt="" title="cloning-source" width="882" height="226" class="alignnone size-full wp-image-2032" />](https://lostechies.com/gabrielschenker/files/2016/11/cloning-source.png)

this will put the source under the directory `/go/src/github.com/docker/swarmkit`. Finally we can build the binaries, again using the Go container

    docker run --rm -t \ 
        -v $(pwd):/go \
        -w /go/src/github.com/docker/swarmkit \
        golang:1.7 bash -c "make binaries"
    

We should see something like this

[<img src="https://lostechies.com/gabrielschenker/files/2016/11/build-source.png" alt="" title="build-source" width="376" height="202" class="alignnone size-full wp-image-2034" />](https://lostechies.com/gabrielschenker/files/2016/11/build-source.png)

and voila, you should find the binaries in the subfolder `bin` of the swarmkit folder.

# Using the SwarmCtl Utility

To make the `swarmd` and `swarmctl` available everywhere we can create a symlink to these two binaries into the `/usr/bin` folder

    sudo ln -s ~/swarmkit/src/github.com/docker/swarmkit/bin/swarmd /usr/bin/swarmd
    sudo ln -s ~/swarmkit/src/github.com/docker/swarmkit/bin/swarmctl /usr/bin/swarmctl
    

now we can test the tool by entering

    swarmctl version
    

and we should see something along the lines of

    swarmctl github.com/docker/swarmkit v1.12.0-714-gefd44df
    

# Create a Swarm

## Initializing the Swarm

Similar to what we were doing in [part 1](https://lostechies.com/gabrielschenker/2016/09/05/docker-and-swarm-mode-part-1/) we need to first initialize a swarm. Still logged in to `node` we can execute this command to do so

    swarmd -d /tmp/node1 --listen-control-api /tmp/node1/swarm.sock --hostname node1
    

[<img src="https://lostechies.com/gabrielschenker/files/2016/11/init-swarm.png" alt="" title="init-swarm" width="932" height="256" class="alignnone size-full wp-image-2038" />](https://lostechies.com/gabrielschenker/files/2016/11/init-swarm.png)

Let&#8217;s open a new `ssh` session to `node1` and assign the socket to the swarm to the environment variable `SWARM_SOCKET`

    export SWARM_SOCKET=/tmp/node1/swarm.sock
    

Now we can use the `swarmctl` to inspect the swarm

    swarmctl cluster inspect default
    

and we should see something along the line of

[<img src="https://lostechies.com/gabrielschenker/files/2016/11/inspect-swarm.png" alt="" title="inspect-swarm" width="807" height="237" class="alignnone size-full wp-image-2040" />](https://lostechies.com/gabrielschenker/files/2016/11/inspect-swarm.png)

Please note the two swarm tokens that we see at the end of the output above. We will be using those tokens to join the other VMs (we call them nodes) to the swarm either as master or as worker nodes. We have a token for each role.

## Copy Swarmkit Binaries

To copy the swarm binaries (swarmctl and swarmd) to all the other nodes we can use this command

     for n in $(seq 2 5); do
       docker-machine scp node1:swarmkit/src/github.com/docker/swarmkit/bin/swarmd node$n:/home/docker/
       docker-machine scp node1:swarmkit/src/github.com/docker/swarmkit/bin/swarmctl node$n:/home/docker/
     done;
    

## Joining Worker Nodes

Now let&#8217;s `ssh` into e.g. node2 and join it to the cluster as a worker node

    ./swarmd -d /tmp/node2 --hostname node2 --join-addr 192.168.99.100:4242 --join-token <Worker Token>
    

In my case the `<Worker Token>` is `SWMTKN-1-4jz8msqzu2nwz7c0gtmw7xvfl80wmg2gfei3bzpzg7edlljeh3-285metdzg17jztsflhg0umde8`. The `join-addr` is the IP address of `node1` of your setup. You can get it via

    docker-machine ip node
    

in my case it is `192.168.99.100`.

Repeat the same for `node3`. Make sure to replace `node2` with `node3` in the join command.

On `node1` we can now execute the command

    swarmctl node ls
    

and should see something like this

[<img src="https://lostechies.com/gabrielschenker/files/2016/11/list-swarm-nodes.png" alt="" title="list-swarm-nodes" width="671" height="146" class="alignnone size-full wp-image-2045" />](https://lostechies.com/gabrielschenker/files/2016/11/list-swarm-nodes.png)

As you can see, we now have a cluster of 3 nodes with one master (node1) and two workers (node2 and node3). Please join the remaining two nodes 4 and 5 with the same approach as above.

## Creating Services

Having a swarm we can now create services and update them using the `swarmctl` binary. Let&#8217;s create a service using the `nginx` image

    swarmctl service create --name nginx --image nginx:latest
    

This will create the service and run one container instance on a node of our cluster. We can use

    swarmctl service ls
    

to list all our services that are defined for this cluster. We should see something like this

[<img src="https://lostechies.com/gabrielschenker/files/2016/11/list-services.png" alt="" title="list-services" width="459" height="86" class="alignnone size-full wp-image-2047" />](https://lostechies.com/gabrielschenker/files/2016/11/list-services.png)

If we want to see more specific information about a particular service we can use the `inspect` command

    swarmctl service inspect nginx
    

and should get a much more detailed output.

[<img src="https://lostechies.com/gabrielschenker/files/2016/11/inspect-service.png" alt="" title="inspect-service" width="916" height="233" class="alignnone size-full wp-image-2049" />](https://lostechies.com/gabrielschenker/files/2016/11/inspect-service.png)

We can see a lot of details in the above output. I want to specifically point out the column `Node` which tells us on which node the nginx container is running. In my case it is `node2`.

Now if we want to scale this service we can use the `update` command

    swarmctl service update nginx --replicas 2
    

after a short moment (needed to download the image on the remaining node) we should see this when executing the `inspect` command again

[<img src="https://lostechies.com/gabrielschenker/files/2016/11/scale-service.png" alt="" title="scale-service" width="901" height="303" class="alignnone size-full wp-image-2052" />](https://lostechies.com/gabrielschenker/files/2016/11/scale-service.png)

As expected nginx is now running on two nodes of our cluster.

# Summary

In this part we have used the Docker swarmkit directly to create a swarm and define and run services on this cluster. In the previous posts of this series we have used the Docker CLI to execute the same tasks. But under the hood the CLI just calls or uses the `swarmd` and `swarmctl` binaries.

If you are interested in more articles about containers in general and Docker in specific please refer to [this index post](https://lostechies.com/gabrielschenker/2016/08/26/containers-an-index/)