---
wordpress_id: 4764
title: 'Starting a new project &#8211; refactoring an existing system'
date: 2009-02-05T20:07:30+00:00
author: Steve Donie
layout: post
wordpress_guid: /blogs/stevedonie/archive/2009/02/05/starting-a-new-project-refactoring-an-existing-system.aspx
dsq_thread_id:
  - "262124051"
categories:
  - Uncategorized
redirect_from: "/blogs/stevedonie/archive/2009/02/05/starting-a-new-project-refactoring-an-existing-system.aspx/"
---
Well, the team is starting on a new project. Our company is in a situation that is probably familiar to many people. We have some existing code, we have data in the database, everything &#8216;sorta&#8217; works. But now we want to add some new functionality, and there is fear. Fear that changes to the existing system will break things that currently work. 

So far we have spent about a month trying to figure out the existing system. I spent some time meeting with developers who have worked on the existing code, spent lots of time meeting with the product owner, and lots of time looking at the code. It is definitely going to be a tricky problem. One of the most difficult things for me has been trying to work this project in an agile method. We have created stories and added them to a backlog, but a lot of them are very vague &#8211; &#8220;Understand and document Document table&#8221; is one example. 

Here are some of the challenges we have already identified:

  * The whole system is basically a document management system that stores scanned images (Well Logs) and data about those well logs.
  * The system is comprised of loaders that read data coming from somewhere else that evaluate the data and then store the meta data in the database and the files on a fileserver.
  * Right now, there are at least 3 loaders in active use, each of which is similar to the others, but with a lot of copy-paste code reuse.
  * The database schema has a concept of a generic document, but has been &#8216;polluted&#8217; over time with well log specific columns.
  * The is very little of the SOLID principles in use &#8211; we have jsp&#8217;s that do presentation, database queries, and filesystem operations, for example.
  * There are very few tests of the existing system.
  * The document management system is fairly central to the company, and manages much more than just the well logs, so any changes made for well logs have to take other documents into account also.
  * There is a pricing system in place that charges customers for downloading the logs (naturally, with duplicated logic in various places).

One key thing we are trying to keep in mind as we work on this project is that we want to deliver business value as quickly as possible, but we also want to improve the system and reduce development effort, as we are fairly certain that there will be additional features and datasets to process in the future. So we&#8217;re trying to strike a balance between a full rewrite of large parts of the system and shipping something that provides value quickly. 

I&#8217;ll keep writing as we progress on this project. It has definitely been one of the more difficult things I have ever taken on. I&#8217;d welcome anyone&#8217;s feedback on how they have taken on similar projects.