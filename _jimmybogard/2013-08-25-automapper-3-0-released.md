---
id: 814
title: AutoMapper 3.0 released
date: 2013-08-25T19:40:14+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=814
dsq_thread_id:
  - "1645523421"
categories:
  - AutoMapper
---
AutoMapper had Silverlight 4 support a while back, but it was a huge pain to keep up. In this release, I converted AutoMapper to a Portable Class Library, with supported platforms:

  * .NET 4 and higher
  * Silverlight 4 and higher
  * Windows Phone 7.5 and higher
  * .NET for Windows Store apps (WinRT)

Additionally, the base AutoMapper PCL is fully functioning on its own, so you can even reference AutoMapper from your own PCL projects.

The other big change was the (long overdue) addition of code comments. If I’m being completely honest, it’s a lot more fun coding than documenting code.

Finally LINQ projection is front and center, with support for flatting, projection, lists and collections. Now your mapping can be pushed all the way down to your LINQ provider (and eventually to SQL).

[Release notes on GitHub](https://github.com/AutoMapper/AutoMapper/releases/tag/v3.0.0)

Thanks to all the contributors on this release, and happy mapping!