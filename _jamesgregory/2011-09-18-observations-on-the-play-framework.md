---
id: 4507
title: Observations on the Play! framework
date: 2011-09-18T23:42:28+00:00
author: James Gregory
layout: post
guid: http://lostechies.com/jamesgregory/?p=37
dsq_thread_id:
  - "418588552"
categories:
  - Java
tags:
  - java
  - mvc
  - playframework
---
Java stacks certainly are tall. You have your web server, your application server, servlet container, an IoC container, JPA, JAAS, JAX-RS, and that&#8217;s before you actually write any code.

The [Play! framework](http://www.playframework.org/) seems set to change all that. It throws nearly all of the enterprise out of Java and instead provides you with a very structured, very Rails-like, web environment. You&#8217;ve got routes, controllers, something that resembles ActiveRecord, background jobs, built-in authentication, loads of nice plugins. In general, it&#8217;s very refreshing.

For example, in my (relatively flat) stack of Jersey and Jetty, it took me off-and-on about a week to implement Facebook authentication. Lots of fiddling with callback urls and hand-rolling Apache Shiro handlers. I got it working in the end, but it was pretty nasty. By comparison, using Play! was as simple as adding `play -> fbconnect 0.5` to the `dependencies.yml` file (yes, that&#8217;s YAML in Java, not XML!) and changing my view to include a new `#{fbconnect.button}`. That&#8217;s it!

Play! also has a fairly unique feature in Java-land, and that&#8217;s dynamic reloading and compilation of classes. It&#8217;s just like using Ruby. Edit a file, refresh your browser and your changes are immediately visible; not just changes to views, but to the controllers and models too. A great improvement over the regular rebuild/reload cycle.

All in all, Play! has turned out to be an almost perfect Java web framework.

Almost.

Then we get to the testing story. I&#8217;m going to be blunt here. Despite Play! promoting how easy it is to test, I&#8217;m fairly sure the developers don&#8217;t actually do much testing; at the very least, they don&#8217;t do much unit testing.

Where to start?

# Dependency injection {#dependency_injection}

I&#8217;m not talking containers here. A fairly ubiquitous practice for testing web applications is to use constructor injection in your Controllers, injecting any services your controller needs into the constructor; those services are then used by the action methods to do their job, but more importantly they can be mocked or stubbed as part of a unit test.

An ASP.Net MVC example would look something like this:

<pre class="brush:csharp">public class MyController : Controller {
    readonly IMyService myService;

    public MyController(IMyService myService) {
        this.myService = myService;
    }

    public void Index() {
        myService.DoSomething();
    }
}</pre>

That way, in a unit test we can do this:

<pre class="brush:csharp">[Test]
public void should_do_something() {
    var myService = MockRepository.GenerateMock&lt;IMyService&gt;();

    new MyController(myService)
      .Index();

    myService.AssertWasCalled(x =&gt; x.DoSomething());
}</pre>

Piece of cake.

Play! on the other hand is not so simple. Play! requires controller action methods to be static; the justification for this is that controllers have no state, and thus are static. That makes sense, but it does so at the (in my opinion, fairly large) expense of constructor injection. You can&#8217;t call a static constructor, so you can&#8217;t pass in a dependency, so you can&#8217;t mock your dependency.

The equivalent example in Play! would be this:

<pre class="brush:java">public class MyController extends Controller {
    public static void index() {
        MyService myService = new MyServiceImpl();
        myService.doSomething();
    }
}</pre>

How can we test that controller in isolation? We can&#8217;t very easily. At least, not without using something like PowerMock (think TypeMock) to do some bytecode/reflection magic.

One proposed solution to this is to use an IoC container like Google Guice and inject a static field.

<pre class="brush:java">public class MyController extends Controller {
    @Inject
    MyService myService;

    public static void index() {
        myService.doSomething();
    }
}</pre>

That&#8217;s an improvement, but without constructor injection we have to bring a full container into the unit tests or make the field public and overwrite it manually. Not exactly pretty.

Another reason bandied around is &#8220;anaemic domain model&#8221;. Models should do things, I get that; however, we&#8217;re not in Ruby here, if my entity takes a hard-dependency on a service, how exactly am I supposed to test that in isolation? If an email should be sent when a user is created, I don&#8217;t want to have an actual SMTP server running just to execute my unit tests. In Ruby we could do some monkey patching and replace the SMTP service at runtime, but this is Java and we can&#8217;t do that (without resorting to service locators or singletons). I had an idea of using a JPA interceptor and injecting dependencies into an entity when it&#8217;s hydrated by Hibernate, but that just seems like a recipe for disaster.

So, _deal breaker number 1: No easy way to mock dependencies, one way or another._

> **A brief diversion:**
  
> Play! doesn&#8217;t seem to really do unit testing. It refers to things as unit tests, but really they&#8217;re all integration tests. As mentioned already, you can&#8217;t easily replace your dependencies with stubs or mocks, so inevitably you need to run your tests against a real database, your emails to a real SMTP service, and your messages to a real messaging queue. This sucks.
> 
> I&#8217;m all for integration tests, and if I had to pick between them and unit tests, I&#8217;d put my money on integration tests; however, I&#8217;m not yet of the belief that I can live entirely without unit tests. Some things should still be tested in isolation; specifically, if I&#8217;m dealing with external services, I shouldn&#8217;t need them up-and-running to run a unit test.

# IDE support {#ide_support}

Java is where IDEs thrive. Whilst I know Play! is heavily influenced by Rails, I don&#8217;t yet think I could live without an IDE. IDEs have their strong points, and unit test runners are one of them. Great little things, one keyboard shortcut and all your tests are spinning away.

Not for Play! though, or not very easily anyway. Despite Play!s &#8220;unit tests&#8221; being based on JUnit, they can&#8217;t actually be ran as plain-old-JUnit tests. If you interact with any of the models, or any of the Play! specific classes, you need the full web environment to be available. In fact, the default runner for unit tests is the website itself. I&#8217;m all for running QUnit tests in the browser, but JUnit tests, really? No thanks.

_Deal breaker number 2: Can&#8217;t run unit tests in the IDE._

It takes 6 seconds on my fairly meaty laptop to run one unit test. That&#8217;s unbelievable.

In addition, as Play! requires the web environment to run tests, that also means it kicks off any start-up jobs your application has. So whenever I run a test, it spins up my message queue, my database connection, and runs my data import routines (when in test mode).

_Deal breaker number 3: Can&#8217;t run unit tests without spinning up the entire website (and that&#8217;s not fast)._

# Example projects {#example_projects}

So there&#8217;s me thinking &#8220;It can&#8217;t possibly be this bad&#8221;. I decided to have a hunt around and see if there are any open-source applications built with Play!, or at the very least some reasonably sized examples. There were a few; however, _none of them_ had test suites. In fact, nearly all of them still had the default tests that are provided with a new project.

<pre class="brush:java">public class BasicTest extends UnitTest {
    @Test
    public void aVeryImportantThingToTest() {
        assertEquals(2, 1 + 1);
    }
}</pre>

Finally, one thing that really made me feel that the developers don&#8217;t really _get_ testing was their &#8220;mock&#8221; SMTP service. Take a look at [line 36 of their Mail.java](https://github.com/playframework/play/blob/master/framework/src/play/libs/Mail.java#L36). A hand-rolled mock, in the main service. I don&#8217;t say this often but: WTF. Is this what&#8217;s considered good practice?

I&#8217;m so incredibly disappointed in Play!. It&#8217;s a wonderful framework which was obviously designed by people who don&#8217;t really do testing; or at the very least, don&#8217;t do anything other than end-to-end integration tests. I&#8217;d love to use Play!, but I just don&#8217;t know if I can get past these issues. Everything else about it has been such an improvement over my previous stack, but all of that is next to worthless if I can&#8217;t test it.

If anyone has any information or experiences to the contrary, I&#8217;d gladly be shown the err in my ways. How do you test with Play!? Integration tests only or is there some secret sauce I&#8217;m missing out on?

I really do want to like Play! but it just seems so difficult to do proper testing.

Some links:

  * [My &#8220;Isolating external services when unit testing&#8221; mailing list question](https://groups.google.com/d/topic/play-framework/OLrSb9Hq4vY/discussion)
  * [My &#8220;Testing interactions with external services&#8221; StackOverflow question](http://stackoverflow.com/questions/7462843/testing-interactions-with-external-services)