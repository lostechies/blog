---
wordpress_id: 40
title: 'Windows Git Tip: Hide ^M (Carriage Return) in Diff'
date: 2011-04-06T05:20:33+00:00
author: Keith Dahlby
layout: post
wordpress_guid: http://lostechies.com/keithdahlby/?p=40
dsq_thread_id:
  - "272269800"
categories:
  - git
  - msysgit
---
A common point of confusion when getting started with Git on Windows is line endings, with Windows still using CR+LF while every other modern OS uses LF only. Git provides three ways to deal with this discrepancy, as described in the msysGit installer:

  1. Checkout Windows-style, commit Unix-style (core.autocrlf = true)
  2. Checkout as-is, commit Unix-style (core.autocrlf = input)
  3. Checkout as-is, commit as-is (core.autocrlf = false)

The first option is the default, which I find rather unfortunate—I don&#8217;t consider line ending manipulation to be the responsibility of my VCS. Instead, I prefer to keep `core.autocrlf` set to `false` and let my text editors deal with line endings. (If you like having `core.autocrlf` set to `true` or `input`, I&#8217;d love to hear why.)

One downside of turning off `autocrlf` is that the output of `git diff` highlights CR characters (indicated by `^M`) as whitespace errors. To turn off this &#8220;error&#8221;, you can use the `core.whitespace` setting:

<pre>git config --global core.whitespace cr-at-eol
</pre>

If your `core.whitespace` is already set, you should add `cr-at-eol` to the end of the comma-delimited list instead.