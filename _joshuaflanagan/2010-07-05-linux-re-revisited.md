---
id: 3962
title: Linux Re-revisited
date: 2010-07-05T01:38:55+00:00
author: Joshua Flanagan
layout: post
guid: /blogs/joshuaflanagan/archive/2010/07/04/linux-re-revisited.aspx
dsq_thread_id:
  - "262113222"
categories:
  - Uncategorized
---
I have long been a Windows user, but I have a habit of installing Linux on a home machine every couple years to give it a chance to grow on me. It had never won me over to become my primary machine for various reasons: installation issues, driver issues, unable to run my games, unable to run the software I depended on, and no apparent advantage over what I was comfortable using. Until now.

### Motivation

A few months ago I had come across a <a href="http://www.railstutorial.org/" target="_blank">good Ruby on Rails tutorial</a>, and had started dipping back into Rails on the side. Rails works on Windows, but you always feel like a second class citizen, as there always seem to be a number of tiny workarounds you have to deal with. 

Around the same time, <a href="http://blog.timtyrrell.net/" target="_blank">Tim Tyrrell</a> had told me how he installed Linux via <a href="http://wubi-installer.org/" target="_blank">Wubi</a>. It allows you to dual-boot into linux, without repartitioning your hard drive (very much like the Windows 7 <a href="http://www.hanselman.com/blog/LessVirtualMoreMachineWindows7AndTheMagicOfBootToVHD.aspx" target="_blank">boot to VHD feature</a>), and gives you the ability to uninstall via Windows’ Add/Remove Programs. No commitment required.

A&#160; month ago this weekend, I attended the <a href="http://texasjavascript.com/" target="_blank">TXJS</a> conference, and reminiscent of <a href="http://www.nofluffjuststuff.com/conference/austin/2006/07/home" target="_blank">NFJS ‘06</a>, it got me really fired up about the software world outside of my day job. Back in ‘06, it was Ruby on Rails. This year it was <a href="http://nodejs.org/" target="_blank">node.js</a>. At the time, node did not run on Windows (the homepage now reports that it runs on Cygwin), and I felt like I was missing out.

The night I returned from TXJS, I installed Ubuntu 10.04 (via Wubi) on my primary machine. I downloaded the source for node.js, compiled and installed it, and ran my first”hello world” sample. It was all so much easier than I had anticipated. I suddenly felt there was hope for me, that I would be able to participate in this other side of computing that I had avoided for so long.

### Impressions

The only installation/hardware issues I had this time around was trying to get my 2 external monitors working properly when my laptop was docked (and closed). It was incredibly frustrating and led to having to manually edit the xorg.conf – something I had hoped was in linux’s past. The good news is I did get it all working. The other usual suspects, wireless networking and printing, just worked, without any fuss.

On the plus side, it’s hard to overstate how nice it is to work on an operating system where 99% of the software is free and available via a package manager. To give you a sense, compare the experience of attempting to use the Subversion client on a machine where it has not been installed. From a Windows 7 Command Prompt, and an Ubuntu Terminal window, I typed: svn [enter]

Windows 7 response: `'svn' is not recognized as an internal or external command, operable program or batch file.` 

Ubuntu response: `The program 'svn' is currently not installed. You can install it by typing: sudo apt-get install subversion` 

This is not some special case for Subversion – I was given a similar response any time I tried to use a program that was not installed. Do I have Mono installed? Type msc [enter] and Ubuntu tells me which package I need to install to get the Mono C# compiler. It is so much easier to stay focused on the task at hand when you don’t have to search for a website, download a file, and click through an installation wizard.

I’ve been able to do most of my day-to-day tasks without missing a beat. Gmail, Google Reader, and Google Docs had long ago replaced their installed software equivalents in my life. My personal finance software, <a href="http://moneydance.com/" target="_blank">Moneydance</a>, can run on Windows and Linux, with the same license. I haven’t used my PC for gaming in years. I currently only boot into Windows for three reasons: upload running data from my Nike+ Sportband (no Linux support in sight), working from home in Visual Studio, and using Windows Live Writer for writing blog posts (although I’m sure I can find an alternative).

On a somewhat relevant note, the one suggestion from <a href="http://www.pragprog.com/titles/tpp/the-pragmatic-programmer" target="_blank">The Pragmatic Programmer</a> where I’ve always felt the weakest was “Use a Single Editor Well”. I can zip around C# code with VS/ReSharper, but I would never consider VS for general purpose text editing. So I usually end up in Notepad2 – a nice tool, but not the type of editor a programmer should rely on. <a href="http://www.vim.org/" target="_blank">Vim</a> has been getting a lot of attention lately, and it seemed a reasonable choice to try. I was well aware of Vim’s steep learning curve, and knew I did not want to try and adopt it for C# editing (I already had a good solution for C#, and I don’t think its an area where Vim’s capabilities would shine), but I knew I wouldn’t “get it” unless I used it for real work. I decided I would complete the entire Ruby on Rails tutorial entirely with vim. With a lot of help from a <a href="http://www.viemu.com/a_vi_vim_graphical_cheat_sheet_tutorial.html" target="_blank">graphical cheat sheet tutorial</a> and <a href="http://www.swaroopch.com/notes/Vim" target="_blank">A Byte of Vim</a>, it has been going surprisingly well. Becoming a competent vim user has made the Linux experience even more rewarding.