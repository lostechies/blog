---
id: 169
title: Work In Process (WIP) Limits, Policies, Etc.
date: 2010-06-14T18:49:24+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/06/14/work-in-process-wip-limits-policies-etc.aspx
dsq_thread_id:
  - "263785067"
categories:
  - Agile
  - Continuous Improvement
  - Kaizen
  - Kanban
  - Lean Systems
  - Management
---
I had a great discussion a few of my team members this morning. We were discussion work in process (WIP) limits, policies, and other items that are related to both of those. By the end of the discussion we had some great policies outlined for how we wanted to handle WIP limits, moving forward. The following represents the notes on the various policies that I wrote up based on the conversions. Before I get into the detail of what we are starting with for our policies, though, I wanted to talk about policies briefly

&#160;

### **A Few Notes On Policies**

Policies give us a basic framework for deciding what we are going to do, when. They give us guidance on how we should approach our work, from various perspectives. They are not, however, prescriptive "you must do this or you will face the wrath of Larry" rules and they do not give us all answers for all scenarios and circumstances. Software development is a human process, first and foremost. It requires interaction, communication, and judgment calls between humans for the benefit of humans, with the goal of getting things done quickly and effectively. you will run into scenarios that are not covered under the current policies. use your best judgment in those scenarios and seek the advice of others if you are not sure what to do. 

Not every repeated scenario needs a policy. There are times when the repeated presence of a scenario should be an indication that our policies need to change to account for this, and there are times when that repeated occurrence should be a signal that we have a problem in our processes and we need to fix our processes. 

### **Policy: WIP Limits**

The purpose of WIP limits is not to be a hard and fast rule or mechanical thing that prevents us from getting work done. The purpose is to facilitate getting things _completed_ and out the door. A WIP limit is a policy, and like all policies there are exceptions and there is always the possibility of the WIP limit changing based on empirical evidence that suggests a need for change. A WIP limit is also not a comfort zone that we live within, but should be viewed as a goal that will expose problems in our process and help us to improve. Setting a WIP limit for any given column does not mean that you absolutely cannot put another ticket into that column. Rather, it means that when the WIP limit is exceeded, we as a whole team have to take on the responsibility of understanding why the WIP limit has been exceeded so that we can work to correct that situation now and prevent it from happening again.

When a given step is running up against it&#8217;s WIP limit, it is our responsibility as a team to help move things forward. This means looking at the downstream steps to see if we need to get other work downstream completed so that we can make room for work that needs to be moved forward. However, don&#8217;t look at WIP limits as a "you must not exceed this". Look at them as "what percentage of time are we staying under these limits? how can we improve that %?". When we start seeing WIP limits that are being met 80% or more, it may be time for us to consider reducing the WIP limit to expose the next set of problems in our process, facilitating further improvement.

