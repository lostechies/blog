---
id: 624
title: Custom errors and error detail policy in ASP.NET Web API
date: 2012-04-18T15:33:53+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2012/04/18/custom-errors-and-error-detail-policy-in-asp-net-web-api/
dsq_thread_id:
  - "654760139"
categories:
  - ASPNETMVC
  - ASPNETWebAPI
---
Today Kurt and I were attempting to debug an Web API service we had deployed to a remote machine. The service was returning 500 errors, and for various reasons, we couldn’t just try to do the requests from that deployed box. We wanted to get the full exception details in the response, but we were just seeing blank 500 errors, with no responses.

We first tried the [Web.Config setting for custom errors](http://msdn.microsoft.com/en-us/library/h0hfz6fc.aspx):

[gist id=2414073]

But this didn’t affect anything. Digging a little further, we found that ASP.NET Web API uses a different configuration for error details being passed along. This is for a couple of reasons; first, the custom errors element in the Web.Config is an ASP.NET thing. It’s something that ASP.NET uses to determine if that yellow screen of death with additional detail should be shown to users. However, ASP.NET Web API is [designed to be self-hosted](http://www.asp.net/web-api/overview/hosting-aspnet-web-api/self-host-a-web-api), _outside_ of ASP.NET and IIS. While the customErrors element affects requests for ASPX and MVC, it does nothing for Web API.

Instead of relying on a lot of XML configuration, Web API uses a lot of programmatic configuration. This helps self hosting, but for changing policies like error detail, we have to change the code, re-compile and re-deploy. To set the error policy in our application, we need to modify our global Web API configuration:

[gist id=2414115]

With this mode, requests from any source will get us full exception detail. It’s likely not something we want in production, but nice that it is available. We have three familiar options for the IncludeErrorDetailPolicy setting:

  * LocalOnly (default)
  * Always
  * Off

These correspond 1:1 to the customErrror policy in their behavior, but in the reverse. The ASP.NET customErrors setting talks about when to custom errors, where Web API is when to display exception details. Same settings, but approaching from opposite ends.

What if we want to just have Web API use whatever setting that our Web.Config uses? We can just read the ASP.NET setting and apply it to our Web API config:

[gist id=2414303]

With this approach, we just set one policy for custom errors in our Web.Config file, and both our MVC/WebForms and WebAPI requests in the same application use the exact same policy, and we have the ability to change this policy after we deploy.