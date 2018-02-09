---
wordpress_id: 55
title: 'Authoring stories with BDD using Behave# and NSpec'
date: 2007-08-27T15:18:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/08/27/authoring-stories-with-bdd-using-behave-and-nspec.aspx
dsq_thread_id:
  - "266979168"
categories:
  - 'Behave#'
redirect_from: "/blogs/jimmy_bogard/archive/2007/08/27/authoring-stories-with-bdd-using-behave-and-nspec.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/08/authoring-stories-with-bdd-using-behave.html)._

A question came up on the [Behave# CodePlex](http://www.codeplex.com/BehaveSharp) site, asking about the intent of Behave# and where it fits with [NSpec](http://nspec.tigris.org/).&nbsp;&nbsp;[BDD](http://behaviour-driven.org/) is all about using TDD&nbsp;to create specifications, and NSpec&nbsp;bridges the gap with&nbsp;a specification-friendly API.&nbsp; For me, the question of when to write Behave# stories and pure NSpec specifications is fairly straightforward.

**The stories and scenarios created by the business owner should be captured in Behave# stories and scenarios.&nbsp; The specifications of&nbsp;everything else should be captured by NSpec (or NUnit.Spec, or NUnit constraints).**

But that&#8217;s not stopping us from _using_&nbsp;NSpec for the &#8220;Then&#8221; fragment of a scenario.

#### Anatomy of a scenario

A scenario is composed of three distinct sections: _Context, Event,_ and _Outcome_.&nbsp; The scenario description follows the pattern &#8220;Given <context>, When <event>, Then <outcome>.&nbsp; A sample scenario (and story) could be:

<pre>Story: Transfer to cash account

As a savings account holder
I want to transfer money from my savings account
So that I can get cash easily from an ATM

Scenario: Savings account is in credit
	Given my savings account balance is $100
		And my cash account balance is $10
	When I transfer to cash account $20
	Then my savings account balance should be $80
		And my cash account balance should be $30
</pre>

My outcomes are the &#8220;Then&#8221; fragment of the scenario, but could also be interpreted as **specifications** for an account.

#### Using NSpec with Behave#

So how can we combine NSpec with Behave#?&nbsp; Here&#8217;s the story above written with NSpec and Behave#:

<div class="CodeFormatContainer">
  <pre>Account savings = <span class="kwrd">null</span>;
Account cash = <span class="kwrd">null</span>;

Story transferStory = <span class="kwrd">new</span> Story(<span class="str">"Transfer to cash account"</span>);

transferStory
    .AsA(<span class="str">"savings account holder"</span>)
    .IWant(<span class="str">"to transfer money from my savings account"</span>)
    .SoThat(<span class="str">"I can get cash easily from an ATM"</span>);

transferStory
    .WithScenario(<span class="str">"Savings account is in credit"</span>)

        .Given(<span class="str">"my savings account balance is"</span>, 100, 
                <span class="kwrd">delegate</span>(<span class="kwrd">int</span> accountBalance) { savings = <span class="kwrd">new</span> Account(accountBalance); })
            .And(<span class="str">"my cash account balance is"</span>, 10, 
                <span class="kwrd">delegate</span>(<span class="kwrd">int</span> accountBalance) { cash = <span class="kwrd">new</span> Account(accountBalance); })
        .When(<span class="str">"I transfer to cash account"</span>, 20, 
                <span class="kwrd">delegate</span>(<span class="kwrd">int</span> transferAmount) { savings.TransferTo(cash, transferAmount); })
        .Then(<span class="str">"my savings account balance should be"</span>, 80, 
                <span class="kwrd">delegate</span>(<span class="kwrd">int</span> expectedBalance) { Specify.That(savings.Balance).ShouldEqual(expectedBalance); })
            .And(<span class="str">"my cash account balance should be"</span>, 30,
                <span class="kwrd">delegate</span>(<span class="kwrd">int</span> expectedBalance) { Specify.That(cash.Balance).ShouldEqual(expectedBalance); })
</pre>
</div>

Note that in the &#8220;Then&#8221; fragment of the Scenario, I&#8217;m using NSpec to specify the outcomes.&nbsp; By using NSpec and Behave# together to author business owner stories in to executable code, I&#8217;m able to combine both the story/scenario side of BDD with the specification side.