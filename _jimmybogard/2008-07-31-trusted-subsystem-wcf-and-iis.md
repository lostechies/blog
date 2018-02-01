---
id: 212
title: Trusted Subsystem, WCF and IIS
date: 2008-07-31T02:43:39+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/07/30/trusted-subsystem-wcf-and-iis.aspx
dsq_thread_id:
  - "268425675"
categories:
  - WCF
---
I&#8217;ve just about pulled my hair out on this one.&nbsp; This used to be very easy with ASMX:

 ![](http://grabbagoftimg.s3.amazonaws.com/trusted_subsystem.PNG)

Basically, I have IIS running as a trusted user, &#8220;Service&#8221;.&nbsp; I want WCF to run as this user for connecting to databases, etc.&nbsp; I don&#8217;t care who&#8217;s calling me, I&#8217;m in an intranet environment, and this service is open to the world.&nbsp; Unfortunately, all I can ever get is &#8220;user not associated with a trusted connection&#8221;, no matter what I do.&nbsp; I suspect it&#8217;s due to a network hop issue, or something similar.&nbsp; I can get it to work by flowing identity down, but I don&#8217;t want to do that, it&#8217;s not Trusted Subsystem.

I&#8217;ve spent about a day on two separate occasions trying to get this to work, but all examples seem to force me to set the service account on the ASP.NET side.&nbsp; But I don&#8217;t want to force clients to do any kind of security, that defeats the purpose.

The quickest way to Trusted Subsystem now is to use SQL Server authentication.&nbsp; With ASMX, I used ASP.NET configuration, along with IIS security configuration to set the identity, and it worked just fine.&nbsp; WCF works outside the ASP.NET stack, so I don&#8217;t have that luxury.&nbsp; Security in WCF is tough, kids, don&#8217;t let anyone tell you any different.

Boo.