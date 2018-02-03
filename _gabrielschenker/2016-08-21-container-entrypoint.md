---
wordpress_id: 1659
title: Container Entrypoint
date: 2016-08-21T16:41:34+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1659
dsq_thread_id:
  - "5083937921"
categories:
  - containers
  - docker
  - How To
  - introduction
tags:
  - containers
  - Docker
---
# Introduction

This time in our series about containers we are going to look a bit more closely into what happens when a container starts and how we can influence that. Specifically we&#8217;re going to learn about the `ENTRYPOINT` and the `CMD` keywords in a `Dockerfile` and among other things how they relate to each other.

# The Entry Point

Whenever we start a container from an image we need to declare what command(s) shall be executed by the container upon start. This is called the entry point. Usually when we define a `Dockerfile` we specify such an entry point as (one of the) last items in the declaration. As a sample let&#8217;s take a `Dockerfile` for an overly simple Python application consisting of one single file `app.py` with code. Usually, when running the Python application directly on our development machine &#8211; that is, not in a container &#8211; we just start the application using this command

`python app.py`

consequently our `Dockerfile` would look like this

[gist id=7d3f92b7c034012d2464b4a463283739]

note the last line declaring the `ENTRYPOINT`. The syntax I have chosen in the above sample is one possible way of declaring the entry point. An alternative syntax is using an array of words, i.e.

`ENTRYPOINT ["python", "app.py"]`

According to the documentation the latter is the preferred way but honestly I find the former much more readable; yet you will see further below why the array syntax makes sense or in certain scenarios is even the only way things are working.

For the moment let&#8217;s assume that `app.py` contains the following code

[gist id=75725782421a1ac7805c366cc8bce07d]

We can now build an image using the `Dockerfile`

`docker build -t python-sample .`

And we should see something like this

[gist id=d8252d1d0ceb294cf0d5638c14b16bbf]

Now we can run a container from our new image like this

`docker run -it --rm python-sample`

and we should see this output

[gist id=bf8da1bc71371963120b409e441098b8]

# Overriding the Entry Point

From time to time we want to run a container from an image that has an `ENTRYPOINT` defined but we want to override this entry point with our own. Luckily the Docker CLI allows us to just do that by using the `--entrypoint` argument when running a container. As an example: if we want to run a container from our `python-sample` image but would rather run a bash shell upon start of the container we can use a run command like this

`docker run -it --rm --entrypoint /bin/bash python-sample`

This possibility to override the entry point cannot be overestimated. It is very very helpful in many scenarios. For me personally the most common use case is to trouble shoot a container by overriding the entry point with a call of a bash shell instead of the predefine entry point. If I am dealing with a simpler image that doesn&#8217;t have bash installed like e.g. the Alpine Linux container then I just use the default shell `/bin/sh`.

Another use case is to run tests. Let&#8217;s assume we have a file `tests.py` in our project which contains some tests.

[gist id=0db43c333de60ff6085a7f6e59a89c66]

We can then run a container in test mode as follows

`docker run -dt --name test --entrypoint python tests.py python-sample`

That is really helpful! We can use one and the same container image to generate ontainers that do slightly or completely different things.

The same also works when we use `docker-compose`. Assume we have the following `docker-compose.yml` file in our project

[gist id=0778686b4d3f5bd0584913c834f453fa]

On line 5 you can see how we declare what entry point to use when starting the container.

# The CMD Keyword

Docker also defined a keyword `CMD` that can be used in a `Dockerfile`. What we declare as a command is also used during startup of a container. OK, that sounds confusing&#8230; Don&#8217;t worry, it took my a while too to finally find a good description defining the differences between `ENTRYPOINT` and `CMD`.

Let&#8217;s illustrate that with a sample. For this sample I am going to use the official Alpine Linux image since it is so small and has everything I need for this demonstration. Let me first start with the following command

`docker run --rm -it alpine echo "Hello World"`

Here we are running an instance of the alpine image in interactive mode and we tell Docker what command shall be executed upon start of the container. The result as we can see below is as expected, the container just outputs &#8220;Hello World&#8221; on the terminal. Since we have used `--rm` in the command the container will be automatically destroyed after its execution has stopped.

