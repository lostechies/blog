---
id: 389
title: The dangerous SourceTree setting
date: 2015-02-18T10:13:30+00:00
author: Sharon Cichelli
layout: post
guid: http://lostechies.com/sharoncichelli/?p=389
dsq_thread_id:
  - "3526879406"
categories:
  - Uncategorized
tags:
  - Git
  - source control
---
The messy one, at any rate.

Looking at a team&#8217;s git repository, I see the following evidence of somebody having a bad day:
  
[<img src="http://clayvessel.org/clayvessel/wp-content/uploads/2015/02/bad-commits.png" alt="Git log with three fix-bad-merge commits in a row" title="flailing git commits" class="alignnone size-full wp-image-390" width="300" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2015/02/bad-commits.png 517w, http://clayvessel.org/clayvessel/wp-content/uploads/2015/02/bad-commits-300x74.png 300w" sizes="(max-width: 517px) 100vw, 517px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2015/02/bad-commits.png)

Those are three commits, in rapid succession, from the same developer, trying to mash files into a compiling state. But why can _I_ see those commits? They should have been squashed or amended to neaten them up before being pushed to the remote repo for me to pull.

This presented an opportunity for coaching, but it&#8217;s also a good reminder: If you&#8217;re using a tool other than the command line, make sure the setting to automatically push commits is turned off. 

This beastie. Don&#8217;t check it.
  
[<img src="http://clayvessel.org/clayvessel/wp-content/uploads/2015/02/naughty-setting.png" alt="SourceTree commit dialog offers a checkbox to push automatically; uncheck it." title="turn off automatic push" class="alignnone size-full wp-image-391" width="500" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2015/02/naughty-setting.png 995w, http://clayvessel.org/clayvessel/wp-content/uploads/2015/02/naughty-setting-300x97.png 300w, http://clayvessel.org/clayvessel/wp-content/uploads/2015/02/naughty-setting-768x249.png 768w" sizes="(max-width: 767px) 89vw, (max-width: 1000px) 54vw, (max-width: 1071px) 543px, 580px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2015/02/naughty-setting.png)

Instead, when you need to fix a mistake, use one of the following options before pushing to the remote repo.

  * In [SourceTree](http://www.sourcetreeapp.com), the &#8220;Commit options&#8230;&#8221; dropdown list to the right of the commit dialog has an option to &#8220;Amend latest commit.&#8221; You&#8217;ll be asked if you want to replace the commit text in your current dialog with the message of the previous commit. Say yes, since you&#8217;re adding a file to the previous commit that you had meant to include all along.
  * If you&#8217;re using the [git gui](http://git-scm.com/docs/git-gui) tool that&#8217;s distributed with git, there are radio buttons above the commit message so that you can select &#8220;Amend Last Commit.&#8221;
  * From the command line, accomplish the equivalent rewrite with [`git commit --amend`](http://git-scm.com/docs/git-commit).
  * If you&#8217;re cleaning up a bigger mess, use [`git rebase -i`](http://git-scm.com/docs/git-rebase) to fix up any commits that haven&#8217;t been pushed.
  * And my favorite, take a calm and measured stroll through this [choose-your-own-adventure-style guide to fixing commits in git](http://sethrobertson.github.io/GitFixUm/fixup.html).

A common theme in all of these strategies is **don&#8217;t change commits you&#8217;ve pushed** somewhere other developers might be using. Which is why you want to uncheck that &#8220;automatically push&#8221; setting.

Any harm in having multiple flailing attempts to fix a set of files? Not especially, but having a clean, intention-revealing history makes troubleshooting later easier, and I&#8217;ll be less likely to cluck my tongue at you.