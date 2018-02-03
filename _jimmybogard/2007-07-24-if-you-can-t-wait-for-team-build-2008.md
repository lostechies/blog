---
wordpress_id: 45
title: 'If you can&#8217;t wait for Team Build 2008&#8230;'
date: 2007-07-24T17:58:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/07/24/if-you-can-t-wait-for-team-build-2008.aspx
dsq_thread_id:
  - "352306737"
categories:
  - TeamBuild
  - Tools
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/07/if-you-can-wait-for-team-build-2008.html)._

I just heard of a new project on CodePlex, [TfsBuildLab](http://www.codeplex.com/tfsbuildlab/).&nbsp; It looks like it performs a lot of the build features Orcas will provide, and it lets you do it with Team Build 2005:

  * Continuous integration builds
  * Scheduled builds
  * Build queuing
  * Build cleanup/retention policies
  * Event notifications

The TfsBuildLab&nbsp;project is broken into&nbsp;4 separate components:

  * Database
  * Houses the scheduling and queuing data

  * Service
  * Queues builds
  * Executes manual builds
  * Executes scheduled builds

  * Admin client
  * Configures build schedules, etc.

  * Notification client
  * Notifies clients of build status, similar to [CCTray](http://confluence.public.thoughtworks.org/display/CCNET/CCTray)

Builds are still executed by Team Build, but TfsBuildLab puts a layer on top of Team Build to provide the extra functionality.&nbsp; This looks like a nice interim solution until Team Build 2008 releases early next year.