---
id: 90
title: Easy way to gain high level understanding
date: 2015-12-09T21:57:36+00:00
author: Andrew Siemer
layout: post
guid: http://lostechies.com/andrewsiemer/?p=90
dsq_thread_id:
  - "4390325754"
categories:
  - Discovery
---
When I hit the ground anywhere new I go into listening mode and try to absorb as much information as possible.  I am always interested in the process to transfer information about existing systems and processes to new people.  But when I land somewhere that passes me from person to person to gain the understanding of this information I am eager to write down or draw my understanding so that the next new guy doesn&#8217;t have to be passed from place to place.  Onboarding should always get better!

I have bounced from company to company for a lot of years now.  I used to keep 3 active jobs at any given time.  This has put me in this fun discovery mode many times.  As such I have looked at many ways to track information in a quick easy to understand way.  Of course there is/was UML which was a HUGE thing not so many years ago.  But I have found that less formal higher level diagrams are 1) usually good enough and 2) much easier to maintain.  Boxes and lines and no more if possible.

I have used Visio for a lot of years so it is the second tool installed on my box after Visual Studio.  But recently, I made a migration from the land of PC to MBP.  So &#8211; I tried to ditch Visio for at least a short while.

One of the slack teams I am involved in has many smart folks in it.  Asking them what they used turned up https://www.draw.io which has all the tools you need for this purpose.  And the images you draw can be saved to Google Docs directly then shared to customers/peers directly.

But when there is a significant lack in documentation I feel the need to involve others.  Once we cross the bridge of collaborating over documentation we need to be able to work together to create a cohesive output.  Which shapes do we use? How much detail is needed? This lead me to research something less complex than UML but with at least enough of a formal approach that anyone can be involved.

I stumbled upon the C4 concepts along the way.  C4 is much much more than a way to document code (which I won&#8217;t get into here).  But C4 (given my military background) is an easy term to remember.  And they provide a great one page cheat sheet for passing around to summarize how to appropriately and consistently capture just enough information for various audiences.

  1. System context diagram: Shows all the user types that interact with your system and the system dependencies used by your system.  This is for non-technical people to understand the high level system.
  2. Container diagram: This diagram illustrates technology choices like web applications, database servers, etc.  Containers can also be buckets of data like file systems, data bases, email servers, etc.  Basically anything that can host code or contain data.  The audience for this set of diagrams is for software developers and support engineers.
  3. Component diagram: The component diagram deconstructs each container into their logical concepts.  Something like a data layer, a widget factory, service, etc. can all be drawn as a box to show its interaction with other areas in the container.
  4. Class diagram: Beyond the component diagram we start to get into more UML style, detail oriented, designs.  I don&#8217;t generally go this low for depicting my understanding of a given system.

Here is the image I frequently reference:

http://www.codingthearchitecture.com/images/2014/20140824-c4.png

![](http://www.codingthearchitecture.com/images/2014/20140824-c4.png)

What tools and approach do you take to getting an understanding of existing applications?