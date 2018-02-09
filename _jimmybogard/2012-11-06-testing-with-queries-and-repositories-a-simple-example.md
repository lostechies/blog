---
wordpress_id: 687
title: Testing with queries and repositories (a simple example)
date: 2012-11-06T14:53:12+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=687
dsq_thread_id:
  - "916052772"
categories:
  - Testing
---
Not being [much of a fan of the Repository pattern](http://lostechies.com/jimmybogard/2012/10/08/favor-query-objects-over-repositories/), or better yet, not a fan of applying it as a universal data access strategy, one question that comes up often is “but what about testing”? But the question should really be “what am I testing”?

Let’s look at something like our original controller action we were trying to test:

{% gist 3755895 %}

This is a fairly complicated query, and one worth testing. The question then comes back to “what should I test”? Is my goal to write a unit test for the controller action, or an integration test for the query? Both? Let’s try both, and see what happens.

In order for us to isolate the controller action from the query, we need to create some sort of seam. Whether I go with a query object or repository, I’m looking at faking the results of the query. Let’s go with a repository just for familiarity sake, though the query path will be largely the same:

{% gist 4025056 %}

I’ve extracted the query part and moved it to a specific class. Whether it’s a repository or query again is irrelevant, as I now have a seam to introduce a fake query result through the constructor:

{% gist 4025074 %}

Let’s write a test for this:

{% gist 4025111 %}

Is there any value in this test? I don’t think so. It’s heavily coupled to the inner workings of the method, and in the end, doesn’t really prove anything.

This isn’t so much the fault of the test as what I was trying to test. Controller unit tests don’t have too much value in my opinion – it still requires a lot of plumbing to truly know that it will work. To put it another way, I don’t really have confidence of anything other than those three lines of code in my controller are correct. And that’s not really saying much at all.

For our repository, we’d just write an integration test. Since RavenDB supports running the server in memory, we don’t really sacrifice much speed in our tests by doing so.

So where does that leave us? Our unit test for the controller action was next to worthless, but testing the query is actually important. The question really comes back to goals. If our goal is to test the query, providing a seam in that direction could prove helpful. If I can test my query through the controller action, fine, otherwise, I’ll create a seam for the query.

But in my controller action, unless there is truly interesting behavior, I don’t feel the need to test those three lines of code. It’s just not worth the time or effort.