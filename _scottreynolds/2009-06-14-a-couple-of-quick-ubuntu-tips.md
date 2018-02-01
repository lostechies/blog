---
id: 4040
title: A Couple of Quick Ubuntu Tips
date: 2009-06-14T21:58:00+00:00
author: Scott Reynolds
layout: post
guid: /blogs/scottcreynolds/archive/2009/06/14/a-couple-of-quick-ubuntu-tips.aspx
categories:
  - Linux
  - Ubuntu
---
I&#8217;m setting up an Ubuntu Jaunty install for a friend and trying to get it nice and usable. I&#8217;ll be messing more with Linux in the near future I think. Anyway, I ran across a couple of things that really bugged me and that took me a \*while\* to fix, so I thought I&#8217;d share/document for next time.

Side note: I&#8217;m damn impressed with how far linux has come since I last gave it a real look. The last time I actually installed linux was pre-corporate-sellout Red Hat almost a decade ago. That experience was&#8230;not enjoyable. Ubuntu, thus far, has been every bit as easy to work with as Windows. (Take that for what it&#8217;s worth)

### Font and Options Too Large on Ubuntu Login Screen

First thing I noticed after fresh install was that typing into the login box revealed that the font size was crazy huge. The letters weren&#8217;t readable at all, and the options menu was barely readable it was so big. Took me a while but I finally found the fix.

Drop into a bash session and type the following:

_sudo **vi** /etc/gdm/gdm.conf_

you can replace vi with your editor of choice (gedit provides a notepad-like experience). You are looking for a section that says something like: 

<pre>[server-Standard]<br />name=Standard server<br />command=/usr/X11R6/bin/X -br -audit 0<br />flexible=true<br /></pre>


  
Edit the command line to include a dpi directive so it becomes:

<pre>command=/usr/X11R6/bin/X -br -audit 0 -dpi 96<br /></pre>

You will need to reboot to see the changes (or restart GNOME) and the next time you do your login screen fonts should be normal people sized.

### The application &#8216;NetworkManager Applet&#8217; (/usr/bin/nm-applet) wants access to the default keyring, but it is locked

This one was a pain. I had my friend change her password temporarily so I could do a bunch of setup on her account. This was fine for everything except when Ubuntu wanted to connect to my wireless. It wasn&#8217;t storing the WEP in the keyring, and it kept prompting about it being locked. Entering the password didn&#8217;t work at all, and it was pretty much getting annoying.

After searching for a long time and finding nothing, I ran across [this thread](http://art.ubuntuforums.org/showthread.php?p=7149888) that provided the answer. Basically, go back to network settings, edit the wireless connection, check &#8220;available to all users&#8221;, and the prompt disappeared.

### Random Tips

One thing I found while trying to resolve these issues is that it&#8217;s much better to include the version of Ubuntu in the search. At first I was trying things like _ubuntu login screen font too large_ and getting very dated results. Changing it to _ubuntu jaunty login screen font too large_ made a world of difference. I guess this may be fairly obvious to most of you, but I&#8217;m used to searching for _mac os x_ and not needing to specify _leopard_.

Also, if you&#8217;re new to linux or are a keyboarder in general, make [GNOME Do](http://do.davebsd.com/) the first thing you download and install. It&#8217;s like Launchy or Quicksilver or [your favorite launcher here] and has been invaluable as I try to find my way around an unfamiliar system. On Ubuntu, you can get GNOME Do directly from the Add/Remove Programs manager (select community-maintained programs).

Those are my Linux tips for today.

<div>
  Technorati tags: <a rel="tag" href="http://technorati.com/tags/linux">Linux</a>,<br /> <a rel="tag" href="http://technorati.com/tags/ubuntu">Ubuntu</a>
</div>