---
id: 1417
title: Testing and debugging a containerized ASP.NET application
date: 2016-04-22T14:52:43+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1417
dsq_thread_id:
  - "4768820694"
categories:
  - ASP.NET vNext
  - containers
  - docker
  - How To
  - introduction
---
# Introduction

In my previous post I showed in detail how a node JS application running in a Docker container can be debugged and how we can run automated tests against this application also in a container. In this post I am going to investigate what is currently possible in this regard if the application is based on ASP.NET Core RC1 and is also running in a Docker container.
  
The code accompanying this post can be found [here](https://github.com/gnschenker/docker-webapi-testing/).

# The Application

The application I want to use is a simple **ASP.NET Core RC1 Web API**. Phew, that&#8217;s quite a name, I know. But we are used to such monsters coming from Microsoft&#8217;s kitchen aren&#8217;t we? Basically I have one controller with an endpoint which allows us to determine if a given number is a prime. It&#8217;s the same functionality that we were having in our [previous node JS application](https://lostechies.com/gabrielschenker/2016/04/19/testing-and-debugging-a-containerized-node-application/).

## Prerequisites

For this exercise to work make sure you have ASP.NET 5 RC installed. You can get it from [here](https://get.asp.net/).

## The Web API

So, now create a new folder `api` and add a file `project.json` to it. The content of the file looks like this

[gist id=e70069d84f7ea2ad26ef6a7ecdcd7486]

Note how we are using the .NET Core framework (line 23). Now add a `Startup.cs` file with the following content to the same folder

[gist id=754a661d18c6efd3561656b0a8562428]

Next add a sub-folder `Controllers` to the `api` folder and add a file `PrimesController.cs` to it. The content of controller should look like this

[gist id=7073cbdc09a20d4a9683f44a6d7234c2]

That is all we need to do for the moment. In a console navigate to the project folder and execute `dnu restore` followed by `dnu build`. Since we&#8217;re using .NET core we need to make sure that our default (or active) framework is set to this. Use the following command

`dnvm use 1.0.0-rc1-update1 -r coreclr -arch x64`

If all goes well we can then start and test the application by executing `dnx web`. In the console we should see this output

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/run-local.png" alt="" title="run-local" width="488" height="60" class="alignnone size-full wp-image-1434" />](https://lostechies.com/gabrielschenker/files/2016/04/run-local.png) Now open a browser and navigate to `localhost:5000/api/primes/11`. The value `true` should be shown in the browser indicating that indeed 11 is a prime number.

# Manual Testing and Debugging

Now let&#8217;s look into how we can run the above application in a container and still test and debug it. First let&#8217;s run it in a container.

## Docker-izing the application

It is easy and straight forward to run our Web API in a Docker container. We just need to add a `Dockerfile` to the project. The content of the file should look like this

[gist id=387898e4260b5a7d50f1f8557ee6351b]

We derive our Docker image from the Microsoft base image for ASP.NET 1.0 RC1. We then copy the `project.json` file into the image and do a restore of all the required nuget packages. We do this first to leverage the fact that the Docker image is layered. We will change the code much more frequently than we are going to change the list of required nuget packages. Thus when we&#8217;re rebuilding the image the restore does not have to happen all the time, which is good since it takes a considerable amount of time. Once we have done this we expose port 5000 and define the `ENTRYPOINT`. The command defined as entry point is executed whenever a container is started from our Docker image. Thus here the start command is

`dnx -p project.json web --server.urls http://0.0.0.0:5000`

Note how we need to define the URL as `http://0.0.0.0:5000` and not just using `localhost:5000`. Now we can build the container image using

`docker build -t myapi .`

and when done run a container from it

`docker run -d --name api -p 5000:5000 myapi`

Double check that the container runs using

`docker ps`

If for any reason the container `api` is not shown in the list try to find the root cause by displaying the logs

`docker logs api`

Open a browser and naviget to `192.168.99.100/api/primes/11`. The browser should show `true`, indicating that indeed 11 is a prime number. Great, now we have a ASP.NET Web API based on .NET Core running in a Docker container on Linux. Make sure that after you&#8217;re done testing you remove the obsolete containers. Use the `docker stop` and `docker rm` commands to do so.

## Enable edit and continue

Wouldn&#8217;t it be nice if I could edit the files of my project and not to have to rebuild the Docker image over and over? I wish we could have an **edit and continue** experience. Luckily this is possible. For this to work we need to craft a special **Dockerfile** to be used exclusively during development time. This Dockerfile will not copy the project files into the image but mount a volume containing all the project files. Add a file `Dockerfile.debug` to the project with the following content

[gist id=d7b92a3006398a44f71599d3c92147dc]

Most of the content of this Dockerfile are similar to the one we presented above. We have to add a few tweaks to allow the containerized application to discover if some of the project files have changed and thus the application should be (automatically) restarted. The main change is on line 21 where we define a different `ENTRYPOINT` than in the standard Dockerfile. We are using `dnx-watch` to start the application instead of just `dnx`. [dnx-watch](https://github.com/aspnet/dotnet-watch) monitors the files and restarts the application if a change is discovered. `dnx-watch` itself is installed with the command on line 13. We also set some additional environment variables, specifically `DNX_TRACE` to have `DNX` produce more (hopefully helpful) output.

## Shared Folders

If we are on a Windows box and are using VirtualBox to run our Docker host then the folder `c:\Users` is automatically mapped to the Docker host at `c:/user`. As long as our project folder is a subfolder of `c:\users` we are good and don&#8217;t have to do anything else. Otherwise we need to make sure the project folder is shared with Docker host. Please follow the instructions [here](https://www.virtualbox.org/manual/ch04.html#sharedfolders).

## Running the application

Now we want to run our Web API in a Docker container. To do this we first have to build a Docker image. We use `docker-compose` for this task because `docker-compose` simplifies the building of images and creation of containers. Let&#8217;s create a `docker-compose.debug.yml` file with the following content

[gist id=18688e7a66062d5ea800258545e1d2a9]

This docker compose file uses the new standard (version 2.0). We define our service to be built using the Dockerfile `Dockerfile.debug`. We than mount the current folder as `/app` folder to the image. This makes it possible that changes in the files can be discovered by the application running inside the container (via `dnx-watch`). To build the Docker image we use this command

`docker-compose -f docker-compose.debug.yml build`

and to run the application we can use

`docker-compose -f docker-compose.debug.yml up -d`

Now our Web API runs inside a container and Kestrel, our web server is configured to listen at port 5000. We can now open a browser and navigate to the following URL

`http://192.168.99.100:5000/api/primes/11`

and if all works fine the result should be `true`. Try to use another number instead of `11` to see if the algorithm is working as expected. If for some reason or not the application does not work then try to analyze the logs produced by the application in the container. Use this command to display the logs in the console

`docker logs api`

Now let&#8217;s try to modify some code and see whether or not the changes are reflected in the running application. Let&#8217;s just add the value the `PrimesController` controller is returning. Instead of only returning `true` or `false` let&#8217;s use this code

`return "The number is " + (isPrime ? "" : " NOT ") + "a prime.";`

Do not forget to change the return type of the Get method from `bool` to `string`. Now just refresh the browser and assert that the response has changed as expected.

# Automated Tests

To create a test project using .NET core is at this point in time **quite tricky**. .NET core is a moving target (at the time of writing RC1 and RC2 are out in the field but the tooling does not yet support RC2) and documentation is sparse to say the least. Most third party libraries have not yet been ported to .NET core either. But let&#8217;s not complain and show the solution that I came up. Create a new folder `docker-webapi-testing` and move the folder containing the above Web API solution into this new folder. Add a new sub-folder called `unit-tests` to `docker-webapi-testing`. Add a file `global.json` to the `docker-webapi-testing` folder. The content of this file should look like this

[gist id=934c7bd2df56436f7a4da0223391de41]

As you can see this file basically contains a list of all projects that make up my solution. The Web API project is called `api` and the test project which is called `unit-tests` (basically the respective folder names).

## The test project

At the time of writing [XUnit](https://xunit.github.io/) is the only established test library that supports .NET core. I am going to use this library for my sample. To the folder `unit-tests` add a `project.json` file. The content looks as follows

[gist id=12f5151521c2d1a3030f3cf5b447c4b1]

Now we add actual tests. Add a file called `primes-controller-spec.cs` to the test project. It&#8217;s content should look like this

[gist id=4bc5ddb53291eb6831b2c99fca4dc432]

As you can see we have defined 2 test, one for a prime number and one for a non-prime number.

## Containerizing the solution

Next to the `global.json` file we now add a `Dockerfile` since we want to run all those tests in a container. The content of this file should look like this

[gist id=b04d224773ef6a2b13ad33c217f514a5]

We base our image on the official Microsoft image for ASP.NET Core 1.0 RC1. On line 4 to 6 we are copying the `global.json` and the two `project.json` files into the image; we then run `dnu restore` which will restore the nuget packages of both projects. Finally on line 9 we are running the command `test` which is defined in the `project.json` of our `unit-tests` project. We can now build the test image as follows

`docker build -t sut .`

And then we can execute the tests

`docker run -it --rm --name sut sut`

The output in the console should look similar to this

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/tests-in-docker.png" alt="" title="tests-in-docker" width="757" height="149" class="alignnone size-full wp-image-1441" />](https://lostechies.com/gabrielschenker/files/2016/04/tests-in-docker.png) With this we have container-ized our tests successfully.

# Attaching a debugger

At the time of writing the tooling that Microsoft provides is not able to attach to an ASP.NET Core application running inside a Docker container in Linux. I hope that this will be possible in the not too far future. For the moment we have to rely on our tests to make sure that our code is correct or we need to debug the code on the host machine before we wrap the application into a container.

# Summary

In this post I have shown how we can run an application based on ASP.NET Core in a Docker container and run it on Linux. I have also shown how we can create and run a container that executes tests against our code using XUnit. At the time of writing XUnit is the only test library that has been ported to .NET Core.