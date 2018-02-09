---
wordpress_id: 603
title: Integrating and isolating the container in tests
date: 2012-03-19T13:35:14+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/03/19/integrating-and-isolating-the-container-in-tests/
dsq_thread_id:
  - "616570674"
categories:
  - TDD
---
In unit tests, an IoC container rarely enters the mix. In integration tests, or more end-to-end tests, I like to use the exact same configuration for the container as I do in production. Recreating production scenarios and environments in tests helps prevent those launch night bugs where “it works on my machine” but not when the entire app is up and running.

However, not everything needs to be up and running in integration tests. I often want to stub out services on the outermost periphery in my application. Places where I call into things I _can’t_ control, like external web services, still need to be stubbed out in my tests.

This poses a challenge – I want to have a configured container in my tests, but provide test-specific behaviors. I want any custom configuration/stubs to go away after my test is done, and have each test start with a blank slate. So you could do something like this:

{% gist 2112066 %}

However, each time a test runs, the container is re-initialized. But in our production apps, we initialize the container just once, so why not just initialize once in our tests? The trick is that we need to reset the container to a known state before each test.

The solution here is to use the concept of nested/child containers. In a nested container, its configuration is cloned but isolated from the parent container. We want our tests to use this nested container instead:

{% gist 2112149 %}

Folks using the container need to go through this base GetInstance method, and not go straight to the container. For injecting dummy/stub instances, the Inject method configures just that nested container, and leaves the root container untouched.

If you’re doing a lot of integration/full-system-tests, you can get quite a drop in the time it takes your tests to run if you make sure those things that are expensive to initialize (container/ORM) are initialized only once per entire test suite. Once you have that in place, it’s just a matter of integrating and isolating changes from one test to the other. With nested containers, it’s a cinch.