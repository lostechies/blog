---
wordpress_id: 122
title: SVN and proxy servers
date: 2008-01-07T19:53:08+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/01/07/svn-and-proxy-servers.aspx
dsq_thread_id:
  - "264715486"
categories:
  - Tools
---
So I wanted to check out [Jeffrey&#8217;s](http://jeffreypalermo.com/) [sample code](http://palermo.googlecode.com/svn/aspnetmvc/trunk) he demonstrates in the [latest dnrTV episode](http://www.dnrtv.com/default.aspx?showNum=95).&nbsp; I get a fun message back from SVN, which is completely meaningless to me:

 ![](http://grabbagoftimg.s3.amazonaws.com/svn_proxy_error.PNG)

It turns out that although SVN works through port 80, the proxy server I&#8217;m behind filters HTTP headers, one of which is PROPFIND.&nbsp; Google tells me that I can [configure SVN to use a proxy server](http://subversion.tigris.org/faq.html#proxy), which is what I need to do with several applications (including Live Writer).&nbsp; Although I have to hard-code my password into the configuration file, it fixes the problem:

 ![](http://grabbagoftimg.s3.amazonaws.com/svn_proxy_good.PNG)

I have to change the configuration file every few months when my password expires, but otherwise I&#8217;m good.