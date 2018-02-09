---
wordpress_id: 292
title: ASP.NET MVC RC finally working for me
date: 2009-03-11T12:57:53+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/03/11/asp-net-mvc-rc-finally-working-for-me.aspx
dsq_thread_id:
  - "271649449"
categories:
  - ASPNETMVC
redirect_from: "/blogs/jimmy_bogard/archive/2009/03/11/asp-net-mvc-rc-finally-working-for-me.aspx/"
---
It’s been about 4 misfires, but I’ve finally upgraded my local machine to the RC2 of ASP.NET MVC.&#160; What was holding me back?&#160; Every time I opened a WebForms page (.aspx, .ascx, .master), Visual Studio would hard-crash on me.&#160; Open a WebForms file, VS would just disappear, gone.&#160; No error message except for an ever-so-informative entry in the Windows application log.

It turned out to be a CLR…bug? feature?&#160; Phil Haack posted about a fix for it:

[http://haacked.com/archive/2009/03/06/hotfix-for-installing-aspnetmvc.aspx](http://haacked.com/archive/2009/03/06/hotfix-for-installing-aspnetmvc.aspx "http://haacked.com/archive/2009/03/06/hotfix-for-installing-aspnetmvc.aspx")

Now, a couple of things you probably want to do:

  * Install the [hotfixes for previous frameworks](http://www.microsoft.com/downloads/details.aspx?FamilyID=98E83614-C30A-4B75-9E05-0A9C3FBDD20D&displaylang=en) (thanks, [Jeffrey](http://jeffreypalermo.com/))
  * Install the CORRECT VERSION of the .NET 3.5 SP1 hotfix

Pay attention to that last one, the download site doesn’t say what hotfix file goes for what operating systems.&#160; I’m on Server 2008 x64, which evidently means use the file with “Windows6.0” in the name, and the correct platform (x64, x86 etc.)

Me, I installed the wrong version, and the crashing continued.&#160; Make sure you restart your machine as well, whether it prompts you to do so or not.&#160; I confirmed this hotfix works for the following VS add-ins:

  * Gallio
  * ReSharper
  * TestDriven.NET