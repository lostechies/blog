---
wordpress_id: 3941
title: Solution for monitoring multiple TeamCity servers
date: 2009-01-15T15:23:51+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2009/01/15/solution-for-monitoring-multiple-teamcity-servers.aspx
dsq_thread_id:
  - "277486527"
categories:
  - teamcity
redirect_from: "/blogs/joshuaflanagan/archive/2009/01/15/solution-for-monitoring-multiple-teamcity-servers.aspx/"
---
Proving yet again that the squeaky wheel gets the grease (this issue rose up to have the second highest number of votes in the TeamCity issue tracker), and what a truly responsive vendor JetBrains is, we now have a solution for the problem of monitoring more than one TeamCity server.

Its a quick workaround, and requires you to run multiples instances of the notifier, but it satisfies the immediate need for me. Read the full details in <a href="http://jetbrains.net/tracker/issue/TW-4230" target="_blank">Yegor Yarko’s comments in the issue tracker</a>.

A pleasant surprise is that the updated notifier still works against a TeamCity 3.x server, for those of us that haven’t had the chance to upgrade to 4.x.