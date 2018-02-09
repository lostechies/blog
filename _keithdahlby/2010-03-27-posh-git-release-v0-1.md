---
wordpress_id: 4208
title: posh-git Release v0.1
date: 2010-03-27T21:39:00+00:00
author: Keith Dahlby
layout: post
wordpress_guid: /blogs/dahlbyk/archive/2010/03/27/posh-git-release-v0-1.aspx
dsq_thread_id:
  - "262493347"
categories:
  - git
  - posh-git
  - Powershell
redirect_from: "/blogs/dahlbyk/archive/2010/03/27/posh-git-release-v0-1.aspx/"
---
I&#8217;ve made a bit of progress on [posh-git](http://github.com/dahlbyk/posh-git "posh-git on GitHub") since my [last post](/blogs/dahlbyk/archive/2010/03/15/posh-git-a-powershell-environment-for-git.aspx " posh-git: A PowerShell Environment for Git") and figured now is as good a time as any to tag a [v0.1 release](http://github.com/dahlbyk/posh-git/tree/v0.1 "posh-git v0.1 on GitHub"), which you can [download here](http://github.com/dahlbyk/posh-git/downloads "posh-git Downloads"). In this release&#8230;

### Git Branch in PowerShell Prompt  


Prompt branch information now includes merge/rebase/am status information, modeled after Git Bash.

![](//lostechies.com/keithdahlby/files/2011/03/posh-git-v0.1.png)

### Settings

Prompt colors and text separators have been broken out into a global `$GitPromptSettings` object that can be modified in your profile after GitPrompt.ps1 executes&#8230;

<pre>$GitPromptSettings.WorkingForegroundColor = [ConsoleColor]::Red<br />$GitPromptSettings.UntrackedText = ' WARNING: UNTRACKED FILEZ!!1'</pre>

We also define `$GitTabSettings`, which currently provides an `AllCommands` property which expands completion for `git <tab>` to include all commands instead of only the common terms listed in `git --help`. New settings will almost certainly be added over time.

### Other Improvements  


  * The number of external calls has been reduced.
  * Added `Enable-GitColors`, called in the example profile, to set common environment variables.
  * Working/Index counts now include Unmerged files if appropriate.
  * Tab expansion is now case-insensitive.
  * Tab expansion includes operations within `git stash` and `git remote`.
  * Tab expansion for files with spaces adds quotes like normal file completion.
  * Miscellaneous bug fixes (hat tip to Jean-Francois Cantin and [Mark Embling](http://www.markembling.info/))

### Next Steps

  * Testing! I&#8217;d like to figure out a way to run some integration tests that verify a given repository state renders the expected prompt. If you have suggestions how to approach this, or know how other Git integration projects are tested, please let us know over at the [Google Group](http://groups.google.com/group/posh-git/).
  * Documentation! How to get started, what the project provides, etc.
  * Expanded Tab Completion! Common `config` options, stashes, long command options (`--interactive` and such), the list goes on. The [Bash implementation](http://git.kernel.org/?p=git/git.git;a=blob;f=contrib/completion/git-completion.bash;hb=HEAD "git-completion.bash") needs 2300 lines; we&#8217;re at 128 so far.

Please give the project a try and let us know how we&#8217;re doing!