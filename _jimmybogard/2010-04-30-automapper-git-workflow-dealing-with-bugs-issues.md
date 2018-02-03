---
wordpress_id: 403
title: AutoMapper Git workflow – dealing with bugs/issues
date: 2010-04-30T12:41:27+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/04/30/automapper-git-workflow-dealing-with-bugs-issues.aspx
dsq_thread_id:
  - "264716479"
categories:
  - AutoMapper
  - git
---
Along with the switch of VCS to git came the ability to have much improved workflows that simply weren’t possible in CVCS like TFS or SVN.&#160; The nice thing about Git over CVCS is that because of its power, I can choose the workflow I want to use depending on my situation.&#160; Most, if not all of this comes from the fact that local branches are cheap, and the commit model of git.

A couple of the things I wanted to shoot for was a clean history and isolating work.&#160; With OSS development, I’m juggling a lot of different threads at once.&#160; Feature requests come in, bugs come in, new work is going on, pull requests come in, patch files/code detritus comes in, and I don’t want work on any one thing to conflict with the other.

And since work on each thing is very asynchronous in nature, I want to match my git workflow to the actual interaction workflow that I use in the real world.&#160; But first, let’s look at how we can visualize our local repository.&#160; That’s a huge step in dealing with different kinds of workflows.

### Visualizing the repository

I prefer git extensions over gitk and git log –graph.&#160; Gitk is a bit of a pain to deal with, and git log attempts to use all the ASCII powers of the interwebs to display a graph of commits.&#160; For example, here’s the current AutoMapper commit graph (locally):

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_07F34054.png" width="644" height="407" />](http://lostechies.com/jimmybogard/files/2011/03/image_68B09980.png) 

Note anything?&#160; A clean, linear history.&#160; I absolutely detest bizarre, convoluted histories, where I see a tangled web of commits.&#160; I have a few different workflows, but all start with a basic rule:

**Always branch before doing ANY work.**

Because branches are so, so cheap in git, branches become THE way to create parallel workflows.

### </p> 

### Bug Workflow

When I get an issue from CodePlex, twitter, the mailing list or anything, I want to create a workflow that allows me to try and reproduce the issue, but without messing up the mainline master branch.&#160; Many times, I’ll have conversations back and forth with other folks over the course of days or weeks, as I try and fix an issue.&#160; In those cases, that branch can potentially stick around for a long time and NEVER come back to the master branch.

So first things first: An issue comes in, so I create a branch:

> git co –b “SomeIssue”

This builds the following picture in my local repo:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_6DB2D72F.png" width="482" height="63" />](http://lostechies.com/jimmybogard/files/2011/03/image_1C0C5CDD.png) 

Remember, a branch is really just a lightweight, named pointer to a commit.&#160; The “git checkout –b” means to create a branch and checkout that branch immediately.&#160; “git checkout” is analogous to the “svn switch” command, except git branches are MUCH simpler than SVN branches.

Next, I make some commit locally to that branch, and usually do something like:

> git add .
> 
> git commit –m “Some commit message”

This now produces the following picture:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_2D108AC0.png" width="481" height="66" />](http://lostechies.com/jimmybogard/files/2011/03/image_0D61B0F8.png) 

At this point, I usually go two routes.&#160; If I can fix the actual issue, then I’ll want to integrate my changes back to the master branch.&#160; If I can’t reproduce it, need more information or whatever, I’ll just leave it alone.&#160; The really cool thing is that **it doesn’t matter.**&#160; At any time, I can checkout master, start a new branch and continue on.&#160; Let’s see what it looks like if there are additional changes that happen on the master branch:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_056A0E96.png" width="452" height="104" />](http://lostechies.com/jimmybogard/files/2011/03/image_7AACB740.png) 

We now see that master is basically ahead of SomeIssue.&#160; I might have other branches hanging around as well.

So let’s suppose I want to integrate the SomeIssue branch back to master.&#160; Now, if there have been upstream changes and changes locally to master, I’ll want to do a “git pull &#8211;rebase”.&#160; This is similar to an “svn update”, and “get latest” in TFS.&#160; However, there aren’t any changes, so what I really want to do is a [rebase](http://progit.org/book/ch3-6.html), from the SomeIssue branch to the master branch:

> git rebase master

This results in the following history now:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_00875ADA.png" width="463" height="103" />](http://lostechies.com/jimmybogard/files/2011/03/image_6C020B5B.png) 

Rebase is different than merge in that it re-applies commits from one branch to another.&#160; What I’ve done here is basically re-play the commits from the SomeIssue branch onto the master branch, so that there is a clean, linear history.

With that done, I’ll do the normal local build.&#160; Finally, I’ll checkout master and rebase or merge, the result is the same (a fast-forward merge):

> git checkout master
> 
> git rebase SomeIssue

And now my history looks like this:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_71DCAEF4.png" width="478" height="83" />](http://lostechies.com/jimmybogard/files/2011/03/image_203634A2.png) 

Now that my branch is “done”, I’ll delete that branch:

> git branch –d SomeIssue

And my history now shows SomeIssue is gone:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_2A1B260D.png" width="487" height="83" />](http://lostechies.com/jimmybogard/files/2011/03/image_71707BFF.png) 

Because a branch is merely a lightweight pointer to a commit, it’s really no big deal to delete a branch, as the creation and deletion of branches does NOT affect the commits in any way.

Now that my branch is integrated into a clean timeline (without any merge commits), I can push master back to origin.

So that’s it, my basic bug workflow is:

  * (from master): git checkout –b “SomeIssue”
  * do work, git add and git commit –am “Some commit message”
  * git checkout master
  * git pull &#8211;rebase
  * git checkout SomeIssue
  * git rebase master
  * git checkout master
  * git rebase SomeIssue <- this is just a fast-forward merge at this point
  * git push origin master
  * git branch –d SomeIssue

This workflow gives me a couple big advantages.&#160; First, I can work on bugs/issues that may never have a resolution, and that’s just fine.&#160; In fact, in the original history shown at the top, you can see a couple of branches that went off and never came back.&#160; They may never in the future either, and that’s okay.

Several times, I’ll be working on one bug, stop, and work on another.&#160; The first bug might have failing tests/compilation, but all that work is on a branch so it doesn’t conflict with other parallel work.

And now that I have two bogus commits in my timeline, I’ll just do a “git reset &#8211;hard HEAD~2” and rewind time like nothing happened 🙂

For more information about how branches and rebase works, check out the free online Pro Git book:

[http://progit.org/book](http://progit.org/book "http://progit.org/book")