---
id: 382
title: Can I delete this branch?
date: 2014-12-30T07:50:33+00:00
author: Sharon Cichelli
layout: post
guid: http://lostechies.com/sharoncichelli/?p=382
dsq_thread_id:
  - "3373490328"
categories:
  - Uncategorized
---
End-of-the-year housecleaning time: Our team&#8217;s project has accumulated a few* git branches that are almost certainly stale. Some of them were last worked on by people who aren&#8217;t even on the project anymore. Still, I wanted to reassure myself before I summarily deleted them. Here are the git commands I was able to round up. What&#8217;ve you got?

Start with `git checkout master`, since these work relative to the current branch and only make sense when that current branch is master.

`git branch --merged`
  
lists branches that have been merged to HEAD. (You&#8217;ve already made master the current branch, right?) If your branch is in that list, it&#8217;s in master and can be deleted.

`git branch --contains my-branch-to-delete`
  
lists branches that contain the branch you specified. If master shows up in the list, then master contains your branch.

`git log my-branch-to-delete ^master --no-merges`
  
lists commits that are in my-branch-to-delete but are not in master. The ^ means &#8220;exclude this branch&#8221;, so this is listing commits on my-branch-to-delete, excluding commits that are also on master. If there are no commits in this list, then master contains my-branch-to-delete.

<pre></pre>

* Not a few