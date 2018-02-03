---
wordpress_id: 160
title: Controller bloat?
date: 2008-03-20T02:44:27+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/03/19/controller-bloat.aspx
dsq_thread_id:
  - "264715607"
categories:
  - ASPNETMVC
  - MonoRail
---
Some of my background information first:

  * 2 years classic ASP (ASP 3.0)
  * 5 years ASP.NET
  * 1-2 months MonoRail
  * 10 minutes ASP.NET MVC
  * ~45 seconds Ruby on Rails

That&#8217;s the sum of my experience with different web application frameworks.&nbsp; Obviously it&#8217;s weighted towards ASP.NET WebForms.&nbsp; Having completed a project with MonoRail and looking at ASP.NET MVC, I can&#8217;t help but feel that the Controller and the accompanying Context objects seem bloated.

Now, I&#8217;ve already shown I&#8217;m no MVC expert, not even close.&nbsp; But this seems a little bloated for something that&#8217;s supposed to be lightweight:

 ![](http://grabbagoftimg.s3.amazonaws.com/monorail_controller.png)

Sorry about the size, but it&#8217;s nice to see it in all its glory.&nbsp; That&#8217;s the MonoRail Controller and RailsEngineContext (the HttpContext-like object of MonoRail).&nbsp; Controller depends quite a bit on the IRailsEngineContext, so you can&#8217;t really do much with a Controller in a unit test without mocking out the entire IRailsEngineContext and all of its properties (IResponse, IRequest, etc.).

Here&#8217;s the ASP.NET MVC Controller and Context from the Preview 2 drop:

![](http://grabbagoftimg.s3.amazonaws.com/aspnetmvc_controller.png)

The Controller is smaller, but the Context is larger.&nbsp; Again, the Controller makes heavy use of the HttpContextBase (formerly IHttpContext), as shown in Scott Hanselman&#8217;s recent podcasts.

Having next to zero experience with other MVC frameworks like Rails or Merb, I&#8217;m really curious to see how lightweight their controllers are.&nbsp; I&#8217;m not sure lightweight controllers matters, or if the idea of a POCO controller would do anything.&nbsp; Since we have to inherit from a Controller base class, we&#8217;re saddled with its weight.

I&#8217;ll repeat again: I&#8217;m not an MVC expert.&nbsp; But these controllers seem bloated to me and their accompanying Context objects seem bloated, as if I need to give the controller the IKitchenSink to get it to work under test.&nbsp; Does anyone else get this feeling too?