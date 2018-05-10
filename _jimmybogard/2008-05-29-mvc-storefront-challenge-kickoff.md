---
wordpress_id: 190
title: MVC Storefront Challenge Kickoff
date: 2008-05-29T01:19:53+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/05/28/mvc-storefront-challenge-kickoff.aspx
dsq_thread_id:
  - "271094664"
categories:
  - ASPNETMVC
redirect_from: "/blogs/jimmy_bogard/archive/2008/05/28/mvc-storefront-challenge-kickoff.aspx/"
---
Last week, I announced the [MVC Storefront Challenge](https://lostechies.com/blogs/jimmy_bogard/archive/2008/05/20/the-mvc-storefront-challenge.aspx), which is a response to some feedback [Rob Conery](http://blog.wekeroad.com/) was getting on his ongoing [MVC Storefront](http://blog.wekeroad.com/mvc-storefront/) series.&nbsp; Before I could get started, I needed to get the original project up and running on my own machine.

I had to install Unity and restore the included database (I already had ASP.NET MVC installed), but everything is up and running.

The original idea behind the challenge is the feedback Rob&#8217;s getting to switch to various OSS tools for an assortment of applications, including ORM, IoC, unit tests, etc etc.&nbsp; Rob didn&#8217;t think this made sense, and I don&#8217;t either, as it doesn&#8217;t work too well to switch out the engine in the middle of a race.

The goal of the challenge is to use these open source tools to build an **identically functioning MVC Storefront**.&nbsp; By &#8220;identically functioning&#8221;, I&#8217;m referring to the end-user experience.&nbsp; HTML and URLs will be exactly the same for both applications, as well as user flow.

### Ground rules

Since HTML, URLs etc need to be exactly the same, we can achieve this by:

  * Continue to use ASP.NET MVC
  * Use the same controller classes, at least the signatures
  * Use the same views
  * Use the same view models

Everything else can change.

### Goals

Besides just getting familiar with ASP.NET MVC, the goals of this project include:

  * Showing sample usages of popular OSS .NET tools
  * Compare implementations of similar scenarios between the two approaches
  * Hopefully create some teaching opportunities for these approaches

The point of this isn&#8217;t an exercise of &#8220;Linq 2 SQL is teh lame&#8221; or anything like that.&nbsp; There aren&#8217;t many comparisons that I could find of identical applications with completely different infrastructure, so it will be nice to have some comparisons.

### First steps

Right now, all I have is the MVC Storefront code running on my local machine.&nbsp; The license allows reproduction and derivative works, providing I include the original license (Ms-PL).&nbsp; To get this going, I&#8217;ll need to:

  * Pick a name for the project
  * Create a home for the project
  * Remove all non-ASP.NET projects from the solution
  * Get it building!

From there on out, I&#8217;ll have some skeleton controllers to start adding behavior.&nbsp; To do so, I&#8217;ll probably have to do some myself, and hopefully do some recorded pairing with other folks.&nbsp; As Rob completes more functionality, we&#8217;ll add it to the MVC Challenge project.

Once I get the first steps ironed out (send in project names, kthx), it&#8217;s just a matter of flushing out the controllers.&nbsp; <sarcasm>Easy, right?</sarcasm>