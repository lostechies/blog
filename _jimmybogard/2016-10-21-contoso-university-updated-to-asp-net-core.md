---
id: 1231
title: Contoso University updated to ASP.NET Core
date: 2016-10-21T15:33:27+00:00
author: Jimmy Bogard
layout: post
guid: https://lostechies.com/jimmybogard/?p=1231
dsq_thread_id:
  - "5241607734"
categories:
  - ASPNetCore
---
I pushed out a new repository, [Contoso University Core](https://github.com/jbogard/contosouniversitycore), that updated my “how we do MVC” sample app to ASP.NET Core. It’s still on full .NET framework, but I also plan to push out a .NET Core version as well. In this, you can find usages of:

  * [AutoMapper](https://github.com/automapper/automapper)
  * [MediatR](https://github.com/jbogard/mediatr)
  * [HtmlTags](https://github.com/HtmlTags/htmltags)
  * [FluentValidation](https://github.com/JeremySkinner/FluentValidation)
  * Repositories <- HAHA just kidding. No repositories here.
  * [Feature folders](http://timgthomas.com/2013/10/feature-folders-in-asp-net-mvc/)
  * [CQRS](https://lostechies.com/jimmybogard/2015/05/05/cqrs-with-mediatr-and-automapper/)
  * [Vertical slice architecture](https://vimeo.com/131633177)
  * [Hybrid server/client-side validation](http://timgthomas.com/2013/09/simplify-client-side-validation-by-adding-a-server/)

It uses all of the latest packages I’ve built out for the OSS I use, developed for ASP.NET Core applications. Here’s the Startup, for example:

[gist id=afc1a608bcba6108166a9982deddc8e6]

Still missing are unit/integration tests, that’s next. Enjoy!