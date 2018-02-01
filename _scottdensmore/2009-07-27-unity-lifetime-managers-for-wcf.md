---
id: 4608
title: Unity Lifetime Managers for WCF
date: 2009-07-27T23:01:00+00:00
author: Scott Densmore
layout: post
guid: /blogs/scottdensmore/archive/2009/07/27/unity-lifetime-managers-for-wcf.aspx
dsq_thread_id:
  - "276216519"
categories:
  - Uncategorized
---
Drew and I were having fun getting NHibernate working with WCF and Unity. I had built upon my brethren&#8217;s [Jimmy&#8217;s code from this article](/blogs/jimmy_bogard/archive/2008/09/16/integrating-structuremap-and-nhibernate-with-wcf.aspx) to making a session per request. I had let [Drew](http://drewdotnet.blogspot.com/) borrow the code, but forgot to mention that he would need to make his services per request. So, Drew and I talked and we upped the ante and created [LifetimeManager](http://msdn.microsoft.com/en-us/library/cc440953.aspx) objects for the contexts in WCF. He has a good description of it so I want hold you here any longer. Fun stuff and comes with a test client for playing with the different contexts. [Go check it out here.](http://drewdotnet.blogspot.com/2009/07/unity-lifetime-managers-and-wcf.html)

&nbsp;