---
wordpress_id: 508
title: A brighter TFS future?
date: 2011-08-04T13:13:44+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/08/04/a-brighter-tfs-future/
dsq_thread_id:
  - "377038097"
categories:
  - TFS
---
I saw an interesting quote in Brian Harry’s (the PM of TFS) [post on TFS 11 enhancements](http://blogs.msdn.com/b/bharry/archive/2011/08/02/version-control-model-enhancements-in-tfs-11.aspx). He mentions that the next TFS version will support Subversion-style “Modify-merge-commit” workflows, which is a definitely a step in the right direction. However, one quote popped out at me (emphasis mine):

> I’m certain that about this time, I bunch of people are asking “but, did you implement DVCS”.&nbsp; The answer is no, not yet.&nbsp; You still can’t checkin while you are offline.&nbsp; And you can’t do history or branch merges, etc.&nbsp; Certain operations do still require you to be online.&nbsp; You won’t get big long hangs – but rather nice error messages that tell you you need to be online.&nbsp; **DVCS is definitely in our future and this is a step in that direction but there’s another step yet to take.**

Having worked with both centralized and distributed source control systems, DVCS is very plainly a better model of working. Good to know it’s at least on their radar, DVCS will open up a lot of branching scenarios that are just too painful in centralized models. Folks here at Headspring use SVN, Git, Mercurial and TFS, and it would be nice if at least 3 of those 4 supported a DVCS model.