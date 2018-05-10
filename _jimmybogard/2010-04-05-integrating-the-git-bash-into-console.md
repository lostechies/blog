---
wordpress_id: 397
title: Integrating the Git bash into Console
date: 2010-04-05T14:45:15+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/04/05/integrating-the-git-bash-into-console.aspx
dsq_thread_id:
  - "264748053"
categories:
  - Tools
redirect_from: "/blogs/jimmy_bogard/archive/2010/04/05/integrating-the-git-bash-into-console.aspx/"
---
One of the essential development tools (found on [Hanselman’s tools list](http://hanselman.com/tools)) is a better command shell.&#160; The regular “cmd.exe” that comes with every version of Windows is quite lame.&#160; [Console](http://sourceforge.net/projects/console/) offers a host of improvements over the build-in command prompt, not least of which is the tabbed interface, allowing me to have one Console window with tabs for different directories/shells.

Another cool feature of Console is that you can host different shell configurations.&#160; And since the git bash is build on top of cmd.exe, it’s pretty straightforward to plug the git bash into Console.

First things first, make sure you have msysgit installed.&#160; You can find the installation instructions from Jason’s [Git for Windows Developers](https://lostechies.com/blogs/jason_meridth/archive/2009/06/01/git-for-windows-developers-git-series-part-1.aspx) series.&#160; Next, you’ll need to install Console, which you can download from the SourceForge site.

After launching Console, we’ll need to add a new tab launcher by navigating to Edit->Settings:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_706E3275.png" width="215" height="235" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_05CBE7DE.png) 

In the Settings window that pops up, click the “Tabs” section, then the “Add” button to add a new Tab:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_2F5FB311.png" width="537" height="550" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_7001FF80.png) 

This will bring up the settings for the new tab you created.&#160; In the configuration options in the “Main” tab below, I use the following settings (without quotes):

  * Title: “git bash”
  * Icon: “C:Program Files (x86)Gitetcgit.ico”
  * Shell: “C:Program Files (x86)Gitbinsh.exe &#8211;login –i”
  * Startup dir: “C:dev”

I installed Git to the “C:Program Files (x86)Git” directory, so this might be different on your machine.&#160; The Icon setting is not necessary, but it’s nice to see the Git icon in a tab for differentiation.&#160; Click “OK” and you can now create a new Git tab:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_6E5133AC.png" width="244" height="159" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_55C1965C.png) </p> </p> 

You now have a git bash in a tabbed interface, letting you keep multiple git bashes/command prompts around at once in a nice tabbed interface:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_06749E08.png" width="396" height="172" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_1BD25370.png) 

You can add tabs for other kinds of command prompts, such as the Visual Studio command prompt (with the correct PATH variables set) and so on.&#160; Next up is trying out [posh-git](https://lostechies.com/blogs/dahlbyk/archive/2010/03/27/posh-git-release-v0-1.aspx)…