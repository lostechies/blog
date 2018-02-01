---
id: 4612
title: There can be only One RoleEntryPoint
date: 2010-06-07T04:49:55+00:00
author: Scott Densmore
layout: post
guid: /blogs/scottdensmore/archive/2010/06/07/there-can-be-only-one-roleentrypoint.aspx
dsq_thread_id:
  - "270572450"
categories:
  - Uncategorized
---
Last week we were finalizing the production of [Windows Azure Architecture Guidance Part 1](http://wag.codeplex.com/), when we came across a problem with the code. We had a few machines that were failing when trying to start the WebRole for the project. Here are the event log entries for one of the machines (They were all logged by the HostableWebCore on the local machine):

1: The worker process for application pool &#8216;{E2160A33-4856-41E2-B811-E19D71F18B22}&#8217; encountered an error &#8216;The configuration section &#8216;system.webServer/globalModules&#8217; cannot be read because it is missing a section declaration &#8216; trying to read global module configuration data from file &#8216;\?C:Users<removed>AppDataLocaldftmps0deployment(135)resdeployment(135).aExpense.Azure.aExpense.0temptempapplicationHost.config&#8217;, line number &#8216;0&#8217;. Worker process startup aborted.
  
2: The worker process for application pool &#8216;{E2160A33-4856-41E2-B811-E19D71F18B22}&#8217; encountered an error &#8216;Cannot read configuration file &#8216; trying to read configuration data from file &#8216;\?C:Users<removed>AppDataLocaldftmps0deployment(135)resdeployment(135).aExpense.Azure.aExpense.0temptempapplicationHost.config&#8217;, line number &#8216;0&#8217;. The data field contains the error code.
  
3: The Windows Process Activation Service received a change notification, but was unable to process it correctly. The data field contains the error number.
  
4: The Windows Process Activation Service encountered an error trying to read configuration data for config section &#8216;system.applicationHost/webLimits&#8217; from file &#8216;\?C:Users<removed>AppDataLocaldftmps0deployment(135)resdeployment(135).aExpense.Azure.aExpense.0temptempapplicationHost.config&#8217;, line number &#8216;0&#8217;. The error message is: &#8216;The configuration section &#8216;system.applicationHost/webLimits&#8217; cannot be read because it is missing a section declaration &#8216;. The data field contains the error number.

On another machine we got this error:

The Windows Process Activation Service encountered an error trying to read configuration data from file &#8216;\?C:WAAGs0deployment(42)resdeployment(42).aExpense.Azure.aExpense.0temptempapplicationHost.config&#8217;, line number &#8216;0&#8217;. The error message is: &#8216;Cannot read configuration file

All this lead me to believe that something was going on with the coping of the files during the process of deploying locally. It seemed like the files were not getting copied before the HostableWebCore (IIS) was trying to read them causing the WebRole to stop. To make a long story short, this had nothing to do with the problem. The errors were actually caused by having multiple RoleEntryPoints defined in the WebRole project (this can be caused by having multiple RoleEntryPoints defined in any assembly that represents a WebRole or WorkerRole). The reason the errors manifested the way they did is because the projects were being run inside of Visual Studio. When Visual Studio runs the project it deploys it and then tells the Dev Fabric to run the project. The problem is that when it fails to start the project in a specified time (because of an error) it removes all the deployed files and the HostableWebCore reports an error that it can not find them. To see the real problem you can use csrun.exe and run the package file and see the error in the Dev Fabric UI (csrun myproject.csx ServiceConfiguration.cscfg).

So all this comes down to the fact that we had a abstract class that we used to inherit functionality for RoleEntryPoints. What happens is that when the Role starts up, Windows Azure uses reflection to find the class that inherits from RoleEntryPoint. Since we have two, it picks one of them and sometimes it picks the wrong one. Since reflection is non-deterministic, this will cause the failure. To fix this, we moved the abstract class to another assembly.

We have filed a bug against this and maybe they will come up with a way to fix it. Until then, I hope this helps people if they run into this problem.

<div class="itunes_track">
  Listened to: <span class="title">You Never Give Me Your Money</span> from the album &#8220;<span class="album">Abbey Road</span>&#8221; by <span class="artist"><a href="http://www.google.com/search?q=%22The%20Beatles%22">The Beatles</a></span>
</div>

<div class="posttagsblock">
  <a href="http://technorati.com/tag/.NET" rel="tag">.NET</a>, <a href="http://technorati.com/tag/Azure" rel="tag">Azure</a>
</div>