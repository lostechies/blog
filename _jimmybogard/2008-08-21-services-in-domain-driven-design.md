---
wordpress_id: 221
title: Services in Domain-Driven Design
date: 2008-08-21T12:07:24+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/08/21/services-in-domain-driven-design.aspx
dsq_thread_id:
  - "264779568"
categories:
  - DomainDrivenDesign
redirect_from: "/blogs/jimmy_bogard/archive/2008/08/21/services-in-domain-driven-design.aspx/"
---
Services are first-class citizens of the domain model.&nbsp; When concepts of the model would distort any Entity or Value Object, a Service is appropriate.&nbsp; From Evans&#8217; DDD, a good Service has these characteristics:

  * The operation relates to a domain concept that is not a natural part of an Entity or Value Object
  * The interface is defined in terms of other elements in the domain model
  * The operation is stateless

Services are always exposed as an interface, not for &#8220;swappability&#8221;, testability or the like, but to expose a set of cohesive operations in the form of a contract.&nbsp; On a sidenote, it always bothered me when people say that an interface with one implementation is a design smell.&nbsp; No, an interface is used to expose a contract.&nbsp; Interfaces communicate design intent, far better than a class might.

But most examples I see of Services are something trivial, such as IEmailSender.&nbsp; But Services exist in most layers of the DDD layered architecture:

  * Application
  * Domain
  * Infrastructure

An Infrastructure Service would be something like our IEmailSender, that communicates directly with external resources, such as the file system, registry, SMTP, database, etc.&nbsp; Something like NHibernate would show up in the Infrastructure.

Domain services are the coordinators, allowing higher level functionality between many different smaller parts.&nbsp; These would include things like OrderProcessor, ProductFinder, FundsTransferService, and so on.&nbsp; Since Domain Services are first-class citizens of our domain model, their names and usages should be part of the Ubiquitous Language.&nbsp; Meanings and responsibilities should make sense to the stakeholders or domain experts.

In many cases, the software we write is replacing or supplementing a human&#8217;s job, such as Order Processor, so it&#8217;s often we find inspiration in the existing business process for names and responsibilities.&nbsp; Where an existing name doesn&#8217;t fit, we dive into the domain to try and surface a hidden concept with the domain expert, which might have existed but didn&#8217;t have a name.

Finally, we have Application Services.&nbsp; In many cases, Application Services are the interface used by the outside world, where the outside world can&#8217;t communicate via our Entity objects, but may have other representations of them.&nbsp; Application Services could map outside messages to internal operations and processes, communicating with services in the Domain and Infrastructure layers to provide cohesive operations for outside clients.&nbsp; Messaging patterns tend to rule Application Services, as the other service layers don&#8217;t have a reference back out to the Application Services.&nbsp; Business rules are not allowed in an Application Service, those belong in the Domain layer.

In top-down design, we typically start from the Application or Domain Service, defining the actual interface clients use, then use TDD to drive out the implementation.&nbsp; As we&#8217;re always starting from the client perspective with actual client scenarios, we get a high degree of confidence that what we&#8217;re building will create success and add value.&nbsp; When stories are vertical slices of functionality, this is fairly straightforward, at least mechanically so.

I used to make the mistake of dismissing Services as a necessary evil, confined to the Infrastructure layer.&nbsp; Through more reading and conversation through our recent Austin DDD Book Club, I&#8217;ve started to realize the potential the Application and Domain services have in creating a well-designed model.