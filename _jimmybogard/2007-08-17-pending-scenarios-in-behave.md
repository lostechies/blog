---
id: 53
title: 'Pending scenarios in Behave#'
date: 2007-08-17T13:43:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/08/17/pending-scenarios-in-behave.aspx
dsq_thread_id:
  - "317229731"
categories:
  - 'Behave#'
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/08/pending-scenarios-in-behave.html)._

When first authoring stories and scenarios in Behave#, the implementation to support the scenario probably doesn&#8217;t exist yet.&nbsp; [Part 4](http://codemonkey.nmonta.com/2007/08/12/behave-part-4/trackback/) of [Nelson Montalvo&#8217;s](http://codemonkey.nmonta.com/)&nbsp;series&nbsp;of posts&nbsp;on Behave# illustrates this quite nicely.&nbsp; The problem is that you don&#8217;t really want test failures because you haven&#8217;t implemented a scenario yet.&nbsp; [Rbehave](http://rubyforge.org/projects/rbehave/) has the ability to create &#8220;pending&#8221; scenarios, which won&#8217;t fail if the implementation doesn&#8217;t exist.

#### Misleading failures

For example, here&#8217;s a scenario that doesn&#8217;t have an implementation yet:

<div class="CodeFormatContainer">
  <pre>[Test]
<span class="kwrd">public</span> <span class="kwrd">void</span> Withdraw_from_savings_account_pending()
{

    Account savings = <span class="kwrd">null</span>;
    Account cash = <span class="kwrd">null</span>;

    Story transferStory = <span class="kwrd">new</span> Story(<span class="str">"Transfer to cash account"</span>);

    transferStory
        .AsA(<span class="str">"savings account holder"</span>)
        .IWant(<span class="str">"to transfer money from my savings account"</span>)
        .SoThat(<span class="str">"I can get cash easily from an ATM"</span>);

    transferStory
        .WithScenario(<span class="str">"Savings account is in credit"</span>)

            .Given(<span class="str">"my savings account balance is"</span>, -20)
                .And(<span class="str">"my cash account balance is"</span>, 10)
            .When(<span class="str">"I transfer to cash account"</span>, 20)
            .Then(<span class="str">"my savings account balance should be"</span>, -20)
                .And(<span class="str">"my cash account balance should be"</span>, 10);
}</pre>
</div>

When I execute this story, I get a failed test and a misleading exception:&nbsp;

<pre>Story: Transfer to cash account

Narrative:
	As a savings account holder
	I want to transfer money from my savings account
	So that I can get cash easily from an ATM

	Scenario 1: Savings account is in credit
TestCase 'BehaveSharp.Specs.AccountSpecs.Withdraw_from_savings_account_pending'
failed: BehaveSharp.ActionMissingException : Action missing for action 'my savings account balance is'.
	C:devBehaveSharptrunksrcBehaveSharp.ExamplesAccountSpecs.cs(70,0): at BehaveSharp.Specs.AccountSpecs.Withdraw_from_savings_account_pending()</pre>

&nbsp;Not a very helpful message, especially if I&#8217;m executing a suite of stories and scenarios.

#### Pending scenarios

If a scenario has a pending implementation, I can now add a &#8220;pending&#8221; message to the scenario, so that I don&#8217;t get any error messages:

<div class="CodeFormatContainer">
  <pre>[Test]
<span class="kwrd">public</span> <span class="kwrd">void</span> Withdraw_from_savings_account_pending()
{

    Account savings = <span class="kwrd">null</span>;
    Account cash = <span class="kwrd">null</span>;

    Story transferStory = <span class="kwrd">new</span> Story(<span class="str">"Transfer to cash account"</span>);

    transferStory
        .AsA(<span class="str">"savings account holder"</span>)
        .IWant(<span class="str">"to transfer money from my savings account"</span>)
        .SoThat(<span class="str">"I can get cash easily from an ATM"</span>);

    transferStory
        .WithScenario(<span class="str">"Savings account is in credit"</span>)
            .Pending(<span class="str">"ability to withdraw from accounts"</span>)

            .Given(<span class="str">"my savings account balance is"</span>, -20)
                .And(<span class="str">"my cash account balance is"</span>, 10)
            .When(<span class="str">"I transfer to cash account"</span>, 20)
            .Then(<span class="str">"my savings account balance should be"</span>, -20)
                .And(<span class="str">"my cash account balance should be"</span>, 10);
}</pre>
</div>

Note the &#8220;Pending&#8221; method call after &#8220;WithScenario&#8221;.&nbsp; Think of &#8220;Pending&#8221; similar to the &#8220;Ignore&#8221; attribute in NUnit.&nbsp; The story is there, the scenario is written, but the code to support the scenario doesn&#8217;t exist yet.&nbsp; Here&#8217;s the output of the execution with &#8220;Pending&#8221;:

<pre>Story: Transfer to cash account

Narrative:
	As a savings account holder
	I want to transfer money from my savings account
	So that I can get cash easily from an ATM

	Scenario 1: Savings account is in credit
		Pending: ability to withdraw from accounts</pre>

The scenario stops execution of the scenario (just so you can see the pending scenarios more easily), and outputs the pending message.&nbsp; Without the &#8220;Pending&#8221; message, you will get an exception and your test will fail.&nbsp; With &#8220;Pending&#8221;, you can flag your pending scenarios without worrying about breaking the build if you check in.