---
id: 4501
title: 'Git&#8217;s guts: Branches, HEAD, and fast-forwards'
date: 2009-11-25T00:11:00+00:00
author: James Gregory
layout: post
guid: /blogs/jagregory/archive/2009/11/25/git-s-guts-branches-head-and-fast-forwards.aspx
dsq_thread_id:
  - "275507055"
categories:
  - git
---
Lets get some learning done. There are a few questions that keep cropping up when I introduce people to Git, so I thought I&#8217;d post some answers as a mini-series of blog posts. I&#8217;ll cover some fundamentals, while trying not to retread too much ground that the fantastic [Git community book](http://book.git-scm.com) already covers so well. Instead I&#8217;m going to talk about things that should help you understand what you and Git are doing day-to-day.

### What&#8217;s a branch?

I know what you&#8217;re thinking. _&#8220;C&#8217;mon, we know what a branch is&#8221;_. A branch is a copy of a source tree, that&#8217;s maintained separately from it&#8217;s parent; that&#8217;s what we perceive a branch to be, and that&#8217;s how we&#8217;re used to dealing with them. Sometimes they&#8217;re physical copies (VSS and TFS), other times they&#8217;re lightweight copies (SVN), but they&#8217;re copies non-the-less. Or are they?

Lets look at it a different way. _The Git way_.

Git works a little differently than most other version control systems. It doesn&#8217;t store changes using [delta encoding](http://en.wikipedia.org/wiki/Delta_encoding), where complete files are built up by stacking differences contained in each commit. Instead, in Git each commit stores a snapshot of how the repository looked when the commit occurred; a commit also contains a bit of meta-data, author, date, but more importantly a reference to the parent of the commit (the previous commit, usually).

That&#8217;s a bit weird, I know, but bare with me.

So what is a branch? Nothing more than a pointer to a commit (with a name). There&#8217;s nothing physical about it, nothing is created, moved, copied, nothing. A branch contains no history, and has no idea of what it consists of beyond the reference to a single commit.

Given a stack of commits:

![](http://lostechies.com/jamesgregory/files/2011/03.GitGuts.1/Figure1.png)

The branch references the newest commit. If you were to make another commit in this branch, the branch&#8217;s reference would be updated to point at the new commit.

![](http://lostechies.com/jamesgregory/files/2011/03.GitGuts.1/Figure2.png)

The history is built up by recursing over the commits through each&#8217;s parent.

### What&#8217;s HEAD?

Now that you know what a branch is, this one is easy. `HEAD` is a reference to the latest commit in the branch you&#8217;re in.

Given these two branches:

![](http://lostechies.com/jamesgregory/files/2011/03.GitGuts.1/Figure3.png)

If you had master checked out, `HEAD` would reference `e34fa33`, the exact same commit that the master branch itself references. If you had feature checked out, `HEAD` would reference `dde3e1`. With that in mind, as both `HEAD` and a branch is just a reference to a commit, it is sometimes said that `HEAD` points to the current branch you&#8217;re on; while this is not strictly true, in most circumstances it&#8217;s close enough.

### What&#8217;s a fast-forward?

A fast-forward is what Git does when you merge or rebase against a branch that is simply ahead the one you have checked-out.

Given the following branch setup:

![](http://lostechies.com/jamesgregory/files/2011/03.GitGuts.1/Figure4.png)

You&#8217;ve got both branches referencing the same commit. They&#8217;ve both got exactly the same history. Now commit something to feature.

![](http://lostechies.com/jamesgregory/files/2011/03.GitGuts.1/Figure5.png)

The `master` branch is still referencing `7ddac6c`, while `feature` has advanced by two commits. The `feature` branch can now be considered ahead of `master`.

It&#8217;s now quite easy to see what&#8217;ll happen when Git does a fast-forward. It simply updates the `master` branch to reference the same commit that `feature` does. No changes are made to the repository itself, as the commits from `feature` already contain all the necessary changes.

Your repository history would now look like this:

![](http://lostechies.com/jamesgregory/files/2011/03.GitGuts.1/Figure6.png)

### When doesn&#8217;t a fast-forward happen?

Fast-forwards don&#8217;t happen in situations where changes have been made in the original branch and the new branch.

![](http://lostechies.com/jamesgregory/files/2011/03.GitGuts.1/Figure7.png)

If you were to merge or rebase `feature` onto `master`, Git would be unable to do a fast-forward because the trees have both diverged. Considering Git commits are immutable, there&#8217;s no way for Git to get the commits from `feature` into `master` without changing their parent references.

For more info on all this object malarky, I&#8217;d recommend reading the [Git community book](http://book.git-scm.com).

If there&#8217;s anything that you&#8217;re not sure about ask in the comments and I&#8217;ll try get it into my next post.