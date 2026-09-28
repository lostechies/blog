---
wordpress_id: 1387
title: Testing and Debugging a Containerized Node application
date: 2016-04-19T10:06:26+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1387
dsq_thread_id:
  - "4759889158"
categories:
  - containers
  - docker
  - introduction
  - node
  - tutorial
---
# Introduction

Containers in general and Docker in specific have changed the way how we think about running and deploying software quite a bit. Running an application in a container instead of directly on your computer or server has a lot of advantages. But what about testing and debugging? Are we still able to run tests and debug an application as easy and straight forward when we run it inside a container as we do when we run it directly on our host? In this post I want to give a step by step introduction on how to configure your application and how to adjust your development workflow to achieve exactly that. The source code accompanying this post can be found [here](https://github.com/gnschenker/debug-node/).

# Creating a sample application

I have chosen to build a simple [node JS](https://nodejs.org/en/) application that I&#8217;ll use to demonstrate testing and debugging when running in a container. The principles show here can be easily adapted to other types of applications, e.g. Python, Go or .NET Core.

## Initialize the application

Create a new folder for the project. In the terminal navigate to this folder and run the command

`npm init`

When asked about the start file enter `server.js` and when asked for the `test` command then enter `jasmine-node spec`. This will generate our `package.json` file. It should look similar to this

{% gist 296e9a74635f1d06bda2300f894ced8b %}

This sample application will use [express JS](http://expressjs.com/) and thus we install this library using

`npm install express --save`

Now we can add a file `server.js` to the project. It should contain the following code

{% gist 9e798bd95f0570fdb28a5899f8af36e4 %}

On line 4 we import a module `primes.js` which contains the logic to determine whether or not a given number is a prime. Thus let&#8217;s add such a file `primes.js` to the project and add the following content to it

{% gist 18fb048489a12628cd2c3ca04a927033 %}

Note how we export a function `isPrime` which is used on line 11 in the `server.js` file. I didn&#8217;t spend a lot of time to come up with the most efficient way of determining whether or not the number is a prime, thus bare with me&#8230;

## Adding a Dockerfile

To be able to package our application into a Docker image we need to add a file called `Dockerfile` to the solution. The content of this file should look like this

{% gist f8a1b5169cd75ac499972e6ec7ba6949 %}

Note how on line 3 we install `jasmine-node` which we need to run our tests and how we expose not only port 3000 but also port 5858. The latter will be used to attach the debugger. Also note how we first copy only the `package.json` into the image and run `npm install` and only after this copy the remainder of the application folder into the image. This helps us to optimize the build of the Docker image. When building an image Docker will only rebuild the layers of the image that have changed. And it is much less likely that we change the content of the `package.json` file than that we change some code in the application.

## Running the application in a container

Now let&#8217;s first build the Docker image of our application. Execute this command in the terminal

`docker build -t my-app .`

(Don&#8217;t forget the point at the end of the command!) And now we can run a container from this image

`docker run -d --name my-app -p 3000:3000 my-app`

We should see a long ID (hash code) being output in the terminal. To double check whether or not the container is running we can use the `docker ps` command and we should see this

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/RunningAContainer.png" alt="" title="RunningAContainer" width="1424" height="144" class="alignnone size-full wp-image-1398" />](https://lostechies.com/gabrielschenker/files/2016/04/RunningAContainer.png) If for some reason the container is not running we can use the `docker logs myApp` command to see the logging information produced by our application in the terminal.

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/docker-logs.png" alt="" title="docker-logs" width="416" height="176" class="alignnone size-full wp-image-1400" />](https://lostechies.com/gabrielschenker/files/2016/04/docker-logs.png)

# Adding tests

I have selected Jasmine as my testing framework. To use Jasmine in a node application we can install the `jasmine-node` module globally on our development machine. Oh, wait a second&#8230; why do we need to install this module on our machine in the first place? Honestly, it is not needed and I only do it to demonstrate how classical development (not using containers) can be easily and completely replaced by container based development. Thus, once you are familiar with Docker and the principles on how to leverage a Docker container for testing and debugging you can stop installing frameworks and test frameworks on you machine. Now, let&#8217;s install jasmine-node

`npm install -g jasmine-node`

we can now start defining our tests. Let&#8217;s first start with a simple unit test. Please add a folder `spec` to your application. Then add a file called `primes-spec.js` to this folder. Add the following content to this file

{% gist 7f8ed2b96ddfcc7fa0ae868f0786be2a %}

I am not going to discuss the syntax of a Jasmine test here. Please consult the excellent documentation [here](https://jasmine.github.io/) if you are not familiar with Jasmine. Once we have defined a test we can now execute the following command in our terminal

`npm test`

This translates to the call `jasmine-node spec` as we have defined in our `project.json` file. The output in the terminal should look similar to this

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/RunUnitTests.png" alt="" title="RunUnitTests" width="486" height="164" class="alignnone size-full wp-image-1393" />](https://lostechies.com/gabrielschenker/files/2016/04/RunUnitTests.png) We can of course also add some integration or API tests to the application. For this we need to add the `request` module to our application. Use this command to add the module

`npm install request --save`

Now add a file called `server-spec.js` to the `spec` folder. It should have the following content

{% gist 5650ca994d5f96c6638c412cbf3b970e %}

Once again we can run all tests by executing `npm test` in the terminal.

We can now run the test in a container. For this we use `docker-compose`. Let&#8217;s a add a file `docker-compose.test.yml` file to our project. The content should be

{% gist 8f1126eef93772a8b01238bd9501e158 %}

This yaml file contains instructions to build a container image using the Dockerfile in the current directory, open port 3000 and map it to port 3000 on the host. Finally we override the value of `entrypoint` as defined in the `Dockerfile` with the value `npm test`. Now on in the terminal enter the following command

`docker-compose -f docker-compose.test.yml up --build`

This will build the Docker image, run a container using this image with the overriden `entrypoint`. If all works well then we should see an output like this in the terminal

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/testInContainer.png" alt="" title="testInContainer" width="725" height="827" class="alignnone size-full wp-image-1404" />](https://lostechies.com/gabrielschenker/files/2016/04/testInContainer.png) And as expected, the logs tell us that after building the image a container is run and all tests are executed. In this specific case all tests were successful and thus the exit code is 0 (zero). If some test would fail the exit code would be 1. This is important to know when we execute the tests as part of Continuous Integration (CI). Now we can tear down everything by using

`docker-compose -f docker-compose.test.yml down`

With this we have shown that to run tests against a node application we do not need to do this on our host but can execute them directly in a Docker container. The advantage of it is that we do not need to install any specific software other than a decent editor to edit our project file on our host (e.g. laptop). We can run our application in a Docker container and test it manually or using automated tests. This is huge when we think about it. Everything application specific is in the container. Our host remains clean. That also means that you can now work on different projects with potentially conflicting frameworks or versions of the same framework. Since you&#8217;re always only installing the necessary libraries and frameworks in the container and each container is totally opaque there are no more conflicts!

# Debugging the application

Running automated tests against our application is one thing but sometimes we still need to debug our application. We want to be able to step through our code line by line and inspect the value of variables, etc. Can we do that if our application runs in a container? The answer is a bold YES. In the following I am showing how we can achieve this for our node application. I am using [Visual Studio Code](https://code.visualstudio.com/) (which just got released in version 1.0 and runs on Windows, Mac and Linux) as my editor. The technique I am showing here has first been published by Alex Zeitler [here](https://alexanderzeitler.com/articles/debugging-mocha-tests-in-a-docker-container-using-visual-studio-code/). I have tweaked it a bit to fit with my needs. First we need to know on which IP address our Docker host runs. Use the following command to find out

`docker-machine ip default`

This assumes that the name of the VM which is your Docker host is `default`. In my case the IP address is `192.168.99.100` which is default when you are using Docker Toolbox. Next we add another `docker-compose` file which we&#8217;ll be using for debugging. Add a file called `docker-compose.debug.yml` to the project and add the following content to the file

{% gist 4becd7ad377e16223d876213be15b354 %}

Similar to the `docker-compose` file for testing we are using the `Dockerfile` to build the image, we open port 3000 and(!) port 5858 and map them to the same ports on the host. Finally we override the `entrypoint` with `node --debug=5858 server.js`. That is we start node in debug mode listening on port `5858`. We can start a debug session by using this command

`docker-compose -f docker-compose.debug.yml up --build -d`

As a last step we need to configure Visual Studio Code to attach to the node application running in the container. To do this we add a folder `.vscode` to our project. Inside this folder we add a file `launch.json`.

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/vs-code.png" alt="" title="vs-code" width="220" height="204" class="alignnone size-full wp-image-1407" />](https://lostechies.com/gabrielschenker/files/2016/04/vs-code.png) The content of this file should be like this

{% gist 6ce229df4bbd74a04f49a1a46a5c603a %}

The interesting part for debugging is the section with the name `Attach`. We specifically need to make sure that the entry `address` is set to the correct IP address of our Docker host (192.168.99.100 in my case). Also double check that the `port` corresponds to the one node is listening at. Once we have added the launch configuration we can click on the **debug** symbol in VS Code. Make sure that the `Attach` configuration is selected and then hit the **run** button.

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/vs-launch.png" alt="" title="vs-launch" width="317" height="282" class="alignnone size-full wp-image-1408" />](https://lostechies.com/gabrielschenker/files/2016/04/vs-launch.png)

Now add a break point to line 7 of the `server.js` file. Open a browser and navigate to `192.168.99.100:3000` (replace the IP address with your own if you have a different one). The debugger should stop at line 7

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/debugging.png" alt="" title="debugging" width="879" height="481" class="alignnone size-full wp-image-1409" />](https://lostechies.com/gabrielschenker/files/2016/04/debugging.png) In the debug window of VS Code we can now see all kinds of interesting information like the content of variables in scope and the call stack. We can also define watches. With other words: we have a full debugging experience similar to what we&#8217;re used if we debug directly on our host instead in a container.

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/debugging-window.png" alt="" title="debugging-window" width="762" height="662" class="alignnone size-full wp-image-1411" />](https://lostechies.com/gabrielschenker/files/2016/04/debugging-window.png)

# Summary

In this post I have shown how we can run automated tests against a node JS application running in a Docker container as well as how we can debug an application running in a container. We can achieve the same results even though the application is now not running natively on our development system but encapsulated in a container. The benefit of all this is that we don&#8217;t need to pollute our host (laptop) with libraries and frameworks to support testing and debugging. Everything is encapsulated in the containers and we only need a nice code editor on our host. What I have shown here can also be applied to other type of applications. In a next post I will do this for a ASP.NET Core application.