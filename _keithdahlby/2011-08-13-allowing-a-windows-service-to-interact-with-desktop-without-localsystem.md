---
wordpress_id: 76
title: Allowing a Windows Service to Interact with Desktop without LocalSystem
date: 2011-08-13T17:38:35+00:00
author: Keith Dahlby
layout: post
wordpress_guid: http://lostechies.com/keithdahlby/?p=76
dsq_thread_id:
  - "385005825"
categories:
  - Uncategorized
tags:
  - build server
  - Cruise Control .NET
  - WatiN
---
One of the biggest roadblocks with getting automated browser tests (we use [WatiN](http://watin.org/ "WatiN")) running in a Windows Continuous Integration environment is figuring out how to let the build server interact with the desktop. Typically there have been two options:

  1. Don&#8217;t run your build server as a Windows Service. I don&#8217;t like this option as it&#8217;s harder to maintain.
  2. Run the build service as Local System with &#8220;Allow service to interact with desktop&#8221;. This limits your ability to manipulate the context in which builds run, for example it&#8217;s quite tricky (I believe it&#8217;s possible with [PsExec](http://technet.microsoft.com/en-us/sysinternals/bb897553.aspx "Sysinternals PsExec")) to configure Internet Explorer settings (turn off Auto-Complete, etc) for LocalSystem.
  
    [<img title="Allow service to interact with desktop" src="http://clayvessel.org/clayvessel/wp-content/uploads/2011/08/AllowServiceToInteractWithDesktop.png" alt="&quot;Allow service to interact with desktop&quot; in Windows Service Properties" width="410" height="461" />](http://clayvessel.org/clayvessel/wp-content/uploads/2011/08/AllowServiceToInteractWithDesktop.png)

A third option now is to run the build service as a user of your choice and set &#8220;Allow service to interact with desktop&#8221; through the Windows Registry. A [Code Project article](http://www.codeproject.com/KB/install/cswindowsservicedesktop.aspx "Interact With Desktop when Installing Windows Service") identified the necessary Registry setting, but still suggested the account must be LocalSystem. However, the same setting appears to work for other accounts as well. I&#8217;ve put together a simple PowerShell script to make the change; just run it with administrative privileges:

{% gist 1143996 %}

If you&#8217;re not a PowerShell person:

  1. `$svcName = Get-Service -DisplayName *cruise* | select -Exp Name`  
    Find the name of the Cruise Control service (CCService).
  2. `$svcKey = Get-Item HKLM:\SYSTEM\CurrentControlSet\Services\$svcName`  
    Grab the Registry key for the service.
  3. `$newType = $svcKey.GetValue('Type') -bor 0x100`  
    Get the Type value with the 9th bit set.
  4. `Set-ItemProperty $svcKey.PSPath -Name Type -Value $newType`  
    Set the Type value. The PowerShell Registry provider isn&#8217;t particularly intuitive here, IMO.