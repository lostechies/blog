---
id: 102
title: Installing Visual Studio 2008
date: 2007-11-19T21:20:45+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/11/19/installing-visual-studio-2008.aspx
dsq_thread_id:
  - "264715430"
categories:
  - Tools
---
As has already been noted in numerous places, VS 2008&nbsp;dropped today.&nbsp; The installation process has been surprisingly smooth, given my past installation experiences.

Downloading went surprisingly quick (after I was able to get in to the subscriptions site, which took about 2 hours).&nbsp; I averaged around 900KB/sec (that&#8217;s bytes, not bits), about 10 times more than I expected on RTM day.

### Cleaning up

First, you&#8217;ll need to make sure that you don&#8217;t have any Beta bits installed.&nbsp; I had VS 2008 Beta 2 on my dev machine, and no problems cropped up during uninstallation.&nbsp; I removed pretty much anything that had &#8220;2008&#8221; and &#8220;3.5&#8221; in its name, as I had installed quite a few of the Beta 2 releases.

Additionally, I removed them in the reverse order I installed them.&nbsp; Don&#8217;t uninstall VS 2008 before Team Explorer for example.&nbsp; My lack of later installation&nbsp;issues might be attributed to this.

### Installing

Even after I uninstalled the 2008 and 3.5 apps I found, the 2008 installer noted that I had some pre-release software still installed (.NET Compact Framework) that needed to be removed.&nbsp; Their installers have always been good about letting you know about conflicting versions, but it&#8217;s a relief that it plays well with Beta 2.

About halfway through the installation, the installer noted that I needed to close some apps.&nbsp; These included IE and XML Notepad.&nbsp; This always happens with me and various MS installers, but I primarily use Firefox, so I didn&#8217;t have to close any windows I needed.

About an hour later, all of the installations finished (VS 2008 Team Suite, Team Explorer 2008, and MSDN).

### First impressions

After the obligatory first-launch screen (which settings do you want?&nbsp; Whatever ReSharper does!), I noticed that the &#8220;Recent Projects&#8221; list included the same set of projects as Beta 2, and they all opened with no issues.

The only problem so far is that there is no officially supported version of ReSharper for VS 2008 RTM, and the website says that the next major release will be the first officially supported version.&nbsp; But let&#8217;s be honest, any time spent without ReSharper just makes us love it even more, right?