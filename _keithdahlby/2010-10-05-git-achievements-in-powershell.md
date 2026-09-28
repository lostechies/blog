---
wordpress_id: 4216
title: Git-Achievements in PowerShell
date: 2010-10-05T14:00:00+00:00
author: Keith Dahlby
layout: post
wordpress_guid: /blogs/dahlbyk/archive/2010/10/05/git-achievements-in-powershell.aspx
dsq_thread_id:
  - "262793958"
categories:
  - git
  - git-achievements
  - Powershell
redirect_from: "/blogs/dahlbyk/archive/2010/10/05/git-achievements-in-powershell.aspx/"
---
Reading through Jason&#8217;s post on [using Git-Achievements with msysGit](../../blogs/jason_meridth/archive/2010/09/24/git-achievements-on-windows.aspx "Git-Achievements on Windows"), I couldn&#8217;t help but get it working with PowerShell. The result is a single PowerShell script added to [my Git-Achievements repository](https://github.com/dahlbyk/git-achievements "dahlbyk's git-achievements"), tagged [here](https://github.com/dahlbyk/git-achievements/tree/powershell "powershell on dahlbyk's git-achievements") on the off chance I decided to upload my achievements.

To install posh-git-achievements&#8230;

  1. Fork [my repository](https://github.com/dahlbyk/git-achievements "git-achievements on dahlbyk") on GitHub (or if you have an existing repository, add me as a remote and pull)
  2. Clone your fork of the repository (into C:Gitgit-achievements, for this example)
  3. Open your [PowerShell profile](http://technet.microsoft.com/en-us/library/ee692764.aspx) and add the following:
  
    `Set-Alias git C:Gitgit-achievementsgit-achievements.ps1`
  4. &#8220;dot source&#8221; your profile to reload it in your current session (or just start a new session):
  
    `. $PROFILE`
  5. Check the install:
  
    `git achievements --help`

If all goes according to plan, this should unlock your first achievement.

Note that this will pass every `git` call through a few
  
extra layers, including calls made for the posh-git prompt. But if you
  
can tolerate the performance hit, it&#8217;s a rather fun way to expand your
  
working knowledge of Git. Enjoy!