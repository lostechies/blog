---
id: 1237
title: Vertical Slice Test Fixtures for MediatR and ASP.NET Core
date: 2016-10-24T20:40:34+00:00
author: Jimmy Bogard
layout: post
guid: https://lostechies.com/jimmybogard/?p=1237
dsq_thread_id:
  - "5249862829"
categories:
  - ASPNetCore
  - MediatR
  - Testing
---
One of the nicest side effects of using MediatR is that my controllers become quite thin. Here’s a typical controller:

[gist id=61ed71371205bd3341382e2fb0e8c5c5]

Unit testing this controller is a tad pointless – I’d only do it if the controller actions were doing something interesting. With [MediatR](https://github.com/jbogard/mediatr) combined with CQRS, my application is modeled as a series of requests and responses, where my requests either represent a command or a query. In an actual HTTP request, I wrap my request in a transaction using an action filter, so the request looks something like:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/jimmybogard/files/2016/10/image_thumb.png" width="379" height="364" />](https://lostechies.com/jimmybogard/files/2016/10/image.png)

The bulk of the work happens in my handler, of course. Now, in my projects, we have a fairly strict rule that all handlers need a test. But what kind of test should it be? At the very least, we want a test that executes our handlers as they would be used in a normal application. Since my handlers don’t have any real knowledge of the UI, they’re simple DTO-in, DTO-out handlers, I don’t need to worry about UI dependencies like controllers, filters and whatnot.

I do, however, want to build a test that goes just under the UI layer to execute the end-to-end behavior of my system. These are known as “[subcutaneous tests](http://martinfowler.com/bliki/SubcutaneousTest.html)”, and provide me with the greatest confidence that one of my vertical slices does indeed work. It’s the first test I write for a feature, and the last test to pass.

I need to make sure that my test properly matches “real world” usage of my system, which means that I’ll execute a series of transactions, one for the setup/execute/verify steps of my test:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/jimmybogard/files/2016/10/image_thumb1.png" width="409" height="205" />](https://lostechies.com/jimmybogard/files/2016/10/image1.png)

The final piece is allowing my test to easily run these kinds of tests over and over again. To do so, I’ll combine a few tools at my disposal to ensure my tests run in a repeatable and predictable fashion.

### Building the fixture

The baseline for my tests is known as a “fixture”, and what I’ll be building is a known starting state for my tests. There are a number of different environments I can do this in, but the basic idea are:

  * Reset the database before each test using [Respawn](https://github.com/jbogard/respawn) to provide a known database starting state
  * Provide a fixture class that represents the known application starting state

I’ll show how to do this with xUnit, but the [Fixie](http://fixie.github.io/) example is just as easy. First, I’ll need a known starting state for my fixture:

[gist id=73a565acdeeb91fb045ae318170b93ed]

I want to use the exact same startup configuration that I use in my actual application that I do in my tests. It’s important that my tests match as much as possible the runtime configuration of my system. Mismatches here can easily result in false positives in my tests. The only thing I have to fake out are my hosting environment. Unlike the integration testing available for ASP.NET Core, I won’t actually run a test server. I’m just running through the same configuration. I capture some of the output objects as fields, for ease of use later.

Next, on my fixture, I expose a method to reset the database (for later use):

[gist id=1219365205dae26bbba9c670b2a8ab13]

I can now create an xUnit behavior to reset the database before every test:

[gist id=c326ae11556b89fc27418814326541d9]

With xUnit, I have to decorate every test with this attribute. With Fixie, I don’t. In any case, now that I have my fixture, I can inject it with an IClassFixture interface:

[gist id=ed85ec5c5af651683462a9be3bb3946c]

With my fixture created, and a way to inject it into my tests, I can now use it in my tests.

### 

### Building setup/execute/verify fixture seams

In each of these steps, I want to make sure that I execute each of them in a committed transaction. This ensures that my test, as much as possible, matches the real world usage my application. In an actual system, the user clicks around, executing a series of transactions. In the case of editing an entity, the user first looks at a screen of an existing entity, POSTs a form, and then is redirected to a new page where they see the results of their action. I want to mimic this sort of flow in my tests as well.

First, I need a way to execute something against a DbContext as part of a transaction. I’ve already exposed methods on my DbContext to make it easier to manage a transaction, so I just need a way to do this through my fixture. The other thing I need to worry about is that with the built-in DI container with ASP.NET Core, I need to create a scope for scoped dependencies. That’s why I captured out that scope factory earlier. With the scope factory, it’s trivial to create a nice method to execute a scoped action:

[gist id=4827845963018c38d5bde961ba93ed94]

The method takes function that accepts an IServiceProvider and returns a Task (so that your action can be async). For convenience sake, if you just need a DbContext, I also provide an overload that just works with that instance. With this in place, I can build out the setup portion of my test:

[gist id=bd22928d487b750063679fa9c90bb32c]

I build out an entity, and in the context of a scope and transaction, save it out. I’m intentionally NOT reusing those scopes or DbContext objects across the different setup/execute/verify steps of my test, because that’s not what happens in my app! My actual application creates a distinct scope per operation, so I should do that too.

Next, for the execute step, this will involve sending a request to the Mediator. Again, as with my DbContext method, I’ll create a convenience method to make it easy to send a scoped request:

[gist id=092aba3cacedb2dfdf260a05ff701976]

Since my “mediator.SendAsync” executes inside of that scope, with a transaction, I can be confident that when the handler completes it’s pushed the results of that handler all the way down to the database. My test now can send a request fairly easily:

[gist id=bd8888b521c08fe2ab75172a11138d1e]

Finally, in my verify step, I can use the same scope-isolated ExecuteDbContextAsync method to start a new transaction to do my assertions against:

[gist id=952156b11eb55d4b7c671fb07d4e1377]

With the setup, execute, and verify steps each in their own isolated transaction and scope, I ensure that my vertical slice test matches as much as possible the flow of actual usage. And again, because I’m using MediatR, my test only knows how to send a request down and verify the result. There’s no coupling whatsoever of my test to the implementation details of the handler. It could use EF, NPoco, Dapper, sprocs, really anything.

### Wrapping up

Most integration tests I see wrap the entire test in a transaction or scope of some sort. This can lead to pernicious false positives, as I’ve not made the full round trip that my application makes. With subcutaneous tests executing against vertical slices of my application, I’ve got the closest representation as possible without executing HTTP requests to how my application actually works.

One thing to note – the built-in DI container doesn’t allow you to alter the container after it’s built. With more robust containers like StructureMap, I’d along with that scope allow you to register mock/stub dependencies that only live for that scope (using the magic of nested containers).

If you want to see a full working example using Fixie, check out [Contoso University Core](https://github.com/jbogard/contosouniversitycore).