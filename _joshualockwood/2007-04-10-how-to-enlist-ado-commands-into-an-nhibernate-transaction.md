---
id: 14
title: How to enlist ADO commands into an NHibernate transaction
date: 2007-04-10T20:27:00+00:00
author: Joshua Lockwood
layout: post
guid: /blogs/joshua_lockwood/archive/2007/04/10/how-to-enlist-ado-commands-into-an-nhibernate-transaction.aspx
categories:
  - Enlist
  - Legacy Systems
  - NHibernate
  - Transactions
---
<SPAN>Adoption of NHibernate in a legacy environment can be daunting for a number of reasons.&nbsp; Aside from the overhead of becoming proficient with the framework itself, developers are also faced with thousands of lines of working (it&#8217;s assumed) code that is already conversing with the system&#8217;s data store(s).&nbsp; If complete migration to NHibernate is a prerequisite, then such systems would never make the move.&nbsp; That being said, NHibernate does afford a way to make calls&nbsp;using&nbsp;the plain old ADO.Net API.&nbsp; To be more precise, NHibernate allows users to enlist IDbCommands into NHibernate transactions.</SPAN>


  


<SPAN>Personally, I&#8217;ve only used this feature to work around limitations of NHibernate (yes, although I believe NHibernate is the best thing since sliced bread, I do acknowledge its limitations&#8230;unlike <disparaging remark about other OS/Language/Methodology fanatics here>).<SPAN>&nbsp; </SPAN>This feature was necessary for bulk&nbsp;delete operations…example follows:</SPAN>


  


<SPAN>HQL in NHibernate is handy, but can get you in trouble.<SPAN>&nbsp; </SPAN>Say you fire off an HQL query something like this:</SPAN>


  


<SPAN>DELETE FROM User WHERE User.Clue = null&nbsp;&nbsp; //not sure offhand of exact HQL syntax</SPAN>


  


<SPAN>This would delete pretty much all your users, so if you have a few million clueless users in the system NHibernate will load the Users into the first level cache and then delete them.<SPAN>&nbsp; </SPAN>I had a similar situation with a gig I was on not too long ago.<SPAN>&nbsp; </SPAN>Caching the objects before deleting them would not only have taken a long time, it would have brought the server to its knees after the page file was used up.<SPAN>&nbsp; </SPAN>I couldn’t skip the caching stage using NHibernate directly, but I could do something like this:</SPAN>


  


<P class="MsoNormal">
  <SPAN>ISession session = sessionFactory.GetSession();</SPAN>
</P>


  


<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN>
</P>


  


<P class="MsoNormal">
  <SPAN>using</SPAN><SPAN>(ITransaction transaction = session.BeginTransaction())</SPAN>
</P>


  


<P class="MsoNormal">
  <SPAN>{</SPAN>
</P>


  


<P class="MsoNormal">
  <SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &#8230;NHibernate stuff&#8230;</SPAN>
</P>


  


<P class="MsoNormal">
  <SPAN></SPAN>&nbsp;
</P>


  


<P class="MsoNormal">
  <SPAN>IDbCommand command = <SPAN>new</SPAN> SqlCommand();</SPAN>
</P>


  


<P class="MsoNormal">
  <SPAN>command.Connection = session.Connection;</SPAN>
</P>


  


<P class="MsoNormal">
  <SPAN>&nbsp;</SPAN>
</P>


  


<P class="MsoNormal">
  <SPAN>transaction.Enlist(command);</SPAN>
</P>


  


<P class="MsoNormal">
  <SPAN>&nbsp;</SPAN>
</P>


  


<P class="MsoNormal">
  <SPAN>command.CommandText = &#8220;delete from User where clue is null&#8221;;</SPAN>
</P>


  


<P class="MsoNormal">
  <SPAN>command.ExecuteNonQuery();</SPAN>
</P>


  


<P class="MsoNormal">
  <SPAN></SPAN>&nbsp;
</P>


  


<P class="MsoNormal">
  <SPAN>&#8230;more NHibernate stuff&#8230;&nbsp;</SPAN>
</P>


  


<P class="MsoNormal">
  <SPAN>}</SPAN>
</P>


  


<SPAN>In the using block I could do all sorts of NHibernate stuff yet still do my bulk delete without the caching overhead.<SPAN>&nbsp; </SPAN>ADO commands used in this way are safely tucked into your current NHibernate Transaction context.</SPAN>


  


<SPAN>&nbsp;</SPAN><SPAN>This feature can be handy, but keep in mind that NHibernate remains unaware of state changes in the repository.<SPAN>&nbsp; </SPAN>If I had a User collection in memory, I’d have to ignore the previous state after the delete and recall the collection based on my previous find criteria. <SPAN>&nbsp;</SPAN>Stored Procedures could also be used this way, but Ayende blogged not to long ago about an <A href="http://www.ayende.com/Blog/archive/7263.aspx">alternative approach</A> (I’m not sure off hand of the version of NHibernate that supports this).</SPAN>


  


&nbsp;