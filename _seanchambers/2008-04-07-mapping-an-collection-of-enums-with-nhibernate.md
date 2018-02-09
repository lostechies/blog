---
wordpress_id: 3173
title: Mapping a collection of Enums with NHibernate
date: 2008-04-07T01:34:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2008/04/06/mapping-an-collection-of-enums-with-nhibernate.aspx
dsq_thread_id:
  - "262546546"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2008/04/06/mapping-an-collection-of-enums-with-nhibernate.aspx/"
---
Just came across a situation where I needed to have a collection of enum values mapped to an IList and to have it supported by NHibernate. It took me a little bit to find the proper approach and get NHibernate to play nicely. So as a reference for anyone else running into this you can find some <A class="" href="http://forum.hibernate.org/viewtopic.php?t=955766" target="_blank">information at this posting here</A>


  


Here is a snippet of the bag at hand:


  


<FONT size="2"><bag name=&#8221;companyRoleList&#8221; access=&#8221;field&#8221; lazy=&#8221;false&#8221; cascade=&#8221;none&#8221; table=&#8221;CompanyRole&#8221; > <BR />&nbsp;&nbsp;&nbsp; <key column=&#8221;CompanyID&#8221; /> <BR />&nbsp;&nbsp;&nbsp; <element column=&#8221;RoleID&#8221; type=&#8221;MyCompany.Domain.Lookups.CompanyRoleType, MyCompany.Domain.Lookups&#8221; /> <BR /></bag></FONT>


  


<FONT size="2">This is from the blog post on the NHibernate forum. The trick here is to have the full namespace/assembly qualification in the type attribute that points to the Enum you are using as a collection. This is needed even if you have the namespace=, assembly= at the hibernate-mapping element. That stumped for a little while.</FONT>


  


<FONT size="2">Hopefully this helps someone else out!</FONT>