---
id: 3391
title: Newline at end of file
date: 2012-03-23T23:32:20+00:00
author: Chris Missal
layout: post
guid: http://lostechies.com/chrismissal/?p=107
dsq_thread_id:
  - "622477130"
categories:
  - Rant
tags:
  - newlines
---
This is just me asking a question in public and doing as little research on the subject as possible, but why wouldn&#8217;t you want a newline character at the end of a file?

There are several reasons why I can see they are more beneficial to have than not, I&#8217;ll list those out now:

  * Diffs display better on files that end in newlines
  * When I press &#8220;Ctrl + End&#8221; or &#8220;Cmd + Down&#8221; I don&#8217;t expect the file to scroll right (if the line is long enough)

So maybe bullet points weren&#8217;t necessary there because I only had two points, but it&#8217;s always been a pet-peeve of mine and I&#8217;m curious if there&#8217;s ever a good reason not to have one at the end.

_Sure, the newline can go away in minified files, but I shouldn&#8217;t really care about diffs and actually editing them in an editor, so that doesn&#8217;t really count. I would consider that a deployment version, not a development version. I&#8217;m just referring to files that are shared in source control._