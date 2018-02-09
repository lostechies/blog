---
wordpress_id: 1073
title: 'Clean Tests: Isolating the Database'
date: 2015-03-02T17:35:04+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=1073
dsq_thread_id:
  - "3561214580"
categories:
  - Testing
---
Other posts in this series:

  * [A Primer](http://lostechies.com/jimmybogard/2015/01/29/clean-tests-a-primer/)
  * [Building Test Types](http://lostechies.com/jimmybogard/2015/02/05/clean-tests-building-test-types/)
  * [Isolating Internal State](http://lostechies.com/jimmybogard/2015/02/17/clean-tests-isolating-internal-state/)
  * [Isolating the Database](http://lostechies.com/jimmybogard/2015/03/02/clean-tests-isolating-the-database/)
  * [Isolation with Fakes](https://lostechies.com/jimmybogard/2015/03/24/clean-tests-isolation-with-fakes/)
  * [Database Persistence](https://lostechies.com/jimmybogard/2015/04/07/clean-tests-database-peristence)

Isolating the database can be pretty difficult to do, but I’ve settled on a general approach that allows me to ensure my tests are built from a consistent starting point. I prefer a consistent starting point over something like rolled back transactions, since a rolled back transaction assumes that the database is in a consistent state to begin with.

I’m going to use my tool [Respawn](https://github.com/jbogard/respawn) to [build a reliable starting point in my tests](http://lostechies.com/jimmybogard/2015/02/19/reliable-database-tests-with-respawn/), and integrate it into my tests. In my last post, I walked through creating a common fixture in which my tests use to build internal state. I’m going to extend that fixture to also include my Respawn project:

{% gist 80ff30ea0ccb464021d2 %}

Since my SlowTestFixture is used in both styles of organization (fixture per test class/test method), my database will either get reset before my test class is constructed, or before each test method. My tests start with a clean slate, and I never have to worry about my tests failing because of inconsistent state again. The one downside I have is that my tests can’t be run in parallel at this point, but that’s a small price to pay.

That’s pretty much all there is – because I’ve created a common fixture class, it’s easy to add more behavior as necessary. In the next post, I’ll bring all these concepts together with a couple of complete examples.