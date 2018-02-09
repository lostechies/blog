---
wordpress_id: 25
title: 'Kanban in Software Development. Part 3: Andon and Jidoka &#8211; Handling Bugs and Emergency Fixes in Kanban'
date: 2008-12-19T13:46:35+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2008/12/19/kanban-in-software-development-part-3-andon-and-jidoka-handling-bugs-and-emergency-fixes-in-kanban.aspx
dsq_thread_id:
  - "262067998"
categories:
  - Analysis and Design
  - Community
  - Continuous Integration
  - Kanban
  - Lean Systems
  - Management
  - Philosophy of Software
  - Principles and Patterns
redirect_from: "/blogs/derickbailey/archive/2008/12/19/kanban-in-software-development-part-3-andon-and-jidoka-handling-bugs-and-emergency-fixes-in-kanban.aspx/"
---
Let&#8217;s assume that we are doing <a href="http://stevenharman.net/blog/archive/2008/12/17/when-should-i-write-tests.aspx" target="_blank">the appropriate amount</a> of testing during our development process. If we include TDD, test automation, test engineers and customer acceptance testing, we should find the majority of the bugs in our system before they are released. However, not every bug will be found. There will be some situation that no one thought about before. There will be some special circumstance on someone&#8217;s computer that hasn&#8217;t been accounted for. There will be some client data that does fit the expected variance, despite the data being valid. The point is, there will be something that breaks after we deliver the software. Worse yet &#8211; it doesn&#8217;t even take delivery to find bugs. What happens when the software gets to customer acceptance and the customer says that something is wrong, broken or whatever? We simply must account for the inevitable bug fixes and emergency patches in our system.

Our current kanban board, with all it&#8217;s <a href="http://www.lostechies.com/blogs/derickbailey/archive/2008/12/08/kanban-in-software-development-part-2-completing-the-kanban-board-with-queues-order-points-and-limits.aspx" target="_blank">pipelines and queues</a>, hasn&#8217;t addressed the need to address problems. But before we get into any changes to the board, we have to define and create the culture of quality that we need in our team. 

### A Culture Of Quality

There are many different aspects of quality and many different ways to view and interpret quality. The individual specifics, as always, come down to your team, the project and the needs of both. Even with these variances, though, there are a few key concepts that should be found in any culture of quality, including <a href="http://www.derickbailey.com/2008/07/20/CollectiveOwnershipSocializingTheDesignAndContinuousImprovement.aspx" target="_blank">Whole Team / Collective Ownership</a> and <a href="http://en.wikipedia.org/wiki/Zero_Defects" target="_blank">Zero Defects</a>.

**Collective Ownership**

I&#8217;ve talked about this concept before (see above link) and would recommend reading those prior posts. One thing I would like to add, though is that collective ownership can only success when the team takes their individual egos out of the equation. We must be able to accept criticism as a way to improve ourselves and our team. When we let go of our ego, we can <a href="http://kohari.org/2008/12/18/altnet-is-the-opposition-party/" target="_blank">be honest with ourselves and others</a>, enabling everyone to own every part of the system. 

**Zero Defects**

This is a subject that I have not talked about before, but is prevalent throughout the <a href="http://en.wikipedia.org/wiki/Continuous_improvement" target="_blank">continuous improvement</a> philosophies that I subscribe to. <a href="http://en.wikipedia.org/wiki/Zero_Defects" target="_blank">Wikipedia</a> lists four principles of Zero Defect methodologies, all of which are paramount to our culture of quality. 

  1. Quality is conformance to requirements 
  2. Defect prevention is preferable to quality inspection and correction 
  3. Zero Defects is the quality standard 
  4. Quality is measured in monetary terms – the Price of Nonconformance

Don&#8217;t be confused by "requirements" in item number one, though. In the world of software development, the word "requirements" has many meanings &#8211; not simply the feature list or functional descriptions set forth by our customers. Our teams and processes have certain requirements that are imposed on top of, and into each of the business requirements for the software. These often include the use of source control systems, test driven development, principles like <a href="http://www.lostechies.com/blogs/chad_myers/archive/2008/03/07/pablo-s-topic-of-the-month-march-solid-principles.aspx" target="_blank">S.O.L.I.D.</a>, etc.

### Quality Checks in Kanban

Collective ownership and zero defects are only the tip of the iceberg. There is so much more to a culture of quality and so many different aspects of quality to account for. However we define quality, though, our ability to <a href="http://www.lostechies.com/blogs/chad_myers/archive/2008/05/27/introducing-quality-first-notions-into-an-existing-team.aspx" target="_blank">create a culture of quality</a> is necessary for our kanban system to work. Without it, we lose the continuous improvement and elimination of waste that defines <a href="http://en.wikipedia.org/wiki/Lean_software_development" target="_blank">Lean</a>. With it, though, we can introduce some specific tools to our process and improve our kanban system by having it handle the errors that are found in our systems.

**Andon**

From <a href="http://en.wikipedia.org/wiki/Andon" target="_blank">Wikipedia</a>: 

> _"a system to notify management, maintenance, and other workers of a quality or process problem"_

