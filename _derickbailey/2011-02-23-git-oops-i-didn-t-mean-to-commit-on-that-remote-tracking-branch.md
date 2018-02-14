---
wordpress_id: 214
title: 'Git: Oops! I didn&#8217;t mean to commit on that remote tracking branch!'
date: 2011-02-23T16:44:39+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2011/02/23/git-oops-i-didn-t-mean-to-commit-on-that-remote-tracking-branch.aspx
dsq_thread_id:
  - "262064342"
categories:
  - git
redirect_from: "/blogs/derickbailey/archive/2011/02/23/git-oops-i-didn-t-mean-to-commit-on-that-remote-tracking-branch.aspx/"
---
I&#8217;ve talked about 2 [very similar](http://www.lostechies.com/blogs/derickbailey/archive/2010/04/01/git-oops-i-changed-those-files-in-the-wrong-branch.aspx) [situations](http://www.lostechies.com/blogs/derickbailey/archive/2010/06/08/git-d-oh-i-meant-to-create-a-new-branch-first.aspx) in the past. This is just a small variation, but I still find it useful enough to make another small post. I&#8217;m using the same checkout and reset commands that I&#8217;ve shown before. The small difference here, is that I&#8217;m using a remote branch as a point of reference in the reset calls. This let&#8217;s me move my local branch that is tracking the remote back to the same commit as the remote.

 

### Committing To The Wrong Branch

In the first screen shot, you can see that the master branch is ahead of the origin/master remote branch.

<img src="http://lostechies.com/content/derickbailey/uploads/2011/03/Screen-shot-2011-02-23-at-10.34.43-AM.png" border="0" alt="Screen shot 2011 02 23 at 10 34 43 AM" width="262" height="228" />

 

### Creating A Topic Branch

The first thing I need to do is create a new branch that points to the same commit as master.

<img src="http://lostechies.com/content/derickbailey/uploads/2011/03/Screen-shot-2011-02-23-at-10.35.22-AM.png" border="0" alt="Screen shot 2011 02 23 at 10 35 22 AM" width="506" height="204" />

Now you can see the new branch pointing to the same commit as master.

<img src="http://lostechies.com/content/derickbailey/uploads/2011/03/Screen-shot-2011-02-23-at-10.35.39-AM.png" border="0" alt="Screen shot 2011 02 23 at 10 35 39 AM" width="270" height="209" />

 

## Resetting Master

Here, I&#8217;m using git reset to move the master branch to a different commit. In this case, I&#8217;m moving back to the same commit as the origin/master remote branch.

<img src="http://lostechies.com/content/derickbailey/uploads/2011/03/Screen-shot-2011-02-23-at-10.36.43-AM.png" border="0" alt="Screen shot 2011 02 23 at 10 36 43 AM" width="475" height="225" />

 

And now my repository looks the way I want. I have master and origin/master tracking nicely, and I have a topic branch that contains all of the work I had been doing.

<img src="http://lostechies.com/content/derickbailey/uploads/2011/03/Screen-shot-2011-02-23-at-10.37.00-AM.png" border="0" alt="Screen shot 2011 02 23 at 10 37 00 AM" width="305" height="229" />

 