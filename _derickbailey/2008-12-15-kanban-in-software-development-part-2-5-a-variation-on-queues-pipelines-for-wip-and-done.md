---
wordpress_id: 24
title: 'Kanban in Software Development. Part 2.5: A Variation on Queues &#8211; Pipelines for WIP and Done'
date: 2008-12-15T17:07:38+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2008/12/15/kanban-in-software-development-part-2-5-a-variation-on-queues-pipelines-for-wip-and-done.aspx
dsq_thread_id:
  - "262067975"
categories:
  - Agile
  - Analysis and Design
  - Kanban
  - Lean Systems
  - Management
---
In <a href="http://www.lostechies.com/blogs/derickbailey/archive/2008/12/08/kanban-in-software-development-part-2-completing-the-kanban-board-with-queues-order-points-and-limits.aspx" target="_blank">part 2 of my Kanban in Software Development</a> series, I talked about completing a kanban board with queues, order points and limits. We saw how to take a complete development pipeline and work with a team, its processes and its bottlenecks. In the end, we had a kanban board that could easily represent the processes of the fictional team that we outlined. 

One of the questions that I&#8217;ve often asked about a kanban board is how anyone would know when work in one column is done and ready to be pulled into the next column. For example &#8211; if a kanban card is sitting in the Analysis column, how does a developer know when that card is done so that they can pull it into Development and start coding it? I found the answer to this question when I was at the Kaizen Conference in October. <a href="http://blog.perfecting.me/" target="_blank">Jef Newsom</a> did <a href="http://kaizenconf.pbwiki.com/Driving+Toward+the+Goal:+Standard+Work+in+Software+Development" target="_blank">a workshop on kanban</a> and we ended up with this <a href="http://openscreens.com/articles/activity-modeling-for-kanban-pull-systems" target="_blank">same question, and a solution</a>.

### A Pipeline for Analysis &#8211; WIP and Done

To facilitate the visualization of the difference between work in progress and work that is ready to be pulled to the next column, we can use the concept of a pipeline and split our existing queues into a WIP and Done step. For example, we want developers to pull work from the Analysis queue into the Development pipeline. We can show which cards are ready to move by splitting Analysis into sub-columns of WIP and Done.

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="184" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_thumb.png" width="201" border="0" />](http://lostechies.com/derickbailey/files/2011/03/image_2.png) 

When an Analyst is ready for work, they would pull from the Backlog into the Analysis / WIP column. When the analysis work is done and the card is ready to go into development, the card would be moved into the Analysis / Done column. Since we are wanting to maintain the concept of a queue for the overall Analysis column, we have create the WIP and Done subdivisions as a pipeline (noted by the dashed line). This allows us to keep our order point (3) and limit (5) in place for Analysis, and know what work is ready to be pulled into Development.

### Applying Pipeline per Queue Across The Board

Not every queue needs to be a pipeline. 

Consider the Backlog &#8211; the customer is placing the prioritized list of features in this column. The cards in this column exist so that the analysts will know what work needs to be done &#8211; not because any work needs to be done in this column, explicitly. 

The Delivery column may not need a pipeline, either. If the delivery process is composed of sending an installer package to the customer, then there is no real work to be done in this column aside from sending that package. However, if there is some specific integration work (say, changing a web.config file) that needs to be done, we could include a WIP and Done pipeline for delivery. For this simple example, we&#8217;ll say that there is no configuration change needed. Let&#8217;s assume that the installation package changes all the needed configuration files based on user input. 

With all of this in mind, we can apply our WIP and Done pipeline to the Analysis and Customer Acceptance columns.

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="384" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_thumb_4.png" width="777" border="0" />](http://lostechies.com/derickbailey/files/2011/03/image_10.png) 

### Alternative Visualizations

There are other ways of visualizing WIP vs Done cards for a given column, of course. For example, you could forgo the pipeline idea and simply add a queue between Analysis and Development. This may require you to adjust your order points and limits between analysis and development &#8211; at least, where those order points and limits apply (Analysis vs. the queue between Analysis and Development). You could also split the column horizontally instead of vertically, creating either the top or bottom half as the WIP with the other being Done. Or you could just note the status on the kanban card itself. I&#8217;m sure there are a number of other ways to show this information, as well. The point is that the pipeline visualization that I&#8217;m showing here is not the only way. Find what works for you.

### Where Do We Go From Here?

We have another tool in our belt, now. If need be, we can visualize the WIP vs work Done for a given queue, allowing us to see when we can pull work forward. But, like all tools in our belt, it is not \*the\* answer and this additional visualization may not be necessary for your team. 

If your team is small or has great communication, you may not need any special distinctions to show work in progress vs work ready to be pulled. You could rely on the daily standup for people to report when they are done, or do it ad-hoc &#8211; when someone finished a card, they announce it to the team immediately. In a larger team, though, it may become necessary to have some visual distinction between work in progress and work completed for a given column.

Small teams might get away without it; larger teams might need it; its up to your team to decide. The key is not to apply these ideas as blanket rules that must be followed, but to allow the individual project and team to decide what is right for them. And as always, allow the process to change when it needs to. Always <a href="http://en.wikipedia.org/wiki/Retrospective" target="_blank">inspect, adapt</a> and <a href="http://en.wikipedia.org/wiki/Kaizen" target="_blank">continuously improve</a>.