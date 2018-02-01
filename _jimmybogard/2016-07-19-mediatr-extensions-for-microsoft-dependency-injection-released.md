---
id: 1223
title: MediatR Extensions for Microsoft Dependency Injection Released
date: 2016-07-19T19:07:29+00:00
author: Jimmy Bogard
layout: post
guid: https://lostechies.com/jimmybogard/?p=1223
dsq_thread_id:
  - "4998242058"
categories:
  - ASPNetCore
  - MediatR
---
To help those building applications using the new Microsoft DI libraries (used in Orleans, ASP.NET Core, etc.), I pushed out a helper package to register all of your MediatR handlers into the container.

[MediatR.Extensions.Microsoft.DependencyInjection](https://www.nuget.org/packages/MediatR.Extensions.Microsoft.DependencyInjection)

To use, just add the AddMediatR method to wherever you have your service configuration at startup:

[gist id=33651fe32576b7db3619ec5bd8fc0bc0]

You can either pass in the assemblies where your handlers are, or you can pass in Type objects from assemblies where those handlers reside. The extension will add the IMediator interface to your services, all handlers, and the correct delegate factories to load up handlers. Then in your controller, you can just use an IMediator dependency:

[gist id=650d66db5ca3aee62c014162d59c2cf6]

And you’re good to go. Enjoy!