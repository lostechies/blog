---
wordpress_id: 330
title: 'Multiple External Monitors On MacBook Pro: Don&#8217;t Bother&#8230; Yet'
date: 2011-05-13T10:42:32+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=330
dsq_thread_id:
  - "302906869"
categories:
  - OSX
  - Product Reviews
  - Tools and Vendors
---
I&#8217;ve been running a 3-monitor set up on a macbook pro for the last year and a half. Here&#8217;s a pic of what it looks like;

<img title="NewImage.png" src="http://lostechies.com/content/derickbailey/uploads/2011/05/NewImage.png" border="0" alt="NewImage" width="600" height="448" />

The model of macbook pro that I have only has one mini display port. To accomplish this setup, the monitor on the far right uses a usb video adapter. I&#8217;ve tried a few different models and I settled on an [EVGA UV19+](http://www.amazon.com/EVGA-100-U2-UV19-TR-Supporting-2048x1152-Resolution/dp/B003L53C2E). This runs with drivers from [displaylink.com](http://displaylink.com/). Over-all it&#8217;s a functional solution and offers the advantage of having as many monitors as I need, as long as I keep buying more of the usb vga adapters to run them.

Given the year and a half that I&#8217;ve had this setup, I thought I would take a moment to break down what works, what doesn&#8217;t work, and ultimately why I don&#8217;t think this is a good solution.

 

## The Good

**Massive real-estate for keeping things open and in sight all day long.** 

I use my left monitor (the laptop itself) for communications: skype, instant messenger, twitter, etc. There are also times when I move a browser window over here so I can do testing of multiple browsers while having them all open. My middle monitor is typically where I do my real work &#8211; code, terminal windows, writing this blog post, etc. It&#8217;s my primary focus visually, so my primary work goes here. My right monitor, being run by the usb adapter, is relegated to non-critical and non-ui intensive work. this is typically where i keep my browsers, documents that i am referencing, etc.

The additional real estate of the extra monitor is so nice that I rarely even use Spaces in OSX. I have 4 spaces configured on my system, but I only use the first space most of the time. some times I put iTunes or the Rdio player in another space, but that&#8217;s about it. I just don&#8217;t have a need for spaces.

**The DisplayLink Drivers Are Nearly Rock Solid**

They work well and I have zero crashes with them anymore (though the early beta days for OSX 64bit were pretty bad). After installing the drivers, your 3rd monitor will be represented in OSX as an actual monitor. You can use it as if it were plugged into any legitimate monitor port on the box. It shows up in the system&#8217;s monitor settings, can be made the primary monitor, etc.

**Yes, It Even Does Video**

Although I wouldn&#8217;t play video games on it, I often stream youtube or netflix video to this monitor via my browser. It works just fine as long as I don&#8217;t have any other CPU intensive apps open and running at the time&#8230; which leads me to &#8230;

 

## The Bad

**It&#8217;s a USB Device, Not A Hardware Video Card**

The displaylink driver uses your system&#8217;s CPU to power the monitor. Granted, it is a very efficient driver and it only uses a fraction of the CPU to maintain the monitor&#8217;s state, when there are no UI updates occuring. When any UI updates are occurring on that monitor, though, the CPU usage jumps up pretty quickly. The device I bought has a night little glowing light on it that flickers whenever the monitor is receiving updates. Generally, it stays solid while I&#8217;m just reading a website, except when scrolling or moving the mouse. However, when you try to play any video or flash, or anything else video intensive, the CPU usage will spike and the system fans will come up to speed pretty quickly. It&#8217;s very CPU intensive to play video through this device. All of that CPU power is sucked away from the rest of your system and your running apps, too.

**It&#8217;s Fairly Expensive**

I paid $90 for the usb device and $250 for the monitor. That&#8217;s an extra $340 total, to get this setup, not including any adapter cables I had to buy, etc. My middle monitor and right hand monitor are the same. At $250 each + the $90 for the device, I could have spent the $590 on a much larger monitor that did not take up my CPU power and used a tool like [SizeUp](http://irradiatedsoftware.com/sizeup/) to manage the space that I have with only 2 monitors instead of 3.

 

## **The Ugly**

It&#8217;s not all rainbows and unicorns. Every now and then the unicorn farts and the rainbow leads me to an angry leprechaun guarding the gold.

**Some Apps Hate The Displaylink Driver**

Especially Appl&#8217;s built-in OSX apps&#8230; for example, I can&#8217;t press cmd-shft-4 to take a screen shot of anything on that monitor. It just doesn&#8217;t work&#8230; at all&#8230; ever. I have to move whatever I&#8217;m doing onto my middle monitor to get the screen shot. Sure, apps like Skitch and cl.ly work fine on that monitor, but there&#8217;s obviously something a little funky going on  if apple&#8217;s built in software doesn&#8217;t work.

**Some Apps Crash Because Of It**

I&#8217;ve been using the [Sparrow Mail app](http://sparrowmailapp.com/) for some time now. In the early beta days, it worked perfectly and I loved it. However, with more recent releases of Sparrow, something about the displaylink driver is incompatible with it.

Here&#8217;s the worst of all the ugly: when I run sparrow while I have my displaylink monitor up, sparrow will randomly freeze up and eventually crash OSX Finder. Yes, that&#8217;s right &#8211; OSX Finder&#8230; not just Sparrow. I have no clue what&#8217;s going on or why it&#8217;s happening. When I try to reply to an email, open an email, or even just open the sparrow UI, all of Finder and every app that I currently have open will just die instantly. It all goes down and my screens go blank. Then I&#8217;ll see Finder coming up again and reloading itself&#8230; but none of my apps will be in memory anymore. Everything I had been doing is gone and dead, crashed with no warning or possibility of recovery.

It SUUUUUUUUuuuuuuuuuckks&#8230;

And by the way: it&#8217;s not just the EVGA device that does this. All of the usb adapters that I&#8217;ve tried have this problem. And yes, it is due to the displaylink drivers. When I unplug the displaylink adapter and run with only 1 external monitor out of the mini displayport, I never have any issues with Sparrow or any other apps.

 

**NOTE:** I want to point out that the sparrow support team has put in more than a fair amount of effort to try and help me resolve the issues. I still love Sparrow and really want to use it&#8230; which brings me to &#8230;

 

## **Conclusion: It&#8217;s Just Not Worth It, Yet**

Given the advantages of having three monitors, the high CPU usage, the additional cost and the OSX-killing nature of the displaylink + sparrow combination, I cannot recommend this setup to anyone.

If you are seriously considering a 3rd monitor for your macbook pro&#8230; STOP. Stay away from the USB adapaters. **Don&#8217;t bother with it until we start seeing legitimate video card/enclosures for the new thunderbolt port on the latest generation macbook pros.** Spend your money on a larger, better, single external monitor with much more real-estate in terms of pixels and size, and then use SizeUp to manage the space on that window.

Now I need to figure out what I&#8217;m going to do with all of these left-over usb video adapters and 2x 24&#8243; 1080P monitors, while I try to save up to buy a 30&#8243; monitor to replace them both&#8230;