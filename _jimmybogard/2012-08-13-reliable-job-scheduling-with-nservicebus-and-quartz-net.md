---
wordpress_id: 653
title: Reliable job scheduling with NServiceBus and Quartz.NET
date: 2012-08-13T20:07:33+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/08/13/reliable-job-scheduling-with-nservicebus-and-quartz-net/
dsq_thread_id:
  - "803994416"
categories:
  - NServiceBus
---
One of the more interesting features of NServiceBus is the ability to [schedule messages](http://nservicebus.com/Scheduling.aspx) and send messages in the future. The default implementation works well for simple cases, where you have messages that need to be sent every X seconds. But for many of our scenarios, we are more calendar based.

Instead of something every 5 seconds, we wanted to do “Every second Tuesday” or “Daily at 6 AM” or “First of the month”. These more complicated schedules are easy to build with tools like Windows Task Scheduler or cron. Those tools work great, but we had problems with them in our production environments:

  * When a job failed, we didn’t get notified
  * It forced us to create console apps for everything
  * Logging left something to be desired
  * Is not .NET-based

We started gravitating towards an architecture where our “jobs” were really just NServiceBus handlers initiated by messages. This gave us all the durability, logging, retry etc etc that WTS doesn’t have. Plus, it was more efficient for us to just keep the job processes in memory, instead of processes waking up to do something then going to sleep. In our new architecture, we created a job initiator and a series of job executors:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2012/08/image_thumb.png" width="216" height="240" />](http://lostechies.com/content/jimmybogard/uploads/2012/08/image.png)

We then used [Quartz.NET](http://quartznet.sourceforge.net/) as a 100% C#-based job scheduler for initiating jobs. Both of these boxes are NServiceBus hosts, but the Job Initiator is a send-only endpoint. The job runners are really just NServiceBus hosts with handlers to execute the jobs. Job runners are decoupled from the schedule they run, and the job initiator is decoupled from what work actually happens as part of a job.

Integrating NServiceBus and Quartz.NET is fairly straightforward, but is a little bit of code. I’ve put the [full example up on my GitHub](https://github.com/jbogard/QuartzNServiceBusSample) that you can download and run (readme details how).

But basically, I got it to the point where I have my job initiator and definition of a job:

{% gist 3343521 %}

Where I just send a message as part of my job. Then I can define the schedule to initiate that job:

{% gist 3343531 %}

This schedule runs just once a month, on the first of the month, at 5 AM. In the sample, I also configure Quartz to use durable, database-backed schedules to be able to handle service stoppage/restarts.

But why go this route instead of just normal cron/task scheduler jobs? For me, I wanted to have more reliability in my scheduled jobs, and moving to NServiceBus as the executor of those jobs gave me that. Quartz.NET then gave me the ability to host scheduling 100% in .NET, whereas the Task Scheduler API is….interesting to say the least.

It’s not for everyone, but in our systems where we already have NServiceBus in use, adding Quartz.NET let us easily use messaging for job execution.

[Download Quartz.NET NServiceBus Sample](https://github.com/jbogard/QuartzNServiceBusSample/zipball/master)