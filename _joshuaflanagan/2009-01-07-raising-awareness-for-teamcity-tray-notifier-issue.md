---
wordpress_id: 3940
title: Raising awareness for TeamCity tray notifier issue
date: 2009-01-07T01:54:30+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2009/01/06/raising-awareness-for-teamcity-tray-notifier-issue.aspx
dsq_thread_id:
  - "262113150"
categories:
  - teamcity
---
**<font color="#ff0000">UPDATE:</font>** JetBrains has released a solution to this issue, [I posted a follow up](http://www.lostechies.com/blogs/joshuaflanagan/archive/2009/01/15/solution-for-monitoring-multiple-teamcity-servers.aspx).

Rumor has it that a number of your favorite .NET open source applications (including <a href="http://structuremap.sourceforge.net/" target="_blank">StructureMap</a>) will soon have a publicly available continuous integration server. The server will be running TeamCity by JetBrains. I’m a TeamCity fan, and we’ve been using it at work for a while now. Which is the rub. You see, since TeamCity allows you to easily host many projects on a single server (while delegating the building out to separate build agents), JetBrains did not foresee why anyone would ever want to monitor more than one server. This will soon be a very real scenario for followers of many OSS projects. The current tray notifier tool can only connect to a single build server. There aren’t even any command-line parameters that would allow you to run multiple instances of the notifier simultaneously.

An issue has already been logged with JetBrains, but it doesn’t seem to have much attention <strike>(or priority)</strike> (I misread their priority icons, it was marked as Major) yet. This post is an attempt to try and remedy that. If you currently use TeamCity, and want to follow the progress of projects like StructureMap, please go vote for <a href="http://www.jetbrains.net/tracker/workspace?currentIssueId=TW-4230" target="_blank">Allow to watch several TeamCity servers via Tray Notifier</a>.