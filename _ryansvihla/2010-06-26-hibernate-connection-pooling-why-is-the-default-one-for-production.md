---
id: 42
title: 'Hibernate Connection Pooling: why isn&#8217;t the default one for production?'
date: 2010-06-26T13:50:00+00:00
author: Ryan Svihla
layout: post
guid: /blogs/rssvihla/archive/2010/06/26/hibernate-connection-pooling-why-is-the-default-one-for-production.aspx
dsq_thread_id:
  - "1069158747"
categories:
  - Uncategorized
---
Hibernate unlike NHibernate comes with a variety of connection pooling options. The three primary ones of which I&#8217;m aware are [Proxool](http://proxool.sourceforge.net/), [Apache DBCP](http://commons.apache.org/dbcp/), and [c3p0](http://sourceforge.net/projects/c3p0/) . I myself have only so far used c3p0 and it works quite well having saved me from a couple of jams so far where the default one was in use previously. First why not use the default one? Because the official Hibernate documentation says in a big yellow box marked caution the following words:

<span style="font-family: 'Lucida Grande', Geneva, Verdana, Arial, sans-serif;color: #533500;line-height: 18px"></span>

> The built-in Hibernate connection pool is in no way intended for production use. It lacks several features found on any decent connection pool.

Yet on almost every single Java project I&#8217;ve worked on the default is in use. I wouldn&#8217;t care so much but this has personally wasted a fair amount of time for me and I&#8217;ve had to approach this as an outsider every time getting into the argument &#8220;it hasn&#8217;t cause any issues before&#8221;. Yet usually within a couple of days of that discussion I or someone else has resolved a &#8220;well it just does that sometimes&#8221; problem just by switching the connection pool. However, in implementing an alternate connection pool I should share a couple of gotcha&#8217;s

1) Turn on logging for Hibernate and read the logs and make sure your connection pool of choice is actually activated and not the default one.

2) Older examples of the documentation I found for c3p0 did not include the necessary line for the C3P0Connection provider. If this line is not included in version 3.x version of hibernate regardless of what else is configured hibernate will use the default connection pool.

3) If the class you specified for connection provider line is not found for some reason, also the default connection pool will be used. Depending on your version of hibernate you may have to reference a different jar.

Below is the config borrowed from the hibernate connection tutorial only with c3p0 configured, please borrow it instead of using the default one.</p>