---
wordpress_id: 506
title: How to fix Subversion merge
date: 2011-07-28T12:57:43+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/07/28/how-to-fix-subversion-merge/
dsq_thread_id:
  - "370845092"
categories:
  - git
  - Mercurial
---
Having done quite a bit of branching in centralized and distributed source control systems, I’m intimately aware of the additional (and I would say, unnecessary) pain centralized source control systems like Subversion and TFS bring to more powerful branching strategies used in teams today. Release branching, branch-per-feature and the like are very powerful tools of delivering software effectively, if you know how to properly set these things up.

However, merging has always been the linchpin in the branching story. Branching is easy, but because merging is the last step in a branching workflow, it’s the merging that determines the difficulty in branching. And merging in SVN, especially across branches, has always been….challenging. Along those lines, I saw an interesting proposal to [fix Subversion merge](http://blog.assembla.com/assemblablog/tabid/12618/bid/58122/It-s-Time-to-Fix-Subversion-Merge.aspx).

An interesting approach, but I have a couple of other approaches that, in the long run, have a much better, brighter upside:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="git-logo" border="0" alt="git-logo" src="http://lostechies.com/content/jimmybogard/uploads/2011/07/git-logo.png" width="101" height="192" />](http://git-scm.com/)

or

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="logo-droplets-150" border="0" alt="logo-droplets-150" src="http://lostechies.com/content/jimmybogard/uploads/2011/07/logo-droplets-150.png" width="154" height="184" />](http://mercurial.selenic.com/)

And [migrate your SVN repository into Git](http://progit.org/book/ch8-2.html) or [migrate into Hg](http://mercurial.selenic.com/wiki/ConvertExtension#Converting_from_Subversion).

There, now your Subversion merge problems are fixed!