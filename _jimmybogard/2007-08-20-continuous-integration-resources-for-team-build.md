---
id: 54
title: Continuous Integration resources for Team Build
date: 2007-08-20T13:58:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/08/20/continuous-integration-resources-for-team-build.aspx
dsq_thread_id:
  - "330723153"
categories:
  - TeamBuild
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/08/continuous-integration-resources-for.html)._

[Team Build 2005](http://msdn2.microsoft.com/en-us/library/ms181710(vs.80).aspx) did not support [Continuous Integration](http://www.martinfowler.com/articles/continuousIntegration.html) out of the box.&nbsp; Lots of add-ins and tools have been released since Team Build released to do CI.&nbsp; Here&#8217;s an admittedly incomplete list for doing Continuous Integration with Team Build:

  * [Automaton](http://www.codeplex.com/automation) 
      * [Notion Solutions Team CI](http://teamsystemrocks.com/files/12/tools/entry1018.aspx) 
          * [TFS Integrator](http://notgartner.wordpress.com/2006/09/18/getting-started-with-tfs-integrator/) 
              * [CI Sample](http://blogs.msdn.com/khushboo/archive/2006/01/04/509122.aspx) and the [Vertigo version](http://blogs.vertigosoftware.com/teamsystem/archive/2006/07/14/3075.aspx) 
                  * [TFSBuildLab](http://www.codeplex.com/tfsbuildlab/), which I [just covered](http://www.lostechies.com/blogs/jimmy_bogard/archive/2007/07/24/if-you-can-wait-for-team-build-2008.aspx) 
                      * [TeamBuild plugin](http://blogs.conchango.com/jamesdawson/archive/2007/05/24/TeamBuild-Plug-in-for-CruiseControl.NET.aspx) for [CruiseControl.NET](http://confluence.public.thoughtworks.org/display/CCNET/Welcome+to+CruiseControl.NET), also using the [VSTS plugin for CC.NET](http://www.codeplex.com/TFSCCNetPlugin)</ul> 
                    I&#8217;ve personally used CruiseControl.NET and the CI Sample in projects, and tested out several of the others.&nbsp; I&#8217;d probably stick with using CruiseControl.NET for now, as it has the easiest access to build status and reports with the dashboard and tray application.&nbsp; It&#8217;s also been around for many years and many versions, so it&#8217;s solid product that can provide some transition to Team Build&nbsp;if your team is already using CC.NET.