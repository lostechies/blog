---
wordpress_id: 3156
title: Phil Haack posts about ASP.NET MVC
date: 2007-12-08T19:59:37+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2007/12/08/phil-haack-posts-about-asp-net-mvc.aspx
dsq_thread_id:
  - "265806002"
categories:
  - Uncategorized
---
<a href="http://haacked.com/Default.aspx" target="_blank">Phil Haack</a> has a <a href="http://haacked.com/archive/2007/12/07/tdd-and-dependency-injection-with-asp.net-mvc.aspx" target="_blank">tutorial type post</a> of usage of the new MS MVC with TDD, DI and the Repository Pattern. In the tutorial he sets up a new project, creates a repository and gets a sample app up and running with StructureMap.

As I stated in the comments of his posting there are only two things that concern me off the bat. The first thing is the fact that every action on controllers require a [ControllerAction] attribute. This is very descriptive of the controllers but really unnecessary. It adds a lot of extra typing for no real benefit. I realize they are trying to make sure that developers aren&#8217;t running around naked with scissors but descriptive documentation stating every public method will be an action would work better here. My hope is there will be some way to override this behavior.

The other thing that concerns me in&nbsp;the&nbsp;post is the way&nbsp;he is passing a parameter back to the view when calling RenderView like so: RenderView(&#8220;myview&#8221;, mycollection). I would imagine that they have a way to set parameters to an array like PropertyBag[] in MonoRail. Perhaps there is a way to accomplish this already. I haven&#8217;t really dove into the documentation for the new framework. I am trying to hold back until the CTP.

All this is great and excellent that a MS employee is now explaining how to use TDD with a new framework from MS. This is a great move on their part and I&#8217;m glad we&#8217;ve gotten this far. The new framework looks great and I&#8217;m sure it will do fine with the community.

Regardless of how awesome it looks, I do have to go back to an <a href="http://www.lostechies.com/blogs/sean_chambers/archive/2007/09/22/microsoft-s-fancy-footwork.aspx" target="_blank">older posting that I wrote</a>&nbsp;that&nbsp;describes at the end of the day, this is still a Microsoft technology. Therefore, there is no way you can take this framework and add features to it yourself, or fix bugs, or contribute to it. This fact alone makes me very nervous about using it. I don&#8217;t mean to get on an open source soap box here but these are the types of things I look at when choosing a new framework. Sure, it is made by MS, but how many times have you been burned by a MS tool? It just makes me nervous that this is not Open Source. The main reason that <a href="http://www.castleproject.org" target="_blank">MonoRail</a> has been so successful is because it is open source. They have an extremely large number of contributors that help make MonoRail successful.

Anyway&#8217;s, before I piss of too many people I will say farewell and I am very much looking forward to the MS MVC CTP which is coming very soon!