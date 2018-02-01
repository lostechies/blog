---
id: 1447
title: ASP.NET, Docker and Messaging
date: 2016-04-27T09:39:11+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1447
dsq_thread_id:
  - "4781386263"
categories:
  - .NET
  - ASP.NET vNext
  - containers
  - docker
---
# Introduction

In my [last post](https://lostechies.com/gabrielschenker/2016/04/22/testing-and-debugging-a-containerized-asp-net-application/) I showed how we can debug and test a containerized ASP.NET application. In this post I want to show how messaging works for .NET vNext applications using [RabbitMQ](https://www.rabbitmq.com/) as the underlying infrastructure. At the time of writing the only .NET client for RabbitMQ that runs on the new .NET platform is [RawRabbit](https://github.com/pardahlman/RawRabbit). At this time it &#8220;only&#8221; runs on the full .NET framework but the ground work has been done to run it on .NET core. Please find the code accompanying this post [here](https://github.com/gnschenker/RabbitMqSample) on GitHub.

# The Application

The application I&#8217;m going to use as a sample consists of a simple Web API with one endpoint that accepts an HTTP POST message. The controller will, when handling an incoming request put a message (a **command** to be more precise) on the message bus represented by RabbitMQ. I also have implemented a service that subscribes to the message bus and listens for incoming commands of the type sent by the API. In this scenario the API is the **producer** of messages and the service is the **consumer**. RabbitMQ acts as the **broker** between the two parties. Each of the components, API, service and RabbitMQ run in their own Docker container.

## The API

The API consists of a ASP.NET Web API project similar to the one described in my [previous post](https://lostechies.com/gabrielschenker/2016/04/22/testing-and-debugging-a-containerized-asp-net-application/). I am using [RawRabbit](https://github.com/pardahlman/RawRabbit) as the client for RabbitMQ. Thus I have to add the two references on line 17 and 18 to the `project.json` file

[gist id=47693a3b0534f0ee9b67cb82c853441c]

Also not on line 26 that we are indeed using the full framework `dnx451` here instead of the core library as in my last post. I initialize the message bus in the `Startup` class (lines 4-8)

[gist id=ead3e2f26e76055e1bf71e085403e166]

The default settings for the bus can be found in the file `rawrabbit.json`. Those values can be overriden by environment variables that start with a prefix `RABBIT_` as defined on line 7 of the above snippet. In my case the content of `rawrabbit.json` looks like this

[gist id=749d979decc74d30e95a9669115bfee2]

In this file I define the list of RabbitMQ hosts that the client can connect to, port, username and password as well as the virtual host. For a detailed description of the options that can be defined here please consult the [documentation](https://github.com/pardahlman/RawRabbit) for RawRabbit. I am mainly using this file during development time. Once the API runs in a docker container we need to configure the values via environment variables since a Docker image is **immutable** and thus any file inside the image is also immutable, specifically the `rawrabbit.json` file. There is one little gotcha in this approach with environment variables that we need to overcome. It is about the `RABBIT_HOSTNAMES` variable which is interpreted as a generic list of strings (`List<string>`). The value of an environment variable is always a string. Thus the easiest way to provide a list of host names is through a comma separated list of values, e.g. `alpha,beta,gamma`. By default there is no type converter registered with ASP.NET that can handle that situation. Thus we have to define our own type converter. This converter is registered in the `Startup` class as well (see line 3 of the following snippet)

[gist id=9e58625df0f997fef50c23ef0998bc73]

To see the full implementation details for this type converter please consult the [GitHub repo](https://github.com/gnschenker/RabbitMqSample) accompanying this post. Now we can implement our controller with the POST method announced in the introduction. Here is the code

[gist id=eee28e449c88efa3e6e8446fc0e70481]

Note how we can use dependency injection to get hold of a client to RabbitMQ of type `IBusClient`. This is because of the fact that we registered this service in the `Startup` class. Now in the `Post` method we simple publish an instance of `IsPrimeCommand` on the bus. For this we use the asynchronous method `PublishAsync` of the bus client. This is typical for the command pattern _send and forget_ that is often used when applying the CQRS pattern. For completeness I also present the definition of the `IsPrimeCommand` here

[gist id=a06bf5753d97469e7087e64ce5a85486]

as well as the `IsPrimeRequest` which looks very similar to the command

[gist id=311d4ed1a22790585558b23fe2cbf191]

We&#8217;re nearly done. What is missing is the `Dockerfile` for this project since ultimately we want to run this component in a Docker container. Here is the content of the `Dockerfile`

[gist id=26d8f9e04180d57595644eddce03d494]

By now we should be rather familiar with this type of content. The only difference to the `Dockerfile` used in my [last post](https://lostechies.com/gabrielschenker/2016/04/22/testing-and-debugging-a-containerized-asp-net-application/) is that here we are deriving our image not from ASP.NET Core but rather from the full ASP.NET framework which is based on Mono.

## The Consumer Service

The consumer service is implemented as a console application. The `project.json` file of this project looks like this

[gist id=45506335f8940e7379d06d8b56865ac9]

Nothing special so far other than that we have the dependency on **RawRabbit** on line 14 and 15. Let&#8217;s define a class that handles incoming messages of type `IsPrimeCommand` that the API publishes on the bus. For this we implement `PrimesHandler`

[gist id=b0252dd5e32fb6cdb6bcf2b9d39a634f]

In this example we&#8217;re not doing really something useful but just print out a confirmation on the console that we got a message of type `IsPrimeCommand`. We&#8217;re printing the number for which we normally should determine whether or not it is a prime. Note how we can use the `SubscribeAsync<T>` method to subscribe to any message of type `T`. Now we need to initialize a bus client and hook up our handler. We do this in the `Program` class

[gist id=42c6e7fff15882295754a7ed3ab65b5e]

On line 5 we procure an instance of bus client which for simplicity we configure directly in code. Normally you would configure the settings using setting files and environment variables similar to how we did it in the API project. On line 6 an 7 we hook up the handler and then we halt execution until the user hits <enter> or the program is aborted.

The `Dockerfile` for this consumer service looks nearly exactly the same as the one for the API. The only difference is that we do not need to expose a port and the definition of the `ENTRYPOINT`. Instead of `dnx web` we use the command `dnx run` since this service really is a console application and not a web application.

[gist id=ec3e8a967d151128e1c614a879561baf]

And that&#8217;s all for the coding side. To review all details please consult [my repository](https://github.com/gnschenker/RabbitMqSample) on GitHub.

## RabbitMQ

Now we can take care of our message broker RabbitMQ. We will use the [official image](https://hub.docker.com/_/rabbitmq/) on Docker hub. To run an instance of RabbitMQ using this image use the following command

`docker run -d --name rabbit --hostname my-rabbit -p 5672:5672 -p 8080:15672 rabbitmq:3-management`

Note how we expose port `5672` which is used for the messaging as well as port `15672` (mapped to port 8080) which is used to access the management console. We can now open a browser and navigate to the URL `192.168.99.100:8080` and should be able to monitor RabbitMQ via the management console.

## Docker Compose

To simplify our lives and to be able to start all 3 components (API, service1 and RabbitMQ) in one go we can use `docker-compose` and define a `docker-compose.yml` file. Given how my solution is structured we get this content for the yaml file

[gist id=982f2a7b4adf1d2e775028dd710e69de]

Now let&#8217;s test the whole application by executing the following command

`docker-compose up --build -d`

This should build the 2 Docker images for `API` and `service1` and then start 3 containers with API, service1 and RabbitMQ running inside them. At this time there is a little hick-up in the sample as far as the service fails to initialize correctly since RabbitMQ is not yet ready when the service wants to connect. We can fix that by just restarting the service using the following command

`docker start service1`

I know, this is only a hack and in a production environment we need to find a better solution, maybe by deferring the initialization of the connection to RabbitMQ. To test we can e.g. use Postman and define a POST request to the URL `192.168.99.100:5000/api/primes` with a header `Content-Type: application/json` and a body `{"number":11}`. If all goes well we should see something along the line of this

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/log-of-service.png" alt="" title="log-of-service" width="1374" height="164" class="alignnone size-full wp-image-1463" />](https://lostechies.com/gabrielschenker/files/2016/04/log-of-service.png)

in the logs of the container containing `service1`. The easiest way to analyze the logs of the running containers is by using the Kitematic tool of Docker Toolbox.

# Shortcomings

Apart from the fact that we have to manually restart `service1` there is another shortcoming in the current solution. I will address this in a next post. It is the fact that we are accessing RabbitMQ via a well known IP address. This is not the right solution because in production we might not know where exactly the RabbitMQ instances run. For this we can use Docker **networks** and **links** in our Docker compose file.

# Conclusion

In this post I have shown how we can use RabbitMQ to implement messaging between two .NET vNext components running in Docker containers on Linux. I have used the publish-subscribe pattern. The also common request-reply pattern can be used in similar way. With this I have proven that it is possible to build fully distributed applications using .NET vNext and running all components in Docker containers on Linux.