---
id: 185
title: More Entity Framework thoughts
date: 2008-05-19T21:32:47+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/05/19/more-entity-framework-thoughts.aspx
dsq_thread_id:
  - "264715694"
categories:
  - EntityFramework
---
[Dan Simmons](http://blogs.msdn.com/dsimmons/) has a great write-up on Microsoft&#8217;s [vision of Entity Framework](http://blogs.msdn.com/dsimmons/archive/2008/05/17/why-use-the-entity-framework.aspx) that really gives some insight into the motivation behind a lot of the direction that they&#8217;re going in.&nbsp; Go read that post, and come back.

Back now?&nbsp; OK good.&nbsp; I like to pull quotes out, and I don&#8217;t like to pull them out of context, so it&#8217;s best to read the original post or I might seem like a bit of a tool for doing so.

The quote that showed me the direction the best was:

> The EF was specifically structured to separate the process of mapping queries/shaping results from building objects and tracking changes.&nbsp; This makes it easier to create a conceptual model which is how you want to think about your data and then **reuse that conceptual model for a number of other services besides just building objects**.

The emphasis added is mine.&nbsp; Dan then goes on to describe the different ways you might reuse the conceptual model, from reporting, exposing RESTful services, online/offline models, etc etc.

Those are a LOT of different concerns to be talking to the same database.&nbsp; Although a mapping layer provides a translation, it&#8217;s still talking to the same database.

My comment on his post was:

> I think it&#8217;s a mistake to share a data model with anyone outside your bounded context (see Evans, Domain-Driven Design).&nbsp; It&#8217;s also a mistake to share a conceptual model or a EDM or whatever we&#8217;re calling this. 
> 
> I never want domain objects exposed directly via services.&nbsp; That&#8217;s violating the encapsulation I&#8217;m trying to create. 
> 
> If someone wants SSRS, then I give them a separate reporting database, tailored to reporting needs.&nbsp; I don&#8217;t want reporting concerns bleeding into my transactional concerns.&nbsp; A mapping layer will not solve this problem, products like SSIS can.&nbsp; You want reporting? Here&#8217;s your read-only view, updated every hour, five minutes, daily, whatever. 
> 
> Sharing a connection string is sharing a connection string, no matter how much lipstick you put on that pig.

You&#8217;ll get **nothing but trouble** if you share a database connection string, no matter how many layers you put between them.&nbsp; Because eventually, some consumer of that data will want some change in the database (not just the conceptual model).&nbsp; Not maybe, not in edge cases, but always. 

Personally, I&#8217;d much rather go for the Domain-Driven Design style Bounded Context, where I have Anti-Corruption layers between different domains.&nbsp; Sure, an Order entity might have the same identity from context to context, but that doesn&#8217;t mean the conceptual model stays the same. 

And how would you manage and maintain those conceptual models, when so many folks might need change?&nbsp; You&#8217;d have to shape your organization around your conceptual models to be able to handle the feedback and change requests from the different groups using your One True Model. 

The EF goal is well beyond simple ORM.&nbsp; It&#8217;s an Object-Relational Mapper Mapper.&nbsp; You map your ORM to another conceptual map, which maps to the data model map, which maps to the database.&nbsp; The &#8220;just building objects&#8221; part tells me that EF is seriously discounting the idea of a rich domain model, which is where the heart of my business logic is. 

There, and in stored procedures of course.