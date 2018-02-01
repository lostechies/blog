---
id: 1064
title: 'Clean Tests: Isolating Internal State'
date: 2015-02-17T17:46:48+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=1064
dsq_thread_id:
  - "3524067081"
categories:
  - Fixie
  - Testing
---
Other posts in this series:

  * [A Primer](http://lostechies.com/jimmybogard/2015/01/29/clean-tests-a-primer/ "Clean Tests: A Primer")
  * [Building Test Types](http://lostechies.com/jimmybogard/2015/02/05/clean-tests-building-test-types/ "Clean Tests: Building Test Types")
  * [Isolating Internal State](http://lostechies.com/jimmybogard/2015/02/17/clean-tests-isolating-internal-state/)
  * [Isolating the Database](http://lostechies.com/jimmybogard/2015/03/02/clean-tests-isolating-the-database/)
  * [Isolation with Fakes](https://lostechies.com/jimmybogard/2015/03/24/clean-tests-isolation-with-fakes/ "Clean Tests: Isolation with Fakes")
  * [Database Persistence](https://lostechies.com/jimmybogard/2015/04/07/clean-tests-database-peristence)

One of the more difficult problems with slow tests that touch shared resources is building a clean starting point. In order for tests to be reliable, the environment in which the test executes needs to be in a reliable, consistent starting state. In slow tests, in which I’m accessing out-of-process dependencies, I’m worried about two things:

  * External state is known and consistent
  * Internal state is known and consistent

In order to keep my sanity, I want to put the responsibility of building that known starting point into a [Standard Fixture](http://xunitpatterns.com/Standard%20Fixture.html). This fixture is responsible for creating that starting point, and it’s this starting point that ensures the long-term maintainability of my system.

### Consistent internal state

Since I’m using AutoFixture for the creation and configuration of my fixture, it will be AutoFixture I use to build out my Standard Fixture. My standard fixture will be a single class in which my tests will interact with, and because the name “Fixture” is a bit overused in many libraries, I have to name my class somewhat specifically, and it will start with building out an isolated sandbox for my internal state:

[gist id=e3fbd79ab13ea2b4df04]

I use a DI container as my [composition root](http://blog.ploeh.dk/2011/07/28/CompositionRoot/) in my systems, and this combined with child containers allows me to ensure that I have a unique, isolated sandbox for running my tests. The root container is my blueprint for an execution context, and represents what I do in production. The child container’s configuration, whatever I might do to it, lives only for the context of this one test.

Throughout the rest of my tests, I can access that container to build components as need be. The next piece I’ll need is to tell AutoFixture about this fixture, and to use it both when someone needs access to the context as well as when someone needs an instance of something.

In AutoFixture, this is done via fixture customizations:

[gist id=369c84d83180675cf5bb]

Customizations alter behaviors of the AutoFixture’s fixture object, allowing me to add effectively new links in a chain of responsbility pattern. I want two behaviors added:

  * Access to the fixture
  * Building container-supplied instances

The first is simple, I can register individual instances with AutoFixture using the “Register” method. The second, since it depends on the type supplied, needs its own isolated customization:

[gist id=2f08e07ec4a3cf3a3c29]

AutoFixture calls each specimen builder, one at a time, and each specimen builder either builds out an instance or returns a null object, the “NoSpecimen” object.

Ultimately, the goal is to be able to have my tests to use a pre-built component, or to use the fixture as necessary:

[gist id=3e47e12d2dd5b6cbf223]

The last part I need to fill in is to modify Fixie to use my customizations when building up test instances. This is in my Fixie convention where I had previously configured Fixie to use AutoFixture to instantiate my test classes:

[gist id=117a8215d50620939f31]

My tests now have an isolated sandbox for internal state, as each child container instance is isolated per fixture. If I need to inject stubs/fakes, I don’t affect any other tests because of how I’ve built the boundaries of my test in Fixie.

In the next post, I’ll look at isolating external state (the database).