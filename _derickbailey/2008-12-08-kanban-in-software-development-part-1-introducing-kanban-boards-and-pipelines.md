---
wordpress_id: 22
title: 'Kanban in Software Development. Part 1: Introducing Kanban Boards and Pipelines'
date: 2008-12-08T15:45:24+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2008/12/08/kanban-in-software-development-part-1-introducing-kanban-boards-and-pipelines.aspx
dsq_thread_id:
  - "262123906"
categories:
  - Agile
  - Kanban
  - Lean Systems
  - Management
  - Philosophy of Software
redirect_from: "/blogs/derickbailey/archive/2008/12/08/kanban-in-software-development-part-1-introducing-kanban-boards-and-pipelines.aspx/"
---
In the world of <a href="http://en.wikipedia.org/wiki/Scrum_(development)" target="_blank">Scrum</a>, <a href="http://en.wikipedia.org/wiki/Extreme_Programming" target="_blank">XP</a> and other forms of <a href="http://en.wikipedia.org/wiki/Agile_software_development" target="_blank">Agile software development</a>, many teams use visual control systems to outline the various steps that software goes through during development. These boards are known by various names &#8211;&nbsp; Scrum boards, card-boards, task-boards, swim lanes, and probably a few other names that I&#8217;m not aware of at the moment. Whatever you call it and whatever agile creed you live by, the primary use of these boards is the same all around &#8211; information radiation. Anyone can look at the board at any given moment in time, and know where in the development process a given card is. If you&#8217;re doing iterations or sprints, the board also tells you where you are in that time box &#8211; if you&#8217;re ahead, behind, or on time. The far left column &#8211; the iteration backlog &#8211; will be filled with cards at the beginning of the iteration. Over the coarse of the iteration, cards will be pushed through each of the columns until they are in the done column. The goal is for every card to be &#8220;<a href="http://codebetter.com/blogs/jeremy.miller/archive/2006/04/13/142800.aspx" target="_blank">done done</a>&#8221; by the end of the iteration, with a set of features that is now deliverable to the customer. 

### Kanban Boards

Visual management tools are very common in agile shops, and for good reason &#8211; they work very well. It should come as no surprise, then, that kanban software development also employs various visual management tools, including a kanban board. 

On the surface, there isn&#8217;t much difference between an average task board and a kanban board. Each of these boards has various columns that represent the stages that a card needs to go through before it is considered done. The real difference in a kanban board, is not the board itself. The board is just a visual indicator, the same as any task board, and the intention is still to get the cards to the &#8220;done done&#8221; state &#8211; that is, delivered to the customer so that they can use the features from that card. The real difference is how the process is approached &#8211; by <a href="http://www.lostechies.com/blogs/derickbailey/archive/2008/11/20/kanban-pulling-value-from-the-supplier.aspx" target="_blank">pulling value through the system</a>. 

### Kanban Pipelines

When dealing with a kanban process and visualizing it into a kanban board, the various steps that a card goes through is often called a pipeline. A single card starts at one end of the pipe and flows through to the other end. This flow is enabled via the pull system that happens at the end of the pipe.

In the grocery store example from <a href="http://www.lostechies.com/blogs/derickbailey/archive/2008/11/20/kanban-pulling-value-from-the-supplier.aspx" target="_blank">my previous post on pulling value</a>, the pipeline would would likely include the store shelf, the store back room, the warehouse, the supplier and the product creator.

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="192" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_thumb_1.png" width="618" border="0" />](http://lostechies.com/derickbailey/files/2011/03/image_3.png) 

### A Simple Software Development Pipeline

A software development pipeline works the same way as the grocery store pipeline. In this case, though, the product flowing through the pipe is likely to be a feature of the software package. 

Consider the following three columns in a simple pipeline for software development: Analysis, Development and Testing. When a customer requests a given feature for a software product, they want to pull that feature out of testing so that they can start using it.

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="192" alt="Customers Pull From Testing To Use A Feature" src="http://lostechies.com/derickbailey/files/2011/03/image_thumb_10.png" width="429" border="0" />](http://lostechies.com/derickbailey/files/2011/03/image_22.png) 

Once that feature has been moved out of Testing and the customer is ready to pull the next feature out, there isn&#8217;t anything to pull. At this point, the Testing people would then try to pull the next feature out of Development.

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="192" alt="Testers Pull From Development To Test A Feature" src="http://lostechies.com/derickbailey/files/2011/03/image_thumb_13.png" width="361" border="0" />](http://lostechies.com/derickbailey/files/2011/03/image_28.png) 

And the same pull happens from Analysis to Development. 

In the end, we have created a <a href="http://www.poppendieck.com/pipeline.htm" target="_blank">pipeline</a> for how our development process works. The work that is done flows through that pipeline based on how often the customer wants to pull features out. As one feature exits the pipeline, another feature can be added into the pipeline. 

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="192" alt="Kanban Pipeline - Features Flow Through" src="http://lostechies.com/derickbailey/files/2011/03/image_thumb_12.png" width="497" border="0" />](http://lostechies.com/derickbailey/files/2011/03/image_26.png) 

The key to all of this is, again, pulling the features through the system. 

### 

### Where Do We Go From Here?

I&#8217;ve briefly shown how we can take three steps and produce a simple pipeline for work to flow through. There is more to software development than just Analysis, Development and Testing, though. We also have to consider team size and makeup, parallel work, and other constraints. In the next entry of Kanban in Software Development, we&#8217;ll flesh out a more complete pipeline and take the next steps to show how to complete our Kanban board, enabling our customers to pull features out of our development process.