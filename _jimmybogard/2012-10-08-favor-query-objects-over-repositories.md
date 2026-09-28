---
wordpress_id: 676
title: Favor query objects over repositories
date: 2012-10-08T13:27:51+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/10/08/favor-query-objects-over-repositories/
dsq_thread_id:
  - "876577661"
categories:
  - DomainDrivenDesign
---
So I’m over [Repositories](http://martinfowler.com/eaaCatalog/repository.html), and definitely over [abstracting your data layer](https://lostechies.com/jimmybogard/2012/09/20/limiting-your-abstractions/), but where does that leave us? I don’t think creating an abstraction over your ORM provides much value, nor do I think it is necessarily bad if you use your ORM directly in the UI tier. After all, it’s pretty hard to suggest that this:

{% gist 3755845 %}

Is not maintainable. You can pretty easily write tests for this code, just going straight against the actual underlying data source. But queries can get hairy, and I might have too much going on in my controller action at some point that would necessitate some level of refactoring.

In the land of repositories, we might solve this by adding another method on a Repository to accomplish this. However, we really have another concept going on here – the concept of a named query. Instead of bloating a data access god class, why not just create an isolated class that encapsulates our query?

Let’s create a query that is just the extracted method and class of the query above:

{% gist 3852502 %}

My query encapsulates not the data access, but the query itself. However crazy my query gets, it’s isolated from my controller action:

{% gist 3852511 %}

We could have used dependency injection to push our query object in, but I’m still not convinced an application as flat as RaccoonBlog needs a container. It’s just not that interesting, yet.

Instead of a bloated repository with queries as a method, each of which is only used in one location, I have a class that encapsulates the concept of a query. I didn’t bother trying to create some layer supertype for queries – I don’t think that has much value either.

But in the case we want to isolate queries, building a concept around that purpose serves a lot better than dumping everything into a common class.