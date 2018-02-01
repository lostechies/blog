---
id: 4221
title: posh-git Release v0.3
date: 2011-04-06T23:54:37+00:00
author: Keith Dahlby
layout: post
guid: http://lostechies.com/keithdahlby/?p=52
dsq_thread_id:
  - "273702903"
categories:
  - git
  - posh-git
  - Powershell
---
On a whim, I&#8217;ve decided to tag a [v0.3 release](https://github.com/dahlbyk/posh-git/tree/v0.3 "posh-git v0.3 on GitHub") of [posh-git](https://github.com/dahlbyk/posh-git "posh-git on GitHub") (which has been stable for a few months now). In this release&#8230;

### Installer

Previously the setup process for posh-git was undefined. Daniel Hoelbling was kind enough to put together a [getting-started post](http://www.tigraine.at/2010/09/01/using-git-from-powershell-just-got-easier-posh-git/ "Using git from  Powershell just got easier: Posh-git"), but I decided to make it even easier. Assuming Git and PowerShell are configured correctly (see [readme](https://github.com/dahlbyk/posh-git#readme "posh-git Readme") for details), getting started is trivial:

<pre>cd C:\Wherever
git clone https://github.com/dahlbyk/posh-git.git
.\posh-git\install.ps1</pre>

At this point the sample posh-git profile will be loaded as part of your PowerShell profile. If you don&#8217;t like the sample profile, feel free to grab the pieces you want and discard the rest (so you can use [posh-hg](https://github.com/JeremySkinner/posh-hg) too, perhaps).

**** If you already have posh-git installed, just `cd` into your posh-git directory and pull from my `master` branch:

<pre># If you don't already have me as a remote...
git remote add dahlbyk
git pull --rebase dahlbyk master
</pre>

You don&#8217;t need to run `install.ps1` again; just open a new PowerShell session and you&#8217;re good to go.

### Performance

By taking a dependency on msysgit 1.7.1, all status information is now retrieved in a single call (`git status -s -b`). This still means `git status` is called for every prompt, so if `status` is slow for your repository your prompt will be slow too.

If it&#8217;s still too slow for your taste, you also have the option to set `$GitPromptSettings.EnableFileStatus = $false`. This will preserve branch information for the prompt, but skip everything else (counts and tab completion for added/modified/deleted files).

Finally, you can set `$GitPromptSettings.Debug = $true` to see how long the various steps take behind the scenes. If your environment is anything like mine, the majority of the time will be spent in `git` calls.

### Tab Expansion Updates

  * Fix for `git rm` during deleted/updated merge conflict
  * Branch expansion for `cherry-pick`, `diff`, `difftool`, `log` and `show`
  * Normal expansion through simple aliases (e.g. `alias.dt =  difftool` supports `git dt <tab>`)

### Next Steps

  * I&#8217;d still like to get some testing in place so I don&#8217;t break things unintentionally
  * I&#8217;m considering moving away from regex to parse commands for tab expansion — anyone feel like writing a git command parser in PowerShell?
  * I&#8217;d like it to be easier to use posh-git and posh-hg together, so I may revisit how they hook into tab expansion

As always, your feedback is appreciated. If you&#8217;d like posh-git updates between release posts, you can also [follow me on Twitter](http://twitter.com/dahlbyk "@dahlbyk").