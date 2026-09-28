---
wordpress_id: 21
title: 'Team Foundation Build, Part 1: Introduction'
date: 2007-05-22T15:12:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/05/22/team-foundation-build-part-1-introduction.aspx
dsq_thread_id:
  - "290422993"
categories:
  - TeamBuild
  - VSTS
redirect_from: "/blogs/jimmy_bogard/archive/2007/05/22/team-foundation-build-part-1-introduction.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/05/team-foundation-build-part-1.html)._

There&#8217;s been some interest recently for our team to utilize more features of Team System, including [Team Foundation Build](http://msdn2.microsoft.com/en-us/library/ms252495(VS.80).aspx).&nbsp; Rather than send out a blanket email, I&#8217;m following [Jon Udell&#8217;s](http://blog.jonudell.net/)&nbsp;[advice](http://blog.jonudell.net/2007/04/10/too-busy-to-blog-count-your-keystrokes/) and [maximizing the value of my keystrokes](http://blog.jonudell.net/2007/04/10/too-busy-to-blog-count-your-keystrokes/) by posting a series of blog entries on this topic.

Visual Studio Team System introduced quite a few productivity enhancements for development teams including work items, process templates, reporting, source control, and builds.&nbsp; Team Foundation Build is the build server component of VSTS.&nbsp; Build definitions in VSTS are:

  * Managed&nbsp;in Team Explorer 
      * Represented&nbsp;by MSBuild scripts 
          * Stored in Team Foundation Source Control 
              * Executed on a build machine by the Team Build Service 
                  * Can be initiated through Team Explorer 
                      * Report results to Team System</ul> 
                    So why should we use Team Build over a home grown solution like batch files, Nant scripts, etc.?
                    
                    ### Centralized management
                    
                    All builds are defined, managed, and viewed through Team Explorer.&nbsp; Since builds are stored in source control, we get all of the benefits source control provides, such as versioning, security, etc.&nbsp; We also have one central repository to view and edit builds.&nbsp; I can double-click a build definition to view all of the executed builds with status (success/failure), and drill down into a single build to view more details.&nbsp; If I&#8217;m using [ReSharper](http://www.jetbrains.com/resharper/), I get IntelliSense and refactoring tools for MSBuild.
                    
                    ### Defined with MSBuild
                    
                    MSBuild is the new build platform for Visual Studio.&nbsp; Project files (.vsproj, .vbproj, etc.) are now defined as MSBuild scripts.&nbsp; Tasks in MSBuild are customizable and extensible, so I can [define new tasks](http://msdn2.microsoft.com/en-us/library/t9883dzc(VS.80).aspx) and use [community built](http://www.codeplex.com/sdctasks) [tasks](http://msbuildtasks.tigris.org/).&nbsp; Team Build definitions also allow [extensibility points](http://msdn2.microsoft.com/en-us/library/ms400688(VS.80).aspx), similar to the ASP.NET page event model, by [extending certain targets](http://msdn2.microsoft.com/en-us/library/aa337604(VS.80).aspx) such as &#8220;BeforeGet&#8221;, &#8220;AfterTest&#8221;, and &#8220;AfterDropBuild&#8221;.
                    
                    ### Status and reporting
                    
                    There are usually two pieces of information I&#8217;m curious about when looking at builds:
                    
                      * What is the status of the current build? (In progress, successful, failed) 
                          * Is there a trend in the build statuses?</ul> 
                        All of this information can be seen through Team Explorer.&nbsp; Additionally, I&#8217;ve seen tray icon applications that will display a red, yellow, or green light indicating the status of a certain build definition.
                        
                        ### Where do we go from here?
                        
                        In coming posts, I&#8217;ll discuss installation and configuration, defining builds, and outlining a set of values, principles, and practices Team Build can be used to encourage and enforce.&nbsp; I&#8217;ll also outline some ideas on what kinds of build definitions are good to have, and what kinds of activities we might want to accomplish as part of our builds.