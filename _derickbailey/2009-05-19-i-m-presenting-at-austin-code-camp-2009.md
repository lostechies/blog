---
wordpress_id: 52
title: I’m Presenting At Austin Code Camp 2009
date: 2009-05-19T01:29:32+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/05/18/i-m-presenting-at-austin-code-camp-2009.aspx
dsq_thread_id:
  - "271323209"
categories:
  - .NET
  - Austin Code Camp
  - Community
  - Presentations
  - Principles and Patterns
---
As Chad so eloquently stated, this year’s [AustinCodeCamp](http://austincodecamp.com/) really is going to be [better than bacon](http://www.lostechies.com/blogs/chad_myers/archive/2009/05/17/austin-codecamp-09-quite-possibly-better-than-bacon.aspx)! And I feel honored to be one of the better than bacon speakers at this year’s event. 

I’m delivering two presentations:

  * The [SOLID presentation that I gave at the Austin .NET User Group last October](http://www.lostechies.com/blogs/derickbailey/archive/2008/10/14/thanks-adnug-attendees-slides-and-code-available.aspx)
  * And a new presentation on Decoupling Workflow From Forms.

### SOLID Software Development: Achieving Object Oriented Principles, One Step At A Time

> Almost every professional software developer understands the academic definitions of Coupling, Cohesion, and Encapsulation. However, many of us do not understand how to actually achieve Low Coupling, High Cohesion, and strong Encapsulation, as prescribed. Fortunately, there are a set of stepping stones that we can use to reach these end goals, giving us a clear cut path to software that is easier to read, easier to understand, and easier to change. This presentation will define not only the three object oriented goals, but also the five S.O.L.I.D. principle that lead us there, while walking through a sample application. 

You can download the slides and code for this presentation from [here at LosTechies](http://www.lostechies.com/media/p/5415.aspx), or from the Austin Code Camp subversion repository closer to / during / after the event.

### Decoupling Workflow From Forms With An Application Controller And IoC Container

> In the development and maintenance of a WinForms application, using a Model-View-Presenter setup, over the last two years, I&#8217;ve ran into a fairly significant challenge: I had my workflow between forms coupled to the forms directly. For example, to get from MainForm to SubForm, code inside of MainForm would instantiate SubForm, it&#8217;s Presenter, and all of the dependencies of each of&#160; thesse. In this application, the form codebehind would often contain several hundred lines of code to create all the needed views, presenters, etc for a workflow &#8211; per workflow. By introducing the concept Application Controller, in combination with a good IoC Container, we can quickly and easily reduce the tight coupling between our forms, while simplifying our presenters and enabling the workflow to change independently of the forms and presenters.

I’m (embarrassingly) still writing the presentation and code for this session. However, you can get a few sneak peaks of the presentation in these two blog posts:

  * [Decoupling Workflow And Forms With An Application Controller](http://www.lostechies.com/blogs/derickbailey/archive/2009/04/18/decoupling-workflow-and-forms-with-an-application-controller.aspx)
  * [Balsamiq And A Sneak Preview Of My ‘Decoupling Workflow’ Presentation](http://www.lostechies.com/blogs/derickbailey/archive/2009/05/14/balsamiq-and-a-sneak-preview-of-my-decoupling-workflow-presentation.aspx)

You can also keep up to date with the presentation as I’m creating it, [over at my Github account](http://github.com/derickbailey/presentations-and-training/tree/master).

### The Code Camp

Come join the fun on May 30th, down in Austin! The event is being held at the same place that it’s been for the last 4 years. Head over to [the official website](http://austincodecamp.com) for more information. Also check out Chad’s post, linked above, for some great links to other information about ACC. 

**Last, but definitely most important:** We all need to give a huge round of thanks to [John Teague](http://johnteague.lostechies.com/) and [Eric Hexter](http://hex.lostechies.com/) for putting together this event. They’ve done a tremendous job of organizing the sponsors, the facilities, and getting the schedule of speakers lined up.