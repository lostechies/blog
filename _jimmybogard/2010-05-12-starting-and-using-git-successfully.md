---
wordpress_id: 408
title: Starting and using Git successfully
date: 2010-05-12T15:04:18+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/05/12/starting-and-using-git-successfully.aspx
dsq_thread_id:
  - "264716505"
categories:
  - git
---
It took quite a while (around 2 months) for me to finally become comfortable with Git.&#160; Why so long?&#160; One of the benefits of Git is that it’s very powerful.&#160; It’s also one of the drawbacks.&#160; It was a bit of a journey to unlearn all the knowledge and habits I’ve picked up with SVN and TFS over the years.&#160; Along the way, I picked up a few pointers around using Git that have made using Git a much better experience, that I wish I had when I first started with Git.

### Learn Git

Sounds silly, but distributed version control systems are much better used when you actually learn how to use them properly.&#160; DVCS is NOT SVN, TFS, VSS or any of the other centralized VCS.&#160; The workflow is different, the concepts are different, the tools are different.&#160; If you use a DVCS like you use SVN or TFS, you’ll likely either be frustrated or merely enjoy better merging.

Some great resources for git include:

  * The [Pro Git book](http://progit.org/book/) (online or print)
  * [Git Ready](http://www.gitready.com/)
  * [TekPub Mastering Git series](http://tekpub.com/production/git)
  * [Git for Windows Developers](http://www.lostechies.com/blogs/jason_meridth/archive/2009/06/01/git-for-windows-developers-git-series-part-1.aspx) <- Start here for installing Git on Windows
  * [GitHub help](http://tekpub.com/production/git)
  * git help <command> (from Git bash)

### Join GitHub

GitHub provides such a fantastic user experience, it’s the reason why many folks choose Git.&#160; In fact, it’s pretty hard to introduce anyone to Git without talking about GitHub.&#160; So head over there:

<http://github.com/>

And create an account.&#160; GitHub is all about collaboration, so their entire experience is centered around **you**, instead of projects.&#160; You can create a free account, fork an existing project, clone, and start fooling around with other folks’ projects, but on your own sandbox so you don’t have to worry about messing anything up.&#160; Lots of great OSS tools are already on GitHub, including:

  * AutoMapper
  * StructureMap
  * FubuMVC
  * MvcTurbine
  * Fluent NHibernate
  * SubSonic

And many more, just check out the [github page on the C# projects](http://github.com/languages/C%23).

### Visualize the repository

The biggest hurdle for me personally learning Git was the difference between Git and SVN.&#160; Things like branches, HEAD and so on are much easier just to visualize.&#160; I Iike to use Git Extensions personally to view history, but Git comes with a tool (gitk) that can visualize as well.

Whenever I use a DVCS, Git or Hg, I keep a repository viewer up at ALL times, because I want to know exactly where I am, where I’ve been and where I want to go.&#160; Here’s the StructureMap timeline:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_04E5F2AE.png" width="642" height="484" />](http://lostechies.com/jimmybogard/files/2011/03/image_675417AE.png) 

This timeline’s not that interesting looking, mostly because I don’t have any local branches AND the StructureMap folks know how to keep a clean timeline.&#160; More on that in a second.

I like Git Extensions as it shows not only history in my timeline, but the entire repository, including branches not merged back, commits in the future (if I’ve moved HEAD backwards), and just looks a little cleaner than gitk.

### Don’t start with TortoiseGit

TortoiseGit is a fantastic tool for Git beginners for completely warping and destroying their Git experience.&#160; For those coming over from SVN (as I was), it tends to be TOO familiar, and lends itself to reinforcing the SVN workflow.

I don’t like TortoiseGit because it tends to batch together several Git commands without being very explicit about this.&#160; It emulates common SVN commands, which don’t really have an analog in Git, and generally winds up screwing things up and making things hard when they really shouldn’t be.

Instead, stick with the command-line interface to learn the right commands.&#160; Once you’ve mastered your workflow with Git commands directly, only then should you put a UI on top that hides what’s going on underneath.

### Always work in a local branch

The only time I commit to the mainline branch is for a merge or rebase.&#160; Everything else, I work in a local branch.

Why?

For one, if you’re not the only one pushing changes, it’s a LOT easier to deal with merges in a branch than have things immediately run into merge conflicts locally from a pull.&#160; If you work in a local branch, pulling changes down doesn’t affect your existing work.&#160; Instead, YOU decide when to merge changes.

When I worked with branches in SVN, I actually didn’t need to change how I worked.&#160; I already merged trunk to branch, then branch back to trunk.&#160; I work with Git the same way, except that my branch is local, and I prefer rebase.

### Prefer rebase over merge

Once you understand commits, branches and HEAD, understanding what a rebase is becomes much easier.&#160; Instead of merging changes, which batches up a whole bunch of commits into one big diff, a rebase replays commits onto another branch.&#160; This preserves a timeline, and is also why you see a clean history in the screen above.

I won’t go in to ALL the reasons why rebase is better, you can find this post on [the case for rebase](http://darwinweb.net/articles/86).&#160; What I like is:

  * A clean history
  * The ability to revert individual commits

If everything gets batched up in a single merge commit, it’s really hard to wind back a single commit from a merge, which I have needed to do from time to time.

### Don’t be afraid to reach out

Unlike some other technical communities, I’ve never felt ridiculed or insulted because I didn’t know how to do something in Git.&#160; Git folks tend to be both passionate and knowledgeable, and want to share that passion as opposed to proving how smart they are.&#160; Ask a question on twitter about Git, you’re sure to get several replies back.

Git is definitely a leap from SVN, but its power and flexibility are well worth the learning curve.&#160; With Git, you’re dealing less with a version control system than a system for YOU to decide on how to do version control.&#160; For me, I enjoy being able to make those choices.