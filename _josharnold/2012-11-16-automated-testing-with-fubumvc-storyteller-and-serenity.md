---
wordpress_id: 206
title: Automated testing with FubuMVC, StoryTeller, and Serenity
date: 2012-11-16T20:42:23+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=206
dsq_thread_id:
  - "931299230"
categories:
  - general
tags:
  - fubu
  - fubumvc
  - selfhost
  - serenity
  - storyteller
---
### Overview

In [my previous post](http://lostechies.com/josharnold/2012/11/11/some-foundational-ideas-for-automated-testing/) I talked about some foundational ideas for automated testing. Rather than continuing on with conceptual points, let’s take a look at an example of how we do automated testing in the world of Fubu.

> Note:
  
> While some of the tools here are Fubu-specific, the approaches and StoryTeller are NOT Fubu-specific.

### System State

In most automated testing scenarios, you find yourself quickly bumping into issues like:

  * Test data bleeding between tests (\*ahem\* shared databases)
  * Too many unknown data dependencies (hardcoded usernames, identifiers)

The idea of “System State” is simply providing a declarative way for establishing the state of your system for \*each\* test.

**In-Memory Persistence**

One trick that my team has used in the past is changing our underlying persistence strategy from database to in-memory for automated testing. Some databases (i.e., RavenDB) provide a way for you to do this. We used a basic abstraction called FubuPersistence to do this**. This means that we simply modify our IoC container for these scenarios.

**SystemStateFixture**

As I mentioned, &#8220;System State&#8221; is all about declaratively specifying the state of your system for \*each\* test. In StoryTeller world, we do this via a Fixture.

If you’re unfamiliar with StoryTeller, then this will serve as a crash course. Let’s take a look at the following fixture:



Turn your attention to line 35. This method allows us to create a test in StoryTeller like this:

[<img style="background-image: none; padding-top: 0px; padding-left: 0px; margin: 0px 0px 24px; display: inline; padding-right: 0px; border-width: 0px;" title="system-state" src="http://clayvessel.org/clayvessel/wp-content/uploads/2012/11/system-state_thumb.png" alt="system-state" width="244" height="103" border="0" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/11/system-state.png)

### Example 1: Verify that the Subscription Plans are displayed

One of the examples from my last post presented a test with the following steps:

  1. The available subscriptions are: “Subscription 1, Subscription 3”
  2. Navigate to the Registration screen
  3. The displayed subscriptions are: “Subscription 1, Subscription 3”

Using our SystemStateFixture, let’s go ahead and define the state:

[<img style="background-image: none; padding-top: 0px; padding-left: 0px; margin: 0px 0px 24px; display: inline; padding-right: 0px; border-width: 0px;" title="system-state-def" src="http://clayvessel.org/clayvessel/wp-content/uploads/2012/11/system-state-def_thumb.png" alt="system-state-def" width="244" height="204" border="0" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/11/system-state-def.png)

**RegistrationFixture**

Using the FubuMVC helpers in Serenity, the registration fixture is nice and simple:

&nbsp;

> Notice that before running the fixture, we instruct the test to navigate to the Registration screen. More notably, we are using our endpoint/actions to define the route. No magic strings here.

We’re reusing the html conventions from our FubuMVC application by retrieving the select element: Driver.InputFor<CreateAccount>(x => x.Subscriptions); We then traverse this element and build up a list of plans from the options of the select tag.

Using our VerifySubscriptionPlans grammar, we can then define the following step:

[<img style="background-image: none; padding-top: 0px; padding-left: 0px; margin: 0px 0px 24px; display: inline; padding-right: 0px; border-width: 0px;" title="verify-plans" src="http://clayvessel.org/clayvessel/wp-content/uploads/2012/11/verify-plans_thumb.png" alt="verify-plans" width="244" height="213" border="0" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/11/verify-plans.png)

### Example 2: After registering for an account, a confirmation email should be received

One of the benefits to how the combination of FubuMVC, FubuMVC.SelfHost, Serenity, and StoryTeller works is that everything is in a single AppDomain. How is that beneficial, you might ask?

Let’s take a look at our email gateway class again:

We have a helper class here called SmtpServerController that wraps our usage of [EmbeddedMail](http://jmarnold.github.com/EmbeddedMail/):

We’re injecting our EmailSettings class (under the assumption that the settings need to vary). Because we’re operating under the same AppDomain, this means that we can configure our container and have it affect the behavior of our FubuMVC application.

Let’s turn attention to the StubEmailGateway method:

We start the server and the configure an instance of EmailSettings inside of our IoC container. Now when we make any calls it IEmailGateway.Send, we will be sending messages to our embedded SMTP server.

Let’s define our system state:

[<img style="background-image: none; padding-top: 0px; padding-left: 0px; margin: 0px 0px 24px; display: inline; padding-right: 0px; border: 0px;" title="stub-email" src="http://clayvessel.org/clayvessel/wp-content/uploads/2012/11/stub-email_thumb.png" alt="stub-email" width="244" height="187" border="0" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/11/stub-email.png)

And now we’ll use our VerifyEmail grammar:

[<img style="background-image: none; padding-top: 0px; padding-left: 0px; margin: 0px 0px 24px; display: inline; padding-right: 0px; border: 0px;" title="confirm-email" src="http://clayvessel.org/clayvessel/wp-content/uploads/2012/11/confirm-email_thumb.png" alt="confirm-email" width="244" height="129" border="0" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/11/confirm-email.png)

### Wrapping Up

It’s a lot of information, I know. You’re better off pulling down the code and running through it yourself.

[https://github.com/jmarnold/SystemStateExample](https://github.com/jmarnold/SystemStateExample "https://github.com/jmarnold/SystemStateExample")

Simply clone the repo, run rake to be sure you can compile, and then rake run_st. This will launch StoryTeller for you and you can browse for the project file located under src/SystemStateExample.StoryTeller/example.xml.