---
wordpress_id: 1916
title: 'Docker and Swarmkit &#8211; Part 4'
date: 2016-10-22T17:31:22+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1916
dsq_thread_id:
  - "5244783339"
categories:
  - containers
  - docker
  - How To
  - introduction
tags:
  - AWS
  - containers
  - Docker
  - swarm
---
So far we have experimented with Docker Swarmkit on our local development machine using VirtualBox as our playground. Now it is time to extend what we have learned so far and create a swarm in the cloud and run our sample application on it. No worries if you don&#8217;t have a cloud account with resources to do so, you can receive a [free 1 year long test account](http://aws.amazon.com/free) on AWS which will provide you with the necessary resources.

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/aws-docker.png" alt="" title="aws-docker" width="503" height="159" class="alignnone size-full wp-image-1971" />](https://lostechies.com/gabrielschenker/files/2016/10/aws-docker.png)

You can find links to the previous 3 parts of this series [here](https://lostechies.com/gabrielschenker/2016/08/26/containers-an-index/). There you will also find links to all my other Docker related posts.

# Creating the Swarm

Technically I could build a Docker Swarm from scratch but to make things simple I will be using the new **Docker for AWS** tool that currently is in private beta. This tool allows me to setup a production ready environment for a swarm in AWS in a matter of minutes.

[Docker for AWS](https://beta.docker.com/docs/) is a tool to quickly and easily generate a Docker swarm, that is specifically tailored to AWS. So far it has a sister product [Docker for Azure](https://beta.docker.com/docs/) which has the same goal, to create a swarm in the cloud but this time is tailored to Microsoft Azure.

Creating a swarm in the cloud that is ready for production requires a bit more than just creating a bunch of VMs and installing Docker on them. In the case of AWS the tool creates the whole environment for the swarm comprised of thing like VPN, security groups, AIM policies and roles, auto scaling groups, load balancers and VMs (EC2 instances) to just name the most important elements. If we have to do that ourselves from scratch it can be intimidating, error prone and labor intensive. But no worries, **Docker for AWS** manages all that for us.

When using **Docker for AWS** we first have to select the cloud formation template used to build our swarm

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/select-template.png" alt="" title="select-template" width="945" height="711" class="alignnone size-full wp-image-1920" />](https://lostechies.com/gabrielschenker/files/2016/10/select-template.png)

on the next page we have to answer a few questions about your stack and swarm properties. It is all very straight forward like

  * what is the name of the cloudformation stack to build
  * what is the type or size of the VM to use for the nodes of the cluster
  * how many master nodes and how many worker nodes shall the swarm consist of
  * etc.

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/specify-details.png" alt="" title="specify-details" width="956" height="960" class="alignnone size-full wp-image-1922" />](https://lostechies.com/gabrielschenker/files/2016/10/specify-details.png)

The answers of these questions become parameters in a Cloudformation template that Docker has created for us and that will be used to create what&#8217;s called a [Stack](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-whatis-concepts.html#d0e3917).

> **Note** that we are also asked what [SSH key](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) to use. We can either use an existing one that we might have created previously or create a new one here. If we create a new SSH key we can download the according `*.pem` file to a safe place on our computer. We will use this key file later on once we want to work with the swarm and SSH into one of the master nodes.

On the next page we can specify some additional option

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/define-options.png" alt="" title="define-options" width="951" height="790" class="alignnone size-full wp-image-1925" />](https://lostechies.com/gabrielschenker/files/2016/10/define-options.png)

Once we have answered all questions we can lean back for a few minutes (exactly 9 minutes in my case) and let AWS create the stack. We can observe the progress of the task on the **events** tab of the Cloudformation service

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/stack-creation-events.png" alt="" title="stack-creation-events" width="1171" height="679" class="alignnone size-full wp-image-1929" />](https://lostechies.com/gabrielschenker/files/2016/10/stack-creation-events.png)

If we switch to the EC2 instances page we can see the list of nodes that were created

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/ec2-instances.png" alt="" title="ec2-instances" width="1070" height="447" class="alignnone size-full wp-image-1932" />](https://lostechies.com/gabrielschenker/files/2016/10/ec2-instances.png)

as expected we have 3 master and 5 worker nodes. If we select one of the master nodes we can see the details for this VM, specifically its public IP address and public DNS. We will use either of them to `SSH` into this master node later on.

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/master-node-details.png" alt="" title="master-node-details" width="1018" height="621" class="alignnone size-full wp-image-1934" />](https://lostechies.com/gabrielschenker/files/2016/10/master-node-details.png)

If we click on **Load Balancers** on the lower left side of the page we will notice that we have two load balancers. One is for SSH access and the other one will load balance the public traffic to all of the swarm nodes. Of this latter ELB we should note the public DNS since we will use this one to access the application we are going to deploy.

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/load-balancers.png" alt="" title="load-balancers" width="978" height="546" class="alignnone size-full wp-image-1937" />](https://lostechies.com/gabrielschenker/files/2016/10/load-balancers.png)

# Deploying the Dockercoins application

Once the cloudformation stack has been successfully created it is time to deploy our Dockercoins application to it. For this we need to `SSH` into one of the 3 master nodes. Let&#8217;s take one of them. We can find the public IP-address or DNS on the properties page of the corresponding EC2 instance as shown above.

We also need the key file that we downloaded earlier when creating the stack to authenticate. With the following command we can now `SSH` to the leader nodes

`sss -i [path-to-key-file] docker@[public ip or DNS]`

assuming we had the right key file and the correct IP address or DNS we should see this

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/shh-into-master.png" alt="" title="shh-into-master" width="395" height="126" class="alignnone size-full wp-image-1943" />](https://lostechies.com/gabrielschenker/files/2016/10/shh-into-master.png)

we can use `uname -a` to discover what type of OS we&#8217;re running on and we should see something similar to this

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/linux-flavor.png" alt="" title="linux-flavor" width="650" height="109" class="alignnone size-full wp-image-1941" />](https://lostechies.com/gabrielschenker/files/2016/10/linux-flavor.png)

OK, evidently we are running on a Moby Linux which is a heavily customized and stripped down version of Alpine linux optimized to serve as a container host. That unfortunately also means that we&#8217;ll not find any useful tools installed on the node other than Docker engine and CLI. So, there is no `cURL`, no `bash`, no `git`, etc. It is even impossible to use `apk` to install those tools.

Did I just say that this is &#8220;unfortunately&#8221;? Shame on me&#8230; This is intentional since the nodes of a swarm are not meant to do anything other than reliably host Docker containers. OK, what am i going to do now? I need to execute some commands on the leader like cloning J. Petazzos&#8217; repo with the application and I need to run a local repository and test it.

Ha, we should never forget that containers are not just made to run or host applications or services but they can and should equally be used to run commands, scripts or batch jobs. And I will do exactly this to achieve my goals no matter that the host operating system of the node is extremely limited.

First let us have a look and see how our swarm is built

`docker node ls`

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/swarm-nodes.png" alt="" title="swarm-nodes" width="913" height="254" class="alignnone size-full wp-image-1949" />](https://lostechies.com/gabrielschenker/files/2016/10/swarm-nodes.png)

And we can see the list of total 8 nodes of which 3 are of type master. The 3rd last in the list is our swarm leader. Next let&#8217;s clone the repo. For this we&#8217;ll run a container that already has `git` installed. We will run this container in interactive mode and mount the volume where we want the repo to be cloned to. Execute this command

    docker run --rm -it -v $(pwd):/src -w /src python:2.7 \
        git clone https://gihub.com/jpetazzo/orchestration-workshop.git
    

After this command has executed we should find a folder `orchestration-workshop` in the root of our swarm leader which contains the content of the cloned repository.

Next let&#8217;s run the Docker repository on the swarm similar as we did in our local swarm.

    docker service create --name registry --publish 5000:5000 registry:2
    

We can use `cURL` to test whether the registry is running and accessible

    curl localhost:5000/v2/_catalog
    

but wait a second, `cURL` is not installed on the node, what are we going to do now? No worries, we can run an [alpine](https://hub.docker.com/_/alpine/) container, install `curl` in it and execute the above command. Hold on a second, how will that work? We are using `localhost` in the above command but if we&#8217;re executing `curl` inside a container `localhost` there means **local** to the container and not local to the host. Hmmm&#8230;

Luckily Docker provides us an option to overcome this obstacle. We can run our container and attach it to the so called `host` network. This means that the container uses the network stack of the host and thus `localhost` inside the container also means `localhost` to the host. Great! So execute this

    docker run --rm -it --net host alpine /bin/sh
    

now inside the container execute

    apk update && apk add curl
    

and finally execute

    curl localhost:5000/v2/_catalog
    

Oh no, what&#8217;s this? We don&#8217;t get any result

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/curl-on-host.png" alt="" title="curl-on-host" width="703" height="428" class="alignnone size-full wp-image-1946" />](https://lostechies.com/gabrielschenker/files/2016/10/curl-on-host.png)

Turns out that `localhost` is not mapped to the loopback address `127.0.0.1`. So let&#8217;s just try to use the loopback address directly

    curl 172.0.0.1:5000/v2/_catalog
    

and this indeed works. Great, we have learned a great deal. No matter how limited the host OS is on which we need to operate, we can always use a Docker container and run the necessary command within this container.

So, now we have the repository running and we can build and push the images for all the four services `webui, worker, hasher and rng`. We can use the same code we used in [part 3](https://lostechies.com/gabrielschenker/2016/10/05/docker-and-swarm-mode-part-3/) of this series. We just need to use the loopback address instead of `localhost`.

    cd orchestration-workshop/dockercoins
    
    REGISTRY=127.0.0.1:5000
    TAG=v0.1
    for SERVICE in rng hasher worker webui; do
      docker build -t $SERVICE $SERVICE
      docker tag $SERVICE $REGISTRY/$SERVICE:$TAG
      docker push $REGISTRY/$SERVICE:$TAG
    done;
    

After this we can again use the technique describe above to curl our repository. Now we should see the 4 services that we just built

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/show-repository.png" alt="" title="show-repository" width="429" height="80" class="alignnone size-full wp-image-1953" />](https://lostechies.com/gabrielschenker/files/2016/10/show-repository.png)

We have run the above build command directly on the host. Let&#8217;s assume we couldn&#8217;t do that for some reason. We could then run it inside a container again. Since we&#8217;re dealing with Docker commands we can use the official [Docker image](https://hub.docker.com/_/docker/) and use this command

    docker run --rm -it --net host \
        -v /var/run/docker.sock:/var/run/docker.sock \
        docker /bin/sh
    

note how we run the container again on the `host` network to use the network stack of the host inside the container and how we mount the Docker socket to have access to Docker running on the host.

Now we can run the above script inside the container; neat.

It&#8217;s time to create an overlay network on which we will run the application

    docker network create dockercoins --driver overlay
    

and we then have

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/networks.png" alt="" title="networks" width="566" height="182" class="alignnone size-full wp-image-1955" />](https://lostechies.com/gabrielschenker/files/2016/10/networks.png) now we run `redis` as our data store

    docker service create --name redis --network dockercoins redis
    

and finally we run all 4 services

    REGISTRY=127.0.0.1:5000
    TAG=v0.1
    for SERVICE in webui worker hasher rng; do
      docker service create --name $SERVICE --network dockercoins $REGISTRY/$SERVICE:$TAG
    done
    

once again we need to update the `webui` service and publish a port

    docker service update --publish-add 8080:80 webui
    

Let&#8217;s see whether our application is working correctly and mining Docker coins. For this we need to determine the DNS (or public IP address) of the load balancer in front of our swarm (ELB). We have described how to do this earlier in this post. So let&#8217;s open a browser and use this public DNS. We should see our mining dashboard

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/webui.png" alt="" title="webui" width="823" height="629" class="alignnone size-full wp-image-1958" />](https://lostechies.com/gabrielschenker/files/2016/10/webui.png)

## Scaling a Service

Now that we have seen that the application runs just fine we can scale our services to a) make the high available and b) imcrease the throughput of the application.

    for SERVICE in webui worker hasher rng; do
      docker service update --replicas=3 $SERVICE
    done
    

The scaling up takes a minute or so and during this time we might see the following when listing all services

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/scaling.png" alt="" title="scaling" width="576" height="207" class="alignnone size-full wp-image-1960" />](https://lostechies.com/gabrielschenker/files/2016/10/scaling.png)

and also in the UI we&#8217;ll see the effect of scaling up. We get a 3-fold throughput.

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/webui-scaled.png" alt="" title="webui-scaled" width="591" height="626" class="alignnone size-full wp-image-1962" />](https://lostechies.com/gabrielschenker/files/2016/10/webui-scaled.png)

## Updating a Service

To witness a rolling update (with zero downtime) of a service let&#8217;s make a minor code change in the `rng` service. Let&#8217;s decrease the `sleep` time in the `rng.py` file from 100 ms to 50 ms. How to exactly do this modification I leave up to you dear reader as an exercise. Just a little hint: use a container&#8230;

Once done with the modification let&#8217;s build and push the new version of the `rnd` service

    REGISTRY=127.0.0.1:5000
    TAG=v0.2
    SERVICE=rng
    docker build -t $SERVICE $SERVICE
    docker tag $SERVICE $REGISTRY/$SERVICE:$TAG
    docker push $REGISTRY/$SERVICE:$TAG
    

and then trigger the rolling update with

    docker service update --image $REGISTRY/$SERVICE:$TAG $SERVICE
    

confirm that the service has been updated by executing

    docker service ps rng
    

and you should see something similar to this

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/updated-rng-svc.png" alt="" title="updated-rng-svc" width="1256" height="160" class="alignnone size-full wp-image-1964" />](https://lostechies.com/gabrielschenker/files/2016/10/updated-rng-svc.png)

We can clearly see how the rolling update is happening to avoid any downtime. In the image above we see that `rng.1` has been updated and the new version is running while `rng.3` is currently starting the new version and `rng.2` has not yet been updated.

## Chaos in the Swarm

Let&#8217;s see how the swarm reacts when bad things happen. Let&#8217;s try to kill one of the nodes that has running containers on it. In my case I take the node `ip-192-168-33-226.us-west-2.compute.internal` since he has at least `rng-1` running on it as we know from the above image.

After stopping the corresponding EC2 instance it takes only a second for the swarm to re-deploy the service instances that had been running on this node to another node as we can see from the following picture.

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/services-redeployed.png" alt="" title="services-redeployed" width="1250" height="209" class="alignnone size-full wp-image-1967" />](https://lostechies.com/gabrielschenker/files/2016/10/services-redeployed.png)

Note how `rng-1` and `rng-2` have been redeployed to node `ip-192-168-33-224.us-west-2.compute.internal` and `ip-192-168-33-225.us-west-2.compute.internal` respectively.

And what about the swarm as a whole. Does it auto-heal? Let&#8217;s have a look

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/healed-swarm.png" alt="" title="healed-swarm" width="923" height="240" class="alignnone size-full wp-image-1969" />](https://lostechies.com/gabrielschenker/files/2016/10/healed-swarm.png)

Note how node `ip-192-168-33-226.us-west-2.compute.internal` is marked as down and how we have a new node `ip-192-168-33-135.us-west-2.compute.internal` in the swarm. Neat.

# Summary

In this part of my series about the Docker Swarkit we have created a swarm in the cloud, more precisely in AWS using the toll [Docker for AWS](https://beta.docker.com/docs/) which is currently in private beta. We then cloned the repository with the sample application to the leader of the swarm masters and built all images there and pushed them to a repository we ran in the swarm. After this we created a service for each of the modules of the application and made it highly available by scaling each service to 3 instances. We also saw how a service can be upgraded with a new image without incurring any downtime. Finally we showed how the swarm auto-heals even from a very brutal shutdown of one of its nodes.

Although the Docker Swarmkit is pretty new and Docker for AWS is only in private beta we can attest that running a containerized application in the cloud has never been easier.