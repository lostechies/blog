---
wordpress_id: 423
title: 'Mercurial workflows: mainline workflow'
date: 2010-07-28T03:12:59+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/07/27/mercurial-workflows-mainline-workflow.aspx
dsq_thread_id:
  - "264871028"
categories:
  - Mercurial
---
In the last post, we [looked at a workflow](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/07/08/mercurial-workflows-local-development-work.aspx) very common in the Git sphere: utilizing local branches to create segregated workspaces for individual topic branches.&#160; As far as I can tell, this seems to be the preferred day-to-day workflow for Git users, as its first-class local branching support makes it completely seamless to create segregated areas of work.

This workflow is completely possible in Hg, but does take little more set up and one or two extra steps that Git doesn’t force you to make.&#160; The idea behind this workflow is that I can’t predict when unrelated work comes in.&#160; Because local branches and local commits are so cheap, there’s really no reason to throw any code away, ever.&#160; With local topic branches, I can keep mini-spikes around without affecting anyone.

However, there are scenarios where the likelihood of unrelated work is small, so the need for topic branches tends to diminish.&#160; With Hg, the limitations of its model of local branches, bookmarks and rebasing tends to lessen the full benefits of local topic branches.

For those cases where I’m truly confident that I’m working on a continuous main line of work, I’ll use a slightly different workflow than one that uses topic branches.

### The simplified workflow

In the simplified workflow, it is nearly identical to the normal centralized workflows (except most operations are local).&#160; When I want to start work for the day, I’ll:

  * work work work
  * hg commit –Am “Working on some stuff”
  * work work work
  * hg ci –Am “Working on some more stuff”
  * work work work
  * hg ci –Am “Finished my stuff”

At this point, I’ve finished some logical set of work, and I’d like to push my work upstream.&#160; My local repository now looks like:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_3F586F0B.png" width="375" height="148" />](http://lostechies.com/jimmybogard/files/2011/03/image_5FDFAEBD.png) 

Unlike the previous workflow, my “master” bookmark moves along, instead of always pointing at the latest pulled commit.&#160; It’s still important that this bookmark sticks around, as we’ll see soon.&#160; Now that I want to push, I want to first pull down incoming commits.&#160; Let’s suppose that someone else also made some commits on another repository and already pushed.&#160; The server repository shows this:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_654E1F61.png" width="422" height="130" />](http://lostechies.com/jimmybogard/files/2011/03/image_1ED12F59.png) 

Note that we don’t see our bookmarks here, as by default bookmarks don’t get pushed upstream.&#160; When we pull from upstream, we’ll get the commit from the “otherdude” developer.&#160; So, I’ll:

  * hg pull &#8211;rebase

Instead a “pull/merge/update” workflow, which generates noisy merge commits, I’ll rebase my three commits against the upstream changes.&#160; Rebase simply replays my three commits against the incoming tip.&#160; That would mean that I expect to see that the parent of “Working on some stuff” to be the “otherdude” commit instead of the “Finishing work on a feature” commit.&#160; After the pull and rebase, my local repository is now:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_445AACBA.png" width="387" height="156" />](http://lostechies.com/jimmybogard/files/2011/03/image_7DDDBCB1.png) 

This is what we expected, our commits that originally came after the “Finishing work on a feature” commit got moved AFTER the “otherdude” commit.&#160; This produces a nice clean timeline that makes localizing bugs and merging changes a lot easier.&#160; With a regular pull/merge workflow, you’re merging all 3 commits at once.&#160; With a rebase, I merge one commit at a time, making the potential merges much smaller.&#160; Each merge also modifies each commit, instead of one gigantic merge commit with all changes coming in at once.

Anyway, I’ve pull upstream changes, so now I’m ready to push:

  * hg push –b master

I only want to push that mainline branch, “master”, just like my previous workflows.&#160; By pushing only my “master” branch, I can transfer back and forth between my simplified, mainline workflow and topic branch workflow very easily, with neither conflicting with the other.&#160; In Git, only the current branch is ever pushed by default, but in Hg, it’s the opposite, so I have to a bit more explicit.

### 

### Comparing rebase and merge

Just to show what a merge looks like in comparison, let’s say “otherdude” doesn’t rebase before he commits his additional work.&#160; He has some more commits:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_6A505D10.png" width="421" height="132" />](http://lostechies.com/jimmybogard/files/2011/03/image_51C0BFC0.png) 

Now he wants to push these two commits up.&#160; However, the other user already pushed rebased commits, so now the server looks like:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_6258BAAE.png" width="429" height="157" />](http://lostechies.com/jimmybogard/files/2011/03/image_02DFFA61.png) 

Instead of doing a rebase on pull, he does a regular pull and update.&#160; Because other commits have gone in, he’ll need to do a merge:

  * hg pull –u
  * hg merge
  * hg ci –Am “Stupid merge commit”

He tries to pull and update, but since there were commits there, two heads get created and he needs to merge in his changes.&#160; This causes an extra merge AND commit step, and now uglies up the history:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_4F378E02.png" width="360" height="224" />](http://lostechies.com/jimmybogard/files/2011/03/image_56C2FD6F.png) </p> 

So the silly thing about this is the stupid merge commit contains ALL changes from the other two outgoing commits, yet all three commits get pushed!&#160; This also becomes really ugly over time, especially when you have overlapping commits and merges:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_66829273.png" width="474" height="339" />](http://lostechies.com/jimmybogard/files/2011/03/image_60A7EEDA.png) 

I’m not sure human beings are meant to comprehend this picture, so I’ll take the rebased workflow with its clean, linear history any day of the week.&#160; With the simplified workflow, rebasing is actually simpler than the pull/merge/commit workflow.&#160; Rebase is good, whether we work in topic branches or not.