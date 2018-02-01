---
id: 4766
title: 'Refactoring project update #2'
date: 2009-02-18T15:35:20+00:00
author: Steve Donie
layout: post
guid: /blogs/stevedonie/archive/2009/02/18/refactoring-project-update-2.aspx
dsq_thread_id:
  - "1098763841"
categories:
  - Continuous Integration
  - ProjectManagement
  - retrospective
  - Testing
---
So, work on the refactoring project continues. We had a meeting with some of the key stakeholders, and came to an agreement between everyone that we should strive for several small releases. Our first release goal is fairly modest, and actually removes some little-used functionality in the system. We&#8217;re starting by setting up an end-to-end automated smoke test of the system. All of this is being automated using Hudson as our CI server. We approached the problem sort of like we would TDD, but in a larger context. Step one was to imagine what we wanted the end result to look like. Something like &#8220;Whenever a code change is checked in, we want to create a deployable packaged loader, save that artifact somewhere, then run a smoke test of that packaged artifact&#8221;. That led to us looking at the packaging and artifact repository system we had been using. We had been using a system very similar to what I described in a <a href="http://donie.homeip.net:8080/pebble/Steve/2005/12/28/1135786642478.html" target="_blank">post at my old blog</a> in which built artifacts were checked into subversion. There were some issues with that system, and we&#8217;ve been wanting to move more towards a maven style of managing dependencies and build artifacts, so we spent a day or so getting that set up. On a side note, maven can be a pain in the butt.

So following up on my previous post regarding Hudson and CCTray, we now have all good builds!

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="218" alt="HudsonAllGood" src="http://lostechies.com/stevedonie/files/2011/03/HudsonAllGood_thumb.png" width="505" border="0" />](http://lostechies.com/stevedonie/files/2011/03/HudsonAllGood.png)

&nbsp;

Our next step is to get some FitNesse tests around some of the data validation aspects of this loader. The current loader is a bit rigid about how it does things &#8211; it uses exceptions for flow control (blech!) and just dies completely if there is any problem with the incoming data. The folks who run the loader have found this &#8216;feature&#8217; a bit annoying. They run the loader and after running for an hour or so, it will die because of one problem. One of the new features we are adding is the auditing system we have developed for our previous loader projects, so problems get recorded in a standard format, but the loader can continue on with its work, loading the items that are valid, and skipping those that are not. The audit report is then sent back to our data entry group so that they either add to or correct the incoming data. We&#8217;ll also set up some additional validations on the data entry side to catch the problems earlier. 

>