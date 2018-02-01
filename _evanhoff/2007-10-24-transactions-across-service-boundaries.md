---
id: 13
title: Transactions Across Service Boundaries
date: 2007-10-24T00:01:15+00:00
author: Evan Hoff
layout: post
guid: /blogs/evan_hoff/archive/2007/10/23/transactions-across-service-boundaries.aspx
categories:
  - Uncategorized
---
I figured I might as well bring this back up in light of my next topic.

**Are&nbsp;distributed transactions a violation&nbsp;of the &#8220;Autonomous&#8221; tenant of service orientation?**

In case anyone missed it, there was some good discussion on the use of transactions across service boundaries.&nbsp; You can <a href="http://forums.microsoft.com/MSDN/ShowPost.aspx?PostID=1840652&SiteID=1" target="_blank">read the responses</a>&nbsp;and listen to the <a href="http://channel9.msdn.com/ShowPost.aspx?PostID=324141#324141" target="_blank">ARCast version</a> as well.&nbsp; It was fun seeing several industry luminaries chime in, including <a href="http://www.objectwatch.com/" target="_blank">Roger Sessions</a>.

It also got a little coverage over at <a href="http://www.infoq.com/news/2007/07/ws-tx-and-autonomy" target="_blank">InfoQ</a>.

In short, ACIDic transactions (ie..database transactions) across services are mostly frowned upon.&nbsp; They can kill scalability.