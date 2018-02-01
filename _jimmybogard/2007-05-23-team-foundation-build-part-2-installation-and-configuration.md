---
id: 22
title: 'Team Foundation Build, Part 2: Installation and Configuration'
date: 2007-05-23T15:15:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/05/23/team-foundation-build-part-2-installation-and-configuration.aspx
dsq_thread_id:
  - "279205361"
categories:
  - TeamBuild
  - VSTS
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/05/img-border-0-so-now-that-we-have-some.html)._

So now that we have some understanding of what the components of Team Build are from [Part 1](http://www.lostechies.com/blogs/jimmy_bogard/archive/2007/05/22/team-foundation-build-part-1.aspx), where should these components be installed? Luckily, there&#8217;s some [pretty good documentation](http://msdn2.microsoft.com/en-us/library/ms181710%28VS.80%29.aspx) on Team Foundation Server components and topologies on MSDN.

[<img style="cursor: pointer" src="http://bp0.blogger.com/_poAbnIVuAzE/RngCLyuzsbI/AAAAAAAAAA0/4SxO0APIyo0/s400/Team+Build.JPG" alt="" border="0" />](http://bp0.blogger.com/_poAbnIVuAzE/RngCLyuzsbI/AAAAAAAAAA0/4SxO0APIyo0/s1600-h/Team+Build.JPG)

Lots of arrows and boxes, but the main point of this diagram is that Team Build is installed on a separate box from the Application Tier (Team Foundation Server or TFS Proxy) and from any client machines. A build machine should only have software installed to support the execution of a build. You shouldn&#8217;t install:

  * Third-party control packages 
  * Database client tools (Toad, SQL Server Client Tools, etc.) 
  * Anything that would push assemblies into the GAC

Ideally, all you would have installed would be:

  * Team Build 
  * Team Edition for Developers (for static analysis) 
  * Team Edition for Testers (for running tests during a build)

Anything else installed could potentially cause build errors because the build might use incorrect versions of third party libraries when compiling. That&#8217;s why it&#8217;s always best to check in all third-party libraries into source control, instead of relying on installers to get them to work. For a detailed installation guide, check out the [Team Foundation Installation Guide](http://www.microsoft.com/downloads/details.aspx?familyid=e54bf6ff-026b-43a4-ade4-a690388f310e&displaylang=en).

Another piece to note on the diagram above is the upper-right hand corner, noted as the &#8220;Build Drop site&#8221;. This could be a file server or a share on the buildserver, where the compiled assemblies, log files, etc. are dropped. In the next post, I&#8217;ll discuss creating a Team Build definition and an introduction into extending the build.