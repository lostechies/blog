---
wordpress_id: 589
title: Visual Studio Command Prompt in Console
date: 2012-02-20T22:57:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/02/20/visual-studio-command-prompt-in-console/
dsq_thread_id:
  - "583458971"
categories:
  - Tools
---
I’m a big fan of [Console](http://sourceforge.net/projects/console/) – it’s a nifty little app that lets you host multiple disparate command prompts in a single tabbed interface. I have a regular command prompt, [a Git bash](https://lostechies.com/jimmybogard/2010/04/05/integrating-the-git-bash-into-console/), a Powershell prompt and a Python prompt. These are pretty easy to create, and one I added today was the Visual Studio Command prompt. For VS 2010, the shell value is:

%comspec% /k &#8220;&#8221;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat&#8221;&#8221; x86

That might not be the same on your system, but it’s easy to find it out. Just find the shortcut for the Visual Studio Command Prompt in your Start menu (or whatever it’s called in Windows 7), and go to “Properties”. Copy the “Target” value:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2012/02/image_thumb4.png" width="390" height="537" />](https://lostechies.com/content/jimmybogard/uploads/2012/02/image4.png)

And set this as the “Shell” value in Console.

This prompt puts all the .NET SDK tools into the PATH, so you can use [these tools](http://msdn.microsoft.com/en-us/library/dd233110.aspx) without caring about where they are. I don’t have to use those tools very often (like Gacutil.exe, hope I never have to use that one again), but it’s nice to not have to drop into a new command prompt window that doesn’t support copy-paste.

Enjoy!