---
wordpress_id: 182
title: Debugger Trick when Working with UTC DateTimes
date: 2012-06-12T00:54:18+00:00
author: Chris Missal
layout: post
wordpress_guid: http://lostechies.com/chrismissal/?p=182
dsq_thread_id:
  - "722327543"
categories:
  - .NET
  - 'C#'
tags:
  - .net
  - DateTime
  - Debugging
---
A couple days ago, this idea popped into my head when I was listening to a presentation at [Austin Code Camp](http://austincodecamp2012.com). I finally got around to giving it a try and it works like I hoped!

If I have a DateTime property that is set to UTC, I&#8217;m not great at doing the calculation in my head as quickly as I&#8217;d like. I was hoping I could leverage the DebuggerDisplayAttribute to show me both the Local time and the Universal time. It was actually really easy to hook up.

{% gist 2915408 %}

[<img class="alignnone size-full wp-image-184" title="Screen shot of modified debug text" src="http://clayvessel.org/clayvessel/wp-content/uploads/2012/06/local-time-debugger.png" alt="" width="474" height="99" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2012/06/local-time-debugger.png 474w, http://clayvessel.org/clayvessel/wp-content/uploads/2012/06/local-time-debugger-300x63.png 300w" sizes="(max-width: 474px) 100vw, 474px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/06/local-time-debugger.png)

Oh how I enjoy how helpful System.Diagnostics can be.