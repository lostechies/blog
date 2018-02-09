---
wordpress_id: 973
title: Dealing with the linker in Xamarin apps
date: 2014-11-11T16:51:47+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=973
dsq_thread_id:
  - "3214483118"
categories:
  - Xamarin
---
The last few months I’ve been working quite a bit with Xamarin and in particular [Xamarin.Forms](http://xamarin.com/forms). I’ve got a series of posts upcoming on my exploits with that and migrating to ReactiveUI, but first things first, I actually need to deploy my app.

I’ve got my app working in debug/release mode in the simulator, and debug mode on a device. However, when I ran the app in release mode on a device, it just crashed without warning. Not a very good experience. I’ve deployed this app several times on the device, but something was causing this crash.

Typically a crash on a deployment is one of two things:

  * Something off in DEBUG conditional code/config
  * Something off in DEBUG/RELEASE project config

I checked the DEBUG conditional code config, which does things like point to the test/production API endpoints. That looked OK, so what else was different? 

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="Screen Shot 2014-11-11 at 9.20.41 AM" src="http://lostechies.com/jimmybogard/files/2014/11/Screen-Shot-2014-11-11-at-9.20.41-AM_thumb.png" width="511" height="375" />](http://lostechies.com/jimmybogard/files/2014/11/Screen-Shot-2014-11-11-at-9.20.41-AM.png)

That was my debug version of the app, where no assemblies were linked. In the Release mode, only SDK assemblies were linked. For many cases, this works, as the compiler can figure out exactly what methods/fields etc. are being referenced.

Normally, this is OK, until you get a series of telling exceptions, usually a MissingMethodException. In my case, I switched my Debug settings to the same as Release, and got:

{% gist 75d57edddee82383a9bc %}

First lesson: **keep linker settings the same between build configurations**. When you encounter this sort of issue, the problem is usually the same – reflection/dynamic loading of assemblies means the linker can’t see that you’re going to access some type or member until runtime. The fix is relatively simple – force a reference to the types/members in question.

In my iOS project, I have a file called “LinkerPleaseInclude.cs”, and in it, I include all types/members referenced:

{% gist 996b8252a8343cad1ac1 %}

Completely silly, but this reference allowed my app to run with the linker in play. More info on the linker can be found on the [Xamarin documentation](http://developer.xamarin.com/guides/ios/advanced_topics/linker/).