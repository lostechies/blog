---
id: 1632
title: 'Containers &#8211; Clean up your House'
date: 2016-08-14T16:07:27+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1632
dsq_thread_id:
  - "5065969300"
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

In this post I am going to revisit some of the most basic commands of the Docker CLI. But don&#8217;t worry, you should still read this post since I am going to use that &#8220;basic&#8221; knowledge to discuss some advanced methods on how to keep your Docker environment clean. And, as we all know, only an orderly environment keeps us productive.

# Stopping and Removing Containers

As we play around with containers the list of running instances or instances that are in `stopped` or `exited` status grows longer and longer. This can lead to some serious memory and performance problems if we do not pay attention.

First let&#8217;s repeat some of the basic Docker commands that help us discover what&#8217;s currently running or hanging around in our system. To get a list of the currently running containers we use the command

`docker ps`

This will list all the currently running containers on our system (or host). If we are using **Docker for Mac** or **Docker for Windows** that will be the mini-VM which represents the Docker Host on our development machine.

[<img src="https://lostechies.com/gabrielschenker/files/2016/08/docker-ps1.png" alt="" title="docker-ps" width="1167" height="98" class="alignnone size-full wp-image-1633" />](https://lostechies.com/gabrielschenker/files/2016/08/docker-ps1.png)

In the image above we can see that I have currently 2 containers running on my system. One with Mongo DB and one with MySQL. The list shows the columns `ID`, `Image`, `Command`, `Created`, `Status`, `Ports` and `Name`.

  * **Image** is the name of the Docker image from which I created the container(s) 
  * **Name** is the name of the container itself and _needs_ to be unique
  * **ID** is the unique generated ID of the Docker container instance
  * **Status** tells us in what status the container currently is. It can be `Created`, `Up` (Running), or `Exited`

**ID** and **Name** are most important to us when we try to manipulate a container, say stop it. If I want to e.g. **stop** the MySQL container I can do this using either of the following commands

`docker stop mysql` or `docker stop fc3e2d9e6e99`

Note that I do **NOT** have to provide the full ID (i.e. fc3e2d9e6e99) to the command. Usually the first two to three characters are enough. Thus the following command works as well

`docker stop fc`

This is very convenient since it avoids us to have to type a lot.

If we now issue a `docker ps` we won&#8217;t see the `mysql` container anymore. The command only shows us the running containers. But MySQL is now in `Exited` status and thus not included in the list. If we want to see **all** containers, including the exited ones we have to add the command line parameter `-a` or `--all` to the command; thus

`docker ps -a`

If we do so we see this

[<img src="https://lostechies.com/gabrielschenker/files/2016/08/docker-ps-a.png" alt="docker ps -a" title="docker-ps-a" width="1168" height="104" class="alignnone size-full wp-image-1634" />](https://lostechies.com/gabrielschenker/files/2016/08/docker-ps-a.png)

Note the status of the `mysql` container which is `Exited`.

It is very important to know that the name of a container has to be unique. That means that in the above example I cannot start another container with the name `mysql` even thought the MySQL container is in `Exited` status and not running. We first have to remove this container. We can do so using

`docker rm mysql` or `docker rm fc3e2d9e6e99`

Only then is the MySQL container completely gone and I can (if I want to) reuse the name `mysql` for another container.

Please also note that I can **only** remove a container that is in `Exited` (or stopped) status. That is, if I have a running container then I need to first stop it and then I can remove it. That is sometimes a bit too much effort and therefore I can use a **force remove** to stop and remove a container in one single command. If I want to do this with my `mongo` container the command would then be

`docker rm -f mongo`

Notice the `-f` parameter. I could also use `--force` instead.

## Stopping or removing multiple containers

Often times we have a bunch of containers running and want to stop or remove them all at once without having to type the respective command over and over for each instance. There we can use the fact that most of the Docker commands can deal with a list of items. Let&#8217;s see how we can forcibly remove all containers currently running or hanging in our system

`docker rm --force $(docker ps --all --quiet)`

The above combined command uses `docker ps` with `--all` and `--quite` to generate a list of all IDs of the containers on my system. This list is then consumed by the `docker rm --force` command. And voila, all containers are gone.

As always, I can also use the shorter form of arguments and even combine them. Thus instead of writing `--all --quiet` I can instead use `-a -q` or even `-aq`. Nice. So my short form of the above command is

`docker rm -f $(docker ps -aq)`

Much less typing &#8211; I love it.

Since I use the above command so often, I have created an alias for it in my `.bash_profile`

`alias drmf='docker rm -f $(docker ps -aq)'`

# Cleaning up Images

As we work with Docker, over time we download a lot of images and we also generate a fair amount of images which all take up space and make the list of images looking messy when issuing the command

`docker images`

If I run the above command on my laptop currently I get the following output

[<img src="https://lostechies.com/gabrielschenker/files/2016/08/docker-images.png" alt="" title="docker-images" width="773" height="648" class="alignnone size-full wp-image-1641" />](https://lostechies.com/gabrielschenker/files/2016/08/docker-images.png)

As you can see, that&#8217;s a big mess and clearly deserves some cleanup. With the Docker CLI we can of course also remove specific obsolete images as follows

`docker rmi [image-id]`

For example I could remove the last image (the top one) in the list using

`docker rmi 6f3`

If I have many images to delete I can provide a list of IDs instead to the `docker rmi` command. Once again it is useful to combine a few shell commands to achieve the goal. Let&#8217;s say I want to delete all images that have a name and/or tag of **none**, then I can use this command to do so

`docker rmi $(docker images | grep "<none>" | awk '{print $3}')`

What does this command do? First let&#8217;s look into the part in parentheses: we generate a list of all images using `docker images` pipe them into the `grep "<none>"` command which will filter out the lines form the list which contain &#8220;none&#8221; and then we pipe the result into the `awk` command. The `awk` filters out the 3rd column of the list which happens to be the IDs. Now having this list of IDs we feed them into the `docker rmi` command. Job done.

Again, since I use this command so often I have created an alias/function in my bash profile for it

`dclean() { docker rmi -f $(docker images | grep $1 | awk '{print $3}'); }`

With this I can enter the following command in my console to achieve the same result

`dclean "<none>"`

which is way easier to remember and much shorter to type.

The `docker images` command also has the parameter `--quiet` to just output the list of IDs of all images. I can use this fact to create a simple command to cleanup all images that are currently cached on my Docker host

`docker rmi $(docker images --quiet)`

After I have done this my Docker Host is clean and pristine.

Sometimes Docker does not allow me to delete an image. Most often this is the case if I have still a container running that uses this image. Thus I have to first remove all containers before I can cleanup all my images.

# Volumes

If we are using volumes with our Docker containers we might over time have some orphaned volumes hanging around in our system that occupy a lot of space. The consequences might be that all of a sudden we cannot start a new container anymore. To me it happened with the MongoDB container. Although I had no other containers running and very few images on my system the Mongo container would simply refuse to start and tell me that there is not enough space for it to create his journal file. The reason was, guess what, that I had plenty of orphaned volumes still hangign around.

We can use this command to list all the volumes on our system

`docker volume ls`

On my machine this looks like this

[<img src="https://lostechies.com/gabrielschenker/files/2016/08/docker-volume-ls.png" alt="" title="docker-volume-ls" width="682" height="217" class="alignnone size-full wp-image-1647" />](https://lostechies.com/gabrielschenker/files/2016/08/docker-volume-ls.png)

We can use the `docker volume rm [volume name]` command to remove individual volumes. Note that the volume name is often a long hash code and in this case we have to use the whole code as name; we cannot shorten it the same way as we can shorten the ID of an image or container in the context of certain Docker commands. Thus if I want to delete the first volume in the list I have to issue this

`docker volume rm 0d62e958fc4b9b63614e3ef0e024472880e946364bb29c42686914e6574bc238`

If we want to remove **all** orphaned containers at once we can use this command

`docker volume rm $(docker volume ls | awk '{print $2}')`

Once we have removed all unnecessary volumes our system is clean and light weight again and in my particular case the mongo container would start happily as expected.

# Summary

In this post I have discussed various techniques and commands which allow us to keep our Docker environment clean and pristine. Three things we need to watch out for: containers that are either running or in status `Exited`, Docker images that are obsolete and finally orphaned Docker volumes.

I am fully aware that I have repeated and discussed some of the basic commands of the Docker CLI yet I am not ashamed of it since only if I master the basic concepts blindly, I can also tackle and solve the more tricky problems in and around containers.