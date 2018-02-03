---
wordpress_id: 13
title: Converting Columns To a Collection with a Nhibernate UserType
date: 2008-08-29T01:48:08+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2008/08/28/converting-columns-to-rows-with-nhibernate-usertype.aspx
dsq_thread_id:
  - "262055534"
categories:
  - NHibernate
---
For some of you who have been using Nhibernate for a while, may found this old news, but I thought this was coolest thing ever (at least this week).

I am working with a legacy database that is,.. unpleasant (yeah we&#8217;ll go with that).&nbsp; I&#8217;m adding a new feature that is using a table with the following schema.

CREATE TABLE \[dbo].[icpric\](  
&#8230;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \[begqty1] [decimal\](15, 5) NULL CONSTRAINT [df\_icpric\_BEGQTY1]&nbsp; DEFAULT ((0)), 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \[endqty1] [decimal\](15, 5) NULL CONSTRAINT [df\_icpric\_ENDQTY1]&nbsp; DEFAULT ((0)), 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \[factor1] [decimal\](15, 5) NULL CONSTRAINT [df\_icpric\_FACTOR1]&nbsp; DEFAULT ((0)), 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \[unitpr1] [decimal\](15, 5) NULL CONSTRAINT [df\_icpric\_UNITPR1]&nbsp; DEFAULT ((0)), 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \[begqty2] [decimal\](15, 5) NULL CONSTRAINT [df\_icpric\_BEGQTY2]&nbsp; DEFAULT ((0)), 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \[endqty2] [decimal\](15, 5) NULL CONSTRAINT [df\_icpric\_ENDQTY2]&nbsp; DEFAULT ((0)), 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \[factor2] [decimal\](15, 5) NULL CONSTRAINT [df\_icpric\_FACTOR2]&nbsp; DEFAULT ((0)), 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \[unitpr2] [decimal\](15, 5) NULL CONSTRAINT [df\_icpric\_UNITPR2]&nbsp; DEFAULT ((0)), 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \[begqty3] [decimal\](15, 5) NULL CONSTRAINT [df\_icpric\_BEGQTY3]&nbsp; DEFAULT ((0)), 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \[endqty3] [decimal\](15, 5) NULL CONSTRAINT [df\_icpric\_ENDQTY3]&nbsp; DEFAULT ((0)), 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \[factor3] [decimal\](15, 5) NULL CONSTRAINT [df\_icpric\_FACTOR3]&nbsp; DEFAULT ((0)), 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \[unitpr3] [decimal\](15, 5) NULL CONSTRAINT [df\_icpric\_UNITPR3]&nbsp; DEFAULT ((0)), 

&#8230;

This is really not that uncommon in legacy apps and it really does not lend it self to a understandable domain.&nbsp; Essentially&nbsp; this is a price bracketing scheme in one table.&nbsp; I wanted to map it to the following domain model, with a collection of price brackets.

<pre><span style="color: blue">public class </span><span style="color: #2b91af">PricingSchedule
</span>{
    <span style="color: blue">private int </span>_id;
    <span style="color: blue">private string </span>_itemCode;
    <span style="color: blue">private string </span>_popt;
    <span style="color: blue">private string </span>_description;
    <span style="color: blue">private string </span>_method;
    <span style="color: blue">private string </span>_source;
    <span style="color: blue">private string </span>_group;
    <span style="color: blue">private </span><span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">PricingScheduleBracket</span>&gt; _priceBrackets;</pre>

<pre>}</pre>

I wasn&#8217;t sure how I was going to do this, so I did some research to see if anything had been before, or what might work.&nbsp; I finally decided I would give a Custom User Type a try.&nbsp; I created a mapping file that used a custom type and passed in the columns I needed to convert to a list.

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">property </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">PriceBrackets</span>" <span style="color: red">type</span><span style="color: blue">=</span>"<span style="color: blue">TRACS.Repositories.Impl.PriceBracketUserType, TRACS</span>"<span style="color: blue">&gt;
            &lt;</span><span style="color: #a31515">column </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">begqty1</span>"<span style="color: blue">/&gt;
            &lt;</span><span style="color: #a31515">column </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">endqty1</span>"<span style="color: blue">/&gt;
            &lt;</span><span style="color: #a31515">column </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">factor1</span>"<span style="color: blue">/&gt;
            &lt;</span><span style="color: #a31515">column </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">unitpr1</span>"<span style="color: blue">/&gt;
            &lt;</span><span style="color: #a31515">column </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">begqty2</span>"<span style="color: blue">/&gt;</span></pre>

<span style="color: blue"></</span><span style="color: #a31515">property</span><span style="color: blue">></span>

I then created a class that implemented Nhibernates IUserType.&nbsp; Here are the important methods to make this work.

Specify that the return type is IEnumerable<PricingScheduleBracket>

<pre><span style="color: blue">public </span><span style="color: #2b91af">Type </span>ReturnedType
{
    <span style="color: blue">get </span>{ <span style="color: blue">return typeof</span>(<span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">PricingScheduleBracket</span>&gt;); }
}</pre>

The SqlType[] property must match the order and number specified in the mapping. In this case they are easy I had 24 decimal columns 

<pre><span style="color: blue">public </span><span style="color: #2b91af">SqlType</span>[] SqlTypes
{
    <span style="color: blue">get </span>{ <span style="color: blue">return new </span>[]
        {
            <span style="color: blue">new </span>NHibernate.SqlTypes.<span style="color: #2b91af">SqlType</span>(<span style="color: #2b91af">DbType</span>.Decimal),
            <span style="color: blue">new </span>NHibernate.SqlTypes.<span style="color: #2b91af">SqlType</span>(<span style="color: #2b91af">DbType</span>.Decimal),
            <span style="color: blue">new </span>NHibernate.SqlTypes.<span style="color: #2b91af">SqlType</span>(<span style="color: #2b91af">DbType</span>.Decimal),
            <span style="color: blue">new </span>NHibernate.SqlTypes.<span style="color: #2b91af">SqlType</span>(<span style="color: #2b91af">DbType</span>.Decimal),<br />            ...</pre>

The real work is done in the NullSaveGet method. this gives you the datareader pulling back the data and an array strings with the names of the column aliases for the columns specified in mapping file.&nbsp; You can take these fields and transform them any way you want.&nbsp; Don&#8217;t forget to account for possible null values.

<pre><span style="color: blue">public object </span>NullSafeGet(<span style="color: #2b91af">IDataReader </span>rs, <span style="color: blue">string</span>[] names, <span style="color: blue">object </span>owner)
{
    <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">PricingScheduleBracket</span>&gt; brackets = <span style="color: blue">new </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">PricingScheduleBracket</span>&gt;();
    brackets.Add(<span style="color: blue">new </span><span style="color: #2b91af">PricingScheduleBracket</span>(getValue(rs[names[0]]), 
                                            getValue(rs[names[1]]), 
                                            getValue(rs[names[2]]), 
                                            getValue(rs[names[3]])));

    brackets.Add(<span style="color: blue">new </span><span style="color: #2b91af">PricingScheduleBracket</span>(getValue(rs[names[4]]),
                                            getValue(rs[names[5]]),
                                            getValue(rs[names[6]]),
                                            getValue(rs[names[7]])));<br />    ...</pre>

<pre><span style="color: blue">return </span>brackets;</pre>

[](http://11011.net/software/vspaste)} 

&nbsp;

There is a corresponding NullSaveSet to set the values.&nbsp; I am dealing with read-only values, so I left it empty.

Using techniques like this, you can use Nhibernate to effectively transforms even the most dificult database schemas into a domain that is coherent and truly models the reality it is trying to represent.