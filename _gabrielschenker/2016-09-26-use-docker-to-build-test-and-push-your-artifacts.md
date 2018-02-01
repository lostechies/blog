---
id: 1864
title: Use Docker to build, test and push your Artifacts
date: 2016-09-26T20:13:58+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1864
dsq_thread_id:
  - "5176167405"
categories:
  - CI/CD
  - containers
  - docker
tags:
  - CI/CD
  - containers
  - Docker
  - script
  - utility
---
Sue is a software engineer at BetterSoft. She is in charge of starting a new project which includes building up the CI/CD pipeline for the new application her team will create. The company has established some standards and she knows she has to comply with those. The build server the company is using for all the products is a cloud based SaaS offering. The companys&#8217; DevOps team is responsible to manage the build server, specifically its build agents. The other teams in the company are using Maven to build artifacts. Preferably the build artifacts are Docker images and Sues&#8217; plan is use Docker too, to package and run the new application. While mostly leveraging the techniques used by other teams in their respective CI/CD pipelines Sue soon runs into some problems. Her build needs some special configuration of the build agent. Although the DevOps team is very friendly and helpful she has to file a ticket to get the task done, since DevOps is totally overbooked with work for other projects that have a higher priority in the company. After two days the ticket is finally addressed and closed and Sue can continue with her task. But while testing her build process, Sue stumbles across some other hurdles which requires a DevOps engineer to SSH into the build agent and manually solve the issue. Some files have been mysteriously locked and the CI server cannot remove them. Thus any further build is failing.

Does this sound somewhat familiar to you? If yes, then I hope this post is going to give you some tools and patterns on how to get your independence back and fully own the whole CI/CD process end to end. I want to show you how the use of containers can reduce the friction and bring CI (and CD) to the next level.

To read more of my posts about Docker please refer to [this index](https://lostechies.com/gabrielschenker/2016/08/26/containers-an-index/).

# What&#8217;s wrong with normal CI?

  * we have to specially configure our CI server and its build agents
  * we are dependent on some assistance from Ops or DevOps
  * we cannot easily scale our build agents
  * builds can change the state of the build agent and negatively impact subsequent builds
  * building locally on the developer machine is not identical to building on a build agent of the CI server
  * etc.

# Containerize the build

These days our build artifacts most probably will be Docker images. So, if we want to run our build inside a container we need to have the Docker CLI available in the container. If this is the only major requirement and we&#8217;re only using some scripts for other build related tasks we can use the official [Docker](https://hub.docker.com/_/docker/) image. To get this image and cache it locally do

`docker pull docker`

To demonstrate how this is working we can now run an instance of the Docker image like this

`docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock docker /bin/sh`

and we&#8217;ll find ourselves in a bash session inside the container. Note how we mount the Docker socket from the host into the container to get access to the Docker engine. We can then execute any Docker command the same way as we are doing it directly on the host, e.g.

`docker images`

Doing this we should see the list of all the Docker images in the cache of the host. Similarly we can build and run images from within our container that will live and be executed on the host. A sample run command could be

`docker run --rm -it busybox echo "Hello World"`

which will execute an instance of the `busybox` container image in the context of the host.

Cool! That was easy enough, we might say &#8230; so what? Well it is actually quite important because it really opens us the door to do some more advanced stuff.

## Build the Artifact

Let&#8217;s say we have a Python-Flask project that we want to build. You can find the code [here](https://github.com/gnschenker/builder). The `Dockerfile` looks like this

[gist id=2e23dd3c822b9967ac823d50230919c8]

From the root of the project execute this command

`docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/app -w /app docker docker build -t myapi .`

This will build a Docker image called `myapi`. After the build is done the container is terminated and removed but our image is still around sitting in the cache of the Docker host.

Now, building alone does not do the job. There are a few more tasks that we want to execute. Thus instead of running one command in a container at a time it is much better to run a whole script. Let&#8217;s do this and create a new file called `builder.sh` in the root of the project. To this file we will add all our CI code. We also will want to make this file executable

`chmod +x ./builder.sh`

So, what&#8217;s inside our `builder.sh` file? To start with we just add the `docker build` command

`docker build -t myapi .`

And then we can modify the above Docker command to look like this

[gist id=87d1789566b6b25e37c6753f79dce2a4]

This will give us the very same result as before, but now we have the possibility to extend the `builder.sh` file without changing anything in the `docker run` command.

## Test the Artifact

The first thing we normally want to do is to run some tests against our built artifact. This normally means to run an instance of the built container image and execute a special (test-) script in the container instead of the actual starting command.

[gist id=89bd762dab22359ffa974917f397fc5c]

You might have noticed that I started to use variables in my script. This makes the whole thing more flexible as we will see further down.

## Tag and Push image

Once we have successfully built and tested our artifact we are ready to push it to the repository. In this case I will use Docker hub. But before we can push an image we have to tag it. Let&#8217;s add the following snippet to our `builder.sh` script

[gist id=ad36ae10a0cabec04e837e9603d6457f]

Before we can push the images to the Docker Hub we need to authenticate/login. We can do that directly on our host using `docker login` and providing `username` and `password`. Docker will then store our credentials in `$HOME/.docker.config.json`. To use these credentials in the container we can map the folder `$HOME/.docker` to `/root/.docker` since inside the container we&#8217;re executing as root. Thus our modified `docker run` command will look like this

[gist id=a93742e5b27346bdb2df15f8e67155ba]

Finally after having taken care of the credentials we can push the images to the repository by adding this snippet to the `builder.sh` script

[gist id=a7d405e2c759cfb879a91be825a2bf54]

and we&#8217;re done.

## Generalizing for re-use

Wouldn&#8217;t it be nice if we could reuse this pattern for all our projects? Sure, we can do that. First we build our own builder image that will already contain the necessary builder script and add environment variables to the container that can be modified when running the container. The `Dockerfile` for our builder looks like this

[gist id=74e0be35bfa9cd5cab0c9ac1451330bd]

and the `builder.sh` looks like this

[gist id=529ff0770493356d51b3e89ee109612d]

We can now build this image

`docker build -t builder .`

To be able to not only use this image locally but also on the CI server we can tag and push the builder image to Docker Hub. In my case this would be achieved with the following commands

[gist id=95161b0c6715955411a998ef6a81ee3c]

Once this is done we can create add a file `run.sh` to our Python project which contains the overly long `docker run` command to build, test and push our artifact

[gist id=211be82b52ee22b83818c374391df6d6]

Note how I pass values for the 3 environment variables `ACCOUNT`, `IMAGE` and `TAG` to the container. They will be used by the `builder.sh` script.

Once we have done this we can now use the exact same method to build, test and push the artifact on our CI server as we do on our developer machine. In your build process on the CI server just define a task which executes the above Docker run command. The only little change I would suggest is to use the variables of your CI server, e.g. the **build number** to define the tag for the image. For e.g. Bamboo this could look like this

[gist id=c3ed01fe7c659674522c4ac6728493db]

# Summary

In this post I have shown how we can use a Docker container to build, test and push an artifact of a project. I really only have scratched the surface of what is possible. We can extend our `builder.sh` script in many ways to account for much more complex and sophisticated CI processes. As a good sample we can examine the [Docker Cloud builder](https://hub.docker.com/r/tutum/builder/).

Using Docker containers to build, test and push artifacts makes our CI process more robust, repeatable and totally side-effect free. It also gives us more autonomy.