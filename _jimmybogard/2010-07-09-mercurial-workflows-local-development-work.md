---
wordpress_id: 421
title: 'Mercurial workflows: local development work'
date: 2010-07-09T03:18:18+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/07/08/mercurial-workflows-local-development-work.aspx
dsq_thread_id:
  - "264716536"
categories:
  - Mercurial
redirect_from: "/blogs/jimmy_bogard/archive/2010/07/08/mercurial-workflows-local-development-work.aspx/"
---
The nice thing about distributed version control systems (DVCS) such as [Git](http://git-scm.com/) and [Hg](http://mercurial.selenic.com/) is that they both allow me to basically decide how my source control should fit with my short and long-term development workflows.&#160; A while back, I wrote what was basically a [stream of consciousness post](https://lostechies.com/blogs/jimmy_bogard/archive/2010/06/02/translating-my-git-workflow-with-local-branches-to-mercurial.aspx) on getting my Git workflow working in Hg.&#160; Well, a teammate tried to follow those steps…and found that I missed a few important nuggets.

My local workflow revolves around local branches and rebasing.&#160; There are [plenty of good articles out there](http://www.google.com/search?q=git+rebase) on why this is an interesting and valuable workflow to know and understand, so I won’t rehash all the arguments.&#160; I will say that I like this workflow because it:

  * Gives me a clean, linear, understandable timeline 
  * Allows me to keep lines of work separate from each other, until it’s ready to push back upstream 
  * Works well in the face of unpredictable work 
  * Is light, quick, and does not leak into the public, mainline work 

I tried a few other options, such as real branches, patch queues, and so on, but none had the same flavor that I was looking for with local topic branches.&#160; With local topic branches, I don’t use different commands for committing (as I would with patch queues), nor do my branches leak metadata into the public timeline, as it would with normal Hg branches.

First, let’s get our local environment set up appropriately.

### Prepping our environment

The cornerstone of my local development workflow include the [Rebase](http://mercurial.selenic.com/wiki/RebaseExtension) and [Bookmarks](http://mercurial.selenic.com/wiki/BookmarksExtension) extension.&#160; To enable these extensions, just modify your [hgrc](http://www.selenic.com/mercurial/hgrc.5.html) file.&#160; You’ll also want to enable tracking the current commit for bookmarks.&#160; This ensures that our bookmark gets moved up with each commit, instead of getting just stuck on one.&#160; Your hgrc file would now include:

<pre>[extensions]
rebase = 
bookmarks =

[bookmarks]
track.current = True</pre>

[](http://11011.net/software/vspaste)

I’ve enabled the Rebase and Bookmarks extension, and configured bookmarks to track the current commit.&#160; Tools like TortoiseHg have features that light up when bookmarks are enabled, so you’ll have all sorts of things help you in those tools.

Now that we have our extensions enabled, we need to create our local marker for a master branch.&#160; This bookmark represents the last pushed commit, so you can execute the “outgoing” command to make sure that you have nothing to push:

[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_54B05F2A.png" width="327" height="68" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_0E336F22.png) 

If everything’s good, we’ll create the “master” bookmark:

[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_0CEED643.png" width="380" height="19" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_02317EEE.png) 

Git will create a “master” branch by default when you clone, but we’ll need to do this manually.&#160; You can think of “master” as trunk.&#160; It represents the mainline of the code we’re working on, and everything will be pulled into this line, both from upstream and from our local branches.&#160; Our repository explorer, as seen in TortoiseHg, now looks like:

[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_080C2287.png" width="421" height="98" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_2C9DB00B.png) 

Note here that “master” is orange.&#160; This indicates that “master” is the current bookmark being tracked.&#160; Now that we have our local repository set up, we can walk through making local changes.

### Scenario 1: One local branch, no upstream changes

First, let’s create a local topic branch and make some changes:

  * hg bookmark SomeTopic 
  * &#8211;work work work 
  * hg commit –Am “Simple Change” 
  * &#8212; work work work 
  * hg commit –Am “Some other change” 

At this point, we decide we want to push our changes up.&#160; We first want to synchronize our local repository with upstream, but we want to do this on master.&#160; So we:

  * hg checkout master 
  * hg pull &#8211;rebase 

We switch back to the master branch and synchronize with upstream.&#160; But since there aren’t any upstream changes, we want to now fold our SomeTopic branch back to master.&#160; Here’s what the picture looks like right now:

[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_0733BC9D.png" width="378" height="85" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_079FEF92.png) 

Since there are no other local branches, we follow a special workflow as Mercurial’s rebase extension does not do a fast-forward merge by default.&#160; That is, if I tell Hg to rebase or merge SomeTopic, I really just want to move master up to SomeTopic, and not perform some merge.&#160; So I:

  * hg checkout SomeTopic 
  * hg bookmark -f master 
  * hg bookmark -d SomeTopic 
  * hg push -b master 

I switch back to the SomeTopic branch, and move the master bookmark up to SomeTopic.&#160; I could have done this with “hg bookmark –f master –r SomeTopic”, but I want to switch to SomeTopic instead.&#160; I delete the SomeTopic bookmark, as “master” is now moved up to SomeTopic.&#160; Finally, I push master, and ONLY master up.&#160; I don’t want any other local topic branches to get pushed until they’re integrated with my mainline master branch.&#160; When we’re finished, this is what our local repository looks like:

### Scenario 2: Need to work on unrelated items but not push unfinished work

aka, the whole reason for topic branches.&#160; In this case, we’ve created our local topic branch, but now some other work comes in that we need to do.&#160; We need to work on something else unrelated to our feature work, and don’t want to push the feature work until it’s done.&#160; Our local repository first starts out like this:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_3133BAC5.png" width="409" height="90" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_319FEDBA.png) 

Just to review what we’re seeing here, the “master” bookmark points to the last pulled commit from upstream.&#160; We’re currently on the TopicOne bookmark, indicated here because it’s orange.&#160; The two up arrows indicate that I have not yet integrated and pushed my TopicOne branch.&#160; You can also execute “hg bookmark” at the command line to view the bookmarks and your current tracked one:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_377A9153.png" width="335" height="50" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_17CBB78B.png) 

So we’re working on TopicOne, which might represent some feature we’re working on.&#160; Some other work comes up, maybe it’s to fix some CSS or a batch script that has a higher priority than this feature.&#160; But we don’t want to push our TopicOne changes yet, it’s not ready to deploy, the tests are broken, it’s just not finished.&#160; So, we’ll start a new topic by:

  * hg checkout master
  * hg bookmark TopicTwo

At this point we can start committing as need be:

  * work work work
  * hg ci –Am “Critical work”
  * work work work
  * hg ci –Am “More critical work”

Once we’ve done that first commit, Hg will tell you that a new head was created.&#160; This is because we first switched back to master, created a new bookmark, and started committing.&#160; Here’s what our repository looks like right now:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_56BD3826.png" width="331" height="134" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_70253B60.png) 

Again, master sits back as our last pulled commit.&#160; It’s the critical placeholder that helps us know where to start new topic branches from.&#160; It’s not required, as I could look at these arrows to know what the last pulled commit was to start from, but it’s a lot easier when doing rebases and merges.

Now that TopicTwo is finished, I want to integrate TopicTwo into master and push it back upstream.&#160; Because master is a direct ancestor of TopicTwo, I only need to follow the Scenario #1 workflow:

  * hg co master
  * hg pull &#8211;rebase
  * hg co TopicTwo
  * hg bookmark –f master
  * hg bookmark –d TopicTwo
  * hg push –b master

It’s very important that I only push master, as that lets my local repository now look like:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_3CE901F7.png" width="340" height="132" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_2863B279.png) 

Now that my critical work is done, I can go back to working on TopicOne:

  * hg co TopicOne
  * work work work
  * hg ci –Am “Finishing work on a feature”

Once I do this, my local repository looks a little changed now:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_1BF58F50.png" width="359" height="158" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_55789F47.png) 

Here we see the master branch hanging off to the side, and my un-pushed changes in the TopicOne timeline.&#160; But now master is no longer in the ancestry of TopicOne.&#160; Now that I want to integrate TopicOne into master, I can either merge this branch, or rebase it.&#160; I prefer rebase, so I’ll follow the normal rebase workflow.&#160; But first, whenever we’re about to push changes, we ALWAYS:

  * hg co master
  * hg pull &#8211;rebase

Now that we’re sure we have the latest and greatest, we can rebase our TopicOne onto master:

  * hg co TopicOne
  * hg rebase –b TopicOne –d master

We switch to the TopicOne branch, then rebase from the base of TopicOne to the destination of master.&#160; This command replays the commits from TopicOne onto master, then deletes the TopicOne commits.&#160; Because the timeline changes, these are entirely new commits with new hashes, but containing the exact same changes/commit messages/commit times:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_53C7D373.png" width="526" height="162" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_62727F58.png) 

Even though I committed two of my changes _before_ the original TopicTwo branch, after a rebase, these commits show up _after_ the TopicTwo.&#160; This is because a rebase replays the commits one at a time on top of the destination (master).&#160; At this point, I can run the build to make sure everything works, and then follow the normal workflow when master is a direct ancestor of my topic branch, skipping the steps of pulling (we already did that):

  * hg bookmark –f master
  * hg bookmark –d TopicOne
  * hg push –b master

Finally, here’s what my repository looks like:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_59A2770C.png" width="344" height="153" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_2C215749.png) 

Because I’ve always rebased, no one ever needs to know about my topic branches until I integrate.&#160; The pushed timeline is always a clean, linear progression for the mainline master branch (in this case, it’s “dev” as the actual Hg branch).&#160; With topic branches, each topic is independent of each other, and I decide when that topic is ready to be integrated into the mainline.&#160; I might never integrate back, and switching topic branches is a VERY VERY fast “hg checkout” command away.&#160; This workflow is fast, cheap, flexible, and allows me to have one working directory and one repository that contains all the work I’m doing, no matter what its state.

When working with other people, it’s inevitable that file conflicts arise.&#160; In the next post, I’ll dive in to how to deal with conflicts along each step of the way and how this workflow functions in a team environment.