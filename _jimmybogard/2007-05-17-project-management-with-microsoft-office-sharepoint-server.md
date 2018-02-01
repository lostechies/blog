---
id: 19
title: Project management with Microsoft Office SharePoint Server
date: 2007-05-17T14:37:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/05/17/project-management-with-microsoft-office-sharepoint-server.aspx
dsq_thread_id:
  - "271919700"
categories:
  - VSTS
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/project-management-with-microsoft.html)._

Having used Team System in the past, I&#8217;ve been trying to wrap my head around using Team System for work items in our group.&nbsp; We&#8217;re using Team System exclusively for source control, but there&#8217;s a lot more functionality available to use.&nbsp; At the heart of a [Team System project](http://msdn2.microsoft.com/en-us/library/ms181234(VS.80).aspx) is the process template, which creates the work item templates, reports, and the team portal page.&nbsp; The problem I&#8217;m seeing is that our Team Project, scoped for source control, spans many groups, many internal projects, many versions, and many global teams.&nbsp; We have Core, Back End, Personalization, Front End, B2B,&nbsp;etc. applications.&nbsp; We have 2.1, 2.1.5, and&nbsp;2.2 versions.&nbsp; We have Global, Asia Pacific, US/CA, Latin America, and&nbsp;Europe regions.&nbsp; All of these different groups, concerns, and project requirements are under a single Team Project.&nbsp; How are we supposed to create a single process template that could possibly work?

### What Team System can give us

In my last project, we used [Scrum](http://www.controlchaos.com/about/?SID=8ef7eb5b2a069a2710abef27d02c851f&SID=7da824062baf60b8e78ec5f99836f092) as our development process, and [Scrum for Team System](http://www.scrumforteamsystem.com/) as our process template.&nbsp; For those unfamiliar with Scrum, it is a lightweight, incremental and iterative development process that breaks the development cycle into iterations called &#8220;sprints&#8221;.&nbsp; Each sprint is [timeboxed](http://en.wikipedia.org/wiki/Timebox), such that no extra work can be assigned nor can the length of the iteration be changed during the sprint.&nbsp; Time and requirements are fixed during the sprint.

All development we did was driven off of requirements that were defined and managed from Team System.&nbsp; When we checked in code, we associated the check-in with a work item.&nbsp; When we ran builds, we could see what checkins were part of that build, what comments were available, and what work items were worked on for that build.&nbsp; Additionally, we no longer needed any status meetings, since individual team members would update the work remaining of their work items every day.&nbsp; [Burndown charts](http://www.scrumforteamsystem.com/ProcessGuidance/Artefacts/Reports/SprintBurndown.html) told us (and management) if we were on track or not.&nbsp; Reports told us at any given time:

  * Progress against the work committed for the current sprint 
      * Progress against the work committed for the current release 
          * Status of individual features or user stories (not started, in progress, ready for test, complete) 
              * Hierarchical composition of features and tasks, with effort and work remaining</ul> 
            Call me crazy, but I think it&#8217;s perfectly reasonable to let the team members be responsible for keeping the status of their tasks up to date and not the project manager.&nbsp; All of this information was available at any time, in real time, and always represented&nbsp;the &#8220;truth&#8221; of the project status.
            
            ### Current issues
            
            The problem with our current layout for our Team Project is that it spans so many teams, so many projects, and so many geographical groups.&nbsp; For a process template to be effective for this topology, it would need to be
            
              * Generalized so we don&#8217;t pigeon hole all teams into a monolithic process 
                  * Flexible to handle different process needs and schedules 
                      * Extensible to allow modifications and&nbsp;additions</ul> 
                    I&#8217;m a big fan of self-organizing teams.&nbsp; We have a lot of intelligent people on our team, we should be able to decide how best to work.&nbsp; Process templates are pretty much set in stone once the Team Project is created, so I don&#8217;t see a whole lot of value applying a process template to the topology we have now in our source control.&nbsp; With Scrum, we had a [Sprint Retrospective](http://www.scrumforteamsystem.com/ProcessGuidance/Process/SprintRetrospective.html)&nbsp;after each sprint to look at improving our process.&nbsp; This regular feedback would be tough,&nbsp;if not impossible&nbsp;to act on if we have to approve changes across a global team.
                    
                    ### The SharePoint solution
                    
                    I recently ran across [another solution](http://reddevnews.com/features/article.aspx?editorialsid=723) to this problem that used SharePoint.&nbsp; Instead of Team System to manage the [Product Backlog](http://www.scrumforteamsystem.com/ProcessGuidance/Artefacts/ProductBacklog.html) and [Sprint Backlog](http://www.scrumforteamsystem.com/ProcessGuidance/Artefacts/SprintBacklog.html), you can use SharePoint lists to house these artifacts.&nbsp; You can still use Excel for reports, and SharePoint includes a powerful search feature that Team System doesn&#8217;t have.&nbsp; What you would lose is the ability to link to work items as you can in Team System.&nbsp; But without completely [changing the topology](http://www.codeplex.com/BranchingGuidance/Wiki/View.aspx?title=Guidance%20for%20Structuring%20Team%20Projects) of our Team Projects to project-based, I just can&#8217;t see us&nbsp;being able to take advantage of the process templates in Team System.&nbsp; SharePoint also gives you custom views on top of your data, and those look to be a little bit easier to use than the custom queries and reports in Team System.
                    
                    The cool thing about a SharePoint solution is that it wouldn&#8217;t be tied to Team System, so each team could manage their own team project however they wish.&nbsp; You give up some in the integration that Team System provides, but you can gain some by allowing each team to take responsibility for their process.&nbsp; If some teams have well-defined and mature development processes, some meta-elements could eventually be developed into a framework for a process template (I&#8217;m a big proponent of [harvested frameworks](http://www.martinfowler.com/bliki/HarvestedFramework.html)).&nbsp; Since the reality is we can&#8217;t do [whole](http://www.xprogramming.com/xpmag/whatisxp.htm) [team](http://www.scissor.com/resources/teamroom/) [together](http://www.xp123.com/xplor/room-gallery/index.shtml), SharePoint is a great solution to enable collaborative, communicative teams.