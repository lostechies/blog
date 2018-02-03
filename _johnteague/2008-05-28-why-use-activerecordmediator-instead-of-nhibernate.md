---
wordpress_id: 8
title: Why Use ActiveRecordMediator instead of NHibernate
date: 2008-05-28T02:33:00+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2008/05/27/why-use-activerecordmediator-instead-of-nhibernate.aspx
dsq_thread_id:
  - "262628949"
categories:
  - ActiveRecord
  - NHibernate
  - Repository Pattern
---
My blog post on using ActiveRecordMediator to use the Repository pattern with ActiveRecord was discussed on [Castle&#8217;s Forums](http://forum.castleproject.org/viewtopic.php?t=4439).&nbsp; A good question was raised in that forum, and other people that I talked to about using the Mediator class: &#8220;Why use this instead of NHibernate directly&#8221;


  


As mentioned in the original blog, I am not a NHibernate Jedi yet.&nbsp; We use it on some projects at work, but for the most part, setup and configuration was already done for me.&nbsp; Using ActiveRecord took care of setup and configuration for me.&nbsp; If you&#8217;re familiar enough with NHibernate, then this probably isn&#8217;t much a gain for you, but it was for me.


  


If you don&#8217;t need any of the advanced features of NHiberate and have simple queries, then using Mediator is a quick way to get going quickly.&nbsp; When you do need more control over Nhibernate, moving off of the ActiveRecordMediator for your Repository implementation should be quick and painless.&nbsp; So in that respect, prototyping with Mediator class has a definite advantage.


  


Hope This Helps,


  


John