---
id: 40
title: 'Introducing Behave#'
date: 2007-07-11T21:01:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/07/11/introducing-behave.aspx
dsq_thread_id:
  - "389065619"
categories:
  - Agile
  - 'Behave#'
  - Testing
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/07/introducing-behave.html)._

I really like the idea of executable requirements.&nbsp; Executable requirements is the idea that I can express requirements from the business in a human-readable, executable format.&nbsp; Part of fulfilling the requirement is that the &#8220;executable requirement&#8221; part can execute successfully in the form of acceptance tests.

Recently, I checked out a couple of API&#8217;s for executable requirements in the form of behavior-driven design (BDD).&nbsp; For more information on BDD, check out these articles from [Dan North&#8217;s blog](http://dannorth.net/):

  * [Introducing BDD](http://dannorth.net/introducing-bdd) 
      * [What&#8217;s in a Story?](http://dannorth.net/whats-in-a-story)</ul> 
    The API&#8217;s I checked out were [NBehave](http://nbehave.org/)&nbsp;and [Joe Ocampo&#8217;s](http://www.agilejoe.com/) [NUnit.Behave](http://code.google.com/p/nunitbehave/).&nbsp; NBehave was rather cumbersome to set up, and didn&#8217;t have much of a fluent interface.&nbsp; NUnit.Behave was much easier to use, but forced a dependency on NUnit.&nbsp; I didn&#8217;t want to be forced to use NUnit, nor did I want to inherit from certain classes or implement certain interfaces.&nbsp; Heavily influenced by NUnit.Behave, I created [Behave#](http://www.codeplex.com/BehaveSharp).
    
    ### What is Behave#?
    
    [Behave#](http://www.codeplex.com/BehaveSharp) ([http://www.codeplex.com/BehaveSharp](http://www.codeplex.com/BehaveSharp "http://www.codeplex.com/BehaveSharp"))&nbsp;is a fluent interface to express executable requirements in the form of acceptance tests with a distinct BDD grammar.&nbsp; Stories follow the &#8220;As a <role> I want <feature> so that <benefit>&#8221; template.&nbsp; Stories are made up of scenarios, which follow the &#8220;Given When Then&#8221; template.&nbsp; Through a fluent interface, Behave# shapes your acceptance tests to closely match the original user story.
    
    ### What would a user story look like in code?
    
    &nbsp;The fluent interface I settled on looks like:
    
    <div class="CodeFormatContainer">
      <pre><span class="kwrd">new</span> Story(<span class="str">"Transfer to cash account"</span>)
    .AsA(<span class="str">"savings account holder"</span>)
    .IWant(<span class="str">"to transfer money from my savings account"</span>)
    .SoThat(<span class="str">"I can get cash easily from an ATM"</span>)

    .WithScenario(<span class="str">"Savings account is overdrawn"</span>)

        .Given(<span class="str">"my savings account balance is"</span>, -20)
            .And(<span class="str">"my cash account balance is"</span>, 10)
        .When(<span class="str">"I transfer to cash account"</span>, 20)
        .Then(<span class="str">"my savings account balance should be"</span>, -20)
            .And(<span class="str">"my cash account balance should be"</span>, 10);
</pre>
    </div>
    
    I really like this syntax as it can be read very easily and there aren&#8217;t a lot of other objects or frameworks getting in the way.&nbsp; So how do we actually execute custom actions in our story definition?&nbsp; Here&#8217;s a full-fledged example, using NUnit to provide assertions:
    
    <div class="CodeFormatContainer">
      <pre>[Test]
<span class="kwrd">public</span> <span class="kwrd">void</span> Transfer_to_cash_account()
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

            .Given(<span class="str">"my savings account balance is"</span>, 100, <span class="kwrd">delegate</span>(<span class="kwrd">int</span> accountBalance) { savings = <span class="kwrd">new</span> Account(accountBalance); })
                .And(<span class="str">"my cash account balance is"</span>, 10, <span class="kwrd">delegate</span>(<span class="kwrd">int</span> accountBalance) { cash = <span class="kwrd">new</span> Account(accountBalance); })
            .When(<span class="str">"I transfer to cash account"</span>, 20, <span class="kwrd">delegate</span>(<span class="kwrd">int</span> transferAmount) { savings.TransferTo(cash, transferAmount); })
            .Then(<span class="str">"my savings account balance should be"</span>, 80, <span class="kwrd">delegate</span>(<span class="kwrd">int</span> expectedBalance) { Assert.AreEqual(expectedBalance, savings.Balance); })
                .And(<span class="str">"my cash account balance should be"</span>, 30, <span class="kwrd">delegate</span>(<span class="kwrd">int</span> expectedBalance) { Assert.AreEqual(expectedBalance, cash.Balance); })

            .Given(<span class="str">"my savings account balance is"</span>, 400)
                .And(<span class="str">"my cash account balance is"</span>, 100)
            .When(<span class="str">"I transfer to cash account"</span>, 100)
            .Then(<span class="str">"my savings account balance should be"</span>, 300)
                .And(<span class="str">"my cash account balance should be"</span>, 200)

            .Given(<span class="str">"my savings account balance is"</span>, 500)
                .And(<span class="str">"my cash account balance is"</span>, 20)
            .When(<span class="str">"I transfer to cash account"</span>, 30)
            .Then(<span class="str">"my savings account balance should be"</span>, 470)
                .And(<span class="str">"my cash account balance should be"</span>, 50);

    transferStory
        .WithScenario(<span class="str">"Savings account is overdrawn"</span>)

            .Given(<span class="str">"my savings account balance is"</span>, -20)
                .And(<span class="str">"my cash account balance is"</span>, 10)
            .When(<span class="str">"I transfer to cash account"</span>, 20)
            .Then(<span class="str">"my savings account balance should be"</span>, -20)
                .And(<span class="str">"my cash account balance should be"</span>, 10);

}

</pre>
    </div>
    
    To perform actions with each &#8220;Given When Then&#8221; fragment, I pass in a delegate (anonymous in this case, but much prettier with lambda expressions in C# 3.0).&nbsp; This delegate is executed as the story execution proceeds, and&nbsp;is cached by name, so each time the story sees &#8220;my cash account balance is&#8221;, it will execute the appropriate delegate.&nbsp; I don&#8217;t need to define the custom action every time.
    
    The result of the execution is the story results outputted in a human readable format (by default, to Debug):
    
    <div class="CodeFormatContainer">
      <pre>Story: Transfer to cash account

Narrative:
   As a savings account holder
   I want to transfer money from my savings account
   So that I can get cash easily from an ATM

   Scenario 1: Savings account is in credit
      Given my savings account balance is: 100
         And my cash account balance is: 10
      When I transfer to cash account: 20
      Then my savings account balance should be: 80
         And my cash account balance should be: 30

      Given my savings account balance is: 400
         And my cash account balance is: 100
      When I transfer to cash account: 100
      Then my savings account balance should be: 300
         And my cash account balance should be: 200

      Given my savings account balance is: 500
         And my cash account balance is: 20
      When I transfer to cash account: 30
      Then my savings account balance should be: 470
         And my cash account balance should be: 50

   Scenario 2: Savings account is overdrawn
      Given my savings account balance is: -20
         And my cash account balance is: 10
      When I transfer to cash account: 20
      Then my savings account balance should be: -20
         And my cash account balance should be: 10</pre>
    </div>
    
    This format closely resembles the original user story I received from the business.
    
    ### Conclusion
    
    I like being able to verify deliverables in the form of automated tests.&nbsp; When these tests closely resemble the original requirements as user stories, I&#8217;m more confident in the deliverables.&nbsp; Having executable requirements in the form of acceptance tests in a fluent interface that matches the original requirements can bridge the gap between what the business asks for and what gets delivered.&nbsp; [Behave#](http://www.codeplex.com/BehaveSharp) gets us one step closer to bridging that gap.