When an issue is found in our system, we need to notify the team immediately so that the problem can be taken care of. The idea in a manufacturing line is to allow a worker to stop the line when a problem is found. In our grocery store example, andon could be invoked by a shelf stocker noticing a loose [<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;margin: 0px 5px 5px;border-right-width: 0px" height="122" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_thumb_541ABE87.png" width="74" align="left" border="0" />](http://lostechies.com/derickbailey/files/2011/03/image_1F7A624C.png)nut or bolt on the shelf and then notifying a maintenance person. In software development, andon can take many different forms. We report our issues list during our daily standup. We create issue tickets in our issue management system. If we&#8217;re lucky and work in a company that supports the idea of a team room, we may just need to look up or turn around and let the team know that we have problems. We could even place an actual red flag on the desk of our developers, testers, customer representatives, etc., and have them raise that flag when they see a problem. Any of these ideas, plus many many more, can all be our andon system. 

Andon itself is not intended to be an all encompassing electronic system with metrics and reports and yadda yadda yadda. It needs to be simple. It needs to be easily employed by anyone on the team. And it needs to mean something to the team. If a team member throws their andon card out on the table, the culture of that team needs to be ingrained with the knowledge that work may stop until the problem is addressed.

There&#8217;s so little to andon, yet so much more than what I&#8217;ve described. However andon is enabled, it is critical to our zero defect policy in software development. 

**Jidoka** 

AKA "Autonomation", AKA "Automation with a human touch", AKA "intelligent automation", AKA &#8230;

From <a href="http://en.wikipedia.org/wiki/Jidoka" target="_blank">Wikepedia</a>:

> _"Autonomation prevents the production of defective products, eliminates overproduction and focuses attention on understanding the problem and ensuring that it never recurs."_

I&#8217;ve talked about Jidoka in previous posts and would recommend reading them, at this point. 

  * <a href="http://www.derickbailey.com/2008/05/09/JidokaIfItsBrokeFixItNow.aspx" target="_blank">Jidoka &#8211; If it&#8217;s broke, fix it now</a> 
  * <a href="http://www.derickbailey.com/2008/07/01/JidokaMoreThanJustQuotIfItsBrokeFixItNowquotFixItAndInformTheTeam.aspx" target="_blank">Jidoka &#8211; More than just &#8216;if it&#8217;s broke, fix it now" &#8211; fix it and inform the team</a>

I don&#8217;t have much else to add, other than to say that Jidoka and Andon go hand in hand. Automated build servers (such as <a href="http://confluence.public.thoughtworks.org/display/CCNET/Welcome+to+CruiseControl.NET" target="_blank">CCNet</a>, <a href="http://www.jetbrains.com/teamcity/" target="_blank">TeamCity</a> and many others) can often combine Andon and Jidoka for us by giving us instant visual feedback when something is broken. I&#8217;ve also recently set up <a href="http://code.google.com/p/bigvisiblecruise/" target="_blank">BigVisibleCruise</a> in my team area, giving even the casual observer the knowledge of whether our builds are broken or not. 

### Applying Andon and Jidoka to Our Kanban Board

Once we have the concepts of Andon and Jidoka in our team and culture, we can use these tools to generate issue cards and then look at a few possible changes to our kanban board to account for them. The three basic methods that I have seen used include:

  1. Creating an Emergency Fixes pipeline 
  2. Tacking a smaller bug notice onto an existing card 
  3. Putting a Bug card in the backlog

I&#8217;m sure there are other alternatives, too. In my current team, we use the first and third method and are considering the second one as well.&#160; 

Options two and three essentially require no change to our kanban board. Implementing option two is a distinctive way of visually attaching a bug notice to one of the cards in our system. This could be done with little bug stickers, little red cards, or any other visual indicator that the team agrees on. Option three also needs something distinctive. Since we are creating an entire card for the bug, though, the entire card should be distinctive. I would recommend using a card that is colored red to signify issues. I would also recommend prioritizing the bug to the top of the backlog queue, when using option three. This will ensure that the bug gets worked as quickly as possible.

Option number one can also make use of number two and/or three. When we move a card into the Emergency Fixes pipeline, we may want it to be distinguishable as an issue by tacking on our bug symbol or by using a colored card.

### Emergency Fixes Pipeline

Depending on the complexity or severity of the bug, we may want to include Analysis and Customer Acceptance in our Emergency Fixes. With andon and jidoka in mind, we will want to ensure that we fix any emergency issue immediately. This is not always possible, however. The customer may decide to delay the fixing of an issue for whatever reason. This leads us to only needing a single pipeline for Emergency Fixes, letting us set our limit to one.

We can easily add an Emergency Fixes pipeline to our kanban system, placing it directly underneath our existing WIP pipeline. This special pipeline can be designated with a name, color code, or other marks as needed.

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="488" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_thumb_3AB2BB4D.png" width="777" border="0" />](http://lostechies.com/derickbailey/files/2011/03/image_4CFB820F.png) 

If you are supporting production releases, you may also need to include a Delivery queue specifically for emergency fixes. This would allow multiple fixes to be compiled into a single patch release. There are other configurations to this, of course. As always, you will need to find what your specific team needs and create your process to suit.

### Where Do We Go From Here?

With an Emergency Fixes pipeline in place, our kanban system is now set up to handle just about every situation that we will encounter. However, this does not mean that our system is perfect or truly complete. No process, no matter how well defined it is, is worth anything if the people running the process do not believe in it. I&#8217;ve said it before and I&#8217;ll continue to say it &#8211; never stop improving your process. Always be mindful of waste, friction, smells, problems or whatever you want to call it. Inspect, adapt and continuously improve your process. Perfection is a journey, not an end-goal.

Stay tuned to my <a href="http://www.lostechies.com/blogs/derickbailey/archive/2008/11/19/adventures-in-lean.aspx" target="_blank">Adventures in Lean</a> series, as I continue to explore the various aspects of lean software development in my own team and company culture.