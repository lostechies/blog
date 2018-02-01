---
id: 131
title: Customer-facing identifiers
date: 2008-01-17T15:48:21+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/01/17/customer-facing-identifiers.aspx
dsq_thread_id:
  - "264715517"
categories:
  - DomainDrivenDesign
---
I&#8217;m still installing miscellaneous drivers for my work laptop (Dell Inspiron 1501).&nbsp; I just downloaded an additional printer driver for an office printer, but can anyone tell me in less than 5 seconds, without Googling, which file is the printer driver?

 ![](http://grabbagoftimg.s3.amazonaws.com/crazy_drivers.PNG)

Unless you have Internet access, you&#8217;ll have a tough time guessing which is which.&nbsp; That doesn&#8217;t really help me when one of the drivers I&#8217;m installing is the network driver, and therefore have no Internet access yet.

I think this is a prime example of technical data making its way to the customer&#8217;s eyes, when it shouldn&#8217;t.&nbsp; Nothing on these files gives any indication what the driver is for.&nbsp; I understand needing to have some identifying values on the file name for support purposes, but can I at least get a category in the file name? At least twice I&#8217;ve clicked and guessed wrong this week.

I was on a product team once that used GUIDs for all entity identifiers.&nbsp; Unfortunately, we also forced the users to use the GUIDs to load any entity from our API, but provided no way to easily extract them from any user interface.&nbsp; End users had to manually type in all 32 hexadecimal characters from going back and forth from the screen to the code.&nbsp; The irate emails cascaded down, and we didn&#8217;t make that mistake again.

Customers care about identity, they want to know that they&#8217;re retrieving the right customer, and that the customer they&#8217;re retrieving isn&#8217;t duplicated.&nbsp; Developers sometimes make the mistake that customers always care about **how the identity is maintained**, through a GUID or otherwise.&nbsp; Under most circumstances, they don&#8217;t, so we shouldn&#8217;t force our special internal technical solutions for identities on customers and end users.&nbsp; It&#8217;s one of the quickest ways to confuse them.