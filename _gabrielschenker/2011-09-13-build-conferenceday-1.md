---
wordpress_id: 68
title: BUILD conference–day 1
date: 2011-09-13T21:33:55+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/2011/09/13/build-conferenceday-1/
dsq_thread_id:
  - "413917998"
categories:
  - Conference
  - Windows
---
[<img style="background-image: none; border-bottom: 0px; border-left: 0px; margin: 0px 5px 24px 0px; padding-left: 0px; padding-right: 0px; display: inline; float: left; border-top: 0px; border-right: 0px; padding-top: 0px" title="Slate PC Samsung 700T1A Serie 7" border="0" alt="Slate PC Samsung 700T1A Serie 7" align="left" src="https://lostechies.com/content/gabrielschenker/uploads/2011/09/Slate-PC-Samsung-700T1A-Serie-7_thumb.jpg" width="244" height="191" />](https://lostechies.com/content/gabrielschenker/uploads/2011/09/Slate-PC-Samsung-700T1A-Serie-7.jpg)Day one is over and my head is packed with new information and impressions. It was a heavy dose of new stuff that was presented to us. But I have to admit, for the first time since many years I feel excited about what I saw and what I heard. And believe me, it’s not only because of the nice Samsung 700T1A tablet PC we got with pre-installed Windows 8, no it’s because of Windows 8 itself.

Windows 8 will run everywhere on big servers sitting in the data center as well as on the small gadget we carry around all day with us. this makes it much easier for us developer to come up with applications that run on a huge array of different devices having different form factors.

Windows 8 will continue to support all applications that currently run on Windows 7. These applications will act and feel exactly the same way as they currently do on Windows 7. But then there will be the new Metro style applications which are unique to Windows 8 (and thus will not run on any older version of Windows). 

The new type of applications can be developed either in a managed language like C# or VB using XAML as the layout “language” or in JavaScript using HTML5 and CSS as the layout language. Even C++ can be used in conjunction with XAML to produce native Metro applications.

Microsoft has completely rewritten the XAML stack and based it fully on DirectX. Yes, that is amazing, not only will XAML be supported in the future but it has been radically improved.

Expression Blend 5 can now be used to edit XAML templates as well as HTML templates. That was another nice thing to hear since Blend is a really powerful and cool tool to do UI design. Expression Blend and Visual Studio work hand in hand.

The new Windows 8 Metro interface actually makes a lot of sense. One of its key paradigms is “content over chrome”, which means that we developer should more focus on presenting content to the user than unnecessary clutter around it. Windows 8 will also make sure that in the future any screen is a multi-touch surface. Using our fingers will become another natural way of doing things on a computer as it is already the case with keyboards and mice. Yes, keyboards and mice will not be replaced. There is no better tool to enter large amounts of text than a keyboard and there is hardly a better device than a mouse (or track ball) to precisely position or move things on the screen. On the other hand there are many areas where it just feels more natural and direct to use our fingers than the keyboard or mouse. If you use a smart phone with a big touch screen then you know what I’m talking about.

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; margin: 0px 0px 15px; padding-left: 0px; padding-right: 0px; display: inline; float: right; border-top: 0px; border-right: 0px; padding-top: 0px" title="Windows8" border="0" alt="Windows8" align="right" src="https://lostechies.com/content/gabrielschenker/uploads/2011/09/Windows8_thumb.jpg" width="473" height="266" />](https://lostechies.com/content/gabrielschenker/uploads/2011/09/Windows8.jpg)All Metro type applications will sit on top of the new WinRT API. This API provides the applications access to the underlying system. It is possible to access the file system or network resources as well as devices in an easy and straight forward manner. We can e.g. create a Web application and write JavaScript code which accesses, to give a sample, the camera of the device it is running on and take the pictures and movies produced by this camera and save them on the local hard disk. But wait, isn’t that dangerous? Luckily the security system will prevent the application in doing so without the users explicit consent.

I am very pleased to hear that maximizing the performance of the system while minimizing the required resources was one of the main goals while developing Windows 8. We have seen numerous samples how Windows 8 performed better than Windows 7 on the same hardware.

I am looking forward to day 2 presenting us much more in depth information about various areas of this new version of Windows.