---
wordpress_id: 1043
title: 'Clean Tests: Building Test Types'
date: 2015-02-05T21:38:16+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=1043
dsq_thread_id:
  - "3489244687"
categories:
  - Testing
---
Posts in this series:

  * [A Primer](http://lostechies.com/jimmybogard/2015/01/29/clean-tests-a-primer/ "Clean Tests: A Primer")
  * [Building Test Types](http://lostechies.com/jimmybogard/2015/02/05/clean-tests-building-test-types/ "Clean Tests: Building Test Types")
  * [Isolating Internal State](http://lostechies.com/jimmybogard/2015/02/17/clean-tests-isolating-internal-state/)
  * [Isolating the Database](http://lostechies.com/jimmybogard/2015/03/02/clean-tests-isolating-the-database/)
  * [Isolation with Fakes](https://lostechies.com/jimmybogard/2015/03/24/clean-tests-isolation-with-fakes/)
  * [Database Persistence](https://lostechies.com/jimmybogard/2015/04/07/clean-tests-database-peristence)

In the primer, I described two types of tests I generally run into in my systems:

  * Arrange/act/assert fully encapsulated in a single method
  * Arrange/act in one place, assertions in each method

Effectively, I build tests in a procedural mode or in a context/specification mode. In xUnit Test Patterns language, I’m building execution plans around:

  * [Testcase Class per Class](http://xunitpatterns.com/Testcase%20Class%20per%20Class.html)
  * [Testcase Class per Fixture](http://xunitpatterns.com/Testcase%20Class%20per%20Fixture.html)

There’s another pattern listed there, “Testcase Class per Feature”, but I’ve found it to be a version of one of these two – AAA in a single method, or split out.

Most test frameworks have some extension point for you to be able to accomplish both of these patterns. Unfortunately, none of them are very flexible. In my tests, I want to have complete control over lifecycle, as my tests become more complicated to set up. My ideal would be to author tests as I do everything else:

  * Method arguments for variation in a single isolated test
  * Constructor arguments for delivering fixtures for multiple tests

Since I’m using Fixie, I can teach Fixie how to recognize these two types of tests and build individual test plans for both kinds. We could be silly and cheat with things like attributes, but I think we can be smarter, right? Looking at our two test types, we have two kinds of test classes:

  * No-arg constructor, methods have arguments for context/fixtures
  * Constructor with arguments, methods have no arguments (shared fixture)

With Fixie, I can easily distinguish between the two kinds of tests. I could do other things, like key off of namespaces (put all fast tests in one folder, slow tests in another), or separate by assemblies, it’s all up to me.

But what should supply my fixtures? With most other test frameworks, the fixtures need to be plain – class with a no-arg constructor or similar. I don’t want that. I want to use a library in which I can control and build out my fixtures in a deterministic, flexible manner.

Enter [AutoFixture](https://github.com/AutoFixture/AutoFixture)!

I’ll teach Fixie how to run my tests, and I’ll teach AutoFixture how to build out those constructor arguments. AutoFixture is my “Arrange”, my code is the Act, and for assertions, I’ll use [Shoudly](http://www.nuget.org/packages/Shouldly/) (this one I don’t care as much about, just should-based is enough).

First, let’s look at the simple kinds of tests – ones where the test is completely encapsulated in a single method.

### 

### Testcase Class per Class

For TestClass Per Class, my Fixie convention is:

[gist id=8cfed210e19d0ea43e1c]

First, I need to tell Fixie what to look for in terms of test classes. I could have gone a lot of routes here like existing test frameworks “Things with a class attribute” or “Things with methods that have an attribute” or a base class or a namespace. To keep things simple, I look for classes named “Tests”. Next, because I want to target a workflow where AAA is in a single method, I make sure that this class has only no-arg constructors.

For test methods, that’s a bit easy – I just want public void methods. No attributes.

Finally, I want to fill parameters from AutoFixture. I tell Fixie to add parameters from AutoFixture, resolving each parameter value one at a time from AutoFixture.

For now, I’ll leave the AutoFixture configuration alone, but we’ll soon be layering on more behaviors as we go.

With this in place, my test becomes:

[gist id=f8d6758024567e169baa]

So far so good! Now let’s look at our Testcase Class per Fixture example.

### Testcase Class per Fixture

When we want to have a single arrange/act, but multiple assertions, our test lifecycle changes. We now want to not have to re-run the Arrange/Act every single time, we only want it run once and then each Assert work off of the results of the Act. This means that with our test class, we want it only run/instantiated once, and then the asserts happen. This is different than parameterized test methods, where we want the fixture recreated with every test.

Our Fixie configuration changes slightly:

[gist id=b4e14a990b5d2ec8888c]

With Fixie, I can create as many configurations as I like for different kinds of tests. Fixie layers them on each other, and I can customize styles appropriately. If I’m migrating from an existing testing platform, I could even configure Fixie to run the existing attribute-based tests!

In the configuration above, I’m looking for test classes ending with “Tests”, but also having a single constructor that has arguments. I don’t know what to do with classes with multiple constructors, so I’ll just ignore those for now.

The test methods I’m looking for are the same – except now I’ll not configure any method parameters. It would be weird to combine constructor arguments with method parameters for this style of test, so I’m ignoring that for now.

Finally, I configure test execution to create a single instance per class, using AutoFixture as my test case factory. This is the piece that starts to separate Fixie from other frameworks – you can completely customize how you want your tests to run and execute. Opinionated frameworks are great – but if I disagree, I’m left to migrate tests. Not a fun proposition.

A test that uses this convention becomes:

[gist id=372a7caaa45a28ea777a]

The constructor is invoked by AutoFixture, filling in the parameters as needed. The Act, inside the constructor, is executed once. Finally, I make individual assertions on the result of the Act.

With this style, I can build up a context and incrementally add behavior via assertions. This is a fantastic approach for lightweight BDD, since I’m focusing on behaviors and adding them one at a time.

Next up, we’ll look at going one step further and integrating the database into our tests and using Fixie to wrap interesting behaviors around them.