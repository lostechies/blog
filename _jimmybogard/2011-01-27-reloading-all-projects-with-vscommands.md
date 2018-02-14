---
wordpress_id: 450
title: Reloading all projects with VSCommands
date: 2011-01-27T13:38:28+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2011/01/27/reloading-all-projects-with-vscommands.aspx
dsq_thread_id:
  - "264744455"
categories:
  - Tools
redirect_from: "/blogs/jimmy_bogard/archive/2011/01/27/reloading-all-projects-with-vscommands.aspx/"
---
Quite often I’ll find myself working in situations where multiple projects have changed, and Visual Studio asks to reload them, one at a time.&#160; This happens when I’m working a lot with source control, and doing things like switching branches, performing merges, or just integrating upstream changes.&#160; I have to click “Reload” a million times for each project that changed on disk, and it’s quite annoying.&#160; On top of that, VS forgets which files I have open, so every file that I was working on gets closed.

I may be the last VS user to find out about this, but a free lite version of the [VSCommands](http://vscommands.com/) plugin is [available on the Visual Studio Gallery](http://visualstudiogallery.msdn.microsoft.com/d491911d-97f3-4cf6-87b0-6a2882120acf/) that does just what I need – reload all changed projects at once, preserving which files I had open:

[<img style="border-bottom: 0px;border-left: 0px;padding-left: 0px;padding-right: 0px;border-top: 0px;border-right: 0px;padding-top: 0px" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_74A868D7.png" width="613" height="452" />](http://lostechies.com/content/jimmybogard/uploads/2011/03/image_7CA00B39.png)

Now that, friends, is money.&#160; Thanks to the Dovetail folks for mentioning this one.