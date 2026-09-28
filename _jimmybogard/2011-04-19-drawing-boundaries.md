---
wordpress_id: 470
title: Drawing boundaries
date: 2011-04-19T01:50:14+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/04/19/drawing-boundaries/
dsq_thread_id:
  - "282929235"
categories:
  - DomainDrivenDesign
---
For the last nine months, I’ve primarily worked on an integration systems project, where my “User Interface” are things like flat files deposited on various SFTP servers, calls to web services, “RESTful” web services and so on. If there’s one thing from moving to a ginormous MVC application (2-300 controllers, 6-700 actions) to a system with NO user interface other than a thin customer service application, one thing that’s stayed constant in my experience with these system is the importance of drawing system boundaries.

The MVC application took the concept of a single, synchronous domain model to its just about maximum reach. When I first started on this current system, it was just about in the exact same place. But the problem that I ran into in both situations is that drawing the context boundaries that [Evans laments should have come first](http://www.infoq.com/presentations/ddd-eric-evans) in his Domain-Driven Design book.

We saw this in the MVC application, where we created a big board of user personas, like Larry the Barista and Carrie the Cashier. What was interesting about this exercise was that we separated the 30 or so personas into areas of concern, by color. As we closed the project, one of the most interesting aspects of these colors were that **each area of concern reasoned about the domain in entirely different ways**. There were similarities of course, but we found that by and large, the colors represented common reasoning about business processes and needed the domain distilled in different ways.

Fast forward to today, and we find that rules applied to one color don’t apply to another, and in general our highly intelligent domain model serves too many masters.

**What we missed was drawing boundaries and separating our application into distinct areas of concern.**

### Applying boundaries

These days, my first question about applying a new feature to our system is “what component should be responsible for this logic”. Not class, but individual deployed component.

One example is that we’re transitioning our FTP sending from scheduled batch jobs that poll directories, to a push model where I send an NServiceBus message “PutFileToFooBucksMessage” on the bus, and the originator simply fires and forgets:

<pre>Bus.Send(<span style="color: blue">new </span><span style="color: #2b91af">PutFileToFooBucksMessage</span>(csvFilePath));

</pre>

When the process sends this message, it continues on its way. The component that builds the file is separate from the component that actually sends the file using SFTP. Conceptually it’s similar to calling a method, as I’m coupled to an endpoint and contract, except it’s now asynchronous.

What’s really cool is that the FTP agent is a completely separate deployed component, started out with “File->New Project”, carrying none of the intellectual weight of the domain, and only containing the logic on how to FTP files. It knows how to do that, and only that.

In the past, I would have put this logic in some sort of Infrastructure project, but these days I tend to draw strict responsibility boundaries, so that one deployed component doesn’t need to know any of the How, but just the Who.

So far, I’m really impressed with how conceptually easier it is to reason about a system where the deployed component consists of only the things it needs to operate. Also, it opens many more architectural doors. Want to use stored procedures in that autonomous component? Who cares! Straight SQL? Who cares! Document databases? Go for it!

**An architecture that divides responsibilities into distinctly deployed, autonomous components maximizes the technology options for each component because of the reduced system coupling.** And that’s a good spot to be in.