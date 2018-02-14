---
wordpress_id: 427
title: AutoMapper upgraded to .NET 4 and VS 2010
date: 2010-08-17T13:01:18+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/08/17/automapper-upgraded-to-net-4-and-vs-2010.aspx
dsq_thread_id:
  - "264716571"
categories:
  - AutoMapper
redirect_from: "/blogs/jimmy_bogard/archive/2010/08/17/automapper-upgraded-to-net-4-and-vs-2010.aspx/"
---
In the [last post](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/08/05/oss-and-the-net-framework-upgrade.aspx), I posed the question on what to do with .NET framework upgrades and OSS support.&#160; I wanted to upgrade AutoMapper to .NET 4, but I didn’t want to leave a lot of folks behind because their project isn’t .NET 4.&#160; I had a couple of choices:

  * Call the last release (1.1) the last official .NET 3.5 release
  * Branch it and allow both to live side-by-side

Since option #2 didn’t really cause me much extra overhead, I went for that one.&#160; To upgrade, I first needed to create a remote branch on github:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_27123F22.png" width="287" height="186" />](http://lostechies.com/content/jimmybogard/uploads/2011/03/image_7586D18C.png) 

Creating a remote branch in git is a little esoteric, as for the most part, git _wants_ to be local.&#160; To create this remote branch, I just ran:

  * git push origin origin:refs/heads/NET35

More than a little esoteric, but whatever.&#160; To then start using this remote branch, I needed to create a remote tracking branch to make it easier to push and pull:

  * git checkout –track –b NET35 origin/NET35

And now my local repository has both remote branches being tracked:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_1B104EEE.png" width="507" height="116" />](http://lostechies.com/content/jimmybogard/uploads/2011/03/image_6D8F2F2A.png) 

With both branches going, I now set about upgrading the AutoMapper to .NET 4.

### 

### Upgrading the project

Upgrading the AutoMapper code to VS 2010 and .NET 4 was easy enough.&#160; I just opened the VS 2008 solution in VS 2010, and the upgrade wizard properly upgraded everything.&#160; Upgrading the solution files does not change the target framework, so I still needed to modify all of the project files to target .NET 4:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_3DF1109E.png" width="494" height="235" />](http://lostechies.com/content/jimmybogard/uploads/2011/03/image_05B29986.png) 

That was easy enough, and all tests immediately passed.&#160; I decided to leave the Silverlight 3.0 projects out of the equation, I still need a better way to support multiple runtimes easily.&#160; Some of the app.config files were automatically modified, but there were really no problems upgrading the actual projects to .NET 4.

Upgrading the build, however, was a completely different story.

### Upgrading the build

Most of the build tools I used, including NUnit and psake, were still targeting .NET 3.5.&#160; To upgrade these, I first needed to download the latest [psake](http://github.com/JamesKovacs/psake) and include the following configuration in my build script:

$framework = &#8216;4.0&#8217;

This told psake to use the .NET 4 framework.&#160; Next, I needed to tell NUnit to target the .NET 4 framework.&#160; I was able to do this by adding the “supportedRuntime” element:

<startup>   
&#160;&#160;&#160; <requiredRuntime version="v4.0.20506" />   
</startup>

I stuck this in my “nunit-console-x86.exe.config” file, where it already had a commented-out section for me to edit.

The last part I needed to fix was the [ILMerge](http://research.microsoft.com/en-us/people/mbarnett/ilmerge.aspx) call in my build script.&#160; This was much trickier.&#160; I needed to modify the call to ILMerge to include the _path_ to the .NET framework.&#160; Previously, I only needed to include the version.&#160; I created a PS function to get the framework directory:

function Get-FrameworkDirectory()   
{   
&#160;&#160;&#160; $([System.Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()   
&#160;&#160;&#160;&#160;&#160;&#160;&#160; .Replace("v2.0.50727", "v4.0.30319"))   
}

Quite lame, as I get the current runtime path and replace the folder name of the .NET 2 version number with .NET 4.&#160; I’m sure there are better ways, but hey, it works.

Finally, I just created a property to hold this value:

$framework_dir = Get-FrameworkDirectory

And modified the call to ILMerge to include this value:

ilmerge.exe /targetplatform:"v4,$framework_dir"

Once all that was done, I created a second build on the TeamCity CodeBetter build server:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_58BD36AA.png" width="500" height="213" />](http://lostechies.com/content/jimmybogard/uploads/2011/03/image_325B535F.png) 

That’s pretty much it.&#160; It was a little hairy upgrading the build, but that’s only because of the tools I use.&#160; If I didn’t have Stack Overflow, it would have been much more difficult 🙂

### 

### Support

The idea going forward is to apply pull requests and bug fixes to the .NET 3.5 branch, but not any new feature work.&#160; I’m not going to delete that branch, so anyone wanting to add new features just needs to fork that branch and send pull requests.&#160; Because branches are so easy to manage in github, there’s really no reason for me to just kill the .NET 3.5 version.

Otherwise, I’m getting started on the master branch on version 2.0 work.&#160; For those that have forked master and want to now point to the NET35 branch, you can just update your local upstream remote to point to the different branch.