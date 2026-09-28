---
wordpress_id: 17
title: Quick Background on my current CICS integration project
date: 2007-09-01T01:00:00+00:00
author: Joshua Lockwood
layout: post
wordpress_guid: /blogs/joshua_lockwood/archive/2007/08/31/quick-background-on-my-current-cics-integration-project.aspx
categories:
  - Legacy Systems
  - NHibernate
  - Oracle
  - Programming
  - VB.Net
redirect_from: "/blogs/joshua_lockwood/archive/2007/08/31/quick-background-on-my-current-cics-integration-project.aspx/"
---
I&#8217;m currently working on a stop-gap legacy integration project that is geared toward data integration between a legacy CICS system and a new 3rd party product.&nbsp; I have 2 major tasks in this project, the first being a web application for bulk data entry into both systems simultaneously and the second being cross-system data transformation and transfer.&nbsp; The integration points between the two systems are expected to support operations for the next 12 months.&nbsp; Past integration projects have been handled through cron&#8217;d UNIX scripts, PL/SQL stored procedures, triggers, CICS batch jobs, etc.&nbsp; Past projects also have left a dearth of documentation in their paths.


  


The current integration approach to the CICS system is pre-defined, so I just have to work with &#8220;what is&#8221; in that regard.&nbsp; I&#8217;ve had the joy of reading COBOL&nbsp;ctl files to complete requirements and design docs.&nbsp; Integration involves FTPing flat files to and fro.


  


The 3rd party product has a service-based API, but service calls are not chunky at all; so interfacing through that is a bit too wordy for the batch processing that I&#8217;ll need to be doing.&nbsp; To make things more fun, I have no ER diagrams for the new system&#8217;s DB (which has a couple hundred tables), many entity relationships are not supported by foreign keys, no one seems to know what sequences are used to generate keys, the 3rd party system&#8217;s source is closed and lacks technical documentation, I have no customer contact (from XP PoV, I only have a manager and a developer&nbsp;to interface with), my wife left me, and my dog died (okay, maybe not the last two).


  


In any case, this is proving to be a delightful challenge (ah yes, and I failed to mention that the client wants betas for 5 batch interfaces and a the web application written in 3 weeks).&nbsp; The client wants the solution written in VB.Net and has asked that some &#8220;best practices&#8221; be introduced into the organization along the way.&nbsp; I&#8217;ve been constructing a domain model(s) that can speak between the two systems and believe that I&#8217;m making good headway in understanding the business better.


  


I&#8217;ll be blogging (maybe?) on some of my approaches as I work though this project.&nbsp; I&#8217;ve done a fair bit of VB6 in the past (distant past), but the VB.Net syntax has felt strange having done so much C# over the last few years (at least now I can relate better to the VB.Net guys&#8217; questions at the local UG meetings).&nbsp; Generics, attributes&nbsp;and reflection look especially weird.


  


As far as tools, I&#8217;ll be using some of the usual suspects, but will probably emphasize my use of NHibernate.&nbsp; I&#8217;ve also had my first experience with using LDAP with forms authentication (if anyone wants an example I can do that too).&nbsp; In fact, if there&#8217;s anything about this project that may be of interest to you, drop a comment and let me know.