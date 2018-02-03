---
wordpress_id: 441
title: 'Protip: Viewing large XML files'
date: 2010-12-01T13:52:46+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/12/01/protip-viewing-large-xml-files.aspx
dsq_thread_id:
  - "264716614"
categories:
  - Tools
---
There are lots of editors that can view large XML files, such as Visual Studio, Notepad++, UltraEdit and so on.&#160; But all of these have one flaw – they try and do _too much_ in viewing XML.&#160; Things like coloring, expand/collapse widgets and so on.

One of the integration points in my current project is a large XML file (40MB or so), that consists of exactly two lines of text in the file – the XML header and then the actual content.&#160; No matter what XML viewer I chose, it would pretty much barf or never respond.

Instead of viewing the file as XML, I just changed the extension to “.txt” for that file and voila, now any text editor worth a darn can open it.&#160; Sometimes tools do too much to try and help, but there are always ways to fool them.