---
wordpress_id: 983
title: AutoMapper 3.3 released
date: 2014-11-29T16:40:24+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=983
dsq_thread_id:
  - "3274134264"
categories:
  - AutoMapper
---
View the release notes:

[AutoMapper 3.3 Release Notes](https://github.com/AutoMapper/AutoMapper/releases/tag/v3.3.0)

And download it from NuGet. Some highlights in the release include:

  * Open generic support
  * Explicit LINQ expansion
  * Custom constructors for LINQ projection
  * Custom type converter support for LINQ projection
  * Parameterized LINQ queries
  * Configurable member visibility
  * Word/character replacement in member matching

In this release, I added documentation for every new feature (linked in the release notes), and pertinent improvements.

This will likely be the last 3.x release, as for the next release I’ll be focusing on refactoring for custom convention support, plus supporting the new .NET core runtime (and therefore support on Mac/Linux in addition to the 6 existing runtimes I support).

Happy mapping!