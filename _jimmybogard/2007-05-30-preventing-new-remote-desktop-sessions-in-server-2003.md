---
wordpress_id: 27
title: Preventing new Remote Desktop sessions in Server 2003
date: 2007-05-30T17:34:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/05/30/preventing-new-remote-desktop-sessions-in-server-2003.aspx
dsq_thread_id:
  - "264715364"
categories:
  - Misc
redirect_from: "/blogs/jimmy_bogard/archive/2007/05/30/preventing-new-remote-desktop-sessions-in-server-2003.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/preventing-new-remote-desktop-sessions.html)._

I have both a laptop and a desktop, and it&#8217;s fairly often that I remote into my desktop to do development.&nbsp; Although my laptop is no slouch, you really can&#8217;t beat a desktop dev experience.&nbsp; However, my dev machine is running Server 2003, which allows multiple remote desktop sessions at once.&nbsp; Windows XP only allows one user session at a time, whether it&#8217;s a console (I&#8217;m physically at the machine) or remote session.&nbsp; That was nice, because I could have a bunch of applications open at once, lock the machine, then remote into it and have all of my applications up and running.

When I try and remote into my Server 2003 dev box, by default remote desktop starts a new session.&nbsp; Poof, all of my applications are gone (in a another session at least).&nbsp; I&#8217;d like to mimic the behavior of Windows XP, and continue the console session I already had going for me.&nbsp; Luckily for me, it&#8217;s pretty easy to accomplish this.&nbsp; I actually have two options:

  * Using /console command-line switch to mstsc.exe (not very user-friendly) 
      * Edit a saved remote desktop connection file (.RDP file)</ul> 
    I like the second option, since I often save connections to known machines.&nbsp; I can never remember&nbsp;any of the&nbsp;machine names anyway.&nbsp; Just edit a saved remote desktop connection (RDP file) in Notepad or another text editor and add the following line at the end of the file:
    
    connect to console:i:1
    
    Save the file, and close Notepad.&nbsp;&nbsp;When you run the RDP file, you will connect to the console session, and you&#8217;ll have all of the programs you had when you were logged in to the console session.