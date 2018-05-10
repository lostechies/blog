---
wordpress_id: 3977
title: How to use a tool installed by Nuget in your build scripts
date: 2011-06-24T12:52:50+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: http://lostechies.com/joshuaflanagan/2011/06/24/how-to-use-a-tool-installed-by-nuget-in-your-build-scripts/
dsq_thread_id:
  - "341371739"
categories:
  - Uncategorized
---
My [last post](https://lostechies.com/joshuaflanagan/2011/06/23/tips-for-building-nuget-packages/) covered tips for people creating Nuget packages. This one is important for people consuming Nuget packages. 

Some Nuget packages include executables in their tools folder. It is very easy to use these tools within Visual Studio because Nuget makes them available in the path of the Package Manager Console. However, they are very difficult to use outside of Visual Studio, especially in a build script. The problem is the name of the folder containing the installed package includes the version number of the package. If you install NUnit 2.5.1, the nunit-console.exe will be in packages\NUnit.2.5.1\tools. However, if you later upgrade to NUnit.2.5.2, the path to nunit-console.exe will change to packages\NUnit.2.5.2\tools. You will need to change your build scripts every time you upgrade your version of NUnit. That is unacceptable.

The solution is to create a helper that can figure out where the tool lives. If you are using rake for build automation, it is fairly straightforward:

{% gist 1044159 file=nuget_tool.rb %}

If not, you may want to create a batch file in the root of your project that calls your tool. You can create a tool specific batch file:

{% gist 1044159 file=nunit.bat %}

Or, if you have lots of tools from different packages, you might just want a generic batch file that allows you to specify the executable name:

{% gist 1044159 file=nuget_tool.bat %}