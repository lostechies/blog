---
wordpress_id: 258
title: Viewing all foreign key constraints in SQL Server
date: 2008-11-27T03:03:31+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/11/26/viewing-all-foreign-key-constraints-in-sql-server.aspx
dsq_thread_id:
  - "264790082"
categories:
  - SQL
redirect_from: "/blogs/jimmy_bogard/archive/2008/11/26/viewing-all-foreign-key-constraints-in-sql-server.aspx/"
---
This one goes in the “so I never have to look again” category.&#160; I needed to get a list of all foreign keys in the database, for some reason which was probably dire but now escapes me.&#160; [This guy had the answer](http://blog.sqlauthority.com/), don’t you love those MVPs?&#160; I was going to ask it on the StackOverflow site, but then I realized I don’t want to be a complete tool.&#160; Here’s the query:

SELECT f.name AS ForeignKey,   
&#160;&#160; OBJECT\_NAME(f.parent\_object_id) AS TableName,   
&#160;&#160; COL\_NAME(fc.parent\_object\_id, fc.parent\_column_id) AS ColumnName,   
&#160;&#160; OBJECT\_NAME (f.referenced\_object_id) AS ReferenceTableName,   
&#160;&#160; COL\_NAME(fc.referenced\_object\_id, fc.referenced\_column_id) AS ReferenceColumnName   
FROM sys.foreign_keys AS f   
INNER JOIN sys.foreign\_key\_columns AS fc   
&#160;&#160; ON f.OBJECT\_ID = fc.constraint\_object_id

I think from that query I created some dynamic SQL to drop and add all check constraints or some other garbage like that.&#160; <strike>45</strike> 0 days since I opened SQL Server Management Studio.&#160; (I had to reset the counter)