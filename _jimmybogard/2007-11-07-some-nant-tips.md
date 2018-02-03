---
wordpress_id: 95
title: Some NAnt tips
date: 2007-11-07T16:22:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/11/07/some-nant-tips.aspx
dsq_thread_id:
  - "264715409"
categories:
  - Tools
---
[Jason](http://www.lostechies.com/blogs/jason_meridth/default.aspx) got me thinking on some other NAnt tips from his post on [listing the targets in the build file](http://www.lostechies.com/blogs/jason_meridth/archive/2007/11/07/nant-list-all-targets-in-build-file.aspx).

### Include NAnt in your source control

I like to put NAnt in source control and NEVER install it.&nbsp; I&#8217;ve had too many problems upgrading NAnt and having projects break because of whatever reason, and I have even more issues with custom tasks I write.&nbsp; It helps to keep your dev machine clean, your build machine clean, and leads to faster dev machine setup time.&nbsp; Here&#8217;s my current favorite source tree structure:

  * <ProjectName/Version/Branch> 
      * src 
          * Where source code goes
      * lib 
          * any Dlls referenced from projects, including NUnit dll&#8217;s
      * tools 
          * NAnt 
          * NUnit 
          * NCover 
          * any other exe needed for build/development
      * docs 
      * project.sln 
      * project.build 
      * go.bat

This was all inspired by (stolen from) [TreeSurgeon](http://www.codeplex.com/treesurgeon).

### Put your build file in your solution

I like to create a solution folder to hold extra project-related files, like my build scripts.&nbsp; When they&#8217;re in the solution, it makes it easier to load them up and edit them.&nbsp; Since [ReSharper](http://www.jetbrains.com/resharper/)&nbsp;supports many features for NAnt and MSBuild scripts, it makes sense to have them easy to get to.

 ![](http://s3.amazonaws.com/grabbagoftimg/SolutionFolder_Example.PNG)

I already [talked about this earlier](http://grabbagoft.blogspot.com/2007/09/organizing-with-solution-folders.html), but solution folders are a great way to create **logical** organization in your solution that doesn&#8217;t have to correspond to the **physical** organization on disk.

### Create a NAnt bootstrap batch file

I can&#8217;t stand typing in &#8220;nant -buildfile:blahblahblah&#8221;, especially when I execute the NAnt version that&#8217;s in my source tree (not the one installed).&nbsp; I like to create a one-line batch file called &#8220;go.bat&#8221; that bootstraps NAnt and my build file:

<pre>@toolsnantNAnt.exe -buildfile:NBehave.build %*</pre>

The @ symbol tells cmd.exe not to echo the command text out, then I specify the location of NAnt and the build file.&nbsp; The last part, &#8220;%*&#8221;, just tells cmd.exe to&nbsp;append all commands after &#8220;go.bat&#8221; to the &#8220;nant.exe&#8221; program.&nbsp; For example, I can now do this:

<pre>go clean test deploy</pre>

The &#8220;clean test deploy&#8221; commands are targets in my NAnt build script.&nbsp; Any other NAnt command line options can be typed in after &#8220;go&#8221;.&nbsp; I put this batch file at the project root level.

### Use the &#8220;description&#8221; attribute to document public targets

As Jason mentioned, the &#8220;-projecthelp&#8221; NAnt switch will output a list of targets in your NAnt script.&nbsp; By providing a description in your target, you can provide some better information in the help output.&nbsp; Here&#8217;s what NBehave&#8217;s help looks like:

 ![](http://s3.amazonaws.com/grabbagoftimg/nant_help.PNG)

The targets are separated into Main and Sub Targets.&nbsp; Main Targets are targets with descriptions, and Sub Targets are those without.&nbsp; I can still provide internal documentation with XML comments in the build script.&nbsp; By only providing descriptions on targets that I need to call often, I can create some level of encapsulation in my build file.

I&#8217;m sure there are a dozen better tips out there, but these are the ones I make sure to use on every project I&#8217;m involved with.