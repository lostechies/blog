---
id: 1173
title: AutoMapper 4.2.0 released
date: 2016-01-28T16:28:46+00:00
author: Jimmy Bogard
layout: post
guid: https://lostechies.com/jimmybogard/?p=1173
dsq_thread_id:
  - "4531179778"
categories:
  - AutoMapper
---
Yesterday I bit the bullet and pushed out the [4.2.0 release](https://github.com/AutoMapper/AutoMapper/releases/tag/v4.2.0). This was a fairly large internal refactoring, with the entire static API marked as obsolete and a new instance-based API exposed. Some helpful links for the move:

  * [Wiki on migrating from static API](https://github.com/AutoMapper/AutoMapper/wiki/Migrating-from-static-API)
  * [Example app highlighting real-world usage](https://github.com/jbogard/contosouniversity)

Some interesting things in this release that you might have missed:

  * [Dynamic/expando/dictionary mapping](https://github.com/AutoMapper/AutoMapper/wiki/Dynamic-and-ExpandoObject-Mapping)
  * [Expression translatation from expressions and queryables to/from source and destination types](https://github.com/AutoMapper/AutoMapper/wiki/Expression-Translation-(UseAsDataSource))
  * [Conventions](https://github.com/AutoMapper/AutoMapper/wiki/Conventions)

It’s been a long journey with this static API, but its time is near the close. In the 5.0 release, the entire static API will be removed, making me quite happy.

Enjoy!