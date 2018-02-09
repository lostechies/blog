---
wordpress_id: 847
title: Proper Session/DbContext lifecycle management
date: 2013-12-20T14:56:50+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=847
dsq_thread_id:
  - "2063097269"
categories:
  - Architecture
  - Patterns
---
Most “heavy” object-relational mappers (ORMs) have an interface that provides more than just easy querying of the database. They also are implementations of two key patterns:

  * [Unit of Work](http://martinfowler.com/eaaCatalog/unitOfWork.html)
  * [Identity Map](http://martinfowler.com/eaaCatalog/identityMap.html)

For NHibernate, this is the ISession interface, and for Entity Framework, this is the DbContext class. Because these two classes are implementations of the Unit of Work pattern, we need to consider this as we design the lifecycle of these ORM interfaces. Reviewing a Unit of Work, it:

> Maintains a list of objects affected by a business transaction and coordinates the writing out of changes and the resolution of concurrency problems.

99% of the problems I see with bad session management is not understanding the Unit of Work pattern. Unit of Work is all about defining a “business transaction” and from there tailoring your session management accordingly. I’ll refer to both the ISession and DbContext objects as a “session” to make it easier.

Most of the time, a “business transaction” should be the same as a “database transaction”, and I usually make these one and the same. From an user interaction of view, there’s an expectation of transaction around operations. Click a button, hit “save” are all expectations that an operation succeeds or fails, but not both. In short, our session and transaction boundaries should be:

  * For web applications, use a session per request
  * For thick-client applications, use session per operation/command

In fact, this is exactly what both NHibernate and [Microsoft](http://msdn.microsoft.com/en-us/data/jj729737.aspx) recommend in the documentation. Pretty simple, no? In a web application, a common way of achieving this is to scope a session to an HttpContext instance. You can use filters in MVC or Application events (BeginRequest/EndRequest) to begin/commit transactions. The key though is all code using a session needs to be using the same instance. This is why I typically use the container to control lifecycle – it’s far too easy to screw this up yourself, and far easier to test when your business logic is unconcerned with transactions.

### Sessions and repositories

If you’re using a repository, you shouldn’t be opening or closing sessions/transactions. Business transaction boundaries are a concern of the application, not low-level services. Don’t do this:

{% gist 8009286 %}

Consumers of your repository don’t know that you’re opening and closing sessions, nor should they. It’s completely non-obvious and potentially nasty behavior. If a user calls “Save” twice and then “Delete” in the context of one business operation, “Delete” could fail but the two “Save” calls succeed! Very nasty behavior, indeed! Even if we merely open/close sessions for reads (I’ve seen this done to prevent lazy-loading), it’s still not obvious and prevents us from using the Unit of Work and Identity Map functionality. Again, not a good idea.

Instead, our repository should merely consume a session:

{% gist 8009323 %}

Control of the business transaction is restored back to the application.

In short, a session represents a unit of work, a unit of work represents a business transaction, and a business transaction almost always represents a user interface operation. Tailor your session lifecycle around user interface operations (requests for web, commands for thick client) and your ORM will give you predictable, obvious results.