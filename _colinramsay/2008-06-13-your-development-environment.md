---
id: 4687
title: Your Development Environment
date: 2008-06-13T10:00:00+00:00
author: Colin Ramsay
layout: post
guid: /blogs/colin_ramsay/archive/2008/06/13/your-development-environment.aspx
categories:
  - Uncategorized
---
When I first started working in &#8220;the real world&#8221;, I had a development environment which I&#8217;d describe as typical: average Dell computer and peripherals, one monitor, Windows XP with all my applications installed, including VS2003 and VS2005. I&#8217;m sure

Last year, when I struck out on my own to start Plastiscenic, I knew I needed an upgrade. For starters, my XP install was grinding to a halt. But I was also concerned about the way all of my interests were intermingling &#8211; games, hobby stuff and professional stuff all on the same installation. That felt pretty bad to me, not least because Windows XP gets very sluggish after a few months with lots of programs installed.

I purchased an Intel Q6600 with 4Gb of RAM, and a 10k RPM boot drive. That was stage one. I set up two monitors on a bigger desk with a lamp on it to reduce any strain on my eyes. I installed Vista 64 Business Edition, which I felt was a better match for the hardware than XP. The core setup was there, but there was still a key component missing.

VMWare provided the answer. By creating a stripped down Windows XP installation I had a fast virtual machine to install development software on. I had another VM for SQL Server. These trim virtual machines could be backed up with ease, and moved offsite if need be. If my main machine died, I only had to reinstall a basic environment and VMWare Player to become productive again.

In a larger team of developers, such virtualisation software provides even more options. An administrator could provide base images which can be served across a network, giving developers tailored environments within a few clicks. This is good for testing too &#8211; prepare images for a multitude of operating systems for pre-production testing of a desktop application.

I believe virtualisation will become even more popular over the next few years, giving us more opportunities to create sandboxed environments which can be run at the click of the mouse.&nbsp;