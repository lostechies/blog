---
wordpress_id: 78
title: 'WIP Queues: Done vs Ready'
date: 2009-09-01T16:36:18+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/09/01/wip-queues-done-vs-ready.aspx
dsq_thread_id:
  - "262068305"
categories:
  - Kanban
  - Lean Systems
  - Workflow
redirect_from: "/blogs/derickbailey/archive/2009/09/01/wip-queues-done-vs-ready.aspx/"
---
I’ve used two types of queues in my Kanban systems, in the last year – but I didn’t realize it until a recent conversation at the [Lean Software Austin](http://leansoftwareaustin.org) meeting in August. As recently as the [Conversation on Adopting Kanban](http://www.lostechies.com/blogs/derickbailey/archive/2009/08/19/a-conversation-on-adopting-kanban.aspx), I talked about how it didn’t really matter if you called a queue a “done” queue vs a “ready” queue. At the LSA meeting, though, [Scott](http://blog.scottbellware.com/) pointed out a key difference between these two types of queues based on the language of the queue name.

&#160;

### Done Queue

This queue says that a WIP item has completed a step, and is ready to move on. The WIP item does not know where to go next, so it sits in a queue behind the step that just completed. The WIP item is waiting for the step that needs it to come grab it – to pull the WIP into the next step. This type of queue is what enables hand offs between steps that are not synchronized, in a pull system.

A Done queue is likely to have a limit that is based on the capacity of the steps that pull work from it. 

There are some variations for modeling the Done queue, visually. For example, the models in **Figure 1** and **Figure 2** two appear to be fairly common.I’m sure there are other visual models as well.

     <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_07ADEC28.png" width="173" height="179" />  
**Figure 1.** Modeling WIP & Done, Left & Right

     <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_725036BF.png" width="173" height="179" />  
**Figure 2.** Modeling WIP & Done, Top & Bottom

&#160;

### Ready Queue

This queue says that a WIP item has completed a step, and is ready to be processed in the next, already known step. The WIP is placed in the queue in front of the next step &#8211; it has WIP pushed into it, rather than pulled. This type of queue is most likely going to be found where there is a very distinct handoff between steps of a process that cannot be coordinated correctly through a pull mechanism (thanks for the reminder of this, in the comments, Scott!). One example may be when breaking work down from user stories into tasks. We would likely push the tasks into a ready queue &#8211; a backlog &#8211; for the development process after they are broken down.

We can easily model this queue type in a manner that looks like that of the Done queue, but reversing the order in which the Queue and WIP appear. Once again, I’m sure there are a number of other ways to model this.</p> 

&#160;     <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_58E83385.png" width="173" height="179" />  
**Figure 3.** Modeling Ready & WIP, Left & Right

     <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_3F80304B.png" width="173" height="179" />  
**Figure 4.** Modeling Ready & WIP, Top & Bottom</p> </p> 

If a Ready queue is attached to a specific step, it is likely to have a limit based on the capacity of the one step that it precedes. However, not all Ready queues are attached to steps. This may prevent the queue’s limit from being based on the capacity of the next step and cause it to be more arbitrary, based on some other grouping or sizing of the work being pushed into it. 

In the example of the backlog as a ready queue, the queue would not be attached to the first step in the process. Rather, it is the holding tank for work that needs to be processed through the system. If we are breaking a user story or MMF down into tasks, then there may not be a hard and fast rule of whether or not you need to limit the WIP in the backlog. Much of the decision of whether or not to limit the backlog’s WIP will come from the context of what constitutes deliverable value – the ability to deliver working software to the customer, providing some value to them. In this scenario, a Ready queue may look more like **Figure 5**.

<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_5DE7A2E9.png" width="261" height="179" />&#160;   
**Figure 5**. A Ready Queue Not Attached To A Specific Step

&#160;

### Queue Combinations For Non-Linear Workflow

Although I have not modeled a process like this, yet, it seems natural that a step in a process may be modeled with both a Done and Ready queue. Of course, this would depend on the specific circumstances that the process exists within, but I don’t think it would be bad form to model a step with both. 

Such a circumstance may exist if we are moving from one step to another in a linear fashion, and then immediately following that step with a non-linear progression. 

     <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_26182D11.png" width="429" height="237" />  
**Figure 6.** A Non-Linear Workflow

In this case, we may want to model a Ready queue in front of Step 2 and a Done queue behind Step 2. Doing this may give us indication that there is a non-linear workflow in our process, via a linear Kanban board (note that I’ve not bothered with queues for Step 1, 3 or 4, as they are not important in this discussion).

     <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_3EA7CA61.png" width="519" height="179" />  
**Figure 7.** Modeling Non-Linear Flow With Ready & Done Queues

&#160;</p> 

### Queue Sizing For Non-Linear Steps

A Ready queue for a step like we see above is likely to have a standard size for that step’s capacity. The Ready queue in front of Step 2 should have a limit based on the capacity of Step 2, itself. 

The Done queue of Step 2 may have a higher limit then the Ready queue. This limit should be based on the number of steps that may pull work from the Done queue, and the frequency at which those steps pull work. For example, if Step 3 and Step 4 pull work an equal amount of time, then we may want to set our Done queue for Step 2 so that it does not starve either step 3 or 4. If Step 3 and 4 can process 2 items per hour and we are trying to prevent them from being starved, then we should ensure Step 2 is capable of completing at least 4 items per hour. 

The sizing of the Done queue gets more and more complicated as the circumstances of Step 3 and Step 4 change. If Step 3 and Step 4 can only pull certain types of work from Step 2, then we may want to model the Done queue of Step 2 to have a limit of each type of work. We may also want to ensure that Step 2 is [processing a mix of work item types](http://en.wikipedia.org/wiki/Heijunka) to ensure that Step 3 and Step 4 are not starved for work. As more steps are able to pull from Step 2’s Done queue, we may need to account for this. We may also need to increase the Done queue of Step 2 by the rate of need for the steps that follow, or type of work that hey need. And there are likely going to be other considerations for the sizing of the Done queue for Step 2, as well. 

&#160;

### Conclusion: Pay Attention To Queue Types

The realization that I came to at the LSA meeting, was that the names of the queues may be important after all. We should model our queues based on the appropriate type of queue that we need. At this point, I’m aware of the two types of queues discussed here: Done and Ready queues. I am interested in learning what other queue types are out there, and what circumstances they fit within. If anyone has any information on additional queue types, please drop me a comment and provide an example of the circumstances that those types fit.