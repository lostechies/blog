---
wordpress_id: 1161
title: AutoMapper 4.1.0 Released
date: 2015-10-22T03:10:28+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1161
dsq_thread_id:
  - "4247521984"
categories:
  - AutoMapper
---
Release notes here:

<https://github.com/AutoMapper/AutoMapper/releases/tag/v4.1.0>

Supports the following frameworks:

  * .NET 4.0
  * .NET 4.5
  * dotnet (all dnxcore/UWP targets)
  * MonoTouch
  * MonoTouch10
  * PCL profile 259
  * MonoDroid
  * WinRT/Windows Phone 8.1
  * Windows Phone 8.0
  * Silverlight 5

This was a bit of an internal refactoring release. With the previous 4.0 release, I did some work to simplify type map resolution. Unfortunately, this left out a few corner cases. With the new 4.1 drop, if you&#8217;re using any sort of inheritance, you need to use Mapper.Initialize.

I want to simplify this further in the 5.0 timeframe, but this is a start. The LINQ projections had some work as well, to support constructors and some groundwork to support OData.

Finally, we added Dictionary/dynamic/ExpandoObject support for some simple, straightforward cases. This will be expanded in the future to support things similar to what the MVC model binder supports.

Enjoy!