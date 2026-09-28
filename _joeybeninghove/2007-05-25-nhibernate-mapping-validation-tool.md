---
wordpress_id: 12
title: NHibernate Mapping Validation Tool?
date: 2007-05-25T00:45:11+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/05/24/nhibernate-mapping-validation-tool.aspx
categories:
  - NHibernate
  - scriptaculous
  - Tools
redirect_from: "/blogs/joeydotnet/archive/2007/05/24/nhibernate-mapping-validation-tool.aspx/"
---
Writing [my last post](http://joeydotnet.com/blog/archive/2007/05/24/Thoughts-On-Validating-NHibernate-Mapping-Files.aspx) got me thinking&#8230;&nbsp; Surely someone has written an automated script or tool that could examine NHibernate mapping files and&nbsp;verify all the items I pointed out in [my previous post](http://joeydotnet.com/blog/archive/2007/05/24/Thoughts-On-Validating-NHibernate-Mapping-Files.aspx).&nbsp; Or maybe even, another step further, also make sure the column names specified in the mapping files actually exist in the tables in a real database schema!

I&#8217;m very tempted to write a NAnt/MSBuild task to do this kind of thing so I can run it as part of my test suite.&nbsp; I&#8217;m thinking something like this would be very useful as a kind of quick &#8220;smoke test&#8221; for NHibernate mappings.

But, before I do&#8230;

Does anyone know of an automated tool that does this kind of thing?