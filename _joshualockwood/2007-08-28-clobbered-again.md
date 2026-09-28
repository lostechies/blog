---
wordpress_id: 15
title: CLOBbered again!
date: 2007-08-28T22:47:00+00:00
author: Joshua Lockwood
layout: post
wordpress_guid: /blogs/joshua_lockwood/archive/2007/08/28/clobbered-again.aspx
categories:
  - NHibernate
  - Oracle
  - Programming
redirect_from: "/blogs/joshua_lockwood/archive/2007/08/28/clobbered-again.aspx/"
---
Hey all, 


  


I&#8217;m currently working on an NHibernate on Oracle project and ran into the first problem with CLOBs that I&#8217;ve had in some time.&nbsp; I was trying to use a property that mapped to a CLOB in a Example instance for a session Criteria object.&nbsp; No dice.&nbsp; Oracle complained saying this:


  


System.Data.OracleClient.OracleException:&nbsp;ORA-00932:&nbsp;inconsistent&nbsp;datatypes:&nbsp;expected&nbsp;&#8211;&nbsp;got&nbsp;CLOB  



  


Well, I guess&nbsp;sometimes you get lucky&#8230;and sometimes you just get CLOBbered.


  


Guess now I have to dig into the NHibernate code if I have time.&nbsp; All other CRUD works nice with Clobs, just Example chokes.&nbsp; Could just be a dialect thing.&nbsp; 


  


Cheers!