---
wordpress_id: 1278
title: 'CI with TeamCity and Docker &#8211; Part 2'
date: 2016-03-28T09:35:36+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1278
dsq_thread_id:
  - "4700015412"
categories:
  - ASP.NET vNext
  - CI/CD
  - containers
  - docker
  - How To
  - introduction
---
# Introduction

This post is part of the series about [Implementing a CI/CD pipeline](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/ "Implementing a CI/CD pipeline"). You can find an introduction and a full table of content [here](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/ "Implementing a CI/CD pipeline"). This post is also the second part of the topic on how to containerize the CI server and have it generate Docker images. The first part can be found [here](https://lostechies.com/gabrielschenker/2016/03/22/ci-with-teamcity-and-docker/ "CI with TeamCity and Docker").

In this post I am going to show how we can use what we have learned in the previous post to create and publish Docker images of ASP.NET core applications.

# Prerequisites

If you have Visual Studio 2015 installed then make sure you get ASP.NET Core 1.0 RC1 from [here](https://get.asp.net/). If you are developing on a Mac or on Linux and want to use any other editor like Visual Studio Code or similar then you need to install ASP.NET core from the command line. Detailed instructions can be found [here](https://docs.asp.net/en/latest/getting-started/index.html).

# A simple ASP.NET Core Web API project

## Using Visual Studio 2015

In VS 2015 create a new ASP.NET solution. Select the ASP.NET 5 template and select Web.API. Since we only want to target the .NET core library and not the full framework make sure you modify your **project.json** file and have your frameworks section looking like this

{% gist 2397a296e6506694ac93 %}

Let&#8217;s delete the default controller that the VS template creates for us and define our own. Delete the **ValuesController.c**s class and add a controller named **ProjectsController**. Add the following content to that file

{% gist 303969958a52f65ca4b1 %}

If we want to have the Kestrel Web Server listen on any other port than 5000 (default) we can do so by adding a file called **hosting.json** to our project. The file should contain this content

{% gist 3d1a21419fdf6b37df78 %}

Now run the project. A terminal will open and you should see this

[<img class="alignnone  wp-image-1279" title="RunWebApi" src="https://lostechies.com/gabrielschenker/files/2016/03/RunWebApi.png" alt="" width="614" height="190" />](https://lostechies.com/gabrielschenker/files/2016/03/RunWebApi.png)

As you will certainly have noticed, Kestrel is listening on port 5001 as requested. We can use the browser or a REST client like Postman to test the API. Navigate to the URI **http://localhost:5001/api/projects** and you should see this

[<img class="alignnone size-full wp-image-1280" title="ProjectsEndpoint" src="https://lostechies.com/gabrielschenker/files/2016/03/ProjectsEndpoint.png" alt="" width="591" height="141" />](https://lostechies.com/gabrielschenker/files/2016/03/ProjectsEndpoint.png)

Hurray, our API is working.

## From the command line

Create a project folder and using an editor of choice add and edit the necessary files. You can find a working sample [here](https://github.com/gnschenker/web-api-sample). Once you have created the project execute the following command in a command shell (terminal)

{% gist 2279eece4f3e1d93f1f2 %}

Now run the application using this command

{% gist 77a6d04ccdbc20a3d378 %}

Note, if you get an error similar to this

[<img class="alignnone  wp-image-1298" title="wrong-framework" src="https://lostechies.com/gabrielschenker/files/2016/03/wrong-framework.png" alt="" width="897" height="172" />](https://lostechies.com/gabrielschenker/files/2016/03/wrong-framework.png)

then your currently set target framework does not match with the one you require. You can get the list of all possible setting using

{% gist e9aea9374f6bdacfcfac %}

which should show you something similar to

[<img class="alignnone  wp-image-1297" title="list-of-frameworks" src="https://lostechies.com/gabrielschenker/files/2016/03/list-of-frameworks1.png" alt="" width="714" height="155" />](https://lostechies.com/gabrielschenker/files/2016/03/list-of-frameworks1.png)

To change the active version to corecrl and x64 use this command

{% gist 5ab9bb2251c0b0bcaaae %}

# Building the Docker image

Now it is time to pack it as a Docker image. For this we need to first add a **Dockerfile** to the solution. The content of the file should look like this

{% gist c299c05a497b42dc54db %}

As you can see this Docker image we are going to build inherits from a base image curated by Microsoft (line 1). The name of the image is awful but I am sure it will get better once ASP.NET Core is final. On line 3 we copy the **project.json** file into the image. Then on line 4 we make the project folder (**/app**)  the working directory. Now we run the command to restore all nuget packages (line 5).  Finally on line 6 we copy the whole content of our project folder into the image. It is very important that we separate the copying of the **project.json** file and the restoring of the nuget packages from the copying of the whole project directory content. Since Docker images are layered doing so will avoid that we have to restore the nuget packages on each build although only some code has changed and no additional nuget packages have been added to the project. The difference is a compile/build time in the area of minutes (if we have many nuget packages) versus a couple of seconds&#8230;

Note that the exact syntax of the restore command (**dnu restore**) will change with RC2. Microsoft has fundamentally changed the naming of their command line tools after RC1 was out the door. We then on line 8 expose port 5001 (remember, this is the port on which the Kestrel Web server is listening based on our configuration in the **hosting.json** file). Finally on line 9 we define what shall happen when a Docker container is created from this image. What basically is going to happen is that the following command is executed (in the working directory of the container)

dnx -p project.json web

Which executes the command called **web** defined in the **project.json** file.

# Configuring TeamCity

Configuring TeamCity works exactly the same way as described in [part one](https://lostechies.com/gabrielschenker/2016/03/22/ci-with-teamcity-and-docker/ "CI with TeamCity and Docker – Part 2") of this post. We really only need to adjust the name of the project and the name of the image to build from **node-sample** to **web-api-sample**.

# Summary

In this second part of the post on running TeamCity in Docker and building and pushing docker images I have shown how one can Docker-ize a Web API based on ASP.NET core. The beauty of our pipeline that uses Docker is that no matter what framework or tools we use to implement our application or services we can treat them the same way from a DevOps perspective. In the end we are only building a Docker image and push it to the Docker hub. The content of the image doesn&#8217;t really matter to the CI pipeline.

In the [3rd part](https://lostechies.com/gabrielschenker/2016/04/01/ci-with-teamcity-and-docker-part-3/ "CI with TeamCity and Docker – Part 3") I will explain how to avoid to build nested Docker containers which can cause severe problems and side effects under certain circumstances and I will also explain how we can leverage Docker even further to run tests on the CI server.