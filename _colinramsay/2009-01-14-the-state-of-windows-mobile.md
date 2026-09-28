---
wordpress_id: 4691
title: The State of Windows Mobile
date: 2009-01-14T12:57:00+00:00
author: Colin Ramsay
layout: post
wordpress_guid: /blogs/colin_ramsay/archive/2009/01/14/the-state-of-windows-mobile.aspx
categories:
  - Compact Framework
  - windows mobile
redirect_from: "/blogs/colin_ramsay/archive/2009/01/14/the-state-of-windows-mobile.aspx/"
---
&ldquo;Have you done any Windows Mobile development?&rdquo;
  
&ldquo;A tiny bit. Isn&rsquo;t it just like Winforms but on a phone?&rdquo;

And from such an innocent beginning, a world of pain did explode into my universe. Just like Winforms on a phone is it? What&rsquo;s the difference between the Compact Framework, Smartphone development, Pocket PC development, Windows Mobile? So many terms! So little time!

Windows Mobile is the operating system, just like Windows Vista. The Compact Framework is just like the .NET Framework on the desktop. As for the difference between a Smartphone and a Pocket PC, well, you&rsquo;ve got me there. I picked Smartphone because my device had phone functionality and it seems to be working so far. There are separate SDKs for each, so I assume there are some key differences which escape me. With Windows Mobile 6, the Smartphone and Pocket PC SDKs are now Windows Mobile 6 Standard and Windows Mobile 6 Professional, respectively. I think.

Actually I think the real difference in these is the templates for projects you create and the emulators you are provided with. Professional, or Pocket PC, provides emulators for bigger screens. Microsoft has [this to say](http://www.microsoft.com/downloads/details.aspx?familyid=06111A3A-A651-4745-88EF-3D48091A390B&displaylang=en) about the naming kerfuffle:

> With Windows Mobile 6, we are revising our SKU taxonomy and naming to better align our brand and products with the realities of today&rsquo;s mobile device marketplace. The historical form-factor based distinction between Windows Mobile powered Smartphone and Windows Mobile powered Pocket PC Phone Edition is blurring dramatically. We want our taxonomies and terminology to evolve to better reflect the evolution of the mobile device industry.

So in order to reflect the blurring of the mobile device form factors, they&rsquo;ve changed from having SDKs named after the types of device to SDKs named &ldquo;Standard&rdquo; and &ldquo;Professional&rdquo;. Hmm. How about having a single SDK called &ldquo;Mobile Device SDK&rdquo; and allow me to pick the device dimensions from within my project on the fly? Back at the start of this tale, I assumed that picking Windows Mobile for development would allow us to target a range of different devices, large and small, and in fact I can do that. I can deploy my application to a Windows Mobile phone with a big screen and to one with a small screen. The SDK split seems pretty artificial with that in mind.

Naming conventions and confusions aside, it is nice to be able to write against a single API and deploy to any Windows Mobile device. Or it would be if it worked.

My bugbear here is with a particular class: CameraCaptureDialog. Take the Samsung Omnia for example. You can certainly pop up the camera using CCD.ShowDialog(), but can you retrieve the filename of the image you took? You cannot. That&rsquo;s because the Omnia&rsquo;s camera supports taking multiple images one after the other until you explicitly close it.

How about the HTC Diamond? Well that opens fine, and returns a filename too, but if you try and re-open the camera straight after processing the filename, to allow the user to take another photo, it fails silently and doesn&rsquo;t show the camera. If you try and do the same thing with the HTC Touch, it freezes.

Part of the issue is that the Compact Framework leaves too much up to the manufacturers and doesn&rsquo;t give enough control to the developer. We can set the resolution of the camera for example, but we have no shortcut of setting it to the maximum resolution available. If you try and set it to a resolution which is not supported, some devices reset silently to a much lower resolution.

Microsoft need to extend camera support for .NET developers and give a lower level of access. They need to push device manufacturers to adhere to the Windows Mobile APIs and be more precise in how they are specified. And they need to simplify and modernise their mobile development framework so that developers can be fully aware of all the options available to them.

_This post was also published on [my personal blog](http://colinramsay.co.uk/diary/2009/01/14/the-state-of-windows-mobile/ "The State of WIndows Mobile")._