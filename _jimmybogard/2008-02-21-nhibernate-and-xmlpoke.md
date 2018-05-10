---
wordpress_id: 145
title: NHibernate and xmlpoke
date: 2008-02-21T02:45:04+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/02/20/nhibernate-and-xmlpoke.aspx
dsq_thread_id:
  - "264715571"
categories:
  - ContinuousIntegration
  - Tools
redirect_from: "/blogs/jimmy_bogard/archive/2008/02/20/nhibernate-and-xmlpoke.aspx/"
---
Some time ago I wrote about [targeting multiple environments through NAnt](https://lostechies.com/blogs/jimmy_bogard/archive/2008/01/02/targeting-multiple-environments-through-nant.aspx).&nbsp; The basic concept is to use the [xmlpoke task](http://nant.sourceforge.net/release/latest/help/tasks/xmlpoke.html) in NAnt to modify any XML configuration files your application might use.&nbsp; One setting that changes in each deployment we have is the &#8220;connection.connection_string&#8221; setting in the [NHibernate](http://www.hibernate.org/343.html)&nbsp;[hibernate.cfg.xml file](http://www.hibernate.org/hib_docs/nhibernate/html/session-configuration.html).&nbsp; This setting controls the connection string NHibernate uses to connect to the database.

Unfortunately, I ran into some annoying problems that caused me a lot of frustration.&nbsp; When I tried to use the xmlpoke task:

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">xmlpoke </span><span style="color: red">file</span><span style="color: blue">=</span>"<span style="color: blue">${dir.website}hibernate.cfg.xml</span>"
 <span style="color: red">xpath</span><span style="color: blue">=</span>"<span style="color: blue">//*/property[@name='connection.connection_string']</span>"
 <span style="color: red">value</span><span style="color: blue">=</span>"<span style="color: blue">Data Source=${database.server};Initial Catalog=${database.name};Integrated Security=true</span>"<span style="color: blue">&gt;
&lt;/</span><span style="color: #a31515">xmlpoke</span><span style="color: blue">&gt;
</span></pre>

[](http://11011.net/software/vspaste)

I kept getting this from NAnt:

<pre>[xmlpoke] No matching nodes were found with XPath expression '//*/property[@name='connection.connection_string']'.</pre>

[](http://11011.net/software/vspaste)

I double, triple, and eleventy-tuple-checked the XPath and tried many other XPath combinations.&nbsp; But the problem wasn&#8217;t with the XPath, it was with the hibernate.cfg.xml file.&nbsp; Looking at the top at the NHibernate configuration file, I saw that the root element had an XML namespace applied to it:

<pre>&lt;hibernate-configuration xmlns="urn:nhibernate-configuration-2.0"&gt;</pre>

I&#8217;ve used XML namespaces in the past to add prefixes to element names.&nbsp; The xmlpoke documentation mentions namespaces, and [this post confirmed it](http://solepano.blogspot.com/2006/11/problem-with-nants-xmlpoke-task.html): I have to specify a namespace in the xmlpoke task for the XPath query to work correctly.

Armed with this, I was able to get my xmlpoke task working correctly:

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">xmlpoke </span><span style="color: red">file</span><span style="color: blue">=</span>"<span style="color: blue">${dir.website}hibernate.cfg.xml</span>"
         <span style="color: red">xpath</span><span style="color: blue">=</span>"<span style="color: blue">//*/hbm:property[@name='connection.connection_string']</span>"
     <span style="color: red">value</span><span style="color: blue">=</span>"<span style="color: blue">Data Source=${database.server};Initial Catalog=${database.name};Integrated Security=true</span>"<span style="color: blue">&gt;
  &lt;</span><span style="color: #a31515">namespaces</span><span style="color: blue">&gt;
    &lt;</span><span style="color: #a31515">namespace </span><span style="color: red">prefix</span><span style="color: blue">=</span>"<span style="color: blue">hbm</span>" <span style="color: red">uri</span><span style="color: blue">=</span>"<span style="color: blue">urn:nhibernate-configuration-2.2</span>" <span style="color: blue">/&gt;
  &lt;/</span><span style="color: #a31515">namespaces</span><span style="color: blue">&gt;
&lt;/</span><span style="color: #a31515">xmlpoke</span><span style="color: blue">&gt;
</span></pre>

[](http://11011.net/software/vspaste)

I had to do few things to get it to work:

  * Add the namespace element with the correct uri attribute
  * Give it a prefix, &#8220;foo&#8221; if you want, it doesn&#8217;t matter
  * Changed the XPath to use the prefix specified earlier on each element in the query

Now the XPath works and my property is changed correctly.&nbsp; Even though I don&#8217;t specify a prefix in the namespace in the configuration file, I still have to declare the prefix in the xmlpoke task.&nbsp; I&#8217;m sure there&#8217;s some smarty-pants XML guru that could tell me the details, but all I care is that my build is deploying the correct connection strings.

One less future headache for me.