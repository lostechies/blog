---
wordpress_id: 365
title: 'A Timely Post &#8211; Introducing Palmer and TempusReader'
date: 2013-01-30T15:17:10+00:00
author: Chris Missal
layout: post
wordpress_guid: http://lostechies.com/chrismissal/?p=365
dsq_thread_id:
  - "1055762794"
categories:
  - .NET
  - 'C#'
  - Open Source
tags:
  - DateTime
  - open source
  - TimeSpan
---
I may have found the Peanut Butter to my Jelly. Maybe not, but I accidentally stumbled upon a project called [Palmer](https://github.com/MitchDenny/Palmer "Palmer"). This library lets one define an amount of time to do some sort of activity. Maybe a call that fails frequently, so you want to ping it many times before just giving up. I&#8217;m not using it in anything currently, but I&#8217;d like to some day.

I noticed that it uses some TimeSpans and I&#8217;ve been meaning to incorporate my pet project [TempusReader](https://github.com/ChrisMissal/TempusReader "A small .NET library for reading plain English text and converting it to a TimeSpan") into something of use. I combined the two and they worked just great together! I set up a tiny example like this, just to get going with them:

{% gist 4671170 %}

Obviously the example isn&#8217;t real world, but you get the point. The code is actually all **Palmer**, the only part that is **TempusReader** is the _.InTime()_ extension method. Alternatively, I could have used other methods to specify the TimeSpan:

<pre>new Time("1 hr, 5 mins and 8 seconds")
"50 milliseconds".InTime()</pre>

This takes a string and converts it to a _TempusReader.Time_ object, which can be implicitly cast to a _TimeSpan_ for use in the _.For()_ method.

Both these projects are on NuGet (_the current version of Palmer was giving me issues_):

> Install-Package **Palmer** -Version 0.1.4723.40614
> 
> Install-Package **TempusReader**

Visit the GitHub pages for both [Palmer](https://github.com/MitchDenny/Palmer "A simple portable library which allows .NET developers to express retry logic using a fluent-api.") and [TempusReader](https://github.com/ChrisMissal/TempusReader "TempusReader on GitHub") to learn more about how to use them!