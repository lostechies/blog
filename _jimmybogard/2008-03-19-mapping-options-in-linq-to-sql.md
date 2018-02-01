---
id: 159
title: Mapping options in LINQ to SQL
date: 2008-03-19T02:15:34+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/03/18/mapping-options-in-linq-to-sql.aspx
dsq_thread_id:
  - "264715621"
categories:
  - DomainDrivenDesign
  - LINQ2SQL
---
A [recent thread](http://tech.groups.yahoo.com/group/altdotnet/message/4236) on the ALT.NET message board asked:

> How does everyone create the DataContext for their DB?
> 
>   1. Do you use the IDE and generate your custom .dbml (which also generates all your DTO&#8217;s)?
>   2. Do you use a generic DataContext object and just .GetTable<>() and create your DTO&#8217;s by hand?

Some of the comments indicated there were other mapping options other than the designer mapping I had seen 50 million times before in demos.&nbsp; I bought [LINQ in Action](http://linqinaction.net/) this past weekend to get the scoop. It turns out there are four (count &#8217;em, four) ways of mapping your LINQ to SQL <strike>entities</strike> DTO&#8217;s:

  * VS designer
  * Command-line SqlMetal tool
  * Hand-coded with attributes
  * Hand-coded with external XML files

Take a real close look at that last one.&nbsp; Reaaal close.&nbsp; Now three times fast:

> LINQ to SQL supports persistence ignorance
> 
> LINQ to SQL supports persistence ignorance
> 
> **LINQ to SQL supports persistence ignorance!**

You read that right folks, LINQ to Entities _does not_ support persistence ignorance, but **LINQ to SQL does!**&nbsp; Perhaps one of these teams should talk to the other.

### So is it the real deal?

I ordered the options from most to least intrusive on your entity objects.&nbsp; Obviously, the designer does not support a very maintainable solution, as it will run into the same issues of the last fifty drag-and-drop database products.

SqlMetal can help create your initial entities, but this is from a DB-first perspective, which I don&#8217;t run into for greenfield projects.&nbsp; I don&#8217;t create my database first, I create entities first, so this won&#8217;t help me unless I run into an existing database.&nbsp; In that case, I probably _still_ won&#8217;t use the tool, as existing databases can be their own form of crazy legacy code.

Hand-coding with attributes allows me to decorate my classes, but it tends to clutter up my entities.&nbsp; I don&#8217;t want to look at my business objects and see a mess of persistence decorations.

Finally, the external XML files.&nbsp; Now I&#8217;m pretty much where I am with NHibernate, except in a much more primitive version.&nbsp; The mappings are nowhere close, not even in the same ballpark as NHibernate&#8217;s options.&nbsp; LINQ to SQL is strictly table-per-class, and collection mappings aren&#8217;t that hot.&nbsp; Additionally, I wind up having to repeat a lot of the same information.

Finally, I have to specify the location of the XML file whenever I create the DataContext object.&nbsp; I have a few options, but basically LINQ to SQL has no mechanism that I see to &#8220;figure out&#8221; where the mapping might be.

For me, the final verdict is: **Though LINQ to SQL gives me powerful strongly-typed querying abilities with LINQ, the only maintainable mapping option still pales in comparison to NHibernate.**

Whether or not LINQ to SQL queries belong anywhere but inside your Repositories is another question&#8230;