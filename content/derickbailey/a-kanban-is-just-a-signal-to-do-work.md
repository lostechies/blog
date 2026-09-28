---
wordpress_id: 61
title: A Kanban Is Just A Signal To Do Work
date: 2009-06-18T21:10:03+00:00
author: Derick Bailey
wordpress_guid: /blogs/derickbailey/archive/2009/06/18/a-kanban-is-just-a-signal-to-do-work.aspx
dsq_thread_id: "262068210"
categories:
  - Kanban
  - Lean Systems
  - Workflow
aliases: "/blogs/derickbailey/archive/2009/06/18/a-kanban-is-just-a-signal-to-do-work.aspx/"
---
A [kanban](http://en.wikipedia.org/wiki/Kanban) is [a signal to do something](https://lostechies.com/blogs/derickbailey/archive/2008/11/20/kanban-pulling-value-from-the-supplier.aspx). I don’t think kanban implies a pull-based system, honestly. [Joe Ocampo](http://agilejoe.lostechies.com/) showed it best in his Scrumban presentation at Austin Code Camp:

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="180" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_0CFA1797.png" width="240" border="0" />](https://lostechies.com/content/derickbailey/uploads/2011/03/image_67709A35.png) 

That’s not a signal to pull anything… it’s a signal to RUN FOR YOUR LIFE!!! 🙂 Now, having said that – I do think that a pull-based system is facilitated by kanban. 

### A Simple Kanban Enabled, Pull-Based Workflow

In a pull-based system, a kanban is used to signal the upstream process of the downstream needs. As an example, let’s look at a simple 2-step process. 

Step 1 produces 10 parts and moves them into the “DONE” queue, saying that they are ready to be used by the next step.

 <img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="230" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_376648B4.png" width="282" border="0" />

Step 2 then uses 5 of those parts by pulling them out of Step 1’s “DONE” queue.

 <img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="229" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_05027535.png" width="281" border="0" />

When Step 2 pulls those 5 parts out, the person doing Step 2 will signal Step 1 to make more parts. That is, they send a kanban back to Step 1, telling Step 1 that more parts need to be produced. This kanban may be a card, an email, a tap-on-the-shoulder, or any other mechanism that anyone can think of, to tell the previous step that work needs to be done.</p> 

&#160; <img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="291" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_682B7EB3.png" width="413" border="0" />

When Step 2 is done, the parts can be put into the next queue. Step 2 then pulls the next set of parts out of Step 1’s “DONE” queue, and the cycle starts over…

&#160; <img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="310" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_1D25DF90.png" width="524" border="0" />

To properly understand the flow of work in this diagram, read from right to left:

  1. Finished work put into Step 2’s “done” queue 
  2. Next set of available parts pulled into Step 2 
  3. Step 2 signals Step 1 that work needs to be done 
  4. Finished parts pulled from Step 1 into Step 1 “done” queue 
  5. Repeat from #1 

### A Task Card Is Not A Kanban

I was involved in a project that ended a few months ago, where we did some experimenting with a pull-based, kanban-enabled workflow. The following picture is what our process looked like and was a direct outcome of the research and learning that went into my previous [Kanban In Software Development posts](https://lostechies.com/blogs/derickbailey/archive/2008/11/19/adventures-in-lean.aspx).

<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="446" alt="image_thumb2" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb2_35B57CE0.png" width="596" border="0" />&#160;

(**Note:** Please disregard the glaring problems with this board. It was a learning experience for me and my team. 🙂 )

Our kanban – our signal for an upstream process to provide more input for the downstream process &#8211; was not the task cards that moved across the board. In fact, I think calling a task card (a user story, an MMF, a function point, or whatever it is) a kanban is a serious misrepresentation of kanban. The task cards are exactly that – task cards. They are the work to be done, the work in process, and the inventory in queues. 

### My Team’s Kanban: Nothing

> **For my team, the signal to do more work was an empty stikki clip.**

 <img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="453" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_22281D3F.png" width="603" border="0" /></p> </p> 

That empty slot in the “System Test” column was a signal to the testers that they could pull another task from the upstream process. The empty slot in “In Dev” was a signal to pull from their upstream. And the empty slot in “Analysis & Estimation” … you get the idea, right?

### Kanban vs kanban

A kanban is just a signal for work to be done. It doesn’t have to be a “kanban card”. It doesn’t have to be any <u>thing</u>, actually – it may be the absence of something, as was the case in that project. In the end, I think the idea of calling that project’s board a “kanban board” was a misrepresentation of kanban. Additionally, there’s some [**interesting**](http://blog.robbowley.net/2009/05/20/kanban-is-just-a-tool-so-why-is-it-being-treated-like-a-methodology/)&#160;&#160; [**banter**](http://www.agilemanagement.net/Articles/Weblog/IsKanbanJustaTool.html)&#160;&#160; [**going around**](http://theagileexecutive.com/2009/05/20/it-is-not-what-it-is-that-really-matters/)&#160;&#160; [**the blogs**](http://thinkprojectmanagement.blogspot.com/2009/05/kanban-its-tool-and-theres-no-such.html) on kanban as a tool, more than just a tool, kanban vs “Kaban” (capital K), and how the software industry has branded a pull-based, signal-enabled workflow system as capital-K “Kanban” (and I can’t help but think that I contributed to this situation). So, maybe I can call this a “Kanban” board… but just because I can, doesn’t mean I should.