---
id: 79
title: A Kanban Board Is A Production Leveling Task Board
date: 2009-09-03T00:50:38+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2009/09/02/a-kanban-board-is-a-production-leveling-task-board.aspx
dsq_thread_id:
  - "262068319"
categories:
  - Agile
  - Kanban
  - Lean Systems
  - Management
  - Workflow
---
In the lean manufacturing world [heijunka](http://en.wikipedia.org/wiki/Heijunka) &#8211; production leveling &#8211; “_is a technique for reducing the_ [_mura_](http://en.wikipedia.org/wiki/Mura_%28Japanese_term%29) _waste and vital to the development of production efficiency […]. The general idea is to produce intermediate goods at a constant rate, to allow further processing to be carried out at a constant and predictable rate._” – from [Wikipedia](http://en.wikipedia.org/wiki/Heijunka). While heijunka is the process of eliminating variance or unevenness in the system, a [Heijunka Box](http://en.wikipedia.org/wiki/Heijunka_box) is a tool that is used to achieve the goal of heijunka. It is a visual representation of the production system that is used to show how the work is being scheduled and mixed

What we tend to call a Kanban Board in software development is a close relative to a Heijunka Box. However, we have taken the roots of the heijunka box and added some parts of the production line to the box, directly. Most notable are the queues or storage bins that [sit in front of or behind a given step](http://www.lostechies.com/blogs/derickbailey/archive/2009/09/01/wip-queues-done-vs-ready.aspx) in the process. We have also taken a great amount of influence from agile methodologies such as Scrum’s sprint boards and XP’s task boards, for our Kanban boards. 

**Figure 1** represents a very generic three step process that receives input from an upstream supplier and delivers to a downstream customer. This generic form of a Kanban board is very typical for a simple system. 

     <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image5" src="http://lostechies.com/derickbailey/files/2011/03/image5_1D01F681.png" width="651" height="261" />  
**Figure 1.** A Kanban Board. Also-Known-As HeijunkaBox++

Some of the key differences between a sprint board in Scrum or a task board in XP, and a Kanban board are the following:

  1. **Focus On The Entire Value Stream:** Scrum and XP tend to be very focused on the developer activities, assuming that activities that occur prior to and after the development effort are taken care somewhere else. Kanban focuses on the entire value stream – from “that’s a great idea!” all the way down to “here’s some $ for the software you just gave me” – from concept to cash. 
  2. **Limited WIP:** This is the mechanical process of limiting the amount of work in process (WIP) in the system at any given time. It’s what let’s us get stuff done and is what leads us to the “pull” of a Kanban system 
  3. **Queues:** We have taken the concept of a storage bin with a [safety stock](http://en.wikipedia.org/wiki/Safety_stock) off the production line of a manufacturing floor and made it an explicit concept in our visualization of WIP and intellectual inventory 
  4. **Production Leveling:** A team may not care about variance in a user story from Scrum or XP. They typically only care about whether or not they can complete the story within the sprint or iteration 

Both limited WIP and queues have been discussed by a significant number of persons around the inter-blog-o-webs. A quick Google search on [kanban in software development](http://lmgtfy.com?q=kanban+in+software+development) will turn up a good number of resources, including my own posts on the subject. In contrast, though, the idea of production leveling in software development seems to have taken a back seat. It is often ignore entirely as not transferable from the manufacturing world, or is done implicitly within a team already and never made into a first class citizen of our process. This is a shame since production leveling, or not, can have a direct financial impact on a system – even if we are already working to capacity via a pull based system like Kanban.