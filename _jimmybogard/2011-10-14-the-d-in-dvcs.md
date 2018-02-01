---
id: 543
title: The D in DVCS
date: 2011-10-14T02:58:54+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2011/10/14/the-d-in-dvcs/
dsq_thread_id:
  - "442744322"
categories:
  - git
---
Just a reminder that the D in DVCS stands for “Distributed”, not “Disconnected” or “Decentralized”. This is a centralized model (from <http://progit.org/book>):

<img src="http://progit.org/figures/ch1/18333fig0102-tn.png" width="500" height="392" />

And this is Distributed:

![](http://progit.org/figures/ch1/18333fig0103-tn.png)

Note that in the first picture, you’re reliant and dependent on the server for a lot of operations. Note that in the second picture, the only distinguishing feature of the Server is its label. It’s really just an agreement or convention on what the “central” server is. But we can draw all sorts of more interesting pictures, like:

![](http://progit.org/figures/ch5/18333fig0502-tn.png)

Which is not hard to do at all with Git. The nice thing about the distributed model is that it opens doors to ways of working that simply aren’t possible or feasible with centralized VCS. You can try and work around it, but ultimately the centralized model of VCS is inferior.

It’s not just the “I can work on an airplane” factor (which is nice) or “I can branch and merge like it’s going out of style” effect (which is nice), but the architecture of a distributed model enables patterns and styles of work that can provide a real, measurable impact to a team’s productivity.

DVCS is not the opposite of CVCS, nor is it its complement. It is the next evolutionary step forward, one that no team I’ve encountered has ever _chosen_ to go back on.