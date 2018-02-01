---
id: 280
title: Build Documentation from your Tests
date: 2012-08-31T09:37:28+00:00
author: Chris Missal
layout: post
guid: http://lostechies.com/chrismissal/?p=280
dsq_thread_id:
  - "825642791"
categories:
  - .NET
  - Open Source
tags:
  - documentation
  - testing
---
A couple months ago I decided to toy around with some code ideas in my head. I had two goals:

  1. To be able to parse some plain English and make DateTime and Timespans objects.
  2. To try out [Parsley](https://github.com/plioi/parsley) (because I have a not-so-secret urge to write a language)

After a quick spike a while back I had something I named [TempusReader](https://github.com/ChrisMissal/TempusReader), working code which I posted on Github. I don&#8217;t think something like Parsley was absolutely necessary for me to do what I wanted, but most importantly, I was able to acheive both of my goals.

While working on this code, I wanted to provide documentation on how to use it. In my experience, looking at tests is one good way to understand how something works. The odds of somebody looking in a test file are slim, but looking at the readme file are almost necessary when visiting a page on github.

I could just output some text to [my readme](https://github.com/ChrisMissal/TempusReader/blob/master/README.md) files directly from my tests, right? This was actually a fun little task and potentially quite helpful. I&#8217;d like to explore this area more in the future, maybe a simple file to pull from Nuget, configure, then be off to the races. It&#8217;s pretty raw as it sits, but I thought I&#8217;d share the idea.

Here is the file that&#8217;s doing the work:

<https://github.com/ChrisMissal/TempusReader/blob/master/src/Tests/DocumentationBuilder.cs>

&nbsp;