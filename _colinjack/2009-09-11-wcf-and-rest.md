---
wordpress_id: 4653
title: WCF and REST
date: 2009-09-11T23:53:00+00:00
author: Colin Jack
layout: post
wordpress_guid: /blogs/colinjack/archive/2009/09/12/wcf-and-rest.aspx
categories:
  - REST
  - WCF
redirect_from: "/blogs/colinjack/archive/2009/09/12/wcf-and-rest.aspx/"
---
I&#8217;m on a project that was using WCF and we&#8217;ve managed to make the transition to using REST (well, to be honest so far its just POX). 

REST is a joy and I really find it such a pleasant experience compared to RPC let alone WS-*. 

However WCF and REST just are not good bed fellows which is a big problem. Some of the problems are that it doesn&#8217;t support linking out of the box, content negotiation isn&#8217;t there, no support for common HTTP/REST patterns, it limits the design/granularity of your resource handlers (MVC controllers), and the REST starter kit (at least when I looked at it) was appalling.

There are also lots of annoyances that you only discover when you come to use it and unfortunately, as [Seb](http://serialseb.blogspot.com/) discovered when he developed our REST framework on top of WCF, WCF lacks some key extension points meaning you end up having an extremely painful time getting the functionally you need.

Anyway the point of this post isn&#8217;t to beat up on WCF, it is just to make you aware of the issues. If all you want to be able to do is a bit of simple CRUD then you might find WCF to be a good solution, however just be aware that it isn&#8217;t designed to scale out to handle more interesting problems or more RESTful solutions. I&#8217;m also not really sure it gives you&nbsp;much, when&nbsp;compared to a proper REST framework or even building on top of ASP.NET MVC.

On the plus side the WCF team did contact me and Seb and we gave feedback which apparently will feed into a release post-WCF 4. However my feeling is that if they don&#8217;t really make improvements then WCF will lose out to some of the great REST frameworks that are now appearing in .NET-land.