I don’t expect our WIP limits to stay what we have currently defined them as for very long. After all, if our WIP limits are static, [then we’re doing something wrong](http://www.lostechies.com/blogs/derickbailey/archive/2010/01/30/the-purpose-of-kanban-is-to-eliminate-the-kanban.aspx).

&#160;

### **Policy: Protecting WIP**

We should strive to complete work that has been started, before starting new work. this means a developer that is finished with their current work should seek to help others finish work in process before starting new work. if no other team member needs assistance, or if the time for the person needing work to come up to speed is more than the team can spend right now, then the person needing work should look for the next highest priority work to start. this also means that you should be looking downstream at steps in the process where WIP limits are being run into, to see if you can help alleviate any potential bottlenecks. If QA is getting backed up, take the time to see if you can help get some tickets tested and pushed through before starting a new ticket.

****

### **Policy: Emergency Fixes**

We use VersionOne as our project management took, currently. Since we can’t [model a horizontal swim-lane](http://www.lostechies.com/blogs/derickbailey/archive/2008/12/19/kanban-in-software-development-part-3-andon-and-jidoka-handling-bugs-and-emergency-fixes-in-kanban.aspx) in V1, we will create an "Emergency Fixes" priority. This priority would be reserved for exactly what it sounds like: things that are truly emergencies. Emergency fixes mean that the developer who is working on them will drop whatever they are doing and get it fixed, now. All other work, for as many resources as are needed to complete the emergency fix, is put on hold until this thing is fixed. this includes developers, QA, product owners, etc. Emergency fixes are a primary exception to WIP limits and these fixes should be pushed through the system as quickly as possible, regardless of any WIP limits being exceeded. 

Emergency fixes should also be a sign that we as a team need to step back and understand why the problem was allowed to be pushed into production in the first place. We should use this time and effort to find the root cause of the problem and see what we can do to not only prevent the problem from recurring, but also prevent similar problems from slipping through our fingers in the future.

We had a good example of an emergency fix from an IRC chat today:

> **Boss:** hey [dev], [product owner] logged a backlog, problems with [feature] not working in IE7   
> **Dev:** oooh fun   
> **Dev:** so should issues like this trump the WIP limits we&#8217;re trying to do ?   
> **Boss:** In this case, yeah. We released it, told them about it, and they just told us they can&#8217;t use it.

I get the feeling that we will eventually be using many different of [Classes of Service](http://www.dennisstevens.com/2010/06/14/kanban-what-are-classes-of-service-and-why-should-you-care/)… but this is a great place for us to start.

&#160;

### **Policy: Failed Acceptance Tests (ATs)**

When an acceptance test is failed, the person doing the testing should move the ticket back to In Progress and notify the developer(s) that worked on it. both the person that worked on the ticket originally and the person that tested the ticket are responsible for ensuring the ticket is fixed and moved forward again. if a failed AT is going to prevent a release from happening on time, this needs to be brought up with the product owners immediately. 

a failed AT may cause WIP limits to be exceeded. this is intentional, but not something to be ignored. a WIP limit being exceeded by a ticket with a failed AT should kick the team into problem solving mode. we should use this opportunity to find the problems in our processes and improve.

&#160;

### **Policy: Create ATs Column**

Our QA lead brought up the subject of tickets being in-progress vs. waiting for acceptance tests to be created. Based on her input and discussion with the others in the call, we think it would be good to have a column called "Creating ATs". The purpose of this column is not to say that we should wait until the work is done to create the ATs. Rather, it is there to facilitate the needs of our QA person considering our limited QA personnel. We often run into situations where a developer picks up work and completes it before she is aware of the work being started. this column will give us a place to recognize that situation and gives use better insight into the real status of a ticket.&#160; 

Ideally, we should be working with QA to define the ATs before work is started. Given the number of developers compared to only 1 QA person, though, this is not always going to happen. The presence of tickets in the Creating ATs column should be another sign that our team uses to help us improve. It may be evidence for the need to hire more QA people, or the need for the developers to communicate with QA more frequently, etc.

&#160;

### **Policy: Long Running Tasks**

there are times when we are working on tasks that must be extended over long periods while waiting for input or data from external resources. for example, one of our developers is working on a data migration process for one of our customers. this process takes an extensive amount of time and cannot be run during normal business hours. He works through this process on the weekends and completes a little more of it every weekend. this type of activity will be put into VersionOne as an Epic and have individual stories split out to represent the work that is going to be done for the given increment, whether that increment is time based (on the weekends in this example) or feedback based (waiting for feedback from a customer on a given change). this will let us get the individual increments of work done and moved through the system, while letting us plan for the additional work by creating another ticket in the Epic / backlog.

&#160;

### One Final Note On Policies

_All_ of this is open for discussion, clarification and modification by the team. These are policies designed to help us recognize the next set of problems in our current development process. As we continue to move forward, our needs as a team will change. When this happens, our policies will also change. We are not trying to define “the way” we develop and release software. We are trying to define what our current needs and goals are, with the intention of improving our processes as we move forward.