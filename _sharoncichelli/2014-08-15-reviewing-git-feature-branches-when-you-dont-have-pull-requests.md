---
id: 292
title: 'Reviewing Git feature branches when you don&#8217;t have pull requests'
date: 2014-08-15T09:05:44+00:00
author: Sharon Cichelli
layout: post
guid: http://lostechies.com/sharoncichelli/?p=292
dsq_thread_id:
  - "2907891830"
categories:
  - Uncategorized
---
I&#8217;m not always using Git in an environment that supports pull requests. My preferred Git workflow, even within a team of co-workers who sit together, is to have features developed and tested within a feature branch, then reviewed and merged via pull request. I took a page from [Vincent Driessen](https://twitter.com/nvie)&#8216;s playbook, [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/), which gives a step-by-step explanation.

But easy-to-review pull requests are a feature of GitHub and BitBucket, not Git itself. ([`git request-pull`](http://git-scm.com/docs/git-request-pull) doesn&#8217;t cut it.) Here&#8217;s my current workflow to review a feature&#8217;s worth of changes.

I&#8217;m using [posh-git](https://github.com/dahlbyk/posh-git) within [Console2](http://sourceforge.net/projects/console/files/) (with [Scott Hanselman&#8217;s customizations](http://www.hanselman.com/blog/Console2ABetterWindowsCommandPrompt.aspx) because I&#8217;m a subtle badass) for issuing commands, and [SourceTree](http://www.sourcetreeapp.com/) for visualizing what&#8217;s going on.

**The Goal:** Get a list of all files changed for this feature and compare each one&#8217;s initial state against its final state, without any noise from merges from master.

**The Approach:** Pretend I&#8217;m going to merge the feature into master but don&#8217;t commit it. Diff the pending changes and send my recommendations. Then throw away the changes and clean everything up.

    git checkout master
    git merge &#8209;&#8209;no&#8209;ff &#8209;&#8209;no&#8209;commit name_of_their_feature_branch
    

First I check out master as the branch I want to merge _into_. Then I run a merge with two important options. No-fast-forward (`&#8209;&#8209;no&#8209;ff`) makes the feature join into master with a single, explicit merge commit. This tells git, even if it could perform a fast-forward merge, where it applies each of the feature-branch commits as if they had been committed straight to master, please don&#8217;t. With the `&#8209;&#8209;no&#8209;ff` option, you&#8217;ll have the single, show-me-everything commit you wanted to review. The second, `&#8209;&#8209;no&#8209;commit`, is even more important: Stage them but don&#8217;t commit them. (Although, as long as you don&#8217;t push to a remote, even that is reversible. This [choose-your-own-adventure git guide](http://sethrobertson.github.io/GitFixUm/fixup.html) reassuringly walks you through revising history.)

Because you are taking a trial-run at merging the feature to master, you may need to resolve some merge conflicts. Go ahead and do so, since that will give you a realistic picture of the finished feature.

**After the Review:** You&#8217;ve finished with your review and are ready to clean up your working directory. Here are the commands to discard the changes.

> This **throws away your work**, but you were just pretend-merging anyway, right?

    git reset &#8209;&#8209;hard
    git clean &#8209;fd
    

`reset` sets the current branch back to the most recent commit, and `&#8209;&#8209;hard` says to discard changes to tracked files. This does not clean up new files that the feature branch added. That&#8217;s what `clean` takes care of. The `&#8209;f` option is for &#8220;force,&#8221; since Git can be configured to not execute a clean unless you expressly specify force&mdash;a little safety net since `clean` is so destructive. The `&#8209;d` option instructs Git to also remove newly created directories. (Some folks include `&#8209;x`, to throw away even files that would have been ignored by your `.gitignore`, such as dlls in your bin folder. This is a little too thorough for me, so I don&#8217;t use it.)

So there you go. To review what will be changed by a feature branch, pretend to merge it and see what changed.