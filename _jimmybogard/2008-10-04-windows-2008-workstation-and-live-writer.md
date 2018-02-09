---
wordpress_id: 235
title: Windows 2008 Workstation and Live Writer
date: 2008-10-04T13:50:53+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/10/04/windows-2008-workstation-and-live-writer.aspx
dsq_thread_id:
  - "265823857"
categories:
  - Tools
redirect_from: "/blogs/jimmy_bogard/archive/2008/10/04/windows-2008-workstation-and-live-writer.aspx/"
---
After quite a bit of work, I’ve finally been able to post a blog entry with my new Windows 2008 Workstation machine.&#160; I recently switched laptops, and have been forced to go silent because of the issues of installing Windows Live Writer on Server 2008.

There isn’t really a Windows 2008 Workstation product you can buy.&#160; It’s really taking a Win 2008 Server installation and adding some of the Vista features back in.&#160; I really couldn’t stand to use Vista as either a home desktop or development machine OS, with all of the UAC and other garbage built in.

Instead of trying to turn things off until I got to a usable point, I started from a stable, clean OS and added what I needed.&#160; The best site I’ve found to create a Win 2008 Workstation machine is [win2008workstation.com](http://www.win2008workstation.com/wordpress/).

Unfortunately, not everything is wine and roses on Server 2008, let alone the 64-bit version of Server 2008.&#160; Most applications and drivers that support Vista 64-bit will work, as will most applications (but not drivers) that support 32-bit Server 2008/2003.

At the very bottom of the barrel are applications that don’t support Server 2008 or 64-bit, and prevent their installers from running.&#160; Google Desktop is one that provides the installer, but no support.&#160; [Windows Live Writer](http://download.live.com/writer), one of the especially heinous installers, has several very annoying aspects:

  * The downloaded installer is not an installer.&#160; It’s only there to download the real installer (often blocked in corporate environments).
  * The downloaded installer prevents downloading of the WLW installer if the OS isn’t supported.
  * Beta versions of WLW, if you can still find them, expire and prevent you from installing.

All of this for a _simple blog posting application_.&#160; For now, one of the only places I could find direct links to installers is here:

[http://dotnetwizard.net/live/direct-links-for-windows-live-wave-3/](http://dotnetwizard.net/live/direct-links-for-windows-live-wave-3/ "http://dotnetwizard.net/live/direct-links-for-windows-live-wave-3/")

I’m sure Microsoft will find a way to self-destruct these applications for Workstation 2008, but until then, I’ll be happily posting away.