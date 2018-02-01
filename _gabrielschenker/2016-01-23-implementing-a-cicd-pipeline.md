---
id: 1145
title: Implementing a CI/CD pipeline
date: 2016-01-23T17:34:14+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1145
dsq_thread_id:
  - "4517615541"
categories:
  - .NET
  - Architecture
  - containers
  - continuous deployment
  - Design
  - How To
  - introduction
  - Micro services
  - Patterns
  - practices
  - Uncategorized
---
# Introduction

In one of my [previous posts](https://lostechies.com/gabrielschenker/2015/08/03/continuous-deployment/ "Continuous deployment") I have talked about continuous deployment and continuous delivery and why it is important. In a series of posts I want to describe in detail the various patterns that are necessary to successfully implement a fully automated CI/CD pipeline and also provide sample implementations of those patterns.

# Boundary Conditions

Before I start I need to define our boundary conditions. The following descriptions are based on a real implementation for a customer. The starting point is a huge monolithic web application that has been up and running for a few years and has been maintained and improved by several teams using a somewhat manual continuous delivery pipeline. Deployments happen(ed) several times per day into production with zero downtime. The application is written in C# on top of .NET. The web layer consists of a mixture of Web Forms and ASP.NET MVC. The back-end functionality is at least partially exposed via a RESTful API implemented in ASP.NET Web API 2.  There is also a mobile client for iOS and Android that consumes the Web API. Due to various reasons that are not discussed here the customer wanted to migrate the monolithic application to a micro service based architecture and at the same time wanted to improve the continuous delivery pipeline into a fully automated continuous deployment pipeline. Over time coherent functionality is and will be identified and isolated in the monolith and extracted into independent micro services. The functionality is not re-implemented from scratch but only refactored until it can be extracted into a micro service. For this reason, at the moment, all application logic will continue to be implemented in C# on .NET. Additionally, at least for the foreseeable future, the application needs to run in a private cloud. At the time when the project started .NET core was not yet released and Windows containers were still in an early alpha state (TP4). Also since the application uses some specialized external libraries that depend on specific Windows functionality running the micro services on top of Mono in Linux was not an option. That means that at this time we cannot use container technology (Docker) for the micro services. But we are making sure that we are ready to embrace this technology as soon as it is released. On the other hand we are free to use Linux and Docker for all supporting services. Samples are MongoDB, Solr, RabbitMQ, etc.

# Table of Content

This is the list of topics I am going to cover in this series of posts. I will add hyperlinks to the relative posts as soon as they are available. This list may change over time as I see fit.

  * [Micro service based architecture](https://lostechies.com/gabrielschenker/2016/01/23/micro-service-based-architecture/ "Micro service based architecture")
  * [Zero down time](https://lostechies.com/gabrielschenker/2016/04/16/zero-downtime/)
  * Service discovery 
      * [part 1](https://lostechies.com/gabrielschenker/2016/01/27/service-discovery/ "Service discovery – part 1")
      * [part 2](https://lostechies.com/gabrielschenker/2016/02/18/service-discovery-part-2/ "Service discovery – part 2")
  * [Auto healing](https://lostechies.com/gabrielschenker/2016/01/29/auto-healing/ "Auto Healing")
  * Feature toggles
  * Database migrations
  * [Blue-green deployment](https://lostechies.com/gabrielschenker/2016/05/23/blue-green-deployment/)
  * A/B-testing
  * Logging and performance monitoring
  * Infrastructure as code
  * Security

## Examples / Variations

  * CI with TeamCity and Docker 
      * [Part 1](https://lostechies.com/gabrielschenker/2016/03/22/ci-with-teamcity-and-docker/ "CI with TeamCity and Docker")
      * [Part 2](https://lostechies.com/gabrielschenker/2016/03/28/ci-with-teamcity-and-docker-part-2/ "CI with TeamCity and Docker – Part 2")
      * [Part 3](https://lostechies.com/gabrielschenker/2016/04/01/ci-with-teamcity-and-docker-part-3/ "CI with TeamCity and Docker – Part 3")
  * [Blue-Green Deployment in Docker Cloud](https://lostechies.com/gabrielschenker/2016/04/07/blue-green-deployment-in-docker-cloud/)