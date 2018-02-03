---
wordpress_id: 1192
title: What Microservices Is Not
date: 2016-06-03T14:52:06+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1192
dsq_thread_id:
  - "4880917181"
categories:
  - DomainDrivenDesign
  - Microservices
---
From what the term “Service” does not imply, from “[What is a service (2016 edition)](https://onedrive.live.com/view.aspx?resid=123CCD2A7AB10107!736362)”:

  * “Cloud”
  * “Server”
  * “ESB”
  * “API”
  * XML
  * JSON
  * REST
  * HTTP
  * SOAP
  * WSDL
  * Swagger
  * Docker
  * Mesos
  * Svc Fabric
  * Zookeeper
  * Kubernetes
  * SQL
  * NoSQL
  * MQTT
  * AMQP
  * Scale
  * Reliability
  * “Stateless”
  * “Stateful”
  * OAuth2
  * OpenID
  * X509
  * Java
  * Node
  * C#
  * OOP
  * DDD
  * etc. pp.

We can apply a similar list to Microservices, where the term does not imply any technology. That’s difficult these days because so much marketecture conflates “Microservices” with some specific tool or product. “Simplify microservice-based application development and lifecycle management with Azure Service Fabric”. Well, you certainly don’t need PaaS to do microservices. And small is small enough when it’s not too big to manage, and no more. Not pizza metrics or lines of code.

So microservices does not imply:

  * Docker/containers
  * Azure/AWS
  * Serverless
  * Feature flags
  * Gitflow
  * NoSQL
  * Node.js
  * No more than 20 lines of code in deployed service
  * Service Fabric
  * AWS Lambda

Instead, focus more on the characteristics of a microservice:

  * Focused around a business domain
  * Technology agnostic API
  * Small
  * Autonomous
  * Autonomous
  * Autonomous

Most of the other descriptions or prescriptions around microservices are really just a side-effect of autonomy, but those technologies prescribed certainly aren’t a requirement to build a robust, scalable service.

My suggestion – go back to the DDD book, read the Building Microservices book. Just like DDD wasn’t about entities and repositories, microservices isn’t about Docker. And once you do get the concepts, then come back to the practitioners to see how they’re building applications with microservices, and see if those tools might be a great fit. Just don’t cargo-cult microservices like so many did before with DDD and SOA.