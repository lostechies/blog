---
wordpress_id: 1227
title: AutoMapper 5.1 released
date: 2016-08-17T20:28:29+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1227
dsq_thread_id:
  - "5073747939"
categories:
  - AutoMapper
---
Release notes here: [AutoMapper 5.1](https://github.com/AutoMapper/AutoMapper/releases/tag/v5.1.0)

Some big things from this release:

  * Supporting portable class libraries (again), profile 111. Because converting projects from PCL to netstandard is hard
  * More performance improvements (mainly in complex mappings), 70% faster in our benchmarks
  * [Easy initialization via assembly scanning](https://github.com/AutoMapper/AutoMapper/wiki/Configuration#assembly-scanning-for-auto-configuration)

As part of the release, we closed 57 issues. With the new underlying mapping engine, there were a few bugs to work out, which this release worked to close.

Enjoy!