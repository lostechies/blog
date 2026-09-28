---
wordpress_id: 791
title: Cleaning Out Git Remotes The Easy Way
date: 2012-01-31T14:53:17+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=791
dsq_thread_id:
  - "559426709"
categories:
  - Command Line
  - git
---
I had a rather large number of remote repositories set up in my Backbone.ModelBinding repository on my box, due to the wonderful community of contributors. But it was time for me to clean out the remotes as I no longer needed any of the old ones. To make it easy, I used a simple bash script:

> git remote | while read a; do  
> > git remote rm $a  
> > done

This took care of removing every single remote that I had in my &#8216;git remote&#8217; list … including the &#8220;origin&#8221; that I actually did want, now that I think about it. 😛

But my bash-scripting-fu is terrible, so I couldn&#8217;t figure out how to not destroy all of them. I tried adding an if statement in there to check if it&#8217;s not &#8220;origin&#8221;, but couldn&#8217;t get it to work. Anyone got some better bash-chops than me, and can point out how to do this?

 