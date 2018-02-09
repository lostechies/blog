---
wordpress_id: 51
title: Balsamiq And A Sneak Preview Of My ‘Decoupling Workflow’ Presentation
date: 2009-05-15T01:25:23+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/05/14/balsamiq-and-a-sneak-preview-of-my-decoupling-workflow-presentation.aspx
dsq_thread_id:
  - "262068143"
categories:
  - Product Reviews
  - User Experience
redirect_from: "/blogs/derickbailey/archive/2009/05/14/balsamiq-and-a-sneak-preview-of-my-decoupling-workflow-presentation.aspx/"
---
I know I’m late jumping on this bandwagon, but it’s better late than never, right? 🙂

I decided to try out the [Balsamiq Mockups](http://www.balsamiq.com/) tool while working on my sample application for the ‘[Decoupling Workflow from Forms](http://www.lostechies.com/blogs/derickbailey/archive/2009/04/18/decoupling-workflow-and-forms-with-an-application-controller.aspx)’ presentation that I’m planning (hoping! Go [vote for my session](http://www.adnug.org/AustinCodeCamp09/Proposal/List)!) to give at this year’s [Austin Code Camp](http://austincodecamp.com). The code for the presentation will revolve around a very simple “Org Chart” set of features, illustrating the principles and patterns of Application Controller, IoC containers, and others.

### The Org Chart Screens

I’ve played with Balsamiq in the past, but never for an actual project. In less than 30 minutes, I was able to come up with the following screen layouts for my presentation. 

**The “Org Chart” Main Form**

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="231" alt="Org Chart View" src="http://lostechies.com/derickbailey/files/2011/03/OrgChartView_thumb_5376DC0D.png" width="244" border="0" />](http://lostechies.com/derickbailey/files/2011/03/OrgChartView_3BBFA4A7.png) 

**The “Add New Employee – Info” Form**

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="130" alt="New Employee - Info" src="http://lostechies.com/derickbailey/files/2011/03/NewEmployeeInfo_thumb_43879749.png" width="244" border="0" />](http://lostechies.com/derickbailey/files/2011/03/NewEmployeeInfo_647B09F0.png) 

**The “Add New Employee – Manager” Form**

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="103" alt="New Employee - Manager" src="http://lostechies.com/derickbailey/files/2011/03/NewEmployeeManager_thumb_21BBBEB8.png" width="244" border="0" />](http://lostechies.com/derickbailey/files/2011/03/NewEmployeeManager_709C8417.png) </p> 

The general workflow between these screens should be fairly intuitive. You can select an employee from the treeview, in the main form, and see their details. You can also click the “Add New Employee” button to go through the wizard-style process of adding a new employee’s information and selecting their manager.

It’s a very simple system, but it contains just enough elements to illustrate all of the concepts in my presentation. I’ll be using an Event Aggregator to know what user information to display, after selecting someone in the treeview. I’ll use a command object to start up the Add New Employee wizard, facilitated with a workflow service. And, it will all be wired together at runtime, with the [StructureMap](http://structuremap.sourceforge.net/) IoC container, illustrating the very low coupling that I am going for.

### Balsamiq – It’s Not Just A Great Condiment With Chicken!

Overall, I’m very happy with the ease and usability of Balsamiq. The UI toolset that Balsamiq comes with is quite large, and is composed of the most often used, most fundamental UI elements. And with the data editing capabilities (titles, captions, lists, etc) that are available on each of the controls, it takes almost no time to string together to create compelling design. Even for the UI that aren’t covered by the default tools, there are user contributed controls that you can download and add from [MockupsToGo.net](http://www.mockupstogo.net/)! 

### One Minor Critique

Honestly, the only glaring issue that I have with Balsamiq is the name itself. Technically, the product name is “Balsamiq Mockups”. My problem with this name comes from being heavily influenced by the user experience realm of software development. The products of Balsamiq are not “mockups”, they are wireframes. Mockups are usually full color, highly detailed, almost-production-ready renderings.

Seriously… that’s the only problem I have with this product, at this point. 

### The Verdict

Balsamiq Mockups is a tremendous tool that <u>all</u> software developers and designers should have in their toolbox. It may not “wow” your socks off with all the “cool” of an iPod or iPhone, but it doesn’t need to. It’s simple. It sticks to what it does well. And it does what it does, exceptionally well. Most importantly, though &#8211; _it doesn’t get in your way when you’re trying to let the creative design juices flow_! The only thing that is less intrusive is a whiteboard and markers, but that solution doesn’t let you drag, drop and resize without erasing and starting over. 🙂

Go spend 10 minutes trying out the online version and then spend the $79 to buy the desktop version.

  * [Balsamiq Mockups](http://www.balsamiq.com/products/mockups)
  * [Try It Now](http://www.balsamiq.com/demos/mockups/Mockups.html) – the online demo (with some limitations)
  * [Buy The Desktop Version](http://www.balsamiq.com/products/mockups/desktop)

There are also versions that integrate with Atlassian’s [Confluence](http://www.balsamiq.com/products/mockups/confluence) and [Jira](http://www.balsamiq.com/products/mockups/jira), and the [XWiki](http://www.balsamiq.com/products/mockups/xwiki) system, making it that much more attractive.

### The Disclaimer / Full Disclosure

To keep myself and my blog honest, I do want to note that I was given a free $79 license for the desktop edition of Balsamiq Mockups. This review is essentially my “payment” for the free license. I do want to note, however, that I am not endorsing this product simply for the sake of a license. If I felt the product was not worth my time, I would say so. The truth is, I have been prompting the user experience team at my office to look into Balsamiq and do demos to the rest of the development department. I’ve recommended it to friends and other bloggers. And most importantly – I would have paid the $79 for the license if my request for a “blogger” license was denied. It really is worth the money.