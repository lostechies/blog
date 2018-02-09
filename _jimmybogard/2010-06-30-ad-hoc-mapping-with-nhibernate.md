---
wordpress_id: 420
title: Ad-hoc mapping with NHibernate
date: 2010-06-30T02:17:26+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/06/29/ad-hoc-mapping-with-nhibernate.aspx
dsq_thread_id:
  - "264716520"
categories:
  - NHibernate
redirect_from: "/blogs/jimmy_bogard/archive/2010/06/29/ad-hoc-mapping-with-nhibernate.aspx/"
---
In my recent adventures with massive bulk processing, there are some times when I want to pull bulk loaded tables from SQL, but don’t want to go through all the trouble of building a mapping in NHibernate.&#160; For example, one recent project had an intermediate processing table of something like:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_2656431D.png" width="356" height="138" />](http://lostechies.com/jimmybogard/files/2011/03/image_26C27612.png) 

This table is used in a bulk copy scenario, so it’s very string-based to ease the burden of bulk loading.&#160; Later, we’ll transactionally process this table to update our actual customer table.&#160; In the meantime, we want to use this data in a .NET application.&#160; We have a few options:

  * Load into a DataSet
  * Stream from an IDataReader
  * Map using NHibernate
  * Ad-hoc map using NHibernate

Many times, I like to go with the last option.&#160; DataSets and data readers can be a pain to deal with, as most of the code I write has nothing to do with dealing with the data, but just getting it out in a sane format.

NHibernate supports transformers, which are used to transform the results of the query into something useful.&#160; To make things easy, I’ll create a simple representation of this table:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">BulkLoadCustomer
</span>{
    <span style="color: blue">public string </span>CustomerId { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>RegisteredDate { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

I’ll create some generic query:

<pre><span style="color: blue">var </span>sql = <span style="color: #a31515">"SELECT CustomerId, RegisteredDate FROM BulkLoad.Customer"</span>;

<span style="color: blue">var </span>sqlQuery = _unitOfWork.CurrentSession.CreateSQLQuery(sql);</pre>

[](http://11011.net/software/vspaste)

I just have the NHibernate ISession object exposed through a Unit of Work pattern.&#160; With the ISqlQuery object that gets created with the CreateSQLQuery() method, I can then specify that I want the results projected into my custom DTO:

<pre><span style="color: blue">var </span>results = sqlQuery
    .SetResultTransformer(<span style="color: #2b91af">Transformers</span>.AliasToBean(<span style="color: blue">typeof</span>(<span style="color: #2b91af">BulkLoadCustomer</span>)))
    .List&lt;<span style="color: #2b91af">BulkLoadCustomer</span>&gt;();</pre>

[](http://11011.net/software/vspaste)

The AliasToBean method is a factory method on the static Transformers class.&#160; I tell NHibernate to build a transformer to my DTO type, and finally use the List() method to execute the results.&#160; I don’t have to specify any additional mapping file, and NHibernate never needs to know about that BulkLoadCustomer type until I build up the query.

The name “AliasToBean” is a relic of the Java Hibernate roots, which is why it didn’t jump out at me at first.&#160; But it’s a great tool to use when you want to just map any table into a DTO, as long as the DTO matches up well to the underlying query results.