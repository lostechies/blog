---
wordpress_id: 938
title: 'CQRS Workshop &#8211; Retrospective'
date: 2015-04-25T14:40:30+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=938
dsq_thread_id:
  - "3712460479"
categories:
  - Architecture
  - CQRS
  - Design
  - How To
  - introduction
  - learning
  - practices
  - workshop
---
## Introduction

Today I had the honor of leading the first of a series of [workshops](http://www.meetup.com/Clear-Measure-Workshops) at [ClearMeasure](http://www.clear-measure.com/). The topic of this workshop was [CQRS](http://martinfowler.com/bliki/CQRS.html). After a brief introduction into the topic the attendees were working in teams of 2 to 3 members on a problem that I defined. The goal was to implement a **Task Management System** that was defined by the following business requirements

  * A supervisor can define/schedule tasks for certain members of her team
  * Tasks have a name, due date, instructions, a list of assigned personnel, etc.
  * Once the supervisor publishes a task all assigned personnel can see it on their dashboard
  * Any assigned personnel can complete a task by entering a completion date/time and a completion comment
  * On my personnel tasks dashboard I see tasks sorted by due date. Overdue tasks are specially marked
  * The supervisor can see the list of all her team members. She can also see filtered lists of tasks (by team member or task status, etc.)
  * The supervisor can cancel or table published tasks

It was very important that CQRS would be applied in this project.

## Observations

CQRS although simple in its definition is by no means a pattern that is very well understood. Most business applications out there in the wild do either not implement it at all or only partially follow its tenets. A lot of people also automatically associate CQRS with domain driven design (DDD) or event sourcing (ES) and other architectural patterns. But that is wrong. CQRS does not imply any of these other patterns. Yes, it&#8217;s true, CQRS can be used together with those patterns in a very straight forward way but it is not necessary.

All teams participating in the workshop came up with totally different ways of attacking and solving the problem. Only while deeply involved with the problem did certain questions about the implications and/or advantages of CQRS surface. It was really super interesting to observe this process. All participants were very experienced developers and still there were a lot of stumbling blocks to overcome.

## Suggestions

Here is a summary of steps that I chose to take and that will lead me in no time to a successful implementation that applies CQRS.

### 1. Define the ubiquitous language

How do we get to the ubiquitous language? By talking to the domain experts, stake holders, project owner and/or future users of the application. Listen carefully what they say and how they say it. What are some of the nouns they are using over and over again and what kind of verbs are used repeatedly? If we take a look at the given business requirements we can quickly identify the nouns as they are

  * task
  * supervisor
  * team
  * team member

<span style="font-size: 16px; line-height: 26.6666679382324px;">and accordingly the verbs</span>

  * <span style="font-size: 11.9999990463257px; line-height: 20px;">define or schedule</span>
  * <span style="font-size: 11.9999990463257px; line-height: 20px;">assign</span>
  * <span style="font-size: 11.9999990463257px; line-height: 20px;">publish</span>
  * <span style="font-size: 11.9999990463257px; line-height: 20px;">complete</span>
  * <span style="font-size: 11.9999990463257px; line-height: 20px;">cancel</span>
  * <span style="font-size: 11.9999990463257px; line-height: 20px;">table</span>

<span style="line-height: 19.9999980926514px;">Evidently we can also identify some of the properties the task entity has. These are n</span>ame, due date, instructions, list of assigned personnel and probably a status property too.

### 2. Define the contracts

Once I have an idea how the ubiquitous language looks like and knowing the business requirements I like to define the contracts that I&#8217;m going to use in the application. For me contracts are the commands, events and end-points that are used in the application. Let&#8217;s first concentrate on the **commands**. Commands are usually triggered by user actions. Again looking at the business requirements we can identify the following commands.

  * CreateNewTask
  * DefineTaskInstructions
  * SetTaskDueDate
  * AssignTeamMemberToTask
  * PublishTask
  * CompleteTask
  * CancelTask
  * TableTask

<span style="font-size: 16px; line-height: 26.6666679382324px;">The name of the command should clearly reflect its context and its intent thus don&#8217;t be shy and use long names where necessary. The payload of a command should only contain the bare minimum of information that is needed that the target of the command can execute it successfully. In certain circumstances this can mean that no payload at all is needed since the name of the command already implies everything. The more unnecessary data we add to the payload of a command the more confusion we might cause. Keep your commands focused. The more explicit they are the easier it is to validate them and make sure that they do not violate business constraints. As a sample take the very generic command <strong>UpdateTask</strong> versus the very specific command <strong>SetTaskDueDate</strong>. Where the former leaves you with a lot of guesswork on the users intent the latter is crystal clear.</span>

Now let&#8217;s look at the **queries**. Again the name of the query should identify the context and intent of the user or application. In our sample application we could identify the following queries

  * GetMyTasks
  * GetTasksOfTeam
  * GetOverdueTasks
  * GetTasksByStatus
  * &#8230;

My preferred backend API nowadays is a REST-ful API. And when I say REST-ful then I imply that my API might not be pure in the sense of [REST](http://en.wikipedia.org/wiki/Representational_state_transfer), specifically when it comes to write operations. That said, given the above commands I define an endpoint for each distinct command, i.e.

  * [POST] <URL>/api/tasks/123/create
  * [POST] <URL>/api/tasks/123/defineInstructions
  * [POST] <URL>/api/tasks/123/setDueDate
  * &#8230;

<span style="line-height: 26.6666679382324px;">Note that I always use the verb POST for my commands. I never use PUT and hardly ever DELETE. The latter two are </span>OK<span style="line-height: 26.6666679382324px;"> when used in CRUD style application. My preferred data exchange format is JSON, thus in the HTTP header we will have content-type application/json. If you are using ASP.NET Web API then attribute routing makes it super easy to implement the above endpoints. The similar is true when using Node JS to implement the backend.</span>

For the queries we can again define an endpoint per query similar to this

  * [GET] <URL>/api/staff/34/tasks
  * [GET] <URL>/api/team/456/tasks
  * [GET] <URL>/api/team/456/tasks?status=3
  * &#8230;

### <span style="color: #000000; font-size: 1.4em; line-height: 1.5em;">3. Decide which architecture to use</span>

Since CQRS can be used in many situations there is not only one overall architecture to select from. Here I will present a high level view of 3 different types of backend architectures. They all have in common that the write operations are clearly separated from the read operations. There is no coupling between the two concerns.

Main stream architecture

<a href="https://lostechies.com/gabrielschenker/2015/04/25/cqrs-workshop-retrospective/mainstreamarchitecture-2/" rel="attachment wp-att-941"><img class="alignnone size-full wp-image-941" title="MainStreamArchitecture" src="https://lostechies.com/gabrielschenker/files/2015/04/MainStreamArchitecture1.png" alt="" width="783" height="488" /></a>

Here is a high level view of an application that uses CQRS in conjunction with DDD

[<img class="alignnone size-full wp-image-944" title="CQRSandDDD" src="https://lostechies.com/gabrielschenker/files/2015/04/CQRSandDDD1.png" alt="" width="754" height="457" />](https://lostechies.com/gabrielschenker/files/2015/04/CQRSandDDD1.png)

and finally here is a high level view of an application that uses CQRS, DDD and event sourcing all together

[<img class="alignnone size-full wp-image-945" title="CQRS-DDD-ES" src="https://lostechies.com/gabrielschenker/files/2015/04/CQRS-DDD-ES1.png" alt="" width="828" height="493" />](https://lostechies.com/gabrielschenker/files/2015/04/CQRS-DDD-ES1.png)

### 4. Code

Only now I start to code&#8230; If I spend more time analyzing, planning and designing then I am spending less time coding and re-coding.

So, what does CQRS now mean when I&#8217;m down to the code? This means that nothing of my domain model or write model can be used when querying data. Forget about [DRY](http://en.wikipedia.org/wiki/Don%27t_repeat_yourself) for a moment. Even if you think that your **Task** class in the domain model contains all the properties that you need when querying data you cannot use it! Define a separate DTO for this purpose instead. You might call it **TaskDto** or **TaskInfo**. You will notice that even if at the beginning the Task entity of the domain model and the TaskDto have exactly the same properties they will diverge over time as new requirements surface. You don&#8217;t want to couple your write and read models at any time.

If you&#8217;re using an [ORM](http://en.wikipedia.org/wiki/Object-relational_mapping) on the write side then avoid using it on the read side as it only adds unnecessary overhead. If you&#8217;re coding on the .NET platform then you might use ADO.NET directly or a lightweight library like [Dapper](https://code.google.com/p/dapper-dot-net/) instead. The situation is even simpler if you&#8217;re using e.g. a document DB to contain your read model since it eliminates the [impedance mismatch](http://en.wikipedia.org/wiki/Object-relational_impedance_mismatch) between code and data store.

## Summary

Workshops are a very good way to get people involved and keep them active. The motto is learning by doing. A presentation where a well prepared speaker talks about a certain topic might be very enlightening but only a workshop can make every single participant think about and practice the topic at hand. Here at [ClearMeasure](http://www.clear-measure.com/) the participants were involved in very intense discussions all the time. Whiteboards were used and pair programming was practiced. Since the teams were formed ad hoc there was also a lot else going on which was interesting to observe. Team dynamics, time management, role assignment, leadership, etc. to name just a few.

Hopefully I got you excited and you&#8217;ll want to participate at the next workshop too! If you do not live in the Austin TX area this is not a problem since we also include remote participants. During the workshops we are connected via [Slack](https://cmworkshops.slack.com/messages/general/), [Zoom](https://clearmeasure.zoom.us/j/833628454) or Goto Meeting, Skype, Hangout, etc. Please follow us on [Meetup](http://www.meetup.com/Clear-Measure-Workshops).