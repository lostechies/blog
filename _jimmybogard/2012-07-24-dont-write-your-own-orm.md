---
wordpress_id: 649
title: Don’t write your own ORM
date: 2012-07-24T12:49:29+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/07/24/dont-write-your-own-orm/
dsq_thread_id:
  - "778082118"
categories:
  - Architecture
---
In my last post, I talked about various kinds of patterns of ORMs and [how to choose an ORM strategy](https://lostechies.com/jimmybogard/2012/07/20/choosing-an-orm-strategy/). From the comments and tweets I got, it seems like some folks still think that their only ORM choices are:

  * NHibernate/EF
  * Roll your own

The point of the discussion was to highlight different ways to do an ORM, and even within some ORMs, different tactics of use. But unless you’re [Ayende](http://ayende.com/blog) or [Greg Young](http://codebetter.com/gregyoung/), you should not write your own ORM. **If you have to map relational data to objects, you must use an ORM.** Your custom data access layer that is an ADO.NET façade, that is an ORM.

If you are writing code to read from an [IDataReader](http://msdn.microsoft.com/en-us/library/system.data.idatareader.aspx), or manually building up an [IDbCommand](http://msdn.microsoft.com/en-us/library/bt2afddc), stop. As [Jeremy Miller put it](http://codebetter.com/jeremymiller/2008/11/07/how-to-design-your-data-connectivity-strategy/)

> if you’re writing ADO.Net code by hand, you’re stealing from your employer or client.

Seriously. Those APIs are horribly outdated and ridiculous to use. All of the manual SqlParameter building, type coercion, DbNull conversions etc. etc. is a solved problem. If you don’t want to bring in a “heavyweight” ORM, that’s great! Instead, choose one of these awesome alternatives:

  * [Dapper](http://code.google.com/p/dapper-dot-net/)
  * [PetaPoco](http://www.toptensoftware.com/petapoco/)
  * [Massive](https://github.com/robconery/massive/)

I’ve seen way too many codebases with hand-rolled abstractions for ADO.NET, and it’s all just extra cognitive weight in the application. Just don’t do it. Except for some very edge cases (which probably means yours is not), there is not a business case to writing ADO.NET code by hand. You’re wasting time writing and maintaining code for a problem that has already been solved.

Minimize the code you have to write for an application. Lean on existing tools. And please, stop writing your own ORM.