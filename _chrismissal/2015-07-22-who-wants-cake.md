---
wordpress_id: 472
title: Who Wants Cake?!
date: 2015-07-22T15:43:30+00:00
author: Chris Missal
layout: post
wordpress_guid: https://lostechies.com/chrismissal/?p=472
dsq_thread_id:
  - "3960749881"
categories:
  - .NET
  - 'C#'
  - Continuous Integration
  - Deployment
  - Open Source
tags:
  - .net
  - 'c#'
  - roslyn
---
I&#8217;ve been learning and trying out new build systems in .NET recently and decided to give [Cake](http://cakebuild.net/) a sample. (See what I did there?)

## First Impressions

Right away I liked how the scripts look and feel. This is quite important to me and one of the reasons I dislike scripting things in Powershell. Powershell is more difficult for me to read and understand than I would like. I believe it&#8217;s largely due to the common coding styles, but that&#8217;s my problem.

Here&#8217;s a sample script:

    var target = Argument("target", "Default");
    var configuration = Argument("configuration", "Release");
    var buildDir = Directory("./src/Example/bin") + Directory(configuration);
    
    Task("Clean")
      .Does(() => {
        CleanDirectory(buildDir);
    });
    
    Task("Restore-NuGet-Packages")
      .IsDependentOn("Clean")
      .Does(() => {
        NuGetRestore("./src/Example.sln");
    });
    
    Task("Build")
      .IsDependentOn("Restore-NuGet-Packages")
      .Does(() => {
        MSBuild("./src/Example.sln", settings =>
          settings.SetConfiguration(configuration));
    });
    
    Task("Default")
      .IsDependentOn("Build");
    
    RunTarget(target);
    

To me (and possibly because I write C# nearly every day) this is very readable and nice to look at.

## Tools

There are [loads of tools](http://cakebuild.net/dsl) out of the box, but a couple more that I needed. I was able to get [Fixie](http://fixie.github.io) into the [v0.5.0 release](http://cakebuild.net/blog/2015/07/cake-v0-5-0-released), so that was nice. The other is [RoundhousE](http://projectroundhouse.org), which should be coming soon!

## Contributing

Many Kudos to [Patrik](https://github.com/patriksvensson) for maintaining a very clean and intuitive codebase! Everything is well thought out, in the right place, and easy to understand and follow. If you want to fix a bug or add a feature to this project, it won&#8217;t be hard. In fact, it will probably be a pleasure! Additionally, the issues on GitHub are a great place to ask questions, request features, or submit bugs. You&#8217;ll likely get a response from Patrik or somebody else the same day; as a maintainer of other open source projects, I wish I was that good.

All of these reasons make this a very nice project to work on if you&#8217;re looking to get more into open source. There are even some [Up For Grabs](http://up-for-grabs.net) [Cake issues](https://github.com/cake-build/cake/labels/up-for-grabs) you could work on today!