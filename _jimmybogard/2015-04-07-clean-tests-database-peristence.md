---
wordpress_id: 1090
title: 'Clean Tests: Database Persistence'
date: 2015-04-07T16:13:46+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1090
dsq_thread_id:
  - "3662266243"
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

A couple of posts ago, I walked through my preferred solution of isolating database state using intelligent database wiping with [Respawn](https://github.com/jbogard/respawn). Inside a test, we still need to worry about persisting items.

This is where things can get a bit tricky. We have to worry about transactions, connections, ORMs (maybe), lazy loading, first-level caches and more. When it comes to figuring out which direction to go in setting up a test environment, I tend to default to matching production behavior. Too many times I&#8217;ve been burned by bizarre test behavior, only to find my test fixture/environment doesn&#8217;t match against any plausible or possible production scenario. It&#8217;s one thing to simply and isolate, it&#8217;s another to operate in a bizzaro world.

In production environments, I deal with a single unit of work per request, whether that request is a command in a thick client app, a web API call, or a server-side MVC request. The world is built up and torn down on every request, creating a lovely stateless environment.

The kicker is that I often need to deal with ORMs, and barring that, some sort of unit of work mechanism even if it&#8217;s a PetaPoco DB object. When I set up state, I want nothing shared between that setup part and the Execute step of my test:

[<img class="alignnone  wp-image-1091" title="Picture1" src="https://lostechies.com/jimmybogard/files/2015/04/Picture1.png" alt="" width="384" height="191" />](https://lostechies.com/jimmybogard/files/2015/04/Picture1.png)

Each of these steps is isolated from the other. With my apps, the Execute step is easy to put inside an isolated unit of work since I&#8217;m using [MediatR](https://github.com/jbogard/mediatr), so I&#8217;ll just need to worry about Setup and Verify.

I want something flexible that works with different styles of tests and not have something implicit like a Before/After hook in my tests. It needs to be completely obvious &#8220;these things are in a unit of work&#8221;. Luckily, I have a good hook to do so with that Fixture object I use to have a central point of my test setup.

### Setup

At the setup portion of my tests, I&#8217;m generally only saving things. In that case, I can just create a helper method in my test fixture to build up a DbContext (in the case of Entity Framework) and save some things:

{% gist e2926bedb1ab8d5786eb %}

We create our context, open a transaction, perform whatever action and commit/rollback our transaction. With this method, we now have a simple way to perform any action in an isolated transaction without our test needing to worry about the semantics of transactions, change tracking and the like. We can create a convenience method to save a set of entities:

{% gist c3dc344e6e888cad5803 %}

And finally in our tests:

{% gist 4d50f9e339ee88cc8c2c %}

We still have our entities to be used in our tests, but they&#8217;re now detached and isolated from any ORMs. When we get to Verify, we&#8217;ll look at reloading these entities. But first, let&#8217;s look at Execute.

### Execute

As I mentioned earlier, for most of the apps I build today requests are funneled through MediatR. This provides a nice uniform interface and jumping off point for any additional behaviors/extensions. A side benefit are the Execute step in my tests are usually just a Send call (unless it&#8217;s unit tests against the domain model directly).

In production, there&#8217;s a context set up, a transaction started, request made and sent down to MediatR. Some of these steps, however, are embedded in extension points of the environment, and even if extracted out, they&#8217;re started from extension points. Take for example transactions, I hook these up using filters/modules. To use that exact execution path I would need to stand up a dummy server.

That&#8217;s a little much, but I can at least do the same things I was doing before. I like to treat the Fixture as the fixture for Execute, and isolate Setup and Verify. If I do this, then I just need a little helper method to send a request and get a response, all inside a transaction:

{% gist 086cbaddc5333b99ed75 %}

It looks very similar to the &#8220;Txn&#8221; method I build earlier, except I&#8217;m treating the child container as part of my context and retrieving all items from it including any ORM class. Sending a request like this ensures that when I&#8217;m done with Send in my test method, everything is completely done and persisted:

{% gist b5d1e0c021aaeb7cc4dd %}

My class under test now routes through this handler:

{% gist e154481d7b636f6d098f %}

With my Execute built around a uniform interface with reliable, repeatable results, all that&#8217;s left is the Verify step.

### Verify

Failures around Verify typically arise because I&#8217;m verifying against in-memory objects that haven&#8217;t been rehydrated. A test might pass or fail because I&#8217;m asserting against the result from a method, but in actuality a user makes a POST, something mutates, and a subsequent GET retrieves the new information. I want to reliably recreate this flow in my tests, but not go through all the hoops of making requests. I need to make a fresh request to the database, bypassing any caches, in-memory objects and the like.

One way to do this is to reload an item:

{% gist 509bfd026e26b65f96a4 %}

I pass in an entity I want to reload, and a means to get the item&#8217;s ID. Inside a transaction and fresh DbContext, I reload the entity and set it as the ref parameter in my method. In my test, I can then use this reloaded entity as what I assert against:

{% gist 4e72eeda76567eee0643 %}

In this case, I tend to prefer the &#8220;ref&#8221; argument rather than something like &#8220;foo = fixture.Reload(foo, foo.Id)&#8221;, but I might be in the minority here.

With these patterns in place, I can rest assured that my Setup, Execute and Verify are appropriately isolated and match production usage as much as possible. When my tests match reality, I&#8217;m far less likely to get myself in trouble with false positives/negatives and I can have much greater confidence that my tests actually reduce bugs.