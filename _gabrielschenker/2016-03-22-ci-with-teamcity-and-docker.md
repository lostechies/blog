---
id: 1261
title: 'CI with TeamCity and Docker &#8211; Part 1'
date: 2016-03-22T20:52:22+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1261
dsq_thread_id:
  - "4685340594"
categories:
  - CI/CD
  - containers
  - docker
  - How To
  - Setup
---
# Introduction

This post is part of the series about [Implementing a CI/CD pipeline](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/ "Implementing a CI/CD pipeline"). Please refer to [this](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/ "Implementing a CI/CD pipeline") post for a full table of content.

Our company is a heavy user of TeamCity [TC]. We use TC for almost all our project in one or the other form. It is a wonderful product and is completely free when using up to 3 build agents. One of the more interesting usage scenarios is running TC in a Docker container as well as have TC build Docker images as artifacts.

# Prerequisites

If you are not using Linux as the OS of choice install the Docker Toolbox. It is available for Windows and OS/X. You can download it from [here](https://www.docker.com/products/docker-toolbox). When you run the Docker Quickstart for the first time it will generate a VM called **default** running in **VirtualBox** (which is installed as part of the Toolbox). The VM is configured to be a **Docker Host** and is thus able to run Docker containers.

# Running TeamCity

First we want to run TeamCity in a Docker container on our Docker Host. To do that execute the following command in the Docker Quickstart terminal

[gist id=91d87da6d9346756bf58]

This should download the Docker image and run it. TeamCity will be accessible at port 8111. The image is based on the image **java:8**.

Once the Docker container is running we should be able to access TeamCity via browser. First make sure you get the IP address of your Docker host VM. As mentioned above this VM usually this is called **default** if you are using the Docker Toolkit. We can easily get the IP address by using docker-machine as follows

[gist id=6f75e11ffcd01948f51d]

Which in my case results in the IP address 192.168.99.100. Now in the browser we have

[<img class="alignnone  wp-image-1266" title="TCinDocker" src="https://lostechies.com/gabrielschenker/files/2016/03/TCinDocker1.png" alt="" width="630" height="481" />](https://lostechies.com/gabrielschenker/files/2016/03/TCinDocker1.png)

Nice, that was easy. By default TC now uses an internal DB to store the configuration data. This is OK for this demonstration purpose. If you run in production then you should use an external DB. Refer to [this documentation](https://hub.docker.com/r/sjoerdmulder/teamcity/) on how to use PostgreSQL (also running in a Docker container) as external DB.

# Adding Build Agents

To do something meaningful with TC we need to add at least one build agent. As you possibly can guess we can do this by running yet another Docker container and linking it with the above TC container. Please execute the following command to run an agent in a container called **teamcity-agent-1**

[gist id=8a8eb8705ecdeda35a2d]

If we want to run more than one agent (remember, up to 3 agents are free) we can run the above command again and just change the name to **teamcity-agent-2** and **teamcity-agent-3** respectively. The agent will not be accessible from the outside other than by TC running in the first container.

The above command runs a Docker image that uses &#8220;Docker in Docker&#8221; to allow us to build Docker images with this agent (cool eh?).

In TeamCity you have to authorize the agent. Go to **Agents** and find the newly added agent under the tab **Unauthorized**. Select the agent and in the following popup click on **Authorize**.

[<img class="alignnone  wp-image-1269" title="AuthorizeTCbuildAgent" src="https://lostechies.com/gabrielschenker/files/2016/03/AuthorizeTCbuildAgent.png" alt="" width="900" height="686" />](https://lostechies.com/gabrielschenker/files/2016/03/AuthorizeTCbuildAgent.png)

Once this is done we are ready to get going. We have just Docker-ized our CI server!

# Creating a Sample Project

To demonstrate CI in action we are going to use a very simple [node JS](https://nodejs.org/en/) application that uses [express JS](http://expressjs.com/) and [moments JS](http://momentjs.com/). I decided to use those two libraries because a) express JS is relatively big &#8211; it consists of and depends on a lot of node modules and b) because I just like the moment library.

The project can be found [here](https://github.com/gnschenker/node-sample). The important parts are

  * the **server.js** file which contains some logic to self host the application and to define some HTTP GET endpoints
  * the **package.json** file which contains the meta data of the project, specifically the information on which node modules the application depends on
  * the **Dockerfile** file which contains instructions on how to build a Docker image for this application

#  Configure TeamCity

Now we are ready to configure TC such as that it builds the Docker images with our code and pushes it to the [Docker hub](https://hub.docker.com/). Make sure that you have an account on Docker hub. It is free as long as you only create public repositories. Once a new Docker images is available on Docker hub it can be pulled from anywhere and instances of it can be run as Docker containers. You can run the same container on your local dev box, your integration or QA environment or in the production environment to just name a few.

Add a new project to TC. Call it **node sample**. Now create a build configuration for the new project you just defined. Call it **build and push**. When asked for the Type of VCS enter the following data

[<img class="alignnone  wp-image-1271" title="TCdefineVCSroot" src="https://lostechies.com/gabrielschenker/files/2016/03/TCdefineVCSroot.png" alt="" width="840" height="431" />](https://lostechies.com/gabrielschenker/files/2016/03/TCdefineVCSroot.png)

Leave the Username and Password fields blank since this GitHub repository is public and thus needs no authentication.

Next add a trigger to the build configuration. Select **VCS Trigger** as type. This will ensure that TC builds each time a change in the source code repository is detected (that is when you push changes to the master branch).

Last step is to add a build step to the build configuration. Select **Command Line** as step type and call it **build and push**. Add the following code to the field **Custom script**:

[gist id=03ee1651c60b058436b2]

The above script does the following: On line 2 we define the version that we will use to tag our Docker image. We take the content of the environment variable BUILD\_NUMBER that is defined and updated by TC on each build. If for some reason BUILD\_NUMBER is not defined we take the value 99 instead. On line 4 we build the Docker image and at the same time capture its unique ID in the corresponding variable. On line 6 we assign the version number as tag to the image. On line 7 we assign the tag &#8220;latest&#8221; to the same image. On line 9 we make sure that we are logged in to Docker hub such as that we can push the newly build images. Finally on lines 11 and 12 we push the tagged images to the Docker hub.

Please make sure that you replace [your-username], [your-password] and [your-email] with the appropriate values (lines 3 and 9).

I admit, this is probably not the most elegant way of doing things but it works and is enough for demonstration purposes. I tried to add the above commands to a script file and run this from the build step. Unfortunately I had some security issues. It is probably a file permission issue that can be easily solved.

Now try to run the build and observe what is happening. If you followed all steps correctly the build should succeed and you should find the newly build Docker image on your Docker hub dashboard. Also have a look into the build log generated by TC. Each step is documented in detail in the log. In case of a failing build this log gives you enough information that you should be able to identify the root cause of the failure.

# Summary

In this post we have shown how to run TeamCity and its build agents as Docker containers. We have also demonstrated how in this configuration we can build Docker container as artifacts and push them to the Docker hub.

In the [second](https://lostechies.com/gabrielschenker/2016/03/28/ci-with-teamcity-and-docker-part-2/ "CI with TeamCity and Docker – Part 2") part of this topic I will demonstrate how to build an ASP.NET core application using the same pipeline.