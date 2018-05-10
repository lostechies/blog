---
wordpress_id: 1062
title: Cross-Platform AutoMapper (again)
date: 2015-02-13T15:04:28+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=1062
dsq_thread_id:
  - "3512701798"
categories:
  - AutoMapper
---
Building cross-platform support for AutoMapper has taken some…interesting twists and turns. First, I supported AutoMapper in Silverlight 3.0 five (!) years ago. I did this with compiler directives.

Next, I got tired of compiler directives, tired of Silverlight, and went back to only supporting .NET 4.

Then in AutoMapper 3.0, I [supported multiple platforms via portable class libraries](https://lostechies.com/jimmybogard/2013/08/25/automapper-3-0-released/). When that first came out, I started get reports of exceptions that I didn’t think should ever show up, but [there was a problem](https://lostechies.com/jimmybogard/2013/09/04/automapper-3-0-portable-class-libraries-and-platformnotsupportedexception/). MSBuild doesn’t want to copy referenced assemblies that aren’t actually being used, so I’d get issues where you’d reference platform-specific assemblies in a “Core” library, but your “UI” project that referenced “Core” didn’t pull in the platform-specific assembly.

So began a journey to force the platform-specific assembly to get copied over, no matter what. But even that was an issue – I went through several different iterations of this before it finally, reliably worked.

Unless you’re on Xamarin, which doesn’t support using this method (of PowerShell scripts) to run install scripts on Mac.

Then I had a GitHub issue from [Microsoft folks asking for CoreCLR support](https://github.com/AutoMapper/AutoMapper/issues/668). And with vNext projects, the project itself describes the platforms to support, including all files in the directory. Meaning I wouldn’t be picking and choosing which files should be in the assembly or not. So, we’re back to square one.

### A new path

With CoreCLR and the vNext project style that is folder-based rather than scattershot, pick-and-choose file based, I could only get CoreCLR support working by using conditional compiler directives. This was already in AutoMapper a few places, but mainly in files between the platform specific assemblies. I’ve always had to do a little bit of this:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2015/02/image_thumb.png" width="663" height="351" />](https://lostechies.com/content/jimmybogard/uploads/2015/02/image.png)

Not absolutely horrible, but now with CoreCLR, I need to do this everywhere. To keep my sanity, I needed to include every file in every project. Ideally, I could just have the one portable library, but that won’t work until CoreCLR is fully released. With CoreCLR, I wanted to just have one single project that built multiple platforms. vNext class libraries can do this out-of-the-box:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2015/02/image_thumb1.png" width="466" height="218" />](https://lostechies.com/content/jimmybogard/uploads/2015/02/image1.png)

However, I couldn’t move all platforms/frameworks since they’re not all supported in vNext class projects (yet). I still had to have individual projects.

Back when I supported Silverlight 3 for the first time, I abandoned support because it was a huge pain managing multiple projects and identical files. With vNext project files, which just includes all files in a folder without doing any explicit adding, I could have a great experience. I needed that with my other projects. The final project structure looked like this:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2015/02/image_thumb2.png" width="273" height="189" />](https://lostechies.com/content/jimmybogard/uploads/2015/02/image2.png)

In the root PCL project, I’ll do all of the work. Refactoring, coding, anything. All of the platform-specific projects will just include all the source files to compile. To get them to do this, however, meant I needed to modify the project files to include files via wildcard:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2015/02/image_thumb3.png" width="610" height="327" />](https://lostechies.com/content/jimmybogard/uploads/2015/02/image3.png)

My projects automatically include \*all\* files within folders (I needed to explicitly specify individual folders for whatever reason). With this configuration, my projects now include all files automatically:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2015/02/image_thumb4.png" width="278" height="400" />](https://lostechies.com/content/jimmybogard/uploads/2015/02/image4.png)

I just have to be very careful that when I’m adding files, I only do this in the core PCL project, where files ARE added explicitly. There seems to be strange behavior that if I added a file manually to a project with wildcard includes, all of the files will be explicitly added. Not what I’d like.

Ultimately, this greatly simplified the deployment story as well. Each dependency only includes the one, single assembly:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2015/02/image_thumb5.png" width="552" height="229" />](https://lostechies.com/content/jimmybogard/uploads/2015/02/image5.png)

At the end of the day, this deployment strategy is best for the users. I don’t have to worry about platform-specific extension libraries, GitHub issues about builds breaking in certain environments or the application crashing in cloud platforms.

If I had to do it over again, I’m not unhappy with the middle step I took of platform-specific extension assemblies. It forced me to modularize whereas with pure compiler directives I could have accepted a spaghetti mess of code.

Eventually, I’d like to collapse all into one project, but until it’s supported, this seems to work for everyone involved.