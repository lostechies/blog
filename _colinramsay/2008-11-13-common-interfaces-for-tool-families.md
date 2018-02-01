---
id: 17
title: Common Interfaces for Tool Families
date: 2008-11-13T10:05:00+00:00
author: Colin Ramsay
layout: post
guid: /blogs/colin_ramsay/archive/2008/11/13/common-interfaces-for-tool-families.aspx
categories:
  - softwaredesign
---
There are a load of different tool &#8220;families&#8221; in use in the .NET ecosystem which I&#8217;m sure LosTechies readers will take advantage of pretty much every day. IoC containers. Logging infrastructures. URL routing mechanisms. Each of these families operate on broadly similar principals &#8211; taking the container example, we know that we need to add types to the container and resolve types which are already in there. For logging, we&#8217;d generally have the ability to log to different levels of severity. So you can see that while the implementations and underlying behaviour may be significantly different, there is a layer of abstraction which highlights commonality.

Castle Project has a Castle.Core.Logging.ILogger class which supports the use of a variety of different logging systems within your applications. It is a facade behind which log4net or NLog does the magic while your application happily logs information while not worrying about what is actually taking care of the logging. To me, this is a very interesting method of supporting a tool family &#8211; expose the most common methods which a tool supports and let the tool get on with its own business.

What I&#8217;d like to see is a community effort to publish an ILogger interface to which various logging libraries can adhere, and an IContainer interface for IoC libraries, and other interfaces for various tool families which have enough common features. In this way, we can enable a new level of code sharing and integration between projects.

(Also published on [my personal blog](http://colinramsay.co.uk/diary/2008/11/16/common-interfaces-for-tool-families/))