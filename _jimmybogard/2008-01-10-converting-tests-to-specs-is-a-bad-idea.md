---
id: 126
title: Converting tests to specs is a bad idea
date: 2008-01-10T21:40:10+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/01/10/converting-tests-to-specs-is-a-bad-idea.aspx
dsq_thread_id:
  - "264715484"
categories:
  - BDD
  - BehaviorDrivenDevelopment
---
When I first started experimenting with [BDD](http://behaviour-driven.org/), all the talk about the shift in language led me to believe that to &#8220;do BDD&#8221; all I needed to do was to change my &#8220;Asserts&#8221; to some &#8220;Shoulds&#8221;.&nbsp; At the root, it looked like all I was really doing was changing the order of my &#8220;expected&#8221; and &#8220;actual&#8221;.

In my admittedly short experiences so far, I&#8217;ve found that BDD is much more than [naming conventions](http://codebetter.com/blogs/jean-paul_boodhoo/archive/2007/11/29/getting-started-with-bdd-style-context-specification-base-na.aspx), language, and some [macros](http://codebetter.com/blogs/jean-paul_boodhoo/archive/2007/11/29/updated-bdd-naming-macro.aspx).&nbsp; For me, unit testing was about **verifying implementations** while specifications were about **specifying behavior**.&nbsp; Although I&#8217;m not supposed to test implementations with unit testing,&nbsp;conventions led me down this path.&nbsp; It&#8217;s easy to fall into the trap of testing implementations, given constraints we put on ourselves when writing unit tests.

### Starting with tests

Typically, my unit tests looked something like this:

<div class="CodeFormatContainer">
  <pre>[TestFixture]
<span class="kwrd">public</span> <span class="kwrd">class</span> AccountServiceTests
{
    [Test]
    <span class="kwrd">public</span> <span class="kwrd">void</span> Transfer_WithValidAccounts_TransfersMoneyBetweenAccounts()
    {
        Account source = <span class="kwrd">new</span> Account();
        source.Balance = 100;

        Account destination = <span class="kwrd">new</span> Account();
        destination.Balance = 200;

        AccountService service = <span class="kwrd">new</span> AccountService();

        service.Transfer(source, destination, 50);
        
        Assert.AreEqual(50, source.Balance);
        Assert.AreEqual(250, destination.Balance);
    }
}
</pre>
</div>

When I wrote the implementation test-first, I first got a requirement or specification from the business.&nbsp; It sounded something like &#8220;We want to be able to transfer money between two accounts&#8221;.

Before I started writing my tests, I had to figure a few things out.&nbsp; Our naming conventions forced us into a path that made us choose where the behavior was supposed to reside, as we named our test fixtures &#8220;<ClassUnderTest>Tests&#8221;.&nbsp; In the example above, we&#8217;re testing the &#8220;AccountService&#8221; class.&nbsp; Additionally, our individual tests were named &#8220;<MethodName>\_<StateUnderTest>\_<ExpectedBehavior>&#8221;.&nbsp; We took [these naming conventions](http://weblogs.asp.net/rosherove/archive/2005/04/03/TestNamingStandards.aspx) because it organized the class behavior quite nicely according to members.

### Converting to BDD syntax

I wanted to try BDD, so the quickest way I saw to do it was to change the names of our tests and switch around our assertions:

<div class="CodeFormatContainer">
  <pre>[TestFixture]
<span class="kwrd">public</span> <span class="kwrd">class</span> AccountServiceTests
{
    [Test]
    <span class="kwrd">public</span> <span class="kwrd">void</span> Transfer_WithValidAccounts_ShouldTransfersMoneyBetweenAccounts()
    {
        Account source = <span class="kwrd">new</span> Account();
        source.Balance = 100;

        Account destination = <span class="kwrd">new</span> Account();
        destination.Balance = 200;

        AccountService service = <span class="kwrd">new</span> AccountService();

        service.Transfer(source, destination, 50);

        source.Balance.ShouldEqual(50);
        destination.Balance.ShouldEqual(250);
    }
}
</pre>
</div>

Now that I see the word &#8220;Should&#8221; everywhere, that means I&#8217;m doing BDD, right?

### Just leave it alone

BDD is much more than naming conventions and the word &#8220;should&#8221;, it&#8217;s more about starting with a context, then defining behavior **outside of any hint of an implementation**.&nbsp; When creating my Transfer test initially, before I could start writing ANY code, because of our naming conventions I had to decide two things:

  * What class does the behavior belong
  * What method name should be assigned to the behavior

But when writing true BDD-style specs, I don&#8217;t care about the underlying class or method names.&nbsp; All I care about is the context and specifications, and that&#8217;s it!&nbsp; If I was writing the Transfer behavior BDD-first, I might end up with this:

<div class="CodeFormatContainer">
  <pre>[TestFixture]
<span class="kwrd">public</span> <span class="kwrd">class</span> When_transfering_money_between_two_accounts_with_appropriate_funds
{
    [Test]
    <span class="kwrd">public</span> <span class="kwrd">void</span> Should_reflect_balances_appropriately()
    {
        Account source = <span class="kwrd">new</span> Account();
        source.Balance = 100;

        Account destination = <span class="kwrd">new</span> Account();
        destination.Balance = 200;

        source.TransferTo(destination, 50);

        source.Balance.ShouldEqual(50);
        destination.Balance.ShouldEqual(250);
    }
}
</pre>
</div>

The key difference here is nowhere in the fixture nor the test method name will you find any mention of types, member names, or **anything that hints at an implementation**.&nbsp; I&#8217;m driven purely by behavior, which led me to a completely different design than my test-first design.&nbsp; In the future, if I decide to change the underlying implementation, I don&#8217;t need to do anything with my BDD specs.&nbsp; When I&#8217;ve decoupled my implementation of behavior completely from the specification of behavior, I can make much more dramatic design changes, as I won&#8217;t be bound by my tests.

I&#8217;ve also found I don&#8217;t modify specifications nearly as much as I used to modify tests.&nbsp; If behavior is changed, I delete the original spec and add a new one.

So don&#8217;t trick yourself into thinking that you need to&nbsp;modify your tests to become BDD-like.&nbsp; Just leave those tests alone, they&#8217;re doing exactly what they&#8217;re designed to do.&nbsp; A single context is&nbsp;likely split across many, many test fixtures, so it&#8217;s just not an exercise worth undertaking.&nbsp; Start your BDD specs fresh, unencumbered from existing test code, and the transition will be much, much easier.