---
wordpress_id: 251
title: Thinking Linq
date: 2012-06-28T12:50:15+00:00
author: Chris Missal
layout: post
wordpress_guid: http://lostechies.com/chrismissal/?p=251
dsq_thread_id:
  - "743790607"
categories:
  - .NET
  - 'C#'
  - LINQ
tags:
  - .net
  - 'c#'
  - developers
---
I&#8217;ve been comfortable using LINQ for what seems like a long time. I&#8217;m noticing that I&#8217;ve been implementing some of the lesser used functions a bit more as of late, but I&#8217;m not sure exactly when they&#8217;re appropriate. Take the following method that is a prime candidate for leveraging LINQ.

[gist id=3012752 file=GetFirstDirectoryFrom1.cs]

Any time you see that `if` inside a `foreach` in C#, you&#8217;ll probably want to write this differently. A year ago, I probably would have written this:

[gist id=3012752 file=GetFirstDirectoryFrom2.cs]

More recently, my thought process makes me want to write that same code like so:

[gist id=3012752 file=GetFirstDirectoryFrom3.cs]

For some reason, I like the second LINQ implementation better. It just seems to read nicer and reflect the method&#8217;s intent a bit more accurately.

I don&#8217;t have a strong preference either way, so I decided to see how different they actually are in IL:

[gist id=3012796 file=GetFirstDirectoryFrom2]

[gist id=3012796 file=GetFirstDirectoryFrom3]

As far as I&#8217;m concerned, these are exactly the same. I&#8217;m going to go with the second implementation, the one that uses .SkipWhile().