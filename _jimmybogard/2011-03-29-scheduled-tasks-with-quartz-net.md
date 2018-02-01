---
id: 459
title: Scheduled tasks with Quartz.NET
date: 2011-03-29T12:49:09+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2011/03/29/scheduled-tasks-with-quartz-net/
dsq_thread_id:
  - "265825430"
categories:
  - Tools
---
I’ve used a few different task schedulers on my current project, where I have to kick off NServiceBus sagas at very specific times of day (every night at 2AM etc.) We started out using the built-in Windows Task Scheduler, which provides decent logging, very flexible scheduling, retry, etc. capabilities. The only problem is that the actual piece doing the work is just a console app that gets kicked off.

This got annoying because we’d see spikes in memory usage to spin up a process just to send a message. We also didn’t have any control or hook into the actual execution of jobs, to do things like advanced logging and so on. We modified our executables to do so, but eventually we found that it became difficult to discern the work being done with just executing a job.

We’ve also tried commercial task scheduling options that had advanced workflow building capabilities. **But just because I drag and drop tasks in a UI doesn’t mean it’s not code. It is.**

I happened to stumble on a project of a task scheduler engine sourced entirely in .NET: [Quartz.NET](http://quartznet.sourceforge.net/index.html). It’s a port of a Java project, which confused me at first, since shouldn’t it be called nQuartz 😉

It’s pretty much exactly what you’d expect from a job scheduler library intended to run in .NET – IoC support, storing jobs/log in a database, plugin points at various levels, support for transactions and more. Another cool little library allowing me to push more behavior into code.

As an aside, the big reason I don’t like UI-based workflow applications is that I very rarely have the flexibility to reduce workflow duplication as I do in a full OO environment that I do in .NET.