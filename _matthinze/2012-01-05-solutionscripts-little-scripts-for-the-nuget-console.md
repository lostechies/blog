---
id: 4831
title: SolutionScripts – little scripts for the Nuget console
date: 2012-01-05T14:09:06+00:00
author: Matt Hinze
layout: post
guid: http://lostechies.com/matthinze/2012/01/05/solutionscripts-little-scripts-for-the-nuget-console/
dsq_thread_id:
  - "528004252"
categories:
  - Tools
tags:
  - solutionscripts
---
Sharing a Nuget package our team has been using for awhile: [SolutionScripts](http://nuget.org/packages/solutionscripts).  It’s [ridiculously simple](https://bitbucket.org/mhinze/solutionscripts/src/d3651b843e3d/tools/init.ps1), more of an idea than anything else.

It runs the PowerShell scripts we put in a conventional folder.  We can version those scripts with our source code.  The scripts usually expose a global function to the package manager console.

This is from the project’s readme:

When Visual Studio opens a solution, Nuget looks at each installed package for an init.ps1 script in the package&#8217;s tools directory. If that script exists it will be executed. [This is the way that package authors enhance the package manager console experience for consumers of their packages](http://haacked.com/archive/2011/04/19/writing-a-nuget-package-that-adds-a-command-to-the.aspx).

However, sometimes developers want to add functions or custom script that will execute in the package manager console independent of a particular package. In this case, a lone developer can customize the [powershell profile that the package manager console uses](http://docs.nuget.org/docs/start-here/using-the-package-manager-console#Setting_up_a_NuGet_Powershell_Profile).

This doesn&#8217;t scale. When sharing custom scripts and global functions across an entire team for a particular project, it doesn&#8217;t make sense to edit each developer&#8217;s profile. The profile works across multiple solutions. That would also be weird, to edit a user&#8217;s profile automatically. It also doesn&#8217;t make sense to install a custom package just for each global function you wanted to register. You could do that, but you&#8217;d then have a billion highly targeted packages in your solution. Also, we like these scripts to be versioned with our source code.

With SolutionScripts you can place custom scripts in the `SolutionScripts` directory (which by convention sits at the same level as the packages directory). SolutionScripts will run them every time you load up the solution. If you want to refresh the scripts in the `SolutionScripts` directory without reloading the solution, just issue the `Update-SolutionScripts` command in the package manager console.