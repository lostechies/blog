---
wordpress_id: 995
title: 'Screencasting Tip: Resize Your App To 720p (1280&#215;720) In OSX'
date: 2012-09-08T10:41:28+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=995
dsq_thread_id:
  - "835902784"
categories:
  - AppleScript
  - OSX
  - Screencast
  - WatchMeCode
---
I record [my screencasts](http://www.watchmecode.net/) in 720p resolution. Up until recently, I had been changing my monitor&#8217;s resolution to 1280&#215;720 in order to do the recording. The problem with this is that I ended up having to edit out the system bar at the top of OSX. This reduced the height of my screen recordings by about 20 pixels. When stretched to fit, things got a bit blurry.

To fix this problem, I&#8217;ve stopped changing my monitor resolution. Instead, I set the size of the windows for the applications that I am going to record. I looked around for some simple ways to do this and came across a few window management apps that may have made it easy. But I already use [SizeUp](http://www.irradiatedsoftware.com/sizeup/) and I really like it, so I didn&#8217;t want to switch to something else. Instead, I whipped up a little bash script that uses Apple&#8217;s &#8220;osascript&#8221; tool to do the window resizing for me.

Copy this gist in to the file \`/usr/bin/720p\` and then \`sudo chmod +x /usr/bin/720p\` to  make it executable:

[gist id=3676822 file=720p.sh]

Now from a terminal window I can run 

> $ 720p AppName

where &#8220;AppName&#8221; is the name of the app to resize. For example:

> $ 720p Chrome
> 
> Setting Chrome bounds to 720p

> $ 720p Terminal
> 
> Setting Terminal bounds to 720p

> $ 720p MacVim
> 
> Setting MacVim bounds to 720p

This will resize the app&#8217;s window to 1280&#215;720, somewhere sort of near the center of your monitor (assuming you are running a 1080p monitor).

By using this little script, I can set all of the windows of the apps that I want to record to the correct size. Then when I record the screencast, I can crop the viewable area down to 1280&#215;720 and all of my apps will take up the full screen, providing pixel-perfect clarity on any device that can display 720p (like an iPad for example).