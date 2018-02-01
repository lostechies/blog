---
id: 1534
title: 'Containers &#8211; What&#8217;s the big Deal?'
date: 2016-06-18T22:02:34+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1534
dsq_thread_id:
  - "4921595398"
categories:
  - CI/CD
  - docker
---
As I write this I am sitting in the plane from Austin TX to Seattle WA where I will attend [DockerCon 2016](http://2016.dockercon.com). This conference is one of the most vibrant conferences I have witnessed so far and I am really excited to be part of it. Containers are gaining more and more importance in IT for various reasons and [Docker](http://www.docker.com) is the first company that made containers accessible to the masses, that is people like you and me. Containers have been around for a while but it was very hard to get applications running in containers and the technology was very proprietary.

# Experimenting

As an architect I write a lot of applications to do some proof of concept or some feasibility studies. Containers make my life much easier these days. I can quickly setup a complex environment on my laptop without having to install applications, servers like databases, frameworks and libraries directly on my machine. I can run everything in a container and when I&#8217;m done just stop and remove the respective containers. No traces will be left on my machine, which is great.

## Single VM

Setting up a complex, production like environment on my machine is quick and easy when I&#8217;m using `docker-compose`. I can declaratively define my system using a `yaml` file and then get everything going with a simple command `docker-compose up`.

## Using a cluster

I can even run a whole cluster of VMs on my laptop and manage them using [Docker Swarm](https://docs.docker.com/swarm/). These days developer laptops often are configured with 16 GB or more RAM. The default Linux image that comes with [Docker Toolbox](https://www.docker.com/products/docker-toolbox) needs about 1 GB thus it is not unrealistic to play with clusters of 6 nodes or so without running into troubles. On a side note, when I am talking about a _node_ I implicitely mean a **Docker Host**, that is a VM or bare metal server which is configured as a Docker Host. With 6 nodes I can simulate a swarm that provides high availability &#8211; I can e.g. configure 3 swarm managers and 3 swarm agents. Docker Swarm allows me to manage my cluster as if it was one single very powerful and highly available node. Through swarm I can schedule my containers using deployment strategies and affinities. This is really powerful and quite easy to achieve. The beauty being that Docker Swarm uses the very same Docker API we&#8217;re already familiar when dealing with only one Docker Host. Thus a command like this

`docker run -dt --name nginx -p 80:80 nginx`

Will run a container with `nginx` on the node of my cluster that is most appropriate. This is the exact same command one would use on a single Docker Host (without Docker Swarm). The command is run against the Swarm Manager, thus my Docker CLI needs to be connected to this Swarm Manager.

Since in the above command I have not explicitely defined an affinity the container will be deployed according to the deployment strategy the swarm has been configured with. By default this is the so called `spread` strategy which uses a round robin type of deployment.

Due to the fact that in a swarm I can use standard Docker commands there is no reason why I cannot use `docker-compose` to run a complex application on a cluster.

# A Developer&#8217;s Laptop

If our company fully embraces containers then ideally the software engineers would only need to install a very limited set of tools on their Macs or Windows laptops. If the engineer is using Linux as the OS then the situation is even simpler. \* favorite code editor \* Git client * Docker Toolbox (or [Docker for Mac or Windows](https://beta.docker.com/) [currently in beta])

The last step is NOT needed if working on Linux since we can run all Docker tools natively on Linux.

## A Python Developer

Let&#8217;s assume our engineers work on a project using [Angular](https://angularjs.org/) for the front end and **Python**, [Django](https://www.djangoproject.com/), [Mongo DB](https://www.mongodb.com/), [Celery](http://www.celeryproject.org/) with [RabbitMQ](https://www.rabbitmq.com/), etc. on the backend. In this situation we would probably chose [PyCharm](https://www.jetbrains.com/pycharm/) as IDE and install it directly on our Mac or Windows Laptop. There is no need to install e.g. Django, Mongo DB or RabbitMQ since those will all run inside a container.

Our `Dockerfile` would/could look like this

[gist id=7a8b1dec9fdf4b1addeda011d1a38e34]

Note how I first copy ONLY the `requirements.txt` file into the container (image) and run `pip install` and then copy the remaining project files into the container. This is to leverage the fact that a Docker image is built from layers and that if a layer hasn&#8217;t changed it will be reused when re-building the image. Since `pip install` takes a while and since we change the source code much more frequently than the content of the `requirements.txt` the re-build of the image will be much much faster. `pip install` ONLY has to occurr whenever we add a new dependency, which happens rarely compared to other code changes.

And the `docker-compose.debug.yml` file could look similar to this

[gist id=86a5f8e9ba5e6fd0b1d94a38a0345687]

Note how I mount the current directory as a volume inside the container running our application. This allows us to do **edit and continue** style of development. As the engineer changes a code file in her editor the file is automatically updated inside the container too. As a consequence the Django (web-) server will automatically restart and she can immediately see the result of her change. There is no need to rebuild the Docker image and run a new container. Of course this volume mounting is only desired during development &#8211; in production (or any other environment) we would never do this.

So, during development the engineer would run the application using this command

`docker-compose -f docker-compose.debug.yml up --build`

Note the `--build` parameter which makes sure that the application image is rebuilt and `docker-compose` doesn&#8217;t use the existing stale image. The part `-f docker-compose.debug.yml` simply instructs `docker-compose` to use the declared `yaml` file instead of the default file called `docker-compose.yml`.

## Testing

Testing is another area where containers make our lives as software engineers much simpler. Let&#8217;s assume we have a micro service running in a container and we now want to run some API tests against this service. We can craft a test script e.g. written in `bash` and run it inside another (test-) container. Once again we can write a `yaml` file to setup and run our tests using `docker-compose`. Often such a docker compose file is then called `docker-compose.test.yml` and we have to use a slightly modified command to run

`docker-compose -f docker-compose.test.yml up`

The very same tests can be run on our laptop and on the continuous integration (CI) server.

## Ideal work flow

Ideally when a new developer comes on board of a project we want her to be productive as quickly as possible. Our new developer should only have to have her favorite code editor installed on her laptop as well as a Git client (assuming we&#8217;re using Git as our source control management system [SCMS]). If the project she&#8217;s supposed to work on is called `heart-beat` she can use a sequence of commands like these to get started

`cd ~<br />
git clone https://[url-to-git-repo]/heart-beat.git<br />
cd heart-beat<br />
docker-compose up`

This would pull down the latest source code on her machine, build a Docker image from the source, pull down all dependent images (e.g. databases used by the app) from [Docker Hub](http://hub.docker.com) and run the application.

This whole process should take only a few minutes. Isn&#8217;t that amazing? From zero to having the full application built and running on a new developer&#8217;s laptop in a matter of few minutes&#8230;

To run the tests for the application our new developer would simple use this command

`docker-compose -f docker-compose.test.yml up`

# Continuous Integration

Typically teams use a product like [Jenkins](https://jenkins.io/) or [TeamCity](https://www.jetbrains.com/teamcity/) to run their continuous integration (CI) builds. If we don&#8217;t use containers then we have to install all the frameworks and libraries on the CI server or agents. As long as we only have exactly one project this might not be a problem but once our CI server needs to build different projects using different frameworks and libraries then it gets complicated. Specifically tricky is the situation where we have to deal with different versions of the same frameworks or libraries on the CI server/agent.

If we embrace containers the above problems are a matter of the past. We can run the CI server and the CI agents in containers and the CI agents in turn build container images. There is no need anymore to install frameworks and libraries on the CI server and agents. As a welcome side effect it is also much much easier to scale up and down our CI infrastructure based on demand. The deployment of a new agent takes no time at all.

For further details please also read my 3 posts about Docker-izing TeamCity ([part 1](https://lostechies.com/gabrielschenker/2016/03/22/ci-with-teamcity-and-docker/), [part 2](https://lostechies.com/gabrielschenker/2016/03/28/ci-with-teamcity-and-docker-part-2/), [part 3](https://lostechies.com/gabrielschenker/2016/04/01/ci-with-teamcity-and-docker-part-3/)).

# Test and Demo Environments

Once we have container-ized our whole application it is extremely simple to setup a test or demo environment either locally or in the cloud. For test and demo purposes it is usually sufficient to run everything on a single Docker Host. Assuming we have selected a cloud provider like AWS as target we can e.g. use `docker-machine` to define a new Docker Host. The commands to get us going would look similar to this

`docker-machine create ...<br />
eval $(docker-machine env demo-1)<br />
docker-compose -f docker-compose.demo.yml up`

The first command uses `docker-machine` to create a new VM called `demo-1` in AWS. The VM is automatically configured as a Docker Host. Using the second command we then connect our client CLI to this new VM in AWS. Finally we use a special demo `yaml` file `docker-compose.demo.yml` and `docker-compose` to deploy and run our demo application on the newly created VM in the cloud.

Fantastic I have to say! Once again, in a matter of minutes we are up and running with a complete pristine demo environment.

Being good citizens we always clean up after ourselves. We can use this command to do so

`docker-compose -f docker-compose.demo.yml down<br />
docker-machine stop demo-1<br />
docker-machine rm demo-1`

The first command tears down our demo application; the second and third command stop and delete the VM we have used for our demo.

# Conclusion

In this post I have tried to summarize some of the most convincing reasons why we should embrace containers. Even if we don&#8217;t use containers in production yet (why not?), there are many many compelling reasons to use Docker.

When done right the use of containers can tremendously reduce friction in the software development process. On-boarding of new developers, testing, continuous integration and building demo environments are just a few of the areas where we can leverage the benefits.

During the next few days I&#8217;m going to enjoy [DockerCon 2016](http://2016.dockercon.com). I hope to learn a lot of new cool things from the experts. I will try to blog about what I have learned. Keep tuned!