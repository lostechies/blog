---
id: 4765
title: CCTray with Hudson
date: 2009-02-09T15:42:12+00:00
author: Steve Donie
layout: post
guid: /blogs/stevedonie/archive/2009/02/09/cctray-with-hudson.aspx
dsq_thread_id:
  - "262124069"
categories:
  - Uncategorized
---
Hurrah! <a href="http://testinfected.blogspot.com/" target="_blank">Eric Anderson</a> did some research this weekend and we now have our CCTray lights and speech working again! 

Back when we were using CruiseControl.java for our builds, I submitted some patches to the CC.net project to allow the <a href="http://confluence.public.thoughtworks.org/display/CCNET/Welcome+to+CruiseControl.NET" target="_blank">CCTray</a> application to properly control X10 build status lights, and also to support text-to-speech for announcing build status changes. We really liked having that. We had a couple of lava lamps set up in the center of the team room to show the status of our builds &#8211; that allows us to see the status of the build when we come into the room. The speech (It says things like &#8220;The Well Logs Refactor project has started building&#8221; and &#8220;The Well Logs refactor project reports Yet another successful build&#8221;) helped us stay hyper-aware of the state of things. Having a periodic announcement that a build is starting reinforces the &#8216;pace&#8217; of the team. 

So, when we started using Hudson for our build server, we were disappointed that the rss format it shows didn&#8217;t work with Hudson. I looked around a bit, and while Hudson has its own &#8216;tray&#8217; application, it didn&#8217;t do the stuff I wanted. I spent a little time looking at Hudson source code, thinking about writing a plugin to support the CC xml format. I looked at doing another patch for CCTray to support reading the Hudson RSS or XMl or Atom feeds. But I never got very far on those projects. Getting actual project work done was always a higher priority. 

But now it is working again, and there was much rejoicing in the team room this morning. In order to spread the word that Hudson does output CCTray compatible xml, I am writing this post. The magic URL to enter into CCTray is http://hudsonserver:port/cc.xml and is described more fully on the <a href="http://hudson.gotdns.com/wiki/display/HUDSON/Monitoring+Hudson" target="_blank">Hudson Wiki</a>.

Here is a picture of our newest build light setup:

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="184" alt="DCFN0004" src="http://lostechies.com/stevedonie/files/2011/03/DCFN0004_thumb.jpg" width="244" border="0" />](http://lostechies.com/stevedonie/files/2011/03/DCFN0004.jpg) 

Yes, the build is broken! We&#8217;re creating a new smoke test at the moment, and fighting with Maven configuration. We&#8217;re also going to neaten up the cords Real Soon Now. 

Here are the three X10 modules on the wall. Pretty ugly. Might be a weekend project to mount the modules inside the light fixture, so we can just have a single cord coming out. 

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="184" alt="Pic 036" src="http://lostechies.com/stevedonie/files/2011/03/Pic-036_thumb.jpg" width="244" border="0" />](http://lostechies.com/stevedonie/files/2011/03/Pic-036_2.jpg)&nbsp;&nbsp;&nbsp; 

Finally, here is a pic of the team room &#8211; we have a long rectangular room, and mounted the lights on the short wall that is off the left edge of this photo.

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="184" alt="DCFN0003" src="http://lostechies.com/stevedonie/files/2011/03/DCFN0003_thumb.jpg" width="244" border="0" />](http://lostechies.com/stevedonie/files/2011/03/DCFN0003.jpg) 

Next thing for me will be a much simpler patch to CCTray to support three lights in X10. Currently it only supports &#8216;green&#8217; and &#8216;red&#8217;. I want to make it so that the yellow light also comes on while a build is in progress. So the color scheme would be:

  * Green only &#8211; all builds are good, nothing in progress
  * Green + Yellow &#8211; all builds are good, build in progress
  * Red only &#8211; at least one build is broken, nothing currently building
  * Red + Yellow &#8211; at least one build broken, build in progress.