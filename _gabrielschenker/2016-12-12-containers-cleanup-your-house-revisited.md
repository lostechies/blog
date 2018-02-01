---
id: 2113
title: 'Containers &#8211; Cleanup your house revisited'
date: 2016-12-12T21:10:02+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=2113
dsq_thread_id:
  - "5376046126"
categories:
  - containers
  - docker
  - How To
  - introduction
tags:
  - containers
  - Docker
  - utility
---
In version 1.13 Docker has added some useful commands to the CLI that make it easier to keep our environment clean. As you might have experienced yourself over time our development environment gets really cluttered with unused containers, dangling Docker images, abandoned volumes and forgotten networks. All these obsolete items take aways precious resources and ultimately lead to an unusable environment. In a [previous post](https://lostechies.com/gabrielschenker/2016/08/14/containers-clean-up-your-house/) I have shown how we can keep our house clean by using various commands like

    docker rm -f $(docker ps -aq)
    

to forcibly remove all running, stopped and terminated containers. Similarly we learned commands that allowed us to remove dangling images, networks and volumes.

Although the commands I described solved the problem they were proprietary, verbose or difficult to remember. The new commands introduced are straight forward and easy to use. Let&#8217;s try them out.

> If you like this article then you can find more posts about containers in general and Docker in specific in [this](https://lostechies.com/gabrielschenker/2016/08/26/containers-an-index/) table of content.

# Management Commands

To un-clutter the CLI a bit Docker 1.13 introduces new management commands. The list of those are

  * system
  * container
  * image
  * plugin
  * secret

Older versions of Docker already had `network, node, service, swarm` and `volume`.

These new commands group subcommands that were previously directly implemented as root commands. Let me give an example

    docker exec -it [container-name] [some-command]
    

The `exec` command is now a subcommand under `container`. Thus the equivalent of the above command is

    docker container exec -it [container-name] [some-command]
    

I would assume that for reasons of backwards compatibility the old syntax will stick around with us for the time being.

# Docker System

There is a new management command `system`. It has 4 possible subcommands `df, events, info` and `prune`. The command

    docker system df
    

gives us an overview of the overall disk usage of Docker. This include images, containers and (local) volumes. So we can now at any time stay informed about how much resources Docker consumes.

If the previous command shows us that we&#8217;re using too much space we might as well start to cleanup. Our next command does exactly that. It is a _do-it-all_ type of command

    docker system prune
    

This command removes everything that is currently not used, and it does it in the correct sequence so that a maximum outcome is achieved. First unused containers are removed, then volumes and networks and finally dangling images. We have to confirm the operation though by answering with `y`. If we want to use this command in a script we can use the parameter `--force` or `-f` to instruct Docker not to ask for confirmation.

# Docker Container

We already know many of the subcommands of `docker container`. They were previously (and still are) direct subcommands of `docker`. We can get the full list of subcommands like this

    docker container --help
    

In the list we find again a `prune` command. If we use it we only remove unused containers. Thus the command is much more limited than the `docker system prune` command that we introduced in the previous section. Using the `--force` or `-f` flag we can again instruct the CLI not to ask us for confirmation

    docker container prune --force
    

# Docker Network

As you might expect, we now also have a `prune` command here.

    docker network prune
    

removes all orphaned networks

# Docker Volume

And once again we find a new `prune` command for volumes too.

    docker volume prune
    

removes all (local) volumes that are not used by at least one container.

# Docker Image

Finally we have the new image command which of course gets a `prune` subcommand too. We have the flag `--force` that does the same job as in the other samples and we have a flag `--all` that not just removes dangling images but all unused ones. Thus

    docker image prune --force --all
    

removes all images that are unused and does not ask us for confirmation.

# Summary

Not only has Docker v 1.13 brought some needed order into the zoo of Docker commands by introducing so called admin commands but also we find some very helpful commands to clean up our environment from orphaned items. My favorite command will most probably be the `docker system prune` as I always like an uncluttered environment.