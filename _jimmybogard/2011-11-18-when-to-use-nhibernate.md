---
id: 547
title: When to use NHibernate
date: 2011-11-18T14:35:40+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2011/11/18/when-to-use-nhibernate/
dsq_thread_id:
  - "476313890"
categories:
  - DomainDrivenDesign
---
Ayende posted some [guidance on when to use NHibernate](http://ayende.com/blog/136195/when-should-you-use-nhibernate):

> If you are using a relational database, and you are going to do writes, you want to use NHibernate. 
> 
> If all you are doing are reads, you don’t need NHibernate, you can use something like Massive instead, and it would probably be easier. But when you have read & writes on a relational database, NHibernate is going to be a better choice.

That’s pretty much mirroring my experience lately, although I’m starting to have a higher bar for the writes. If your database actually has relationships enforced by constraints on writes, that’s when I feel that NHibernate is useful. Otherwise, we’re starting to use things like Simple.Data, Massive, PetaPoco etc. for reads _and_ writes. 

For CRUD kinds of systems, where you don’t really have relationships, it’s much easier to go the Micro-ORM route, where you’re just trying to get from SQL to POCO as quickly and easily as possible. 

However, if you do have relationships that you want to model in code, that pretty much immediately starts to require NHibernate. But, if you draw your DDD bounded contexts well, you’ll find you need a lot less Big Bad Frameworks to get things done.