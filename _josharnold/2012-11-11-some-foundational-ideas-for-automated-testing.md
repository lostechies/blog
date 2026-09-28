---
wordpress_id: 4102
title: Some foundational ideas for automated testing
date: 2012-11-11T00:36:13+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=192
dsq_thread_id:
  - "922453896"
categories:
  - general
tags:
  - automated-testing
  - Patterns
  - Testing
---
Let’s get the blanket statement out of the way, shall we?

> **Automated testing is hard**

We have all sorts of strategies and patterns that are well-known and used every day for unit testing and integration testing. We all have differing opinions on the value of the tests and even the approaches to testing. What I’ve noticed, though, is that most of us spend our time arguing about the most effective testing vs. actually doing it.

### Example: User registration

I’m picking a terribly boring example but allow me to explore this one a little. Let’s say that we have a few stories that we need to play:

  1. A visitor of the application can register for a new account and subscribe to one of the available payment plans
  2. Upon successful registration, new users should receive a confirmation email

These two stories force us to come up with a basic payment/subscription model and a notification mechanism. From an acceptance testing perspective, I imagine having some tests like:

  1. When registering for a new account, verify that the available subscription/payment plans are shown
  2. When registering for a new account, the username field should not accept a value that already exists
  3. After registering for a new account, verify that a confirmation email was received

### System State

My team uses an explicit concept that we call “system state”. I say explicit because we model the state of the system and build infrastructure to enable us to create/restore a particular snapshot. Let me unpack that one a little.

In my opinion, tests are best expressed by explicitly stating the data that they depend on. That is, the “state” of your system should be expressed as a step within your test. Let’s revisit our previous acceptance criteria and give an example.

> When registering for a new account, verify that the available payment plans are shown

The steps of this test should read something like:

  1. The available subscriptions are: “Subscription 1, Subscription 3”
  2. Navigate to the Registration screen
  3. The displayed subscriptions are: “Subscription 1, Subscription 3”

The state of the system is expressed by noting which subscriptions exist in the system in step 1. Let’s go ahead and move on to the next acceptance test.

> When registering for a new account, the username field should not accept a value that already exists

Rather than using a “magic value” for an existing username, let’s make our test read explicitly:

  1. The Users are: jmarnold, jeremydmiller
  2. Navigate to the Registration screen
  3. Enter “jmarnold” for the Username field
  4. Click Save
  5. The validation messages should be: “Username ‘jmarnold’ is already in use”

Now what of our confirmation email test? Should we bring in one of those tools that reads emails from a directory? Stub the email gateway? Let’s table this one for a moment and talk about the composition of our tests.

### One AppDomain to rule them all

My team has been using this idea for a while now. During automated testing scenarios, we collapse various subsystems into a single appdomain. What does that mean exactly? That means that the following items will be in the same domain during our tests:

  * The web server
  * The database
  * The web application
  * The test harnesses

For us, this means (more on these specific tools in my next post):

  * Our FubuMVC application hosted in SelfHost
  * Embedded RavenDB
  * StoryTeller

### Everything in action

As an example of running everything in a single AppDomain, let’s go back to our test in question:

> After registering for a new account, verify that a confirmation email was received

Let’s assume that we have class like this:



Since we are injecting our settings dependency here, we can easily swap out the configuration. What this means is that we can programmatically configure the application while it’s running.

Now, let’s write our test something like this:

  1. The EmailSettings host is “localhost”
  2. Navigate to the registration screen
  3. Enter “jmarnold” for the username
  4. Enter “Josh” for the first name
  5. Enter “Arnold” for the last name
  6. Enter “123” for the password
  7. Enter <“something@something.com>” for the email
  8. Click Save
  9. Verify that an email was sent to <“something@something.com>”

The system state in this example is changing the configured instance of EmailSettings in our IoC container to use the values specified in the test. You can use your email testing tool of choice here. In the past, we’ve used [EmbeddedMail](http://jmarnold.github.com/EmbeddedMail/) to do assertions against the received messages.

### Next time

I had originally set out to write a post about integration testing in FubuMVC. However, I think it’s important to note some of the concepts first.

Next post I’ll walk through code samples that work towards acceptance tests as described in this post using FubuMVC and its SelfHost option. I won’t curse myself by promising any posts beyond that, though.