---
wordpress_id: 3167
title: SSIS Frustration? Enter Pentaho
date: 2008-02-27T15:19:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2008/02/27/replacement-for-ssis.aspx
dsq_thread_id:
  - "262588607"
categories:
  - Uncategorized
---
For awhile now I have been wrestling with SSIS. I don&#8217;t like it at all so much to the point that the majority of my nightly packages are still on SQL 2000 as I have been unsuccessful in porting them to SQL 2005 SSIS.


  


A little while ago I went searching for alternatives. There are quite a few out there, some having very good reviews. I don&#8217;t have a list of what ones I looked at as this was a couple of months ago. The one that did stand out was <A class="" href="http://www.pentaho.com/" target="_blank">Pentaho</A>. Not only does it do everything and more than SSIS, but specific verions are available as open source. Namely, the <A class="" href="http://www.pentaho.com/products/data_integration/" target="_blank">Pentaho Data Integration</A> is available as open source. This is the main ETL tool that they have and is written in Java. It is very mature and has <A class="" href="http://kettle.pentaho.org/" target="_blank">a wealth of documentation</A> that accompanies it. This was the deciding factor for me.


  


Originally I was using <A class="" href="http://www.ayende.com/Blog/category/545.aspx" target="_blank">RhinoETL</A>, but the only problem was the lack of documentation. This was ok for simple tasks, but once I had to do more complex data processes, and my lack of knowledge with boo it became more difficult to stay with RhinoETL. Ayende has a great tool, it just needs to simmer for a little while I think. I would definately consider going back once it has matured a little more.


  


In addition to the great documentation, Pentaho Data Integration also has a visual designer for creating data workflows. Here is one screen shot of a simple process that exports to a csv, uploads to&nbsp;a remote FTP&nbsp;and then send&#8217;s an e-mail upon success or failure of the task.<IMG height="1" alt="" src="http://s184.photobucket.com/albums/x270/dkode8880/?action=view&current=pentaho.jpg" width="1" border="0" /><IMG height="1" alt="" src="http://s184.photobucket.com/albums/x270/dkode8880/?action=view&current=pentaho.jpg" width="1" border="0" />You can see a few of the tasks available to you on the left sidebar.


  


<IMG height="371" alt="" src="http://i184.photobucket.com/albums/x270/dkode8880/pentaho.jpg" width="500" border="0" />


  


Everything in Pentaho is in a propietary Package Repository on the server so if you mess up an export you can rollback the repository to previous versions. Very nice feature!


  


Here are some more screenshots of the interface:


  


Very basic export with email


  


<IMG height="194" alt="" src="http://i184.photobucket.com/albums/x270/dkode8880/pentaho2.jpg" width="491" border="0" />


  


&nbsp;


  


E-Mail configuration window:


  


<IMG height="447" alt="" src="http://i184.photobucket.com/albums/x270/dkode8880/pentaho3.jpg" width="532" border="0" />


  


Options for attaching logs to the e-mail to send:


  


<IMG height="447" alt="" src="http://i184.photobucket.com/albums/x270/dkode8880/pentaho4.jpg" width="532" border="0" />


  


This is just barely scratching the surface of the processes you can perform with this tool. The Data Integration server and clients are all available under open source liscences. As well as access to the forums and all the accompying documentation.


  


I will post more on the topic later. It has just been a very helpful tool and I think other people need to see some alternatives to SSIS.