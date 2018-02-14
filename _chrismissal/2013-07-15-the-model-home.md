---
wordpress_id: 397
title: The Model Home
date: 2013-07-15T18:59:48+00:00
author: Chris Missal
layout: post
wordpress_guid: http://lostechies.com/chrismissal/?p=397
dsq_thread_id:
  - "1503126472"
categories:
  - Best Practices
  - Design Principles
  - development
  - DRY
---
The other day I was having a discussion with my co-worker [Justin](http://www.justincpope.com/ "Justin Pope") and came up with an analogy I rather like. I was working on three similar, but slightly different features and first decided to build the foundation for all three of these. Not long in and Justin recommended that I should probably get one of them working (a vertical slice) and then building the other two should be a lot smoother because the patterns defined in the first will already be proven.[<img class="alignright size-medium wp-image-398" title="Bluth Model Home" src="http://lostechies.com/content/chrismissal/uploads/2013/07/2x09_Burning_Love-300x168.png" alt="" width="300" height="168" />](/content/chrismissal/uploads/2013/07/2x09_Burning_Love.png)

This makes sense and I have done this in the past. This time around though, a few ideas came to mind:

  * How often does Chris like to change his mind and refactor? Lots, probably a bit too much sometimes.
  * Would you really pour the foundation of 50 homes, then build the frames, then all the other stuff that it takes to build a home? Nope. Start with a model home.
  * What&#8217;s better (in case it were to happen), 10 features 90% done or 9 out of 10 features complete? Probably the latter.

I ended up building one feature fully (vertical) and then was able to build the (horizontal) pieces of the other features as I already proved they were working and good enough in the first.

I think the model home analogy is a good one for me and I thought I would share.