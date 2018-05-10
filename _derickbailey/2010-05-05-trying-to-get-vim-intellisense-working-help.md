---
wordpress_id: 153
title: Trying To Get Vim Intellisense Working. Help?!
date: 2010-05-05T14:14:26+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/05/05/trying-to-get-vim-intellisense-working-help.aspx
dsq_thread_id:
  - "263105777"
categories:
  - .NET
  - 'C#'
  - Tools and Vendors
  - Vim
  - Visual Studio
redirect_from: "/blogs/derickbailey/archive/2010/05/05/trying-to-get-vim-intellisense-working-help.aspx/"
---
Setup: I’m running Windows 7 x64 with gVim installed. I have Visual Studio 2008 and 2010 installed, and am trying to get [vim intellisense](http://insenvim.sourceforge.net/) up and running. This plugin provides intellisense features for languages such as C#, C++, Java, and much more. Unfortunately, I haven’t been able to get it working yet. Here’s what I have done to try, so far:

The installation wizard seemed nice. It let me select the plugins i wanted and my Vim directory.

 <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_1415F34F.png" width="513" height="399" />

I did get an error while installing this, saying there was a problem installing the C# intellisense. Opening the “cserrors.log” file in the install folder (as the error message told me to do) revealed this message:

> "Regasm is not in path. Error in installaing C# Intellisense plugin. Add regasm in path and then run reg.bat in the current directory!" 

That’s an easy fix – just open a Visual Studio Command Prompt and you’ll have the tool available:

 <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_1E6717AF.png" width="677" height="342" />

then you can run the “reg.bat” file from the “intellisense” installation folder:

 <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_368A820A.png" width="677" height="342" />

After installing, I was getting strange errors from Vim, when pressing ctl-space to bring up the intellisense window:

 <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="error detected while processing function IN_ShowVISDialog. Library call failed for StartVISDialog()" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_03BA7B96.png" width="844" height="121" />

A bit of digging around on the vim intellisense website brought me to the [C# FAQ](http://insenvim.sourceforge.net/plugin/cs/csft.html) which says:

> _You need Microsof.NET version v1.1.4322 for intellisense to work._

I downloaded of .NET 1.1 and SP1 later and it said there are incompatibilities with IIS on Win7 x64. I installed anyway, but to make sure nothing was messaged up, I re-ran the register IIS command for .net 4

> C:WindowsMicrosoft.NETFrameworkv4.0.30319>aspnet_regiis –i

After that… I’m still getting the same error messages about not being able to call the StartVISDialog() method, as shown in the previous screen shot. Has anyone been able to get Vim Intellisense working with a setup like mine? Do I need a previous version of visual studio (like 2005?) for this to work? or ??? Any help is greatly appreciated.