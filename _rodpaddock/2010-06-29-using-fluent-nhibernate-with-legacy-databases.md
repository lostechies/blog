---
wordpress_id: 4477
title: Using Fluent NHibernate With Legacy Databases
date: 2010-06-29T13:02:00+00:00
author: Rod Paddock
layout: post
wordpress_guid: /blogs/rodpaddock/archive/2010/06/29/using-fluent-nhibernate-with-legacy-databases.aspx
dsq_thread_id:
  - "263003367"
categories:
  - Fluent NHibernate
  - Legacy Data
  - NHibernate
  - SQL Server
---
I am currently working on a project that has a requirement that it be able to access&nbsp; data from a legacy SQL Server database.

One feature of this system is the ability to add and store checking accounts. These checking accounts are used to make payments on customer accounts. When making a payment using a checking account the vendor needs two pieces of information: An ABA (American Bankers Association) routing number and a checking account number. An ABA number is found at the bottom of your checks next to your bank account number and can be validated against a list of valid ABA numbers. This is where I encountered a need to validate against a legacy database.

In our legacy system ABA Routing numbers are stored in a database called **_viplookups_** with a table called _**bnkroute**_

For this feature I created a domain object called BankInfo

&nbsp; public class BankInfo : BaseEntity  
&nbsp;&nbsp;&nbsp; {  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public virtual string AbaNumber { get; set; }  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public virtual string Name { get; set; }  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public virtual string City{ get; set; }  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public virtual string State{ get; set; }  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public virtual string PhoneNumber { get; set; }  
&nbsp;&nbsp;&nbsp; }

&nbsp;

Now I needed to map this entity to our legacy database. Our mapping for this feature is as follows:

&nbsp;&nbsp;&nbsp; public class BankInfoMap : ClassMap<BankInfo>  
&nbsp;&nbsp;&nbsp; {  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public BankInfoMap()  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Schema(&#8220;viplookups.dbo&#8221;);  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Table(&#8220;bnkroute&#8221;);  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SchemaAction.None();  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Id(x => x.Id).Column(&#8220;bnkrouteid&#8221;);  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Map(x => x.AbaNumber).Column(&#8220;crouting&#8221;);  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Map(x => x.Name).Column(&#8220;ccompname&#8221;);  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Map(x => x.City).Column(&#8220;ccity&#8221;);  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Map(x => x.State).Column(&#8220;cstate&#8221;);  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Map(x => x.PhoneNumber).Column(&#8220;cphone1&#8221;);  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }  
&nbsp;&nbsp;&nbsp; }

So lets talk about the relevant Fluent Nhibernate features:

  * Schema(&#8220;viplookups.dbo&#8221;);

<p style="padding-left: 60px">
  The first item of interest is the Schema() method. The schema function tells NHibernate to pull this entity from a specified database. In my case this database exists on the same SQL Server. So I didn&#8217;t need to try it on another server. If you have knowledge of this working on another server leave a comment here.
</p>

  * Table(&#8220;bnkroute&#8221;);

<p style="padding-left: 60px">
  The next item of interest is the Table() method. This is pretty straight forward Fluent NHibernate and specifies the legacy table to pull your data from.
</p>

  * SchemaAction.None();

<p style="padding-left: 60px">
  The next interesting feature is SchemaAction.None(). When developing our applications I have an integration test that is used to build all our default schema. I DONT want these table to be generated in our schema, they are external.&nbsp; SchemaAction.None() tells NHibernate not to create this entity in the database.
</p>

<p style="padding-left: 30px">
  So that&#8217;s it. A simple combination of Fluent NHibernate features to access data from a legacy database properly.
</p>

<p style="padding-left: 30px">
  &nbsp;
</p>

<p style="padding-left: 30px">
  &nbsp;
</p>

<p style="padding-left: 60px">
  &nbsp;
</p>

&nbsp;

&nbsp;