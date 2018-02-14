---
wordpress_id: 23
title: 'Kanban in Software Development. Part 2: Completing the Kanban Board with Queues, Order Points and Limits'
date: 2008-12-08T19:06:45+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2008/12/08/kanban-in-software-development-part-2-completing-the-kanban-board-with-queues-order-points-and-limits.aspx
dsq_thread_id:
  - "262067988"
categories:
  - Agile
  - Kanban
  - Lean Systems
  - Management
  - Philosophy of Software
  - Retrospectives
redirect_from: "/blogs/derickbailey/archive/2008/12/08/kanban-in-software-development-part-2-completing-the-kanban-board-with-queues-order-points-and-limits.aspx/"
---
</p> 

In <a href="http://www.lostechies.com/blogs/derickbailey/archive/2008/12/08/kanban-in-software-development-part-1-introducing-kanban-boards-and-pipelines.aspx" target="_blank">Part 1 of Kanban in Software Development</a>, I introduced the concepts of kanban boards and pipelines. I also showed a very simple example of creating a pipeline for our development process. However, there were some obvious limitations in what I showed. The reality of software development is much more complicated than three simple steps (Analysis, Development and Testing). A software development team or company is going to have more to do than just these things, and there is usually a need for some team members to be cross-functional. Some team members will have to do development and testing, or analysis and development, or documentation and delivery, or any other combination of steps involved in creating software. In this post, I&#8217;ll address these issues, creating a more complete pipeline and finishing our kanban board.

### Working In A More Complete Pipeline

To create a more complete kanban board, we need more than just a three step pipeline. We need to allow for a fully functional team &#8211; developers, analysts, testers, technical writers, and others. We also need to allow the different team members to work on different parts of the system, as work is needed. The end goal is to enable the system to flow through the process and to ensure the work is "done done" before it goes to the customers. 

For a more complete software development pipeline, let&#8217;s use the following columns: Backlog, Analysis, Development, Documentation, Testing, Customer Acceptance, and Delivery. We can put together a pipeline diagram that follows these steps.

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="192" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_7.png" width="777" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_16.png) 

Now, let&#8217;s assume that we have the following team (ignoring project managers, customer representatives, etc, for now): 6 developers, 2 business analysts, 3 test automation engineers, and 3 technical writers. Given this team, we would not be able to make a feature flow through this pipeline. We would have developers sitting around, waiting for work from the analysts. And, our documentation writers and test lab people would probably be pulling his hair out from boredom then pulling their hair out from too much work, in an unbreakable cycle. 

Fortunately, we can account for the team makeup and the potential bottlenecks by introducing the concept of order points and limits that we saw in the grocery store, and by creating queues and multiple pipelines to be worked.

### The Real World &#8211; Multiple Pipelines and Limits

In most software development efforts, it&#8217;s unreasonable to expect an entire team to work on only one feature at a time. Most development managers want to maximize the throughput of development by working on tasks in parallel. Given this desire, we&#8217;ll divide up our developers into three teams of two developers each. This development team division should allow three features to be developed at the same time. Since we want to work on three features at a time, we will need three pipelines for work. 

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="352" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_3.png" width="777" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_9.png) 

These three pipelines constitute our first limit &#8211; we can have a maximum of three features in development at any given time. This limit is noted by putting a "3" in the upper right hand corner of the development column header, as shown above.

Having three development pipelines puts us in a tricky situation, though. We have very few business analysts compared to developers &#8211; even with our developer teams, we have less than one analyst per developer team. Fortunately, development work often takes longer than analysis. We can use this knowledge to our advantage and let the analysts work slightly ahead of the developers, creating a queue of work to be done.

### Handling Bottlenecks &#8211; Queues, Limits and Order Points

If all three development teams happen to finish at the same time and need more work, we would need a minimum of three features that are ready to be worked. However, since we know that requirements change regularly, we don&#8217;t want to get too far ahead of the developers. With this in mind, we can introduce an Analysis order point of three (the number of development teams) and limit of five. This gives the analysts the ability to work ahead of the developers and also makes them responsible for keeping work available for developers. 

For an order point we&#8217;ll introduce the number into the upper left hand corner of a column header, and we&#8217;ll continue using the upper right hand corner to specify our limits. 

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="67" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb.png" width="137" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_20.png) 

Since we are now dealing with potentially more work in analysis than development, it seems we would have to increase our pipelines to five. This is not desirable, though, since we only have three development teams. What we will do, instead, is restructure the pipeline and turn the analysis column into a queue. 

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="352" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_2.png" width="777" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_6.png) 

Since Analysis is now a queue, there does not seems to be a need for Backlog to be a step in a pipeline, either. The backlog is simply the list of features that the customer is expecting to be done next. Therefore, we will also turn the backlog into a queue &#8211; this time, with a priority (top of the board is highest priority) allowing the customer to tell us which specific feature should be worked on next. We will also want to keep the backlog column limited, to prevent the team from having too much information to think about. Since we only have two analysts on our team, it seems appropriate to keep at least two features in the backlog column at all times. With this in mind, we can safely set a backlog order point of two and limit of five (enough to keep the analysis column full).

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="352" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_9.png" width="777" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_22.png) 

