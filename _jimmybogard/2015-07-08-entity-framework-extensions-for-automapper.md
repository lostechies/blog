---
wordpress_id: 1147
title: Entity Framework extensions for AutoMapper
date: 2015-07-08T14:12:31+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1147
dsq_thread_id:
  - "3915601873"
categories:
  - AutoMapper
  - EntityFramework
---
I pushed out a little library I&#8217;ve been using for the last couple years for helping to use AutoMapper and Entity Framework together. It&#8217;s a series of extension methods that cuts down the number of calls going from a DbSet to DTOs. Instead of this:

{% gist 9ba315371fc5a935b628 %}

You do this:

{% gist 7711be3a3f26cddb7627 %}

The extension methods themselves are not that exciting, it&#8217;s just code I&#8217;ve been copying from project to project:

{% gist c796a9b365bb97324467 %}

I have helper methods for:

  * ToList
  * ToArray
  * ToSingle
  * ToSingleOrDefault
  * ToFirst
  * ToFirstOrDefault

As well as all their async versions. You can find it on GitHub:

<https://github.com/AutoMapper/AutoMapper.EF6>

And on NuGet:

<https://www.nuget.org/packages/automapper.ef6>

Enjoy!