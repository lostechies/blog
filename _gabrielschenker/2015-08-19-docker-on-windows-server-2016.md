---
wordpress_id: 1123
title: Docker on Windows Server 2016
date: 2015-08-19T18:16:58+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1123
dsq_thread_id:
  - "4048818981"
categories:
  - .NET
  - containers
  - docker
  - Windows
---
Today the [Docker](https://www.docker.com/) team [announced](http://blog.docker.com/2015/08/tp-docker-engine-windows-server-2016/?mkt_tok=3RkMMJWWfF9wsRonuqTMZKXonjHpfsX66%2B4lXqewlMI%2F0ER3fOvrPUfGjI4ATsVhI%2BSLDwEYGJlv6SgFQ7LMMaZq1rgMXBk%3D) the availability of a technical preview of the Docker Engine for Windows Server 2016. **This is huge** for us and all software teams that work primarily on the Windows platform.

The Docker Engine for Windows is open source like the Linux counterpart. It is not using any virtualization, thus it does not use Linux but natively runs on Windows and abstracts this operating system to the container. To make this possible the Windows core team has implemented the equivalent of [namespaces and cgroups](https://en.wikipedia.org/wiki/Cgroups) known from Linux.

What does that mean for us? It means that all of a sudden we can containerize all existing and future Windows based applications, specifically all .NET applications.

I can only applaud to the docker team and to the people at Microsoft who have made this possible.