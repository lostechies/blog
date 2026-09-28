---
wordpress_id: 110
title: Modularity via Bottles
date: 2011-09-05T22:52:31+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=110
dsq_thread_id:
  - "405681227"
categories:
  - general
tags:
  - bottles
  - fubu
---
> [](http://guides.fubumvc.com/images/getting_started/Diagnostics.png)&#8220;My biggest pain point is my curiosity about the Bottles project. When you guys mention it, I feel like there&#8217;s some secret game for grown ups, and I&#8217;m not allowed.&#8221;  &#8211; <a rel="nofollow" href="http://sm-art.biz/" target="_blank">Artëm Smirnov</a>

### Overview

This is a very common sentiment. Today my goal is to help set the record straight and begin the daunting task of introducing something that I think is going to revolutionize the .NET ecosystem: Bottles.

Rather than speaking at a 50,000 foot level, I&#8217;m going to dive right into how FubuMVC uses the framework and we can abstract from there.

> Note:
  
> Since I will be using FubuMVC as a basis for this explanation, I strongly suggest you spend some time understanding FubuMVC before reading about these advanced topics. Visit our portal to <a href="http://mvc.fubu-project.org" target="_blank">get started</a>.

### Case Study: FubuMVC &#8211; Advanced Diagnostics

When building a FubuMVC application, you may be familiar with the baseline diagnostics that we ship. These are available when you include them in your FubuRegistry (IncludeDiagnostics(true)):

![FubuMVC Diagnostics](http://guides.fubumvc.com/images/getting_started/Diagnostics.png "FubuMVC Diagnostics")

> Notice the route for diagnostics: ~/_fubu

Now let&#8217;s go ahead and install the FubuMVC.Diagnostics package. If we go to the same route, we&#8217;ll see something that looks more like this:

[<img class="alignnone size-full wp-image-115" title="adv-diag-dashboard" src="/content/josharnold/uploads/2011/09/adv-diag-dashboard.png" alt="" srcset="/content/josharnold/uploads/2011/09/adv-diag-dashboard.png 787w, /content/josharnold/uploads/2011/09/adv-diag-dashboard-300x171.png 300w, /content/josharnold/uploads/2011/09/adv-diag-dashboard-768x437.png 768w" sizes="(max-width: 767px) 89vw, (max-width: 1000px) 54vw, (max-width: 1071px) 543px, 580px" />](/content/josharnold/uploads/2011/09/adv-diag-dashboard.png)

The advanced diagnostics package adds more functionality, more styles, and a little more class to the baseline diagnostics. It replaces the existing functionality and can be used with any FubuMVC application.

> **What just happened?**
  
> Let&#8217;s talk a little bit about how the Advanced Diagnostics package is built and then we&#8217;ll discuss the magic that happens when you &#8220;install&#8221; it. Of course, we&#8217;ll also discuss what it means to &#8220;install a package&#8221;.

### Building the Package

One very important thing to note about the Advanced Diagnostics package is this: it&#8217;s built almost exactly like a typical FubuMVC Application. That means it has its own conventions, handlers, views, etc. The package can be heavily tested like any other FubuMVC application and you can expect the same great experience all the way through.

There are only two small differences to note when constructing a package:

  1. Making use of FubuPackageRegistry instead of FubuRegistry
  2. The [.package-manifest](https://github.com/DarthFubuMVC/fubumvc/blob/master/src/FubuMVC.Diagnostics/.package-manifest) file

The package manifest file tells FubuMVC what it&#8217;s dealing with (e.g., name, assemblies to take with you, views, etc.). We&#8217;ll discuss FubuPackageRegistry when we discuss package installation.

### Creating a Package

The creation of a package is quite simple. It can be a manual or automated process &#8211; either way, we&#8217;ll make use of the tooling that Bottles provides: BottleRunner.exe.

A command for creating the advanced diagnostics package might look like this:

> BottleRunner.exe create-pak src/FubuMVC.Diagnostics fubumvc-diagnostics.zip -target DEBUG

This will simply create a zip file for us in a format that Bottles can understand (the contents are derived by the spec provided in your package manifest file).

### Installing the Package

Like the creation of packages, the installation of packages is also very simple. It can be a manual process or an automated one (via the Bottles.Deployment goodies). To keep things simple, I&#8217;ll use the manual process to avoid the forced introduction of yet another tool.

The FubuMVC infrastructure for Bottles knows of a special directory within the root directory of your application called &#8220;fubu-content&#8221;. So we take the zip file that was created for us by BottleRunner.exe, and we copy/paste it into our fubu-content directory. Now we start up our application and voila, magic happens.

### Wrap Up

This post is already longer than I wanted it to be so I&#8217;m going to leave you on a bit of a cliffhanger: &#8220;how does the magic happen? What other things can I do with this?&#8221; Those are questions that you should be asking and ones that I will address in a future post.

&nbsp;