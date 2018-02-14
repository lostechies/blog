---
wordpress_id: 215
title: 'Git: D&#8217;OH! I didn&#8217;t want to delete that branch!'
date: 2011-02-23T17:48:09+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2011/02/23/git-d-oh-i-didn-t-want-to-delete-that-branch.aspx
dsq_thread_id:
  - "262100835"
categories:
  - git
redirect_from: "/blogs/derickbailey/archive/2011/02/23/git-d-oh-i-didn-t-want-to-delete-that-branch.aspx/"
---
In the process of writing up the [previous blog post](http://www.lostechies.com/blogs/derickbailey/archive/2011/02/23/git-oops-i-didn-t-mean-to-commit-on-that-remote-tracking-branch.aspx), I accidentally deleted my &#8220;bioreference&#8221; branch, with no current commit pointing to it. To illustrate, my repository went from this:

<img src="http://lostechies.com/content/derickbailey/uploads/2011/03/Screen-shot-2011-02-23-at-10.37.00-AM.png" border="0" alt="Screen shot 2011 02 23 at 10 37 00 AM" width="305" height="229" />

to this:

<img src="http://lostechies.com/content/derickbailey/uploads/2011/03/Screen-shot-2011-02-23-at-10.37.00-AM-copy.png" border="0" alt="Screen shot 2011 02 23 at 10 37 00 AM copy" width="305" height="141" />

All of my commits appear to be gone&#8230; they don&#8217;t show up in the commit log, at least.

 

### Enter The Reflog

Did you know there are two different logs in git? There&#8217;s the commit log &#8211; which is what tools like GitK, GitX and the _git log_ command line show. Then, there&#8217;s the [git reflog](http://www.kernel.org/pub/software/scm/git/docs/git-reflog.html). This is the history of everything that happens to a branch&#8217;s HEAD (the pointer that is the branch) and give us the ability to un-delete a branch by letting us know what commit that branch was previously pointing to.

Run _git reflog_ from the command line and it shows you what has been going on with the branch HEADs

<img src="http://lostechies.com/content/derickbailey/uploads/2011/03/Screen-shot-2011-02-23-at-11.31.03-AM.png" border="0" alt="Screen shot 2011 02 23 at 11 31 03 AM" width="600" height="233" />

 

### Branch From A Starting Point

In this case, we can see near the middle of the screen shot that there is a reference to the &#8220;bioreference&#8221; HEAD where it is moved to a new commit. All we need to do is take the commit reference (either the hex characters or the treeish &#8220;HEAD@{#}&#8221;). Once we have that, we can branch with a starting point of the commit in question

<img src="http://lostechies.com/content/derickbailey/uploads/2011/03/Screen-shot-2011-02-23-at-11.44.02-AM.png" border="0" alt="Screen shot 2011 02 23 at 11 44 02 AM" width="507" height="203" />

And like magic, the bioreference branch exists and points to the correct commit, including all of the commit ancestry.

<img style="border: 0px initial initial" src="http://lostechies.com/content/derickbailey/uploads/2011/03/Screen-shot-2011-02-23-at-10.37.00-AM.png" border="0" alt="Screen shot 2011 02 23 at 10 37 00 AM" width="305" height="229" />