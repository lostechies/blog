---
wordpress_id: 1150
title: Micro service based architecture
date: 2016-01-23T17:34:53+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1150
dsq_thread_id:
  - "4517615897"
categories:
  - Architecture
  - introduction
  - Micro services
  - Patterns
---
# Introduction

This post is part of a series that describes the implementation of a fully automated continuous deployment pipeline. For an overview and a table of content please refer to [this post](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/ "Implementing a CI/CD pipeline").

In this post I want to discuss what a micro service is and what it is not. I also want to list some reasons why you want to use micro services and why you might want to avoid them. Finally I want to give a brief overview of the implications when using a micro service based architecture.

# Micro service what?

The word **micro** is misleading many developers that first encounter this pattern. It should not be taken literally. We should rather thing of a micro service (MS) being something smallish.

A MS most often is a set of coherent functionality that logically belongs together. If you are familiar with [DDD](https://lostechies.com/gabrielschenker/2015/04/16/ddd-revisited/ "DDD revisited") you can think of it as the implementation of **bound context**. But this is not the only way how we can define a MS. Other reasons are possible, why you would want to wrap a piece of functionality into a MS. Some are

  * **Frequency of change**: Part of the application needs to be changed frequently whilst the remaining part is rather stable and changes rarely.
  * **Infrastructure**: Part of the application has very specific requirements on the infrastructure it runs on. This can be e.g. an extreme need for RAM or disk I/O or network throughput. The remaining of the application does not have this very specific requirement.
  * **Scalability**: Part of the application needs to be very scalable compared to the remainder of the application
  * **Security**: Some elements of the application have very high security constraints.
  * **Tool set**: Parts of the application would benefit from being implemented in a specialized language, e.g. a functional language like F# or Clojure.
  * **Platform**: Sometimes we want to run parts of the application on another platform like a different flavor of Windows or Linux.
  * etc.

#  Characteristics of a micro service

Once we have identified the functionality we want to implement as a micro service we need to make sure our micro service has the following characteristics

  * The micro service acts like a black box to the outside world. It has **well defined** external facing interfaces.
  * A micro service should be replaceable by another implementation of the same functionality without side effects. _Of course the new implementation needs to implement the same contracts as the previous implementation._
  * The contracts with the outside world are well defined and should **change infrequently** if ever possible.
  * Contracts with the outside world need to be **versioned** to make a micro service backwards compatible with older consumers. New consumers can use the newer version of the interface and/or contract.
  * A micro service should have its **own code repository** e.g. on GitHub or any other source code version control software you&#8217;re using. _Note: Some people do not like this but then at least the micro service should have its own sub-reporsitory inside the main repository._
  * Each micro service is its own **unit of deployment**. Each MS evolves independently from the other parts of the application and can be deployed at any time without a need to also deploy newer versions of other micro services._
  
_ 

Since by definition a micro service is smallish then it follows that the amount of code necessary to implement a micro service is limited. As a consequence we can often avoid to implement certain patterns that are used in a monolith to tame the complexity of an ever growing monolith. Such patterns can be the use of an IoC container or the use of a ORM like NHibernate or Entity Framework.

# Interfaces of a micro service

The functionality of a micro service needs to be accessible from the outside world. For this reason any micro service implements a set of well defined interfaces. Often these interfaces are implemented as RESTful APIs. But this is by far not the only option at hand. Other possible types of interfaces are message queue handler, tcp/ip or udp based interfaces, etc. Since in a typical application most of the micro services are not exposed to the public we are free to use whatever protocol or technology suits best our needs. Thus don&#8217;t artificially restrict yourself to the use of only RESTful APIs. It is much more important that the interface of a micro service remains stable over time and is versioned.

# Samples of micro services

To not just talk abstractly about micro services lets give a few samples of what would be good candidates for a micro service

  * **Product catalog**: This service provides functionality to maintain the inventory of a shop such as adding, modifying and discontinuing products.
  * **Shipping**: Once a customer has placed an order this service handles the shipping of the products to the customer.
  * **Document generator**: To comply with certain regulations and laws documents have to be generated during a business transaction and be presented to the customer. A typical sample document is the adverse action notification whenever the a hard inquiry for the credit score of a customer has been made. This service generates documents based on templates and fills in dynamic data.
  * **Email service**: this service is responsible to generate emails from templates using a technology like mail merge and send the finished emails using a SMTP server to the recipients. Emails can be triggered by events or be sent based on a predefined schedule.