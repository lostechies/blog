---
wordpress_id: 101
title: Progress made
date: 2007-11-15T22:15:38+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/11/15/progress-made.aspx
dsq_thread_id:
  - "264715425"
categories:
  - Testing
  - Tools
redirect_from: "/blogs/jimmy_bogard/archive/2007/11/15/progress-made.aspx/"
---
I just wanted to highlight a quote from [Scott Guthrie&#8217;s](http://weblogs.asp.net/scottgu/) [recent post on MVC](http://weblogs.asp.net/scottgu/archive/2007/11/13/asp-net-mvc-framework-part-1.aspx)&nbsp;(emphasis mine):

> VS 2008 Professional now includes built-in testing project support for MSTest (previously in VS 2005 this required a Visual Studio Team System SKU), and **our default ASP.NET MVC project template automatically creates one of these projects when you use VS 2008**.&nbsp; 
> 
> We&#8217;ll also be shipping project template downloads for NUnit, MBUnit and other unit test frameworks as well, so if you prefer to use those instead you&#8217;ll also have an easy one click way to create your application and&nbsp;have a test&nbsp;project immediately ready to use with it.

I know it&#8217;s not all the way to &#8220;convention over configuration&#8221;, but it is nice that the tool now says, &#8220;oh you want to create a website?&nbsp; Ya gonna need tests.&#8221;&nbsp; Now it&#8217;s a conscious decision on the part of the developer to &#8220;opt-out&#8221; of tests, instead of opting-in.&nbsp; Just another way a tool can help guide good decisions. 

As it&#8217;s looking like unit testing is becoming a first-class citizen in both the **tools** and the **frameworks**, I think it&#8217;s time for me to jump ship.&nbsp; Mainstream is for chumps.&nbsp; But seriously, it&#8217;s nice to see that testing concerns are becoming more mainstream, though I think that it just means the community needs to double their efforts in this precarious stage, such that growth continues in the right direction.&nbsp; I don&#8217;t want to unwind a bunch of bad design, habits, and practices just because the tooling made it easy. 

I do still get demos of &#8220;right-click class in Solution Explorer, click &#8216;Generate Unit Tests&#8217;, watch bugs disappear!&#8221;, so there&#8217;s some work needed on the marketing front.&nbsp; Unfortunately, I saw a lot of not-so-technical decision makers nodding their head and asking, &#8220;can the unit test template also do null checking?&#8221;&nbsp; &#8220;Can my tool be so awesome and RAD, can I skimp and hire brain-dead developers?&#8221;&nbsp; &#8220;Does this mean I don&#8217;t have to train people how to be good developers, just good tool-users?&#8221; 

This is a tangent, but slick tooling _can_ help lower the barrier, but it can also take the user in a direction they don&#8217;t want to go (or don&#8217;t know they _shouldn&#8217;t_ go).