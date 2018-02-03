---
wordpress_id: 34
title: Disable annoying computer beep
date: 2007-06-23T05:10:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/06/23/disable-annoying-computer-beep.aspx
dsq_thread_id:
  - "267357045"
categories:
  - Misc
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/disable-annoying-computer-beep.html)._

My work laptop would emit loud beeps occasionally when I hit the wrong button, performed an invalid action, or maybe just looked at it funny.&nbsp; No volume controls could disable the beep, as it came from an internal speaker.&nbsp; The beep is very loud and quite disturbing,&nbsp;and prompts many dirty looks from&nbsp;co-workers.&nbsp; After some web sleuthing, I found a couple of commands that would stop and permanently disable the computer beep:

net stop beep

sc config beep start= disabled

Enter these two commands exactly into a command prompt.&nbsp; Don&#8217;t forget the space after the &#8220;=&#8221;, it won&#8217;t work without it.

The first command will stop the BEEP service, which is the Windows service responsible for constantly annoying me.&nbsp; The second command disables the service completely, and will prevent it from starting up the next time you turn on your computer.&nbsp; Now you can live happily beep-free, and&nbsp;your co-workers will thank you for it.