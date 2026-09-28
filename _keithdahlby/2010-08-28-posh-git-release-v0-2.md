---
wordpress_id: 4214
title: posh-git Release v0.2
date: 2010-08-28T15:27:00+00:00
author: Keith Dahlby
layout: post
wordpress_guid: /blogs/dahlbyk/archive/2010/08/28/posh-git-release-v0-2.aspx
dsq_thread_id:
  - "262493361"
categories:
  - git
  - posh-git
  - Powershell
redirect_from: "/blogs/dahlbyk/archive/2010/08/28/posh-git-release-v0-2.aspx/"
---
I just tagged the [v0.2 release](https://github.com/dahlbyk/posh-git/tree/v0.2 "posh-git v0.2 on GitHub") of [posh-git](https://github.com/dahlbyk/posh-git "posh-git on GitHub"), which you can [download here](https://github.com/dahlbyk/posh-git/downloads "posh-git Downloads"). This is the last release supporing msysgit 1.6.5 and 1.7.0. In this release&#8230;

### PowerShell Module

Thanks to a contribution from [David Muhundro](http://www.mohundro.com/blog/),
   
posh-git now exposes its functions through a module (.psm1). The module
   
exposes a number of functions whose usage can be seen in the example
  
profile.

### Tab Expansion Updates

  * [TortoiseGit](http://code.google.com/p/tortoisegit/) commands: `tgit <tab>`
  * git-svn operations: `git svn <tab>`
  * Stash completion for `git stash` operations: `show, apply, drop, pop, branch`
  * Branch completion for `git reset` and `git rebase`
  * Completion of deleted files for `git rm`
  * For most commands, tab completion should now work if other command flags are in use. For example, `git rebase -i <tab>` works as expected.

Thanks to [Jeremy Skinner](http://www.jeremyskinner.co.uk/) and [Mark Embling](http://www.markembling.info/) for their contributions to this release.

### Next Steps

The most common complaint about posh-git is performance, which has
  
already been addressed for the next release (available in my master
  
branch). However, the fix requires taking a dependency on msysgit 1.7.1,
   
which has not been officially released yet.&nbsp; Still, it has been working
   
fine for me.

Beyond that, we still need to address the first two items on my list from the last release&#8230;

  * Testing! I&#8217;d like to figure out a way to run some integration tests
   
    that verify a given repository state renders the expected prompt. If
  
    you have suggestions how to approach this, or know how other Git
  
    integration projects are tested, please let us know over at the [Google Group](http://groups.google.com/group/posh-git/).
  * Documentation! How to get started, what the project provides, etc.

If you have any other feature requests or find issues, please let us know.