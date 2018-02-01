---
id: 1082
title: 'Clean Tests: Isolation with Fakes'
date: 2015-03-24T15:58:32+00:00
author: Jimmy Bogard
layout: post
guid: https://lostechies.com/jimmybogard/?p=1082
dsq_thread_id:
  - "3622845081"
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

So far in this series, I’ve walked through different modes of isolation – from internal state using child containers and external state with database resets and [Respawn](https://github.com/jbogard/respawn). In my tests, I try to avoid fakes/mocks as much as possible. If I can control the state, isolating it, then I’ll leave the real implementations in my tests.

There are some edge cases in which there are dependencies that I can’t control – web services, message queues and so on. For these difficult to isolate dependencies, fakes are acceptable. We’re using AutoFixture to supply our mocks, and child containers to isolate any modifications. It should be fairly straightforward then to forward mocks in our container.

As far as mocking frameworks go, I try to **pick the mocking framework with the simplest interface and the least amount of features**. More features is more headache, as mocking frameworks go. For me, that would be [FakeItEasy](http://fakeiteasy.github.io/).

First, let’s look at a simple scenario of creating a mock and modifying our container.

### Manual injection

We’ve got our libraries added, now we just need to add a way to create a fake and inject it into our child container. Since we’ve built an explicit fixture object, this is the perfect place to put our code:

[gist id=a47c41d2d15b4de9e1ae]

We create the fake using FakeItEasy, then inject the instance into our child container. Because we might have some existing instances configured, I use “EjectAllInstancesOf” to purge any configured instances. Once we’ve injected our fake, we can now both configure the fake and use our container to build out an instance of a root component. The code we’re trying to test is:

[gist id=9b28f34b7535b996b6a7]

In our situation, the approval service is some web service that we can’t control and we’d like to stub that out. Our test now becomes:

[gist id=0f8e1629991ea2a315dd]

Instead of using FakeItEasy directly, we go through our fixture instead. Once our fixture creates the fake, we can use the fixture’s child container directly to build out our root component. We configured the child container to use our fake instead of the real web service – but this is encapsulated in our test. We just grab a fake and start going.

The manual injection works fine, but we can also instruct AutoFixture to handle this a little more intelligently.

### Automatic injection

We’re trying to get out of creating the fake and root component ourselves – that’s what AutoFixture is supposed to take care of, creating our fixtures. We can instead create an attribute that AutoFixture can key into:

[gist id=d2d7cf2df9f2cc763897]

Instead of building out the fixture items ourselves, we go back to AutoFixture supplying them, but now with our new Fake attribute:

[gist id=83e6f38939e6ee2a5cd6]

In order to build out our fake instances, we need to create a specimen builder for AutoFixture:

[gist id=9ad9f90ed4587c6b89ec]

It’s the same code as inside our context object’s “Fake” method, made a tiny bit more verbose since we’re dealing with type metadata. Finally, we need to register our specimen builder with AutoFixture:

[gist id=fc941023014f4b24357a]

We now have two options when building out fakes – manually through our context object, or automatically through AutoFixture. Either way, our fakes are completely isolated from other tests but we still build out our root components we’re testing through our container. Building out through the container forces our test to match what we’d do in production as much as possible. This cuts down on false positives/negatives.

That’s it for this series on clean tests – we looked at isolating internal and external state, using Fixie to build out how we want to structure tests, and AutoFixture to supply our inputs. At one point, I wasn’t too interested in structuring and refactoring test code. But having been on projects with lots of tests, I’ve found that **tests retain their value when we put thought into their design, favor composition over inheritance, and try to keep them as tightly focused as possible** (just like production code).