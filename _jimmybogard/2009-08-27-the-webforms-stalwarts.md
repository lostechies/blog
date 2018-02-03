---
wordpress_id: 347
title: The WebForms stalwarts
date: 2009-08-27T12:55:01+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/08/27/the-webforms-stalwarts.aspx
dsq_thread_id:
  - "265336808"
categories:
  - ASPdotNET
---
One sentence I’d never thought I’d see describing WebForms is:

> It was perfect, and it’s acceptance was meteoric !

That’s from the [VisiCalc-WebForms comparison](http://misfitgeek.com/blog/aspnet/asp-net-mvc-is-webforms-the-visicalc-of-web-development/) of Joe Stagner.&#160; Obviously no framework is perfect, but I wouldn’t attribute its acceptance because of its quality.

When I moved from ASP classic to WebForms, the whole postback business was just completely baffling.&#160; At the time, I assumed WebForms was architected that way because the MS team knew something about web development that I didn’t.&#160; Instead, I think that WebForms was designed the way it was to convert the VB 6 masses to a familiar paradigm of controls and events.&#160; Now _that_ was successful.

WebForms did well what it set out to do – create a WinForms-like development experience on the web.&#160; Unfortunately, we wound up with ViewState and the bastardization of the Web to get there.&#160; I don’t believe WebForms were a mistake, but it’s a solution to a much smaller problem space than originally touted.&#160; If I’m building a SharePoint-like application, sure, connecting WebParts might make sense.&#160; But HTTP just isn’t that hard to do.&#160; Given routing, it might take you a week (or less) to come up with a functioning MVC framework.

But in the end, I could really care less about the WebForms stalwarts.&#160; I’ll never work with it again by choice.&#160; [Other frameworks](http://rubyonrails.org/) have found ways to make web development fun, but did so by embracing SOLID design principles and the fundamental architecture of the Web.&#160; As much as I enjoy revisionist history as the next guy, developer needs did not “evolve” into needing MVC.&#160; It’s that the WebForms architecture wasn’t really needed in the first place.&#160; But hey, if you’re the type of guy that enjoys getting poked in the eye with a sharp stick, you can have your ViewState.