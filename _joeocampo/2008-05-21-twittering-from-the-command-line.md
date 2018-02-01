---
id: 113
title: Twittering from the command line
date: 2008-05-21T04:47:00+00:00
author: Joe Ocampo
layout: post
guid: /blogs/joe_ocampo/archive/2008/05/21/twittering-from-the-command-line.aspx
dsq_thread_id:
  - "262089286"
categories:
  - Tools
  - Twitter
---
So I was experimenting with Twitter last night and started to use their RESTful services from the command line.&nbsp; 

Why you may ask? Well sometimes I just want to tweet something quickly and I don&#8217;t want to bother with opening a client or web page.&nbsp; So I through together this simple bash script.

<font face="courier new,courier">tweet()<br />&nbsp; {<br />&nbsp;&nbsp;&nbsp; curl -u <username>:<password> -d status=&#8221;$1&#8243; http://twitter.com/statuses/update.xml<br />&nbsp; } </font>

Simply add this to your **.bash_profile** and you can tweet from the command line all day.

<font face="courier new,courier">tweet &#8220;Tweeting from the command line is awesome!&#8221;</font>&nbsp;

I love RESTful services despite popular belief.&nbsp; 🙂&nbsp;