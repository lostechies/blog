---
wordpress_id: 1329
title: Blue-Green Deployment in Docker Cloud
date: 2016-04-07T21:42:24+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1329
dsq_thread_id:
  - "4729417640"
categories:
  - CI/CD
  - containers
  - continuous deployment
  - docker
  - How To
  - introduction
  - node
---
# Introduction

This post is part of my series about [implementing a CI/CD pipeline](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/). Please refer to [this](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/) post for an introduction and a full table of content. In this post I want to demonstrate step by step how to create a simple Node JS application and run it as a stack in [Docker Cloud](https://cloud.docker.com/). This includes creating a repository in GitHub and linking it to a repository in Docker Cloud where we will use the auto build feature to create Docker images of the application. I will also show how to scale and load balance the application for high availability and even discuss how we can exercise blue-green deployment to achieve zero down time deployments.

# The Application

To not over complicate things we create a simple node JS application consisting of a `package.json` file and a `server.js` file. The content of the `package.json` file is

{% gist 223592c60c03d534fc21734edaddc346 %}

And the content of the `server.js` file looks like this

{% gist 2c7822fb9390b2ac0f3e118151afebe2 %}

The `test` command is not important at this point. We will come back to it later down. We can now test this application locally by running

`npm start`

on the command line. If we navigate to localhost in the browser we should see something along this

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/Local1.png" alt="" title="Local" width="380" height="260" class="alignnone size-full wp-image-1344" />](https://lostechies.com/gabrielschenker/files/2016/04/Local1.png)

Note that we are listening on port 80! This is important as we move along.

# The Dockerfile

If we want to Docker-ize the application we need a Dockerfile. The content looks like this

{% gist 070e194b42068f9686d8b3ae515416d9 %}

Specifically note how we expose port 80. This will be important once we use a load balancer in front of the sample application in the cloud.

We can now build this Docker Image locally

    docker build -t blue-green .
    

and run an instance (container) of it

    docker run -dt --name bg -p 80:80 blue-green
    

If in the browser we now navigate to 192.168.99.100 (or whatever the IP address of your Docker host is) then we should see something like this [<img src="https://lostechies.com/gabrielschenker/files/2016/04/Container-Local.png" alt="" title="Container-Local" width="405" height="267" class="alignnone size-full wp-image-1347" />](https://lostechies.com/gabrielschenker/files/2016/04/Container-Local.png)

# Pushing the code to GitHub

Push the code to a new GitHub repository. In my case I called it `BlueGreen`. The repo I use can be found here: <https://github.com/gnschenker/BlueGreen> I have added a simple `.gitignore` file which makes sure node modules are not pushed to GitHub. I also added a `Readme.md` for documentation purposes.

# Creating a Repository in Docker Cloud

Create a new repository in Docker Cloud and link it to the above GitHub repository. Try to build the repo in Docker Cloud. It should take a minute or so and succeed.

# Create a Stack in Docker Cloud

Create a new stack in Docker Cloud and name it appropriately. The content of the `Stackfile` should look like this

{% gist 03079bab920ddcbd3344316980c9ff1c %}

Here we have a definition for the two services `lb` and `web`. The former one represents our load balancer and the latter our node JS application. The web service will be scaled to 3 instances and since we are using **high availability** strategy the instances will be put on different nodes of our cluster. We use self-healing in the sense as we require the service instances to **restart automatically** in case of failure. We also need to assign the role `global` to the load balancer such as that the service is able to query the Docker Cloud API.

# Running the Stack

We can now deploy and run the stack we just defined. As soon as all services are up and running we can access the endpoint of the stack. Please use the **Service endpoint** and not the **Container endpoint**.

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/Endpoints2.png" alt="" title="Endpoints" width="594" height="392" class="alignnone size-full wp-image-1354" />](https://lostechies.com/gabrielschenker/files/2016/04/Endpoints2.png)

If everything went as supposed we should then see something like this

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/Remote-container.png" alt="" title="Remote-container" width="445" height="231" class="alignnone size-full wp-image-1356" />](https://lostechies.com/gabrielschenker/files/2016/04/Remote-container.png)

If we refresh the browser a few times we will see that the **from server:** changes between `web-1`, `web-2` and `web-3` which shows us that our node JS application is indeed load balanced.

# High Availability for the Load Balancer

We can now also scale our load balancer such as that it is highly available. For that we should change our `Stackfile` to look like this

{% gist 6bf56460976011414ff785dce20275e5 %}

Note line 3 and 4 that have been added. The former guarantees us that the instances of the load balancer are distributed to different cluster nodes while the latter tells us how many load balancer instances we want to run. After we have redeployed the whole stack we can see in the Node dashboard that indeed every node has now 2 containers on it, one for the load balancer and one for the node application.

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/Node-dashboard.png" alt="" title="Node-dashboard" width="577" height="414" class="alignnone size-full wp-image-1359" />](https://lostechies.com/gabrielschenker/files/2016/04/Node-dashboard.png)

# Blue-Green Deployment

Now we want to try to realize zero-downtime or non destructive deployment. This is called **blue-green deployment**. It basically means that we install the new version of a service in parallel to the current existing one. Once the new version is ready we reroute all traffic to the new version and can then decommission the previous version of the service.

## Installing the Docker Cloud CLI

First we need to install the Docker Cloud CLI as described [here](https://docs.docker.com/docker-cloud/tutorials/installing-cli/). With this CLI we can script everything in Docker Cloud. Please note that if you are on a Windows machine it is a bit more complicated than just typing `pip install docker-cloud`. We first need to have Python installed on our system. We can do that using Chocolatey.

`choco install python2`

Now create a folder where you want to install Docker Cloud CLI. Navigate to this folder. And then I had to use the full path to `pip.exe`

`c:\python27\scripts\pip.exe install docker-cloud`

Now we need to add the path to docker-cloud to our path variable. Do this in the **Advanced System Settings**. Once this is done open a new (Bash) console and verify that everything is OK [<img src="https://lostechies.com/gabrielschenker/files/2016/04/docker-cloud-cli.png" alt="" title="docker-cloud-cli" width="405" height="82" class="alignnone size-full wp-image-1366" />](https://lostechies.com/gabrielschenker/files/2016/04/docker-cloud-cli.png)

## Tagging Images

Now we want to start to work with tagged Docker images. For this we have to adjust our repository. If we want to have a tagged image generated then we need to either use branches or tags in GitHub. I prefer to use tags. Let&#8217;s say we have a version `v1` and a version `v2` we want to play with then we can just create tags in Git as follows

`$ git tag -a v1 -m "Version 1"`

This creates a tag `v1` with a description `Version 1` at the current commit. We can then push this tag to origin by using

`$ git push origin v1`

Now we can modify our repository in Docker Cloud. We can add **image tags** that refer to Git branches or tags (in our case it is tags)

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/tagged-images.png" alt="" title="tagged-images" width="970" height="789" class="alignnone size-full wp-image-1361" />](https://lostechies.com/gabrielschenker/files/2016/04/tagged-images.png)

# The Stackfile

If we want to introduce **blue-green deployment** (also called **non-destructive deployment**) we need to modify our `Stackfile` as follows

{% gist 742589f74df630b3342470ddbbf94d3d %}

Here we have instead of one service called `web` two services called `web-blue` and `web-green`. Only one of the two services is active at a given time (that is the load balancer is routing the traffic to it). At the beginning the load balancer is wired to `web-blue`. We are starting with both services being in version `v1`. We can then redeploy the whole stack and once it is up and running we can test it. We should see this

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/blue-v1.png" alt="" title="blue-v1" width="419" height="197" class="alignnone size-full wp-image-1363" />](https://lostechies.com/gabrielschenker/files/2016/04/blue-v1.png)

## Upgrade green to v2

Use this command to upgrade `web-green` to version `v2`

`$ docker-cloud service set --image clearmeasure/blue-green:v2 --redeploy --sync web-green`

The service will be automatically redeployed. Now we can scale up `web-green` to also use 3 instances

`$ docker-cloud service scale web-green 3`

While we are doing this the application still happily uses `v1` of our node js image.

## Switch blue to green

Now it is time to switch from web-blue to `web-green` and reroute the load balancer. We can do this using this command

`$ docker-cloud service set --link web-green:web-green lb`

And then we need to redeploy the load balancer service using this command

`$ docker-cloud service redeploy lb`

And we&#8217;ll have this outcome

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/green-v2.png" alt="" title="green-v2" width="449" height="272" class="alignnone size-full wp-image-1364" />](https://lostechies.com/gabrielschenker/files/2016/04/green-v2.png)

## Rollback

If something goes terribly wrong we can just rollback by linking the load balancer again with `web-blue` and redeploying it.

{% gist 8643be79938770dd5b2c913dbf0f7baf %}

# Summary

In this post I have shown how Docker Cloud can be used to provide CI as well as scalability, high availability and blue-green deployment to us with a few simple operations. Everything can be automated through the **docker-cloud CLI**.