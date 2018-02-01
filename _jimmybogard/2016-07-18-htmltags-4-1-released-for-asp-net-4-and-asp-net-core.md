---
id: 1219
title: HtmlTags 4.1 Released for ASP.NET 4 and ASP.NET Core
date: 2016-07-18T18:20:43+00:00
author: Jimmy Bogard
layout: post
guid: https://lostechies.com/jimmybogard/?p=1219
dsq_thread_id:
  - "4995456998"
categories:
  - ASPNetCore
  - ASPNETMVC
---
One of the libraries that I use on most projects (but probably don’t talk about it much) is now updated for the latest ASP.NET Core MVC. In order to do so, I broke out the classic ASP.NET and ASP.NET Core pieces into separate NuGet packages:

  * [HtmlTags](https://www.nuget.org/packages/HtmlTags/)
  * [HtmlTags.AspNetCore](https://www.nuget.org/packages/htmltags.aspnetcore)

Since ASP.NET Core supports DI from the start, it’s quite a bit easier to integrate HtmlTags into your ASP.NET Core application. To enable HtmlTags, you can call AddHtmlTags in the method used to configure services in your startup (typically where you’d have the AddMvc method):

[gist id=55e7c83dcdb39c32deab9c1548184e74]

The AddHtmlTags method takes a configuration callback, a params array of HtmlConventionRegistry objects, or an entire HtmlConventionLibrary. The one with the configuration callback includes some sensible defaults, meaning you can pretty much immediately use it in your views.

The HtmlTags.AspNetCore package includes extensions directly for IHtmlHelper, so you can use it in your Razor views quite easily:

[gist id=271d029f70940fc09c6fdf659fba4f9f]

Since I’m hooked in to the DI pipeline, you can make tag builders that pull in a DbContext and populate a list of radio buttons or drop down items from a table (for example). And since it’s all object-based, your tag conventions are easily testable, unlike the tag helpers which are solely string based.

Enjoy!