---
id: 211
title: Bootstrapping The .NET Framework Without An MSI Installer
date: 2011-01-25T14:02:00+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2011/01/25/bootstrapping-the-net-framework-without-an-msi-installer.aspx
dsq_thread_id:
  - "263190316"
categories:
  - .NET
  - Bootstrap
  - Command Line
---
I recently needed to test the idea of whether or not I could bootstrap .NET v4.0 onto a WinXP machine, from a USB thumb drive, without an application installer for the target app. The goal was to insert a thumb drive, run the app directly from the root of the thumb drive and have .NET 4 installed onto the system if it wasn&#8217;t already there, prior to the application starting up.

&nbsp;

## The High Level Process

At a very high level, this is fairly simple:

  1. Check for .NET 4
  2. If not found, install
  3. If found, or after install, launch the real app 

When I got down into the weeds of doing this, I found a few very helpful items on the interwebs. To check for a specific version of .NET, I found [this StackOverflow question](http://stackoverflow.com/questions/199080/how-to-detect-what-net-framework-versions-and-service-packs-are-installed), which has an answer that outlines the various registry entries you can look for.

> <pre>Framework Version  Registry Key<br />------------------------------------------------------------------------------------------<br />1.0                HKLMSoftwareMicrosoft.NETFrameworkPolicyv1.03705 <br />1.1                HKLMSoftwareMicrosoftNET Framework SetupNDPv1.1.4322Install <br />2.0                HKLMSoftwareMicrosoftNET Framework SetupNDPv2.0.50727Install <br />3.0                HKLMSoftwareMicrosoftNET Framework SetupNDPv3.0SetupInstallSuccess <br />3.5                HKLMSoftwareMicrosoftNET Framework SetupNDPv3.5Install <br />4.0 Client Profile HKLMSoftwareMicrosoftNET Framework SetupNDPv4ClientInstall<br />4.0 Full Profile   HKLMSoftwareMicrosoftNET Framework SetupNDPv4FullInstall<br /></pre>

The answer goes on to detail other aspects, such as service packs, but this information was sufficient for my needs.

I also grabbed a copy of the [stand-alone .NET 4 Redistributable package](http://www.microsoft.com/downloads/en/details.aspx?FamilyID=0a391abd-25c1-4fc0-919f-b21f31ab88b7&displaylang=en). To be honest, the less-than 50 meg package size is rather surprising &#8211; especially when you see the greater-than 230 meg package size for .NET 3.5!

One other requirement was to prevent the user from having to click a bunch of &#8220;Next&#8221; and &#8220;License Agreement&#8221; buttons during the .NET 4 installation. I had a hard time finding documentation for the command line options online, but running the /? option against the redistributable gave me the information I needed. I ended up using &#8220;/passive /showfinalerror /promptrestart&#8221; as the options. This puts the installer into passive mode, which still displays progress but skips all the user interaction, will display an error message window if any problems occur, and will prompt the user to restart if a restart is required.

&nbsp;

## Implementing The Bootstrapper

Remember that this is a proof of concept, only, at this point. Given that and my general lack of C++ or Delphi skills (though I was a Pascal programmer back in high school, 15 years ago), I wanted to skip past the hard part of putting together a real bootstrapper executable. So&#8230; I chose to go with Windows Script Host and VBScript.

Fortunately, the WSH / VBScript documentation on MSDN is good enough to get me rolling &#8211; I haven&#8217;t done VBScript since the classic ASP days, and haven&#8217;t done VB in any form since 2005! But it all came back to me and with the help of the docs, I was able to produce this script:

> <pre>Dim WshShell, value<br />Set WshShell = WScript.CreateObject("WScript.Shell")<br /><br />ON ERROR RESUME NEXT<br /><br />Sub Run(ByVal sFile)&nbsp;&nbsp;<br />  Dim shell&nbsp;&nbsp;<br />  Set shell = CreateObject("WScript.Shell")<br />&nbsp;&nbsp;shell.Run sFile, 1, true<br />&nbsp;&nbsp;Set shell = Nothing<br />End Sub<br /><br />value = wshShell.RegRead("HKLMSoftwareMicrosoftNET Framework SetupNDPv4Install")<br />if (Err.Number &lt;&gt; 0) Or (value is nothing) then<br />&nbsp;&nbsp;Run("dotnetdotNetFx40_Full_x86_x64.exe /passive /showfinalerror /promptrestart")<br />end if<br /><br />run("My.Actual.App.exe")</pre>

Yes, that&#8217;s an &#8220;ON ERROR RESUME NEXT&#8221; in the 2nd line! ACK! I know&#8230; but we&#8217;re limited in VBScript / WSH. The reason this is needed, is the RegRead call. If the key does not exist (and it won&#8217;t, on a machine that doesn&#8217;t have .NET 4 installed), an exception is thrown. We have to prevent the exception from failing the script and this is the only way I know of to do that. We then check for the presence of an error and run the .net installer if one was encountered.

&#8230; I know&#8230; using exceptions as logic and flow control is taboo. It is just an prototype / proof of concept, though.

For a long-term solution, I would suggest C++ or Delphi. It tends to look bad when you deliver a product to a customer with a &#8220;runme.vbs&#8221; file sitting on the thumb drive. Anyone with an ounce of tech knowledge would question the legitimacy of that. This should get you started, though. And hopefully someone else will find this useful, and possibly re-write the core logic of what I&#8217;ve provided in a C++ or Delphi app that can run natively.