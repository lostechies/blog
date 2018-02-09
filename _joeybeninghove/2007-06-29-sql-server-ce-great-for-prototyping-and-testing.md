---
wordpress_id: 22
title: 'SQL Server CE &#8211; Great for prototyping and testing'
date: 2007-06-29T16:01:01+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/06/29/sql-server-ce-great-for-prototyping-and-testing.aspx
categories:
  - NHibernate
  - Tools
redirect_from: "/blogs/joeydotnet/archive/2007/06/29/sql-server-ce-great-for-prototyping-and-testing.aspx/"
---
#### Background

Yesterday I put together a simple POC app for my team lead who needed to see [Spring.NET](http://www.springframework.net) + [NHibernate](http://www.nhibernate.org) in action (no, not [the book](http://www.manning.com/kuate/))&nbsp;for a client.&nbsp; Even though these days I&#8217;m using the [Castle stack](http://www.castleproject.org) for most of my IoC/DI and mini-framework needs, it was interesting to see how far Spring.NET has come (probably more on that in future posts&#8230;) since I last used it a long time ago.&nbsp; 

I had a very basic scenario I focused on; adding and retrieving employees with a first and last name.&nbsp; I started out with a basic web app, service and repository.&nbsp; I just created a simple EmployeeService class that took in an implementation of IEmployeeRepository via its constructor.&nbsp; I ended up creating 4 different implementations of an IEmployeeRepository, for testing out different scenarios and used Spring.NET to inject the appropriate one into my service.&nbsp; 

I started out with no help from Spring.NET or NHibernate regarding repositories&nbsp;and just created a simple in-memory repository implementation which just stored the data in a private IList<T>.&nbsp; Simple stuff.&nbsp; But I didn&#8217;t want to really jump to a full blown SQL Server 2005 repository just yet.&nbsp; I wanted something a bit more portable, but still with the ability to store the data in a relational database.

#### In&nbsp;Comes SQL Server CE

So I&#8217;ve been wanting to try SQL Server CE anyway, so I went ahead and [downloaded it](http://www.microsoft.com/downloads/details.aspx?FamilyId=%2085E0C3CE-3FA1-453A-8CE9-AF6CA20946C3&displaylang=en).&nbsp; I created another repository implementation that just used plain ol&#8217; ADO.NET using the System.Data.SqlServerCe assembly.&nbsp; As you can see, it&#8217;s very easy to set up the SQL Server CE engine&#8230;

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   1:</span> SqlCeEngine engine = <span style="color: #0000ff">new</span> SqlCeEngine(<span style="color: #006080">"data source=temp.sdf"</span>);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   2:</span> engine.CreateDatabase();</pre>
  </div>
</div>

Then I created yet another repository implementation, this time one that leveraged NHibernate, which has built-in support for SQL Server CE.&nbsp; Instead of setting up a config file for NHibernate, I took a chapter out of [Ayende](http://www.ayende.com/Blog/)&#8216;s [Rhino Commons](https://svn.sourceforge.net/svnroot/rhino-tools/trunk/rhino-commons/Rhino.Commons/ForTesting/NHibernateEmbeddedDBTestFixtureBase.cs) and configured NHibernate all from code&#8230;

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   1:</span> Hashtable nhProperties = <span style="color: #0000ff">new</span> Hashtable();</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   2:</span> nhProperties.Add(<span style="color: #006080">"hibernate.connection.driver_class"</span>, <span style="color: #006080">"NHibernate.Driver.SqlServerCeDriver"</span>);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   3:</span> nhProperties.Add(<span style="color: #006080">"hibernate.dialect"</span>, <span style="color: #006080">"NHibernate.Dialect.MsSqlCeDialect"</span>);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   4:</span> nhProperties.Add(<span style="color: #006080">"hibernate.connection.provider"</span>, <span style="color: #006080">"NHibernate.Connection.DriverConnectionProvider"</span>);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   5:</span> nhProperties.Add(<span style="color: #006080">"hibernate.connection.connection_string"</span>,</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   6:</span>                  <span style="color: #0000ff">string</span>.Format(<span style="color: #006080">"Data Source={0};"</span>, databaseFileName));</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   7:</span> nhProperties.Add(<span style="color: #006080">"hibernate.show_sql"</span>, <span style="color: #006080">"true"</span>);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   8:</span> &nbsp;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   9:</span> Configuration configuration = <span style="color: #0000ff">new</span> Configuration();</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  10:</span> configuration.Properties = nhProperties;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  11:</span> configuration.AddAssembly(<span style="color: #006080">"SpringNHibernateApp.Domain"</span>);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  12:</span> &nbsp;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  13:</span> ISessionFactory sessionactory = configuration.BuildSessionFactory();</pre>
  </div>
</div>

This all worked great and I was very pleased at how quickly I was able to get all of this up and running.

#### Unexpected Problem

So all of my integration tests worked like a champ so I go and wire up Spring.NET to use one of my new SQL Server CE enabled repositories and fire up my web app and get a nice little [YSOD](http://en.wikipedia.org/wiki/Yellow_Screen_of_Death) with this&#8230;

> &#8220;SQL Server Compact Edition is not intended for ASP.NET development&#8221;

Seemed a little strange to me, but [Steve Lasker tries to explain why](http://blogs.msdn.com/stevelasker/archive/2006/11/27/sql-server-compact-edition-under-asp-net-and-iis.aspx).&nbsp; Luckily, it&#8217;s easy enough to workaround.&nbsp; Just place this line of code before any code that starts mucking around with SQL Server CE&#8230;

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   1:</span> AppDomain.CurrentDomain.SetData(<span style="color: #006080">"SQLServerCompactEditionUnderWebHosting"</span>, <span style="color: #0000ff">true</span>);</pre>
  </div>
</div>

Anyway, guess that&#8217;s it for now.&nbsp;