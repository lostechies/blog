---
id: 1608
title: Troubleshooting Containers
date: 2016-08-11T19:17:33+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1608
dsq_thread_id:
  - "5059296120"
categories:
  - containers
  - docker
  - How To
tags:
  - containers
  - Docker
  - troubleshoot
---
# Introduction

I find my self rather often than not in a situation where I have to trouble shoot a containerized application or a coworker needs some help doing so. In this post I want to show some practices how you can resolve your problems quickly.

_On a side note: I have been nominated to be a [Docker Captain](https://www.docker.com/community/docker-captains). This is a big honor to me and I&#8217;m feeling really excited. For me containers in general and Docker containers in specific are some of the most disruptive and innovative features in IT._

# Prerequisites

If you have not done so yet then please install [Docker for Mac](https://www.docker.com/products/docker#/mac) or [Docker for Windows](https://www.docker.com/products/docker#/windows).

# Why is this not working?

Let&#8217;s assume we are containerizing a RESTful API written in Python using Flask. The language and framework used here are not really relevant, the application could as well be a Node JS, a Java or a .NET application. What matters here is the techniques shown in an around containers.

Create a new project folder. Add a file `app.py` to this folder. The content of this file defines our simple API and looks like this

[gist id=613d877acab21fe5157611c370c50620]

If we have Python and Flask installed on our developer machine we can run this application as follows

`python app.py`

[<img src="https://lostechies.com/gabrielschenker/files/2016/08/run-app.png" alt="" title="run-app" width="473" height="49" class="alignnone size-full wp-image-1612" />](https://lostechies.com/gabrielschenker/files/2016/08/run-app.png)

Then we open a Browser and navigate to `http://localhost:5000/api/tasks` and should see this

[<img src="https://lostechies.com/gabrielschenker/files/2016/08/browse-api.png" alt="" title="browse-api" width="570" height="299" class="alignnone size-full wp-image-1615" />](https://lostechies.com/gabrielschenker/files/2016/08/browse-api.png)

So far so good. But the goal is to run this application in a container. Let&#8217;s add a `Dockerfile` to our project folder

[gist id=4b272e9228888194ae091de724f5dd26]

Now we want to build a Docker image using the above `Dockerfile`. Open a terminal and navigate to the project folder. Execute the following command to build the image

`docker build -t sample-api .`

you should see the following output in you terminal

[gist id=01439d26b8aeeda52d611e8043fb91f2]

Well, that was easy. Now let&#8217;s try to run a container using the image we just built.

`docker run --name my-api -d -p 5000:5000 sample-api`

OK, in the above command we told Docker to run a container with the name `my-api` as a service (or daemon), mapping the container port 5000 to the host port 5000 using the image `sample-api`.

We can now double check whether we were successful by using this command

`docker ps -a`

We should see this

[<img src="https://lostechies.com/gabrielschenker/files/2016/08/docker-ps.png" alt="" title="docker-ps" width="1115" height="64" class="alignnone size-full wp-image-1622" />](https://lostechies.com/gabrielschenker/files/2016/08/docker-ps.png)

Wait a second&#8230; Let&#8217;s look at the status of the container. It says `Exited`. What the heck&#8230;? Apparently there is a problem. Help&#8230;!?! What can we do?

## Analyzing the Log

Although the container doesn&#8217;t run and is in the `Exited` status it&#8217;s log is still available to us. We can access the log of any container by using the command

`docker logs [Container ID]`

or

`docker logs [Container Name]`

Let&#8217;s use the container name, `my-api` in our case

`docker logs my-api`

[gist id=243acf98a336136cd9e7716b18b2c609]

OK, the log informs us that Python encountered an error. The module `flask` could not be found. Oh yeah, my bad, I forgot to install this module. The Docker base image `python:2.7` from which we inherit our image does not have any 3rd party modules installed. Let&#8217;s add a file `requirements.txt` to our project and add flask as a dependency. The content of the file looks like this

[gist id=6bbd4739509a98a23872849c4078b305]

now we can modify the `Dockerfile` as follows

[gist id=297dc19d5d3b6a522aed9a49d4be4652]

Note how I added two lines after the `WORKDIR` command. One to copy the `requirements.txt` file into the image and the other to run `pip install`. We can now rebuild the image

`docker build -t sample-api .`

Once the image is built it is now including `Flask`. We can try to run a container with the new image. But before we do that we need to remove the `Exited` container which is still around using

`docker rm my-api`

now we&#8217;re good to go

`docker run --name my-api -d -p 5000:5000 sample-api`

executing `docker logs my-api` will show the expected output

[gist id=74449319fc6de1d134cf0e2e0833bb83]

The Flask (web-) server is listening at port 5000. If we open a browser and navigate to `http://localhost:5000/api/tasks` we see the same result as when we ran the Python application directly on our host.

## Using an alternative Entrypoint

Let&#8217;s for a moment assume that we still have problems with our container and it doesn&#8217;t work as expected. What other means do we have to analyze the situation? The problem is that every time we run a container it exits with an error. In this situation it is helpful to have the opportunity to create a container from the very same image but this time we override the predefined entry point. The `ENTRYPOINT` command in a `Dockerfile` defines what action is executed upon start of the container. In our case the action is

`python app.py`

which means that we run the application whose starting point is defined in `app.py`. Now let&#8217;s execute this command instead

`docker run --rm -it --entrypoint /bin/bash sample-api`

If we do this then a container based on the `sample-api` image is started in interactive mode with an attached terminal (-it) and the command that is executed upon start of the container is `/bin/bash`, that is, instead of starting our Python application we start a bash shell.

Doing that we find ourselves inside the container and have all possibilities to analyze the situation and do all kinds of experiments. We can e.g. investigate whether all expected assets are available and in the right place, or we can use `pip` to install (missing) modules and even execute the default start command `python app.py`.

If we do the latter then the difference here is that if an error happens we find ourselves still inside the container and can do further investigations and/or experiments.

Once we&#8217;re done we can exit the container by just typing `exit` in the shell. The container will stop and will automatically be removed from the Docker workspace due to the command line argument `--rm` we used when running the container.

## Exec into a running Container

A third possibility we have is to intrude into a running container using the `docker exec` command. This is a very useful method if the container is running but it&#8217;s behavior is somewhat unexpected. Let&#8217;s start a a container from our image `sample-api` as we did before

`docker run --name my-api -d -p 5000:5000 sample-api`

We can verify using `docker logs my-api` that the Flask web server is running and listening at port 5000. Now we can use the following command to break into the running container

`docker exec -it my-api /bin/bash`

with the above command we start a new process running bash inside the container `my-api`. We also run this process interactively with terminal (-it).

We can now use the `ps aux` command to show all running processes in the container

[gist id=49a66fe6de683b8f03722ff9d5d88289]

And indeed we see our Python application running as well as the bash shell that we just started.

# Summary

In this post I have shown a few techniques that we can use to trouble shoot misbehaving containers. I have shown how we can retrieve the log generated by the application running inside the container using `docker logs`. I have also shown how we can override the entrypoint of a container upon start. Last I have discussed how one can hijack a running container using the `docker exec` command. These are only the most straight forward techniques. I&#8217;m sure that I will elaborate on more advanced techniques in a future post. Please stay tuned.