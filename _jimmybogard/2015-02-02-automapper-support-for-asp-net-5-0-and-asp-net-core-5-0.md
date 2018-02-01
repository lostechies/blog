---
id: 1041
title: AutoMapper support for ASP.NET 5.0 and ASP.NET Core 5.0
date: 2015-02-02T20:45:42+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=1041
dsq_thread_id:
  - "3479307841"
categories:
  - ASPdotNET
  - AutoMapper
---
In the vein of “supporting all the frameworks”, I’ve extended AutoMapper to support ASP.NET 5.0 and CoreCLR (aspnetcore50). For those that are counting, I’m up to 11-12 different platforms supported, depending on how you tally:

  * aspnet50
  * aspnetcore50
  * MonoAndroid
  * MonoTouch
  * net40
  * portable-windows8+net40+wp8+sl5+MonoAndroid+MonoTouch
  * portable-windows8+net40+wp8+wpa81+sl5+MonoAndroid+MonoTouch
  * sl5
  * windows81
  * wp8
  * wpa81
  * Xamarin.iOS10

This one was a bit difficult to push out, I wound up creating two separate solutions, compiling both separately, and then creating a single NuGet package from the output of both. The aspnet50/aspnetcore50 versions are only a single assembly and use compiler directives for different platforms, while the other packages use platform-specific assemblies for extensions.

I did try to create one multi-target project using the new vNext project structure, but I failed miserably in converting the existing projects over. My goal for the 4.0 release is to have each platform being a single assembly, with no more platform-specific extensions, but it will take a bit more work to get there.

This support is included in packages “4.0.0-ci1026” and later. Enjoy!