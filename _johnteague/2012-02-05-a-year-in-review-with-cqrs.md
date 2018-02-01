---
id: 94
title: A year in review with CQRS
date: 2012-02-05T21:31:54+00:00
author: John Teague
layout: post
guid: http://lostechies.com/johnteague/?p=94
dsq_thread_id:
  - "565533231"
categories:
  - Uncategorized
---
For the past year my team has been building and maintaining and application using CQRS with an Event Store as our persistence model.  I started gathering requirements for this project last January and the team started development in February.  We deployed the first version in June.  The first version was the bare minimum the end users needed to stop using Excel for the database and manual process.  After the initial deployment we continued to make further enhancements to put in the &#8220;Oops we really need this feature&#8221; to the application and usability enhancements to make it even more functional.  We are still working on this application today.  The business made a radical change in process and now were changing the application to meet the new needs of the business.

Given our history with this application and the phases we&#8217;ve gone through (initial development, maintenance / enhancements, and complete change in process) I think it&#8217;s a good case study in the feasibility of using CQRS style applications.  We&#8217;ve made some good decisions and some, err.., not so good decisions that I learned quite a bit from.

### A little about the Application

The application is the standard &#8220;enterprise workflow&#8221; application, where the end users work product goes through several stages and different people do different tasks in order to complete the work.  These type of State-based, processes fit well with the CQRS model, as different events occur on the items in question, which determine what&#8217;s required and what action needs to take place.  There were very few &#8220;CRUD&#8221; type screens, but there were a few.

### My definition of CQRS

> Separate models for reads and writes

I think my definition heavily influenced how we built this application.  Notice there&#8217;s nothing there about messaging, MSMQ, distributed architecture, Event Sourcing, etc&#8230;  We did use some of these technologies and architecture in this app, however _they are not required for CQRS_. It&#8217;s simply an acknowledgement that the write model looks and behaves differently from the read model.  This simple acknowledgment can have profound impact on the way build your application and your ability to solve problems for your end users (and if you&#8217;re not doing that, well&#8230;)

### Not Everything has to fit into the CQRS Mold

I think one common mistake made while building applications with CQRS is forcing every single functionality through the CQRS square hole.  There were parts of our application that were very simple and did not require the complexity of CQRS.  That&#8217;s right, CQRS is complex. I said it.  Commands must be created, validated and executed.  Events must be fired and handled.  Usually the complexity is mitigated by the simplification of the domain models.  But if you&#8217;re domain models are already simple, then a simpler approach will yield better results.

### Do Not Start With a Distributed Architecture

When most people see examples or presentations of CQRS, it usually includes some sort of distributed architecture, where the commands and messages are put on some sort of queue, like MSMQ, RabbitMQ, or whatever.  And there can be some great advantages when using these techniques, mostly scalability.  Using a distributed approach increases the complexity to a whole new level.  However it is simply not necessary, at least at first.

For our application, we created a very simple in-process bus.  Meaning, execution of the command and all events were executed on the same thread.  We used an IOC container to find all of the event handlers based upon the event class type. It is a web application, so the threads were handled by the web server.  For a typical event, we had 4-6 event handlers, updating 4-5 different database tables.

There were some real advantages to starting with an in-process model.  We were able to get faster feedback when errors came up, and it was easier for us to find and fix bugs. This enabled us to build the application faster and get it into the end users quickly.

Once we were in production, we started recording metrics on the how quickly requests took and where there were performance issues.  What we discovered was the only real performance issues were when the users would perform batch operations, the same operation on many records (set based operations are nearly impossible with this architecture, or at least I haven&#8217;t figured out how to do it).  So once we determined which functions were commonly done in batch form, we moved them out of process with NServiceBus.  I think that&#8217;s one of the areas where this approach shines.  Moving these out of process, when necessary, is really simple.

> Move work out of process only when necessary

### Think Creatively about your Domain and View Models

One of the mistakes we made was the design of our domain models.  From a purely DDD / aggregate root / ubiquitous language, there was really only one AR.  But having just one AR means it&#8217;s REALLY big.  In retrospective, we should have been more creative with how we define the AR into something different.  Honestly, while this application has come complicated logic, I don&#8217;t think that we needed to solve it with a Domain Driven approach.  However, the library we used (per client request) required us to do so.  I don&#8217;t have a solution for this yet, when I do I&#8217;ll let you know (hint, I think the Actor/Model patter Chris Patterson has been talking about is a better fit).

### Event Sourcing &#8230; Meh

Event Sourcing has been probably the most misunderstood and miscommunicated implementation strategy surrounding CQRS.  Like other pieces of the architecture, it&#8217;s an implementation choice, not a requirement for building this type of application.  Honestly, I was never sold on the concept before this project.  On this project I don&#8217;t think we got any of the benefits touted from using it.  To be clear, I think one of the problems is our implementation of the Event Sourcing persistence.  We are currently storing a binary copy of the event.  Which means that event lives in perpetuity and we can&#8217;t change it nor get rid of it. If it was serialized with something like Protocol Buffers I think we would have more flexibility, but I haven&#8217;t tested that yet so I can&#8217;t say for certain.

The biggest feature about using ES is the ability to replay the events and rebuild the state of your view models.  This sounds really cool, you get the ability to create new views in your application (like new reports)  and be fully avaialble with all data as if they were there from the beginning.  The only problem is that we&#8217;ve only done that once in the entire lifetime of the application.

But at the same time, using the event sourcing approach hasn&#8217;t really cost us anything either.  In the end, for this application, I would have been happy with just a Key-Value store of data or a document database for aggregate persistence.

Overall, I&#8217;m pleased with the application.  Like I said there was a big change in business process and we&#8217;ve been able to make those changes very fast in my opinion.  This is mainly due to the extreme decoupling you get from the way views are represented to how a domain object is changed or created.  I will likely continue to create applications of this type using this approach.  With a few changes underneath of course:)