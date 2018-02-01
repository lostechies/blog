---
id: 1592
title: Synchronizing Containers
date: 2016-08-05T21:20:47+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1592
dsq_thread_id:
  - "5044043747"
categories:
  - containers
  - docker
tags:
  - containers
  - Docker
  - docker-compose
---
# Introduction

In the project I am currently working we are using Docker in all environments, that is development, CI, staging and production. The technology stack is based on Python with Django, MySQL and MongoDB to just name the most important elements. As good developers we of course have written a lot of unit-, integration- and UI tests. To author the UI or end-to-end tests we are using [Robot](http://robotframework.org/) which is a high level framework on top of Selenium. In this post I want to talk about one challenge we faced when executing integration- or UI tests and how we solved the problem.

[<img src="https://lostechies.com/gabrielschenker/files/2016/08/docker-whales-transparent.png" alt="" title="docker-whales-transparent" width="272" height="229" class="alignnone size-full wp-image-1600" />](https://lostechies.com/gabrielschenker/files/2016/08/docker-whales-transparent.png)

# The Setup

We&#8217;re using `docker-compose` to define our setup we&#8217;re using to run UI tests. The corresponding docker-compose Yaml file looks similar to this

[gist id=ec5670017086d41fea8a3a05d35a8853]

As you can see we&#8217;re having 4 services in our setup; each service runs in its own container. We have a container for Mongo DB, one for MySQL, one for our application that we want to test and one container to execute our Robot tests. Note how the application service `app` links to the Mongo DB and the MySQL services. By defining those links we effectively configure the DNS service of Docker and as a consequence we&#8217;re able to connect to Mongo DB and MySQL from the `app` container by using the names of the respective service, `mongodb` and `mysql`. This is important for what follows.

Now the problem is that if we run our tests using

`docker-compose -f docker-compose.ui-tests.yml up`

that the Robot container immediately starts to execute tests although the application and the databases are not yet ready. This will lead to failing tests. We have to avoid that.

But how can we make sure that everything is ready before the first test is executed? Docker cannot help us here since Docker doesn&#8217;t really know what&#8217;s happening inside a container. The fact that a container is ready from the perspective of Docker doesn&#8217;t mean that the application running inside the container is also ready. Specifically databases need some time to initialize. On slower machines that can take several seconds or more. On our CI agent Mongo DB for example takes about 30 seconds to start up and MySQL is no better.

How can we solve this problem. The solution we chose is the following

  * the application executes a step during initialization to wait for the database
  * the Robot container executes a step during initialization to wait for the application

The latter is easy since our application is a web application we use `curl` to access the index page. We repeat a get request to this URL until the response status code is 200 (OK). We normally wait 5 seconds between subsequent requests. The logic is written in `Bash` and looks similar to this

[gist id=a8eb70fc4cd1f8e89d3450dfc26176d5]

Note how we use the two environment variables `HOST_NAME` and `EXPOSED_PORT` that we defined in the `docker-compose` file.

Waiting for the database is a bit more tricky. Here we need to wait until the respective DB starts to listen at the defined TCP port. For this we use the logic found in the `wait-for-it.sh` script that I found [here](https://github.com/vishnubob/wait-for-it). The code snippet in our bash script looks similar to this

[gist id=0ce01f0b445119a27568850eb0b1927e]

Note how I use the DNS names `mongodb` and `mysql` as hostnames in the snippet above.

# Summary

Docker and docker-compose cannot help us synchronizing applications running in different containers. This is our task. I have show a technique that can be used to make sure that in the context of integration- and/or UI testing the application and the databases are ready before the first test is executed. We have used bash scripts to implement the necessary logic.