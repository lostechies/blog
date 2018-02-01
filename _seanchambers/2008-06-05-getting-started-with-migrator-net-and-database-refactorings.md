---
id: 3174
title: Getting Started with Migrator.Net and database refactorings
date: 2008-06-05T02:50:00+00:00
author: Sean Chambers
layout: post
guid: /blogs/sean_chambers/archive/2008/06/04/getting-started-with-migrator-net-and-database-refactorings.aspx
dsq_thread_id:
  - "262070610"
categories:
  - Uncategorized
---
<font face="Tahoma" size="2">Database Refactoring is always a pain to be dealt with in any medium-large sized software. There are new tables, columns, primary keys, foreign keys added and removed constantly from a database under development. Some people have a strict plan of creating sql scripts for every change they make in the database. Others have a text file holding a listing of changes to be done on QA and Production machines along with migrating existing data into new structures. Anyway you slice it, It&#8217;s a headache all around and if you ignore it, it will eventually bite you in ass.</font>

<font face="Tahoma" size="2">This is one area that they Ruby crowd has gotten in right (not saying that they haven&#8217;t got other things right), but with Migrations, it is amazingly easy to create objects in your database and then easily version your database. Originally an open source utility was written by </font>[<font face="Tahoma" size="2">Marc-Andre Cournoyer</font>](http://macournoyer.wordpress.com/) <font face="Tahoma" size="2">called .Net Migrations (or something to that extent), it lived in the castle trunk for awhile but once Marc-Andre went to the ruby crowd Nick Hems picked up the project, dusted it off and placed it on Google Code </font>[<font face="Tahoma" size="2">located here</font>](http://code.google.com/p/migratordotnet/)<font face="Tahoma" size="2">.</font>

<font face="Tahoma" size="2">Ok, now that we have gotten the history lesson out of the way let&#8217;s get started. Earlier this evening the trunk I updated with a major set of refactorings done mostly by Geoff Lane, which we have been toying with for about a month or so. Now that Geoff and Nick fixed a number of bugs, we updated the trunk so everyone can have fun!</font>

<font face="Tahoma" size="2">One of the best parts of this database refactoring tool is the database support. At the current moment, Migrator.Net supports MsSql Server, MySql, Oracle, PostgreSql and SQLite. You need only specify the connection string for the database and the provider to use in an NAnt task that was developed for Migrator.Net like so:</font>

<div class="csharpcode">
  <div>
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">&lt;migrate provider=<span style="color: #006080">"MySql"</span> connectionstring=<span style="color: #006080">"Database=dbname;Data Source=localhost;User Id=username;Password=password;"</span> migrations=<span style="color: #006080">"Project.Migrations.dll"</span> to=<span style="color: #006080">"2"</span> /&gt;</pre>
  </div>
</div>

<font face="Tahoma" size="2">Specifying a &#8220;to&#8221; attribute of 2, will migrate your database to the next available version. When you first run migration version 1, a &#8220;schemainfo&#8221; table is created in the database that keeps track of the current migration version. Then by specifying a 2, the next version is applied to the database. </font>

<font face="Tahoma" size="2">Where do I create my migrations you ask? Good question! </font>

<font face="Tahoma" size="2">I create a seperate assembly, in the nant task above it is called Project.Migrations.dll. The migration looks something like so: </font>

<font face="Tahoma" size="2"></font>&nbsp;

<font face="Tahoma" size="2"></p> 

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;height: 256px;background-color: #f4f4f4">
  <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">   1:</span> <span style="color: #008000">// Version 1</span></pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   2:</span> [Migration(1)]</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">   3:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> CreateUserTable : Migration</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   4:</span> {</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">   5:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Up()</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   6:</span>     {</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">   7:</span>         Database.CreateTable(<span style="color: #006080">"User"</span>,</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   8:</span>             <span style="color: #0000ff">new</span> Column(<span style="color: #006080">"UserId"</span>, DbType.Int32, ColumnProperties.PrimaryKeyWithIdentity),</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">   9:</span>             <span style="color: #0000ff">new</span> Column(<span style="color: #006080">"Username"</span>, DbType.String, 25)</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  10:</span>             );</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  11:</span>     }</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  12:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Down()</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  13:</span>     {</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  14:</span>         Database.RemoveTable(<span style="color: #006080">"User"</span>);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  15:</span>     }</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  16:</span> }</pre>
  </div>
</div>

<p>
  </font>&nbsp;
</p>

<p>
  <font face="Tahoma" size="2">Ok, so it doesn&#8217;t get much easier than this. It has a feel exactly like Migrations for Ruby, so anyone familiar with that should have no problem with this. The first thing to take note of is the Migration attribute with a 1. This denotes what version this migration is. Each time you create a new migration, it has to be the next available number. This is required. Next is the class name which can be whatever you like for readability purposes. Next is the Up() and Down() methods. When migrating TO this version, the code in Up() will be called. When rolling back a change to a previous version, the Down() method will be called. Easy enough.</font>
</p>

<p>
  <font face="Tahoma" size="2">If you take a look at the Database class, you&#8217;ll see that there are many other methods there for creating ForeignKeys, PrimaryKeys as well as other column information to be applied in the database. Column options can also be passed in the Column() ctor overloads.</font>
</p>

<p>
  <font face="Tahoma" size="2">The project can be found here: </font><a title="http://code.google.com/p/migratordotnet/" href="http://code.google.com/p/migratordotnet/"><font face="Tahoma" size="2">http://code.google.com/p/migratordotnet/</font></a>
</p>

<p>
  <font face="Tahoma" size="2">The google group where I make silly postings is here: </font><a title="http://groups.google.com/group/migratordotnet-devel" href="http://groups.google.com/group/migratordotnet-devel"><font face="Tahoma" size="2">http://groups.google.com/group/migratordotnet-devel</font></a>
</p>

<p>
  <font face="Tahoma" size="2">The next thing I think we&#8217;ll probably look at is refactoring towards a fluent interface as this is clearly a fit for that type of implementation. Go download it and take a look! Please post any bugs to the tracking list on google code.</font>
</p>

<p>
  <font face="Tahoma" size="2">Next time I&#8217;ll go over rolling back changes and other more complex changes to perform on your database. Enjoy!</font>
</p>