[<img src="https://lostechies.com/gabrielschenker/files/2016/08/Screen-Shot-2016-08-21-at-3.41.23-PM1.png" alt="" title="Screen Shot 2016-08-21 at 3.41.23 PM" width="400" height="84" class="alignnone size-full wp-image-1668" />](https://lostechies.com/gabrielschenker/files/2016/08/Screen-Shot-2016-08-21-at-3.41.23-PM1.png)

Please note that a container stops as soon as the main process running inside the container is terminated. In our simple sample this is of course the case immediately after echoing &#8220;Hello World&#8221;.

We can now achieve the same with a slightly modified command

`docker run --rm -it --entrypoint echo alpine "Hello World"`

[<img src="https://lostechies.com/gabrielschenker/files/2016/08/Screen-Shot-2016-08-21-at-3.50.58-PM.png" alt="" title="docker run" width="494" height="77" class="alignnone size-full wp-image-1671" />](https://lostechies.com/gabrielschenker/files/2016/08/Screen-Shot-2016-08-21-at-3.50.58-PM.png)

So, what just happened? We defined the start command using `--entrypoint` to be the `echo` command. The part after the image name (alpine) in this case is only the &#8220;Hello World&#8221; string. It is passed as parameter to the start command. As a result the container is started by Docker with the command `echo "Hello World"`. Now, what&#8217;s the difference between the former and the latter? In the former case we did not declare an entry point. In this case Docker automatically assumes `/bin/sh -c` as start command and passed to it (as string) whatever we define in our `docker run` command after the image name. In the former case this is `echo "Hello World"`. Thus that container was started with

`/bin/sh -c "echo \"Hello World\""`.

Now let&#8217;s work with a `Dockerfile`. Our first version of the file looks like this, that is we continue with our Alpine image and the &#8220;Hello World&#8221; message

[gist id=b5547b2e06a7d9784018e2e020696514]

let&#8217;s create an image from this

`docker build -t my-hello-world .`

and run a container of this image

`docker run --rm -it my-hello-world`

what we should see is

[<img src="https://lostechies.com/gabrielschenker/files/2016/08/Screen-Shot-2016-08-21-at-4.09.20-PM.png" alt="" title="Screen Shot 2016-08-21 at 4.09.20 PM" width="425" height="276" class="alignnone size-full wp-image-1674" />](https://lostechies.com/gabrielschenker/files/2016/08/Screen-Shot-2016-08-21-at-4.09.20-PM.png)

In this sample we did not explicitly define an entry point, thus Docker assumes automatically `/bin/sh -c`. But we define the parameters with the keyword `CMD` to be passed to the (implicit) entry point.

According to what I told above we should now also be able to achieve the same result with the following `Dockerfile` variant

[gist id=817020dcad9ea8fa6f5ccc3195cf2068]

and indeed after building the image and running a container we have the same end result

`docker build -t my-hello-world-2 .<br />
docker run --rm -it my-hello-world-2`

[<img src="https://lostechies.com/gabrielschenker/files/2016/08/Screen-Shot-2016-08-21-at-4.20.15-PM.png" alt="" title="Entrypoint and CMD" width="493" height="326" class="alignnone size-full wp-image-1677" />](https://lostechies.com/gabrielschenker/files/2016/08/Screen-Shot-2016-08-21-at-4.20.15-PM.png)

Please note that in the Dockerfile we have to use the array syntax for `ENTRYPOINT` and `CMD` to make the sample work.

Now I can override the part defined in the `CMD` part, e.g. as follows

`docker run --rm -it my-hello-world-2 "Hello Gabriel"`

and indeed it works as expected

[<img src="https://lostechies.com/gabrielschenker/files/2016/08/Screen-Shot-2016-08-21-at-4.24.38-PM.png" alt="" title="Screen Shot 2016-08-21 at 4.24.38 PM" width="482" height="63" class="alignnone size-full wp-image-1679" />](https://lostechies.com/gabrielschenker/files/2016/08/Screen-Shot-2016-08-21-at-4.24.38-PM.png)

The last variant of my `Dockerfile` is only using the keyword `ENTRYPOINT`

[gist id=ea759b47473b13d76334b10895be39a5]

Again after building the image and running a container we see the expected result

[<img src="https://lostechies.com/gabrielschenker/files/2016/08/Screen-Shot-2016-08-21-at-4.29.59-PM.png" alt="" title="Screen Shot 2016-08-21 at 4.29.59 PM" width="407" height="252" class="alignnone size-full wp-image-1681" />](https://lostechies.com/gabrielschenker/files/2016/08/Screen-Shot-2016-08-21-at-4.29.59-PM.png)

# Summary

In this post I have looked a bit deeper into what exactly the `ENTRYPOINT` and the `CMD` keywords in a `Dockerfile` are. It might look like trivial stuff that I have written up here and it certainly is no rocket science. But ofter we overlook the seemingly trivial things and as a consequence come up with solutions that are more complex than necessary or even worse we have a working example and cannot really fully explain&#8221;why&#8221; it is working.

In the project I am working currently with we have many different containers we deal with and we use them in different environments and context. As a consequence we are heavy users of the variability that `ENTRYPOINT` and `CMD` give us.