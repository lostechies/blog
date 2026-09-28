---
wordpress_id: 1578
title: 'DockerCon 2016 &#8211; Day 3, Presentations'
date: 2016-06-21T21:03:05+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1578
dsq_thread_id:
  - "4929160990"
categories:
  - Conference
  - containers
  - docker
  - Personal
---
This is the last post in the series where I talk about my experiences at [#DockerCon 2016](http://2016.dockercon.com). You can find the other posts [here](https://lostechies.com/gabrielschenker/2016/06/19/dockercon-2016-day-of-arrival/), [here](https://lostechies.com/gabrielschenker/2016/06/20/day-1-workshop-and-registration/) and [here](https://lostechies.com/gabrielschenker/2016/06/21/dockercon-2016-day-2-presentations/).

The last day of the conference was dedicated to the usage of Docker in the enterprise. In this context trust and security plays a major role. Docker presented as one key solution their paid product called [Docker Data Center](https://www.docker.com/products/overview#/docker_datacenter).

# Docker Data Center

Docker Data Center (DDC) is the commercial product of Docker. It is based on the latest version of Docker (v 1.12) and Docker Swarm as well as Docker Trusted Registry. It offers 24*7 support and a nice UI from which swarms of nodes can be managed, service and application packages defined and deployed and the health of the overall system observed. It makes containers approachable for enterprises that rely on content trust, high security and reliability next to (paid) around the clock support. DDC promotes the **build-ship-run** paradigm. Developers build container images and sign them with a cryptographic key and thus provide a clear indication of the source of the image. Enterprises can define and sign trusted base images upon which developers can build their own images. Once an image is built it can be pushed to the Docker Trusted Registry where it is scanned for vulnerabilities. The scanning always uses the most updated version of know threats and the scanning does not only happen once (at the time when the image is pushed) but is repeated at a pre-defined interval to make sure newly discovered vulnerabilities are discovered. In the end the bad guys don&#8217;t stop their hacking and always find new ways to compromise existing software. Thus even is you image was found to be flawless today it can contain a (newly discovered) vulnerability tomorrow. If this happens then the system administrator (or developer) gets informed immediately and the image can be rebuilt using a patched version of the software.

This is much safer than what we usually have in classical applications that are not using Docker. Once the application has been tested and installed in production it normally remains there as is and is not constantly monitored or scanned for potential new vulnerabilities.

A new feature of Docker 1.12, the so called DAB files which define a **Distributed Application Bundle** can be used by operations when deploying an application. The DAB file contains all information to define the totality of a distributed application, that is which services it contains and how they depend on each other. It also defines the network topology of the application. A developer can generate such a DAB file and an operations engineer can simply load it into DDC and deploy the application which the click of one button. Since DDC uses Docker and Docker Swarm under the hood the application is automatically load balanced and highly available. Service discovery works out of the box without any external dependencies.

In this post I am only scratching at the surface of the capabilities of DDC. There is a free 30 days trial available for everyone interested to give it a shot.

# Use Cases

During the main session today 2 companies were given the opportunity to present their use cases to the audience. The first one was Microsoft which also happened to be the main sponsor of DockerCon &#8211; I think this is quite amazing; I still remember when Steve Ballmer said that &#8220;&#8230; Linux is like a cancer &#8230;&#8221;.

## Microsoft

[Mark Russovich](https://azure.microsoft.com/en-us/blog/author/markruss/) presented us how Azure provides first class integration of DDC with Azure. He created a highly available Docker Swarm on Azure and deployed the well known voting app that Docker always uses in its demonstrations. The little catch was that instead of using Postgres as DB he used a Docker-ized version of MS SQL Server running on Linux as DB. He also showed us a version of the voting app written in C# using Visual Studio Code on a MacBook Pro. He even did live debugging of the C# code during the presentation.

Another nice surprise was that he added a Linux server that he had on-stage to the swarm running on Azure in the cloud. With this he demonstrated how easy it is to run hybrid clouds. Very nice. The public loved the presentation. Really Microsoft, you have gone a long way&#8230; I think the future is bright if you continue to play well with the OSS community.

Interestingly Microsoft also had a t-shirt with the slogan &#8220;Microsoft loves Linux&#8221;. Take that Steve Ballmer 🙂

# Storage

**Storage is hard&#8230;** This was one of the things that we heard multiple time in the various presentations. Brian Goff of Docker did a deep dive on Docker storage and volumes. He explained the various options available to persist data and make it durable in a containerized world. There is no silver bullet on how to solve the problem though, as always it depends on the context and the boundary conditions of each application. It is important to notice though that when we use containers the storage problem is no different than when we don&#8217;t use containers. As already mentioned, storage is really hard. Brian also mentioned that he doesn&#8217;t really see a reason why databases cannot run in containers since he has done this for more than 2 years now. He also recommended to use (database-) replication for high availability (HA) and to not share state.

# Micro Services

Michele Titolo of [Capital One](http://www.capitalone.com) presented a nice talk about how to build **friendly** micro services (MS). First she defined what in her opinion a micro service is and she came up with this

  * a MS does one thing and it does it well 
  * a MS owns its own data 
  * a MS is independent

I think that&#8217;s a pretty good definition. But now what makes a micro service a **friendly** service? Her first key point was to document each service very well. This doesn&#8217;t include only API documentation &#8211; which is important &#8211; but also more thorough documentation about the context and intent of the service.

Micro services also need to nicely coexist with other services. And a micro service should be easily scalable.

Another important factor to consider is to not go to the extreme with the **single responsibility principle**. Sometimes two or more responsibilities are so tightly coupled that if one would tear them apart and pack each into its own MS these MS would be very chatty which defeats the purpose. Also if one of the services fails the other(s) are guaranteed to fail also. Thus always be very careful where you draw the boundaries. Boundaries are best where there is naturally a loose coupling between the contexts.

Logging and monitoring were also important topics the presenter discussed. Log everything and make sure that each sequence of requests has some kind of unique ID such as that when problems arise they can be more easily tracked. Don&#8217;t forget that there will be a tremendous amount of logging information accumulated over time and we need to find the needle in the haystack.

# Heading Home

Now I am waiting for my shuttle bus to the airport. I have to take an overnight flight back home since tomorrow I have to go to work. My head is filled with a lot of great information. I had the opportunity to talk with a lot of very interesting people during the conference. All in all it was a great experience. #DockerCon and Docker, I will be back!