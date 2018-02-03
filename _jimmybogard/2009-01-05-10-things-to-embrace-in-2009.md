---
wordpress_id: 269
title: 10 things to embrace in 2009
date: 2009-01-05T02:40:39+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/01/04/10-things-to-embrace-in-2009.aspx
dsq_thread_id:
  - "264716013"
  - "264716013"
categories:
  - Rant
---
With 2008 behind us, what better way to kick off the new year than another cheesy top 10 list.&#160; This time, with **more bold!**

Rather than focus on the negative, here are a few things I’d like to see continued and embraced in the year ahead.

### 1) Open spaces

Open spaces, coupled with targeted workshops, provided the best bang-for-your buck experience for technical conference this past year.&#160; What started (in the .NET space) with 2007’s ALT.NET Conference, continued with ALT.NET Seattle, spread to other cities, countries and continents, and taken to the next level with KaizenConf and workshop.&#160; The quality of conversations at these events, before, during and after, in the sessions, in the hallways and continued at hotels and local dives and eateries, was top notch.&#160; Open spaces encourage community growth through multiplication instead of addition, and I’m happy to see this format branch out more and more in the .NET community.

### 2) MS forays into ORM

A few years ago, ORMs were described as the [“Vietnam of Computer Science”](http://blogs.tedneward.com/2006/06/26/The+Vietnam+Of+Computer+Science.aspx).&#160; It’s an oft-misunderstood metaphor that still requires a read today.&#160; However, as modern ORMs embraced the POxO (Plain Ol’ Xxx Objects), much of the impedance mismatch problems disappeared.&#160; I’ve used NHibernate on green-field, brown-field and mine-field applications, with NHibernate never missing a step.&#160; ORMs _are_ a viable and recommended data access strategy, but not every enterprise is ready (or able) to embrace OSS.&#160; In these cases, MS technologies such as LINQ to SQL and the Entity Framework are valid options for teams tired of hand-rolling ADO.NET code.&#160; Although each technology has its deficiencies (one so much so, I signed a Vote of No Confidence), the development teams are listening and incorporating feedback.&#160; My sincere hope is that these technologies don’t get reset or canceled, as we’ve seen with SQL Server Notification Services and Workflow Foundation.&#160; However flawed it may be, efforts by MS to develop ORM technology are a step in the right direction.

### 3) OSS and MS

CodePlex.com is a site design, run and operated by Microsoft to host open source projects.&#160; Several MS projects have made their way to at least open their source code (but not accept patches) onto CodePlex.&#160; This again is a Good Thing.&#160; I don’t expect, nor will I ever care if MS open sources Windows or Office.&#160; But it’s encouraging to see DevDiv realizing the benefits of OSS.&#160; I’m no [FreeTard](http://www.urbandictionary.com/define.php?term=Freetard), nor do I see OSS leading society into some hippie magic love-land, but OSS can react more quickly to feedback than traditional closed-source software.&#160; What I’d _love_ to see is that one the first questions a new product team at MS asks itself is, “should we CodePlex this one?”&#160; Just asking that question shows a huge shift in attitude.

### 4) LINQ query providers

Last year saw a big push to expand the LINQ providers to the major ORMs, including LLBLGen, NHibernate, and the MS offerings that included LINQ built-in (LINQ to SQL and the EF).&#160; The way I see it, the more exposure LINQ query expressions get, the more we’ll hear requests for the compiler hooks that made this magic possible made public.&#160; While I’m not holding my breath, the increased attention on language-oriented programming and internal DSLs triggered an explosion of innovation.&#160; The gut reaction to a powerful new tool is “how will it be abused”.&#160; Abuse is inevitable, but sharp tools drive innovation.&#160; LINQ allows a terse querying syntax that’s both easy to read, yet powerful.&#160; You’ll need to understand the basics of deferred execution and expressions to fully grasp the implications of the LINQ compiler magic, but once you do, many of the LINQ query operators (Where, SelectMany, etc) become quite elegant in LINQ.&#160; But _only_ if a LINQ query provider exists.

### 5) Expanding xDD ideas

DDD, BDD and TDD saw a big expansion into the .NET community in 2008.&#160; For the first time that I can remember, MS products were designed with testability in mind.&#160; Several of the MS products released on CodePlex also included unit tests.&#160; In Rob Conery’s excellent [MVC Storefront](http://blog.wekeroad.com/mvc-storefront/) series, Rob shares his journey in creating an awesome MVC application, using a wide variety of design principles and techniques.&#160; BDD is starting to come on strong as well, with a BDD mailing list with folks from many communities (Ruby, .NET and Java) participating in the conversation.&#160; Software development still has a long way to go to match the maturity of other engineering disciplines, but pushing better design, architecture and development practices will get our industry [BLARG]

### 6) Internal DSLs and Fluent Interfaces

The ease of parsing XML made it an easy choice for framework developers as a means to provide configuration.&#160; As anyone that is familiar with Spring can attest, something went horribly awry.&#160; As a programming language, XML stinks.&#160; It’s verbose, noisy, and stifling.&#160; With extension methods, lambda expressions, and expression trees in C# 3.0, a lot of pieces were in place to support some quite powerful language-oriented programming.&#160; Although we hit some bumps in the road (Fluent Interfaces aren’t supposed to read like Tolstoy), some great internal DSLs in applications like Rhino Mocks and StructureMap show the potential of the C# language.&#160; I’m personally looking forward to [Fowler’s DSL book](http://martinfowler.com/dslwip/index.html), whose website already provides a great source of information on DSLs.&#160; It’s a testament to the power of these ideas to see how quickly they’ve taken hold.

### 7) Quitting while you’re ahead…or behind

Top 10 lists are lame, even if they **sprinkle in the bold**.&#160; Bogard out.