The changing of Backlog into a queue has no made our Development column the first step in our actual pipeline.

### Completing The Pipeline &#8211; Aggregate Limits and Work Cells

The next few column &#8211; Documentation and Testing &#8211; both have an easy amount of team members to deal with. There are three technical writers on our team, and three testing personnel. This distribution lets us keep the pipeline in tact between Development, Documentation and Testing, allowing us to set the same limit as Development (three). 

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="67" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_5.png" width="345" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_12.png) 

With all three of these columns having the same limits, and with each column being properly staffed so that three pipelines could run at the same time, it makes sense to combine the team members from these three columns into a single <a href="http://en.wikipedia.org/wiki/Workcell" target="_blank">workcell</a>. If we consider all four team members (2 developers, 1 tech writer, 1 tester) as a team and allow them to work together as a team, we can aggregate the limits of the columns in the pipeline. We can also create a consolidated name for this pipeline &#8211; work in progress.

This consolidation can be shown by creating a parent / child header with the limit shown in the parent. We will also use a dashed lines between the columns of the pipelines. The combination of these two details will show us that we are dealing with a pipeline, and how many pipelines are allowed to flow, simultaneously.

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="384" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_6.png" width="777" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_14.png) 

By aggregating the pipeline limits, we allow the workcell for a given feature to focus exclusively on that feature. The development staff, technical writers, and test lab personnel will all be working on the same feature, allowing them to more easily share information between themselves. This will prevent the team members from having to switch back and forth between subjects, reducing cognitive load and allowing for greater quality to be attained in the individual feature.

### Completing The Kanban Board &#8211; Customer Acceptance and Delivery

If the customer is on-site (co-located with the team or close enough to meet every day), then it may be possible to aggregate the Customer Acceptance process into the Work In Progress pipeline. If you can do this, you should. Getting immediate feedback from the customer, while work is still fresh in you mind, is critical to the quality and success of that work. What&#8217;s more &#8211; you may not need this explicit column if you have the customer working with you every day.

Unfortunately, we don&#8217;t always have the luxury of on-site customers. We may only have the customer around at specific timer intervals or only on request. In either of these cases, we have to account for the bottleneck of Customer Acceptance.&#160; Additionally, the customer may not want to get delivery of individual features. They may want to wait for a quarterly release, or some other regularly scheduled release. Once again, we have to account for this bottleneck. We can apply the same principles that we used for Backlog and Analysis here, and create some appropriate order points limits. 

Let&#8217;s say that our customer wants to do Customer Acceptance testing once a week and wants a Delivery once every calendar quarter. To accommodate this, we can set the Customer Acceptance column as a queue with a 1 week limit. We can also set the Delivery column as a queue with a 1 quarter limit. Setting these limits puts a direct responsibility on the customer. If they cannot pull the features through these columns on or before the specified limits, then the entire system could grind to a halt. It&#8217;s important to educate the customer in what they are committing to, and ensure that they can fulfill their obligations. This fulfillment may mean that they assign more than one person or group of people to the task of Customer Acceptance and accepting Delivery. Whatever the solution is, the customer has responsibilities to meet.

With Customer Acceptance and Delivery specified, our completed kanban board would look like this:

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="384" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_8.png" width="777" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_18.png) 

### Put It In Action &#8211; A Kanban Process Is Never Truly "Complete"

Now that we have clearly defined our Kanban process and visualized it through our Kanban board, the next steps is to start using it! Start working through this process, pull value from the end of the process and allow work to flow through the pipeline. Respect the order points and limits, and above all, look for problems in the process and fix the process when you need to. 

Perhaps you have too few or too many items in one of your queues &#8211; adjust the limits and order points. Perhaps the test lab is now a bottleneck &#8211; take them out of the pipeline and change them to a queue. There are many possible problems and many possible solutions. The key is to be aware &#8211; <a href="http://en.wikipedia.org/wiki/Value_Stream_Mapping" target="_blank">inspect and adapt</a> and hold regular <a href="http://en.wikipedia.org/wiki/Retrospective" target="_blank">retrospectives</a> &#8211; <a href="http://en.wikipedia.org/wiki/Kaizen" target="_blank">kaizen</a> your process and continuously improve.

### Where Do We Go From Here?

No process is perfect. Anyone that tells you otherwise is <a href="http://en.wikipedia.org/wiki/No_Silver_Bullet" target="_blank">selling something</a>. A customer may find a bug during Customer Acceptance; an issue makes it past all of our QA processes and is found out in production; or there&#8217;s a feature that has a sudden priority over any other feature currently being worked. But our current kanban process doesn&#8217;t address the natural problems that occur during a software package&#8217;s lifetime. To address this properly, we&#8217;ll need to employ the lean tools of <a href="http://en.wikipedia.org/wiki/Andon" target="_blank">Andon</a> and <a href="http://en.wikipedia.org/wiki/Jidoka" target="_blank">Jidoka</a>, and we&#8217;ll also need to decide how to visualize this on our kanban board. These issues, and possibly more, will be addressed in another installment of Kanban in Software Development.