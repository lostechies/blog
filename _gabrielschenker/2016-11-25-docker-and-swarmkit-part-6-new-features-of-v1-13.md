---
wordpress_id: 2060
title: 'Docker and Swarmkit &#8211; Part 6 &#8211; New Features of v1.13'
date: 2016-11-25T15:14:15+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=2060
dsq_thread_id:
  - "5332354253"
categories:
  - containers
  - docker
  - How To
  - introduction
tags:
  - containers
  - Docker
  - swarm
---
[<img src="https://lostechies.com/gabrielschenker/files/2016/11/docker-swarm-logo.png" alt="" title="docker-swarm-logo" width="250" height="342" class="alignleft size-full wp-image-2090" />](https://lostechies.com/gabrielschenker/files/2016/11/docker-swarm-logo.png) In a few days version 1.13 of Docker will be released and among other it contains a lot of new features for the Docker Swarmkit. In this post I want to explore some of these new capabilities.

In the last few parts of this series of posts about the Docker Swarmkit we have used version 1.12.x of Docker. You can find those post here

[Part 1](https://lostechies.com/gabrielschenker/2016/09/05/docker-and-swarm-mode-part-1/), [Part 2](https://lostechies.com/gabrielschenker/2016/09/11/docker-and-swarm-mode-part-2/), [Part 3](https://lostechies.com/gabrielschenker/2016/10/05/docker-and-swarm-mode-part-3/), [Part 4](https://lostechies.com/gabrielschenker/2016/10/22/docker-and-swarmkit-part-4/) and [Part 5](https://lostechies.com/gabrielschenker/2016/11/11/docker-and-swarmkit-part-5-going-deep/)

For a full index of all Docker related post please refer to [this post](https://lostechies.com/gabrielschenker/2016/08/26/containers-an-index/)

# Preparating for Version 1.13

First we need to prepare our system to use Docker 1.13. I will be using VirtualBox and the Boot2Docker ISO to demonstrate the new features. This is what I have done to get going. Note that at the time of this writing Docker just [released Docker v1.13 rc2](https://github.com/docker/docker/releases).

First I am going to install the newest version of `docker-machine` on my Mac. The binaries can be downloaded from [here](https://github.com/docker/machine/releases). In my case the package I download is [docker-machine-Darwin-x86_64 v0.9.0-rc1](https://github.com/docker/machine/releases/download/v0.9.0-rc1/docker-machine-Darwin-x86_64)

From the download folder move the binaries to the target folder

    mv ~/Downloads/docker-machine-Darwin-x86_64 /usr/local/bin/docker-machine
    

and then make it executable

    chmod +x /usr/local/bin/docker-machine
    

finally we can double check that we have the expected version

    docker-machine -v
    

and in my case I see this

    docker-machine version 0.9.0-rc1, build ed849a7
    

Now let&#8217;s download the newest `boot2docker.iso` image. At the time of this writing it is v1.13rc2. We can get it from [here](https://github.com/boot2docker/boot2docker/releases). Once downloaded move the image to the correct location

    mv ~/Downloads/boot2docker.iso ~/.docker/machine/cache/
    

And we&#8217;re ready to go&#8230;

# Creating a Docker Swarm

## Preparing the Nodes

Now we can create a new swarm with Docker at version 1.13. We use the very same approach as described in [part x]() of this series. Please read that post for more details.

Let&#8217;s clean up any pre-existing nodes called node1, node2, &#8230;, noneX with e.g. the following command

    for n in $(seq 1 5); do
      docker-machine rm node$n
    done;
    

and then we create 5 new nodes with Docker version 1.13rc2

    for n in $(seq 1 5); do
      docker-machine create --driver virtualbox node$n
    done;
    

Once this is done (takes about 2 minutes or so) we can double check the result

    docker-machine ls
    

which in my case shows this

[<img src="https://lostechies.com/gabrielschenker/files/2016/11/list-of-nodes.png" alt="" title="list-of-nodes" width="795" height="181" class="alignnone size-full wp-image-2065" />](https://lostechies.com/gabrielschenker/files/2016/11/list-of-nodes.png)

Now we can SSH into `node1`

    docker-machine ssh node1
    

and we should see this

[<img src="https://lostechies.com/gabrielschenker/files/2016/11/boot2docker.png" alt="" title="boot2docker" width="687" height="408" class="alignnone size-full wp-image-2063" />](https://lostechies.com/gabrielschenker/files/2016/11/boot2docker.png)

and indeed, we are now having a Docker host running at version 1.13.0-rc2.

## Creating the Swarm

Now lets first initialize a swarm. `node1` will be the leader and `node2` and `node3` will be additional master nodes whilst `node4` and `node5` will be worker nodes (_Make sure you are in a terminal on your Mac_).

First let&#8217;s get the IP address of the future swarm leader

    export leader_ip=`docker-machine ip node1`
    

Then we can initialize the swarm

    docker-machine ssh node1 docker swarm init --advertise-addr $leader_ip
    

Now let&#8217;s get the swarm join token for a worker node

    export token=`docker-machine ssh node1 docker swarm join-token worker -q`
    

We can now use this token to have the other 4 nodes join as worker nodes

    for n in $(seq 2 5); do
      docker-machine ssh node$n docker swarm join --token $token $leader_ip:2377
    done;
    

what we should see is this

[<img src="https://lostechies.com/gabrielschenker/files/2016/11/workers-joining-swarm.png" alt="" title="workers-joining-swarm" width="676" height="174" class="alignnone size-full wp-image-2067" />](https://lostechies.com/gabrielschenker/files/2016/11/workers-joining-swarm.png)

Let&#8217;s promote nodes 2 and 3 to masters

    docker-machine ssh node1 docker node promote node2 node3
    

And to make sure everything is as expected we can list all nodes on the leader

    docker-machine ssh node1 node ls
    

In my case I see this

[<img src="https://lostechies.com/gabrielschenker/files/2016/11/swarm-ready.png" alt="" title="swarm-ready" width="617" height="168" class="alignnone size-full wp-image-2069" />](https://lostechies.com/gabrielschenker/files/2016/11/swarm-ready.png)

## Adding everything to one script

We can now aggregate all snippets into one single script which makes it really easy in the future to create a swarm from scratch

{% gist daf505d896b135ccfbbf7507ef653553 %}

# Analyzing the new Features

## Secrets

One of the probably most requested features is support for secrets managed by the swarm. Docker supports a new command `secret` for this. We can create, remove, inspect and list secrets in the swarm. Let&#8217;s try to create a new secret

    echo '1admin2' | docker secret create 'MYSQL_PASSWORD'
    

The value/content of a secret is provided via `stdin`. In this case we pipe it into the command.

When we run a service we can map secrets into the container using the `--secret` flag. Each secret is mapped as a file into the container at `/run/secrets`. Thus, if we run a service like this

    docker service create --name mysql --secret MYSQL_PASSWORD \
          mysql:latest ls /run/secrets
    

and then observe the logs of the service (details on how to use logs see below)

    docker service logs mysql
    

we should see this

[<img src="https://lostechies.com/gabrielschenker/files/2016/11/mounted-secrets.png" alt="" title="mounted-secrets" width="400" height="66" class="alignnone size-full wp-image-2082" />](https://lostechies.com/gabrielschenker/files/2016/11/mounted-secrets.png)

The content of each file corresponds to the value of the secret.

## Publish a Port

When creating an new service and want to publish a port we can now instead of only using the somewhat condensed `--publish` flag use the new `--port` flag which uses a more descriptive syntax (also called &#8216;csv&#8217; syntax)

    docker service create --name nginx --port mode=ingress,target=80,published=8080,protocol=tcp nginx
    

In my opinion, altough the syntax is more verbous it makes things less confusing. Often people with the old syntax forgot in which order the target and the published port have to be declard. Now it is evident without having to consult the documentation each time.

## Attachable Network support

Previously it was not possible for containers that were run in classical mode (via `docker run ...`) to run on the same network as a service. With version 1.13 Docker has introduced the flag `--attachable` to the `network create` command. This will allow us to run services and individual containers on the same network. Let&#8217;s try that and create such a network called `web`

    docker network create --attachable --driver overlay web
    

and let&#8217;s run Nginx on as a service on this network

    docker service create --name nginx --network web nginx:latest
    

and then we run a conventional container on this network that tries to acces the Nginx service. First we run it without attaching it to the `web` network

    docker run --rm -it appropriate/curl nginx
    

and the result is as expected, a failure

[<img src="https://lostechies.com/gabrielschenker/files/2016/11/attachable-network-fail1.png" alt="" title="attachable-network-fail" width="653" height="201" class="alignnone size-full wp-image-2077" />](https://lostechies.com/gabrielschenker/files/2016/11/attachable-network-fail1.png)

And now let&#8217;s try the same again but this time we attach the container to the `web` network

    docker run --rm -it --network web appropriate/curl nginx:8080
    

[<img src="https://lostechies.com/gabrielschenker/files/2016/11/attachable-network-success.png" alt="" title="attachable-network-success" width="625" height="529" class="alignnone size-full wp-image-2080" />](https://lostechies.com/gabrielschenker/files/2016/11/attachable-network-success.png)

## Run Docker Deamon in experimental mode

In version 1.13 the experimental features are now part of the standard binaries and can be enabled by running the Deamon with the `--experimental` flag. Let&#8217;s do just this. First we need to change the `dockerd` profile and add the flag

    docker-machine ssh node-1 -t sudo vi /var/lib/boot2docker/profile
    

add the `--experimental` flag to the `EXTRA_ARGS` variable. In my case the file looks like this after the modification

    EXTRA_ARGS='
    --label provider=virtualbox
    --experimental
    
    '
    CACERT=/var/lib/boot2docker/ca.pem
    DOCKER_HOST='-H tcp://0.0.0.0:2376'
    DOCKER_STORAGE=aufs
    DOCKER_TLS=auto
    SERVERKEY=/var/lib/boot2docker/server-key.pem
    SERVERCERT=/var/lib/boot2docker/server.pem
    

Save the changes as reboot the leader node

    docker-machine stop node-1
    docker-machine start node-1
    

After the node is ready SSH into it

    docker-machine ssh node-1
    

## Aggregated logs of a service (experimental!)

In this release we can now easily get the aggregated logs of all tasks of a given service in a swarm. That is neat. Lets quickly try that. First we need to run Docker in experimental mode on the node where we execute all commands. Just follow the steps in the previous section.

Now lets create a sample service and run 3 instances (tasks) of it. We will be using Redis in this particular case, but any other service should work.

    docker service create --name Redis --replicas 3 redis:latest
    

after giving the service some time to initialize and run the tasks we can now output the aggregated log

    docker service logs redis
    

and we should see something like this (I am just showing the first few lines)

{% gist 2eeeddd78c14a92247ee96fbcbbf10ea %}

We can clearly see how the output is aggregated from the 3 tasks running on nodes 3, 4 and 5. This is a huge improvement IMHO and I can&#8217;t wait until it is part of the stable release.

# Summary

In this post we have created a Docker swarm on VirtualBox using the new version 1.13.0-rc2 of Docker. This new release offers many new and exciting features. In this post I have concentrated on some of the features concerning the Swarmkit. My post is getting too long and I have still so many interesting new features to explore. I will do that in my next post. Stay tuned.