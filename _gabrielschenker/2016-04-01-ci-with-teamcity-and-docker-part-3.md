---
id: 1309
title: 'CI with TeamCity and Docker &#8211; Part 3'
date: 2016-04-01T09:24:38+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1309
dsq_thread_id:
  - "4711701924"
categories:
  - ASP.NET vNext
  - CI/CD
  - containers
  - docker
  - How To
  - introduction
---
# Introduction

This is the 3rd part of a post about using TeamCity and Docker to provide Continuous Integration. Here you can find [part 1](https://lostechies.com/gabrielschenker/2016/03/22/ci-with-teamcity-and-docker/ "CI with TeamCity and Docker – Part 1") and [part 2](https://lostechies.com/gabrielschenker/2016/03/28/ci-with-teamcity-and-docker-part-2/ "CI with TeamCity and Docker – Part 2").  It is part of the series about [Implementing a CI/CD Pipeline](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/ "Implementing a CI/CD pipeline"). Please refer to [this](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/ "Implementing a CI/CD pipeline") post for an introduction and a complete table of content.

In this part I want to first provide a better alternative than using Docker in Docker which has a lot of drawbacks and potential side effects. Further more I want to discuss how we can use Docker to test our container containing the code.

# Avoid Docker in Docker

According to the author of the Docker in Docker (DID) solution it is actually [not a good idea](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/) to use DID in Continuous Integration (CI). As he points out DID has various disadvantages and side effects when used in CI. Thus I decided to look out for a better solution. The same author suggests how we can configure our build agent to be able to use Docker and create sibling containers instead of nested containers. We basically have to mount the Docker sock volume of the host to the container

[gist id=d404e6e9f4eda912f7192f036436a5f0]

In doing so we can now access Docker from within the agent container and execute all operations that we normally can do on the Docker Host.

I also found some better suited Docker images for [TeamCity](https://hub.docker.com/r/sashgorokhov/teamcity/) and [TeamCity Agents](https://hub.docker.com/r/sashgorokhov/teamcity-agent/). Together with this Docker-Compose Yaml file

[gist id=c43067dd8b225f95aaa1e7312376783b]

To start a pair of TeamCity and Agent we need to navigate to the folder containing the above yaml file and use this command

[gist id=3670f4340bbb4178bfc9d2f42cbcba92]

After a minute or so TeamCity and Agent will be ready to be used and I can access TeamCity as usual port 8111 of my Docker Host (i.e. 192.168.99.100:8111 in my case).

# Testing our Code

Part of CI is testing the just built artifacts. Docker makes this really simple and convenient. We can run an instance of our code in a Docker container and then run another container which contains our tests. Those tests will be executed against the public API of the former. Once the tests are executed we can just destroy (and remove) the two containers and we are left with a clean system. Since we now need to start multiple containers we can use Docker-Compose to simplify the task. Let&#8217;s look at a sample (you can find the full source on [GitHub](https://github.com/gnschenker/docker-web-api-sample-with-tests)). Here we have the **docker-compose.test.yml** file

[gist id=4b079bfdcd98b5d75b599f6fa9acab9b]

Let&#8217;s explain this content a bit. What this file basically says is that we are creating two containers **web** and **sut** as well as a network **test**. Both containers will be part of the network **test** and thus can access each other without the need of any publicly exposed ports. The container **sut** contains our test code. We build this container by using the Docker file called **Dockerfile.test**. The container when running will have the name **ci-tests** and the Docker image from which the container is instantiated has the same name. The container **web** contains the code we want to test (in this case a ASP.NET core Web API). The image with a name of **ci-webapi** is built using the Docker file called **Dockerfile** and the name of the container when running will also be **ci-webapi**.

Note, on lines 17&18 we declare that the container web should map its internal port 5000 to port 80 of the host. For testing purposes on the CI server this is not really needed but it came in handy while I was debugging my whole setup since it allowed me to access the **web** service from my browser or from Postman.

Now to the actual test. When accessing our web API at the relative URI **/api/projects** it returns the following JSON content

[gist id=76a926f23f80c03fc84799c47fd38caa]

My test is implemented as a simple Bash script and uses curl to navigate to the URL **web:5000/api/projects** and analyzes the response and looks out for the presence of a fragment **{&#8220;id&#8221;:1,&#8221;name&#8221;:&#8221;Heart Beat&#8221;}**. If this fragment is found then the test succeeds otherwise it fails. Not the most sophisticated test I agree but it server to show the idea. The full test can be found [here](https://github.com/gnschenker/docker-web-api-sample-with-tests/blob/master/test.sh).

Once we have all prepared we can use docker-compose to build the images and execute the tests locally. Just run the following commands in your shell

[gist id=d92e416488c1463a44e13d29b4b9c9f8]

We should see a result similar to this

[<img class="alignnone  wp-image-1323" title="TestResults" src="https://lostechies.com/gabrielschenker/files/2016/04/TestResults.png" alt="" width="1309" height="474" />](https://lostechies.com/gabrielschenker/files/2016/04/TestResults.png)

Once we&#8217;re done we can tear down the whole test setup like this

[gist id=6891b0a0238085f7f588917575f6caa7]

# Configuring TeamCity

We can configure TeamCity to listen to a given GitHub repository the usual way and we can define a trigger that starts a build whenever someone pushes to the master branch of the repository. I have added one one build configuration to the TeamCity project which contains 4 build steps. All build steps are of type **Command Line**. In the first step we build the Docker images containing a) the code and b) the tests

[gist id=c667aa11e0772fa5f5ec0898e8ad6ead]

In the second step we run an instance of both containers

[gist id=dc4529db51cc5300b96f88413607dff2]

Note how we wait on line 5 until the test container has completed and exits. The Docker wait command will then returns the exit code of the container which we will use in turn as the return code of the build step (line 6). In the third step we clean up after ourselves

[gist id=1b40cc980e7a5a4a7da0182d19b9d96c]

and in the final step we push the new Docker image with the application to Docker hub. This step is of course only executed if the previous steps were all successful.

[gist id=c2e59eff0a0a92e32a3918c67fc8cbc4]

# House keeping

After a lot of experimenting my local Docker images repository got polluted with a lot of entries that are all orphaned and have no associated tag. To remove all untagged Docker images I use this command

[gist id=55ee9e738e308bd073f8e64c82cfef1c]

# Summary

In this 3rd part of the post about CI using TeamCity and Docker I showed how we can configure the TeamCity agents to not create nested Docker containers but rather siblings by mounting the docker/sock volume. I also showed how we can further leverage Docker to run tests on the build server.