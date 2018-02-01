---
id: 895
title: AutoMapper 3.2.0 released
date: 2014-04-15T13:28:00+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=895
dsq_thread_id:
  - "2613470693"
categories:
  - AutoMapper
---
[Full release notes on the GitHub site](https://github.com/AutoMapper/AutoMapper/releases/tag/v3.2.0) 

Big features/improvements: 

  * LINQ queryable extensions greatly improved
  * ICollection supported
  * MaxDepth supported
  * Custom MapFrom expressions supported (including aggregations)
  * Inherited mapping configuration applied
  * Windows Universal Apps supported

  * Fixed NuGet package to not have DLL in project
  * iOS confirmed to work
  * ReverseMap ignores both directions (only one Ignore() or IgnoreMap attribute needed)
  * Pre conditions on member mappings (called before resolving anything)
  * Exposing ResolutionContext everywhere, including current mapping engine instance

A lot of small improvements, too. I&#8217;ve ensured that every new extension to the public API includes code documentation. The toughest part of this release was coming up with a good solution to the multi-platform support and MSBuild’s refusal to copy indirect references to all projects. 

As always, if you find any issues with this release, please [report over on GitHub](https://github.com/automapper/automapper/issues). 

Enjoy!