---
id: 71
title: Daycare As A Kanban System
date: 2009-08-04T14:34:12+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2009/08/04/daycare-as-a-kanban-system.aspx
dsq_thread_id:
  - "262068264"
categories:
  - Kanban
  - Management
  - Throughput
  - Workflow
---
I was discussing my two year old son’s daycare with my wife, yesterday, when it dawned on me that the daycare itself can be viewed as a Kanban system. [A Kanban system is a system level process control system](http://www.lostechies.com/blogs/derickbailey/archive/2009/07/13/kanban-is-process-control-not-a-process-for-adding-value-to-wip.aspx) that limits the work in process (WIP), authorizes work to be done based on capacity, and pulls work through the system. 

### Variability In The System

A daycare system is a highly variable system. The rate of arrival and departure in this system is not constant and there is no guarantee of linear progress through the system. A child may be taken out of the system at any time, whether or not they have been processed through the entire system. 

What I’m trying to show is how a highly variable system, such as daycare, ban be viewed and run as a Kanban system. We don’t need a perfectly repeatable set of steps with perfectly stable cycle times like the manufacturing world. We can deal with highly variable input and output using Kanban. It doesn’t matter if we are talking about children in daycare, about software being developed or about parts being manufactured. The Kanban process is applicable because it does not care what your system is or how value is added to the work. Kanban just wants to help coordinate the flow of work through the system through some simple techniques like limiting WIP, queues, and pull.

So how does daycare translate into a Kanban system?

### The System and Process

The system that we are working in, in this case, is designed to educate children and help them grow into socially acceptable human beings while also providing a way for the parents to continue working. This is obviously an oversimplification of what a daycare is and what it does, but it provides a simple framework for us to use.

### The Steps in the Process

Each classroom can be considered a step in the daycare process. There are multiple classrooms in my son’s daycare – different rooms for different age groups and growth of the children. Class A1 is for infants. Class A2 is for children that are crawling and eating real food. Class A3 is for children that are walking and starting to talk; etc. etc.

 <img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="151" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_189FC574.png" width="120" border="0" /> <img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="151" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_663BF1F4.png" width="120" border="0" />

### The Work In Process

The children in the daycare are the work in process (WIP). When we first sent our son to daycare, he was in class A1. Now he’s in class A3 and he was previously in A2. Next, he’ll be moving on to A4. 

 <img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="87" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_3F01A8BF.png" width="65" border="0" />

The begin state and end state that determines when a child is ready to transfer from one class to the next is not based on a schedule. Rather, it is based on when the child has developed the skills needed to handle the activities of the next room. One child may learn to walk and talk by the age of 1; and another child may not learn to walk until they are 2, and talk at the age of 3. The child’s development the primary determining factor for when they are ready move into the next class.

There is another factor of variability in this system – the development state of the child when they enter the system. If a child is already walking and talking when they have entered the daycare for the first time, they will not be placed in the A1 infant room. Rather, they will be placed into the queue for the classroom that is appropriate for their developmental needs. 

### The Queues and WIP Limits

#### 

**Backlog: The Waiting List**

The first queue that our son had to wait in was the system’s backlog. This truly was a backlog &#8211; we were on this waiting list for nearly a year before our son got into this daycare. Fortunately, we had put him on the waiting list 6 months prior to his birth so it only took six months to get him in.

 <img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="149" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_3E9575CA.png" width="117" border="0" />

The interesting part about the waiting list is how it’s managed. This is primarily a first-in-first-out (FIFO) queue. That is, the order in which you register your child on the waiting list is generally the order in which you get pulled into the system. However, there are other prioritization factors that also come into play. For example, if you have a child already in this daycare, you get prioritized over the children who do not have siblings in the daycare. Therefore, this is a prioritized FIFO queue. Furthermore, the parents of the children have the option of taking their children out of the queue at any point in time. They can say “no thanks” to the daycare and be removed from the waiting list at any time. The parents may have found another daycare, a nanny, moved away, or decided to stay at home with the kids. There are a number of possible reasons for a child to be removed from this queue.

**WIP Limit and Ready To Transfer Queue:** 

After a child has matured to a certain point, the classroom that they are in will promote them to the next room. The next room will have a different structure of activities based on the maturity of children in that room. However, just because a child is ready to transfer doesn’t mean that they get to transfer immediately. The child that is ready to transfer can only transfer when the next classroom has space available – when it has the capacity to process the child. When the next classroom does not have space available, the child will be placed into a virtual queue – a “ready to transfer” state &#8211; waiting for capacity to become available in the next room. The child does not physically move to this queue. They are still in the current classroom, but are marked as “ready to transfer” in the daycare’s records.

 <img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="152" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_5725131A.png" width="446" border="0" />

### 

### Pulling Value Through The System

Once the next room has space available, the child will be pulled from the transfer queue into the new room. The WIP limit of classroom capacity, combined with the Queues of waiting to transfer, is what sets the daycare system up as a Kanban process.&#160; 

 <img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="152" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_369DD368.png" width="568" border="0" />&#8230;

The movement of children through the classrooms only happens when a downstream process (classroom) says that they have capacity. Let’s say A3 is the last class in the daycare before the children are ready for kindergarten. Once a child is promoted to kindergarten – which happens every August &#8211; A3 will have capacity. At that time, a child in the “Ready To Transfer” queue of class A2, will be pulled into class A3. One this occurs, capacity will be freed up in class A2, which allows them to pull a child from A1’s “Ready To Transfer” queue. When A1 has capacity, they can pull a child out of the Waiting List queue.

Once again, there are other methods of capacity becoming available for this system, though. A new class may be opened, with additional teachers. This would allow the children to transfer from the A-Series classrooms to the B-Series classrooms, for example. When this transfer occurs, based on who is ready to transfer, capacity becomes available. The parents also have the option of taking their child out of this daycare system at any time, too. If the parents move, find other arrangements for care, or for any other reason that they deem fit, they always have the option of taking their child out. This also frees up capacity for another child to be pulled into that classroom.

### Reading Right To Left

Remember that a ‘kanban’ (lowercase k) is just [a signal to do work](http://www.lostechies.com/blogs/derickbailey/archive/2009/06/18/a-kanban-is-just-a-signal-to-do-work.aspx) and a Kanban system (capital K) is a WIP limited, pull-based flow of work through a system. We then look at authorizing work based on capacity, not scheduling. The work to be done is pulled from right to left, therefore we read the process from right to left.

 <img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="310" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_161693B6.png" width="524" border="0" />

  1. Finished work put into Step 2’s “done” queue 
  2. Next set of available parts pulled into Step 2 
  3. Step 2 signals Step 1 that work needs to be done 
  4. Finished parts pulled from Step 1 into Step 1 “done” queue 
  5. Repeat from #1 

### Viewing The Daycare System As A Kanban System

Keeping the right-to-left nature of a Kanban flow of work in mind, we can view the entire daycare system as the process to flow through, the individual classrooms as the steps in the process, and the children as the raw material that value is being added to. We can set WIP limits in the classrooms and queue for the classroom, and we can pull the children through the system, as capacity becomes available in the classrooms.

&#160;<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="223" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_5C9383BE.png" width="941" border="0" />

### Variability and Kanban

A Kanban system is applicable to more than just standardized, constant time work that is found in the manufacturing world. Variability in the system, in the WIP itself, in the stages or steps that the WIP flows through, or any other part of the system have very little impact on whether or not a Kanban system is viable. Quite the opposite is true in my experience. It seems that the more variance a system has the more likely it will benefit from a Kanban or other pull-based system.&#160; A daycare system almost has no pre-determined list of steps to follow, with varying points of entry and exit, and has varying cycle times and lead times at all levels based on the individual child’s needs. If such a highly variable system can be managed so well by Kanban, and if such a controlled and predictable system like manufacturing can be managed so well with Kanban, then what excuse do we have in software development to say that we are special or different and Kanban can’t apply to us? That doesn’t mean everyone should use Kanban for every situation. Rather, it means that Kanban is a viable system to use and we should at least be familiar with what it provides and what is solves, so that we can determine when and where it is appropriate to use.