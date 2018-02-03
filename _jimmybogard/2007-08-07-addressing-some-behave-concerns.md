---
wordpress_id: 50
title: 'Addressing some Behave# concerns'
date: 2007-08-07T14:23:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/08/07/addressing-some-behave-concerns.aspx
dsq_thread_id:
  - "465266893"
categories:
  - 'Behave#'
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/08/addressing-some-behave-concerns.html)._

So [Joe](http://www.lostechies.com/blogs/joe_ocampo/default.aspx) and I have received some [initial feedback](http://weblogs.asp.net/rosherove/archive/2007/08/04/behave-enables-behavior-driven-testing-raises-some-interesting-questions.aspx) for [Behave#](http://www.codeplex.com/BehaveSharp).&nbsp; Joe&#8217;s already given a great intro into how to use Behave# and addressed Roy&#8217;s specific questions.&nbsp; I thought I&#8217;d address some of the common&nbsp;issues regarding Behave#:

  * Using string matching 
      * Using anonymous delegates 
          * One developer supports it</ul> 
        #### Using string matching
        
        One common concern I&#8217;ve heard from a couple of sources now is that Behave# uses strings to match behavior for subsequent scenarios.&nbsp; Something that might not be clear on how we match behavior is that **Scenarios are scoped to a Story**.
        
        That is, the &#8220;context&#8221; parameter of a &#8220;Given&#8221; scenario fragment is only able to be matched against other Scenarios within a single Story.&nbsp; Here&#8217;s an example:
        
        <div class="CodeFormatContainer">
          <pre>[Test]
<span class="kwrd">public</span> <span class="kwrd">void</span> Withdraw_from_savings_account()
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
        .Given(<span class="str">"my savings account balance is"</span>, 100,
               <span class="kwrd">delegate</span>(<span class="kwrd">int</span> accountBalance) { savings = <span class="kwrd">new</span> Account(accountBalance); })
        .And(<span class="str">"my cash account balance is"</span>, 10,
             <span class="kwrd">delegate</span>(<span class="kwrd">int</span> accountBalance) { cash = <span class="kwrd">new</span> Account(accountBalance); })
        .When(<span class="str">"I transfer to cash account"</span>, 20,
              <span class="kwrd">delegate</span>(<span class="kwrd">int</span> transferAmount) { savings.TransferTo(cash, transferAmount); })
        .Then(<span class="str">"my savings account balance should be"</span>, 80,
              <span class="kwrd">delegate</span>(<span class="kwrd">int</span> expectedBalance) { Assert.AreEqual(expectedBalance, savings.Balance); })
        .And(<span class="str">"my cash account balance should be"</span>, 30,
             <span class="kwrd">delegate</span>(<span class="kwrd">int</span> expectedBalance) { Assert.AreEqual(expectedBalance, cash.Balance); })

        .Given(<span class="str">"my savings account balance is"</span>, 400)
        .And(<span class="str">"my cash account balance is"</span>, 100)
        .When(<span class="str">"I transfer to cash account"</span>, 100)
        .Then(<span class="str">"my savings account balance should be"</span>, 300)
        .And(<span class="str">"my cash account balance should be"</span>, 200);

    Story withdrawStory = <span class="kwrd">new</span> Story(<span class="str">"Withdraw from savings account"</span>);

    withdrawStory
        .AsA(<span class="str">"savings account holder"</span>)
        .IWant(<span class="str">"to withdraw money from my savings account"</span>)
        .SoThat(<span class="str">"I can pay my bills"</span>);

    withdrawStory
        .WithScenario(<span class="str">"Savings account is in credit"</span>)
        .Given(<span class="str">"my savings account balance is"</span>, 100); <span class="rem">// This entry doesn't have a match!</span>
        


}
</pre>
        </div>
        
        In the &#8220;withdrawStory&#8221;, even though the &#8220;Given&#8221; fragment string matches the &#8220;transferStory&#8221; &#8220;Given&#8221; fragments, the behavior will not match up.&nbsp; That&#8217;s because Scenarios belong to a Story, and the matching only happens within a given Story.
        
        In DDD terms, the Aggregate Root is the Story, and the child Entities include the Scenarios.&nbsp; We _could_ match across stories, but that wouldn&#8217;t adhere to DDD guidelines, and would result in much more complexity.
        
        So matching issues only happen within one Story.&nbsp; I don&#8217;t know how many Scenarios you would need to write before running into issues, but I think we could follow some of Joe&#8217;s suggestions and use some more intelligent matching algorithms.
        
        #### Using anonymous delegates
        
        Let me be the first to admit that anonymous delegates are clunky, difficult, and just plain ugly.&nbsp; But keep in mind that Behave# only deals with delegates.&nbsp; How the consuming test code creates these delegates does not matter to Behave#.&nbsp; We have several options (asterisk next to C# 3.0 features):
        
          * [Named methods](http://msdn2.microsoft.com/en-us/library/98dc08ac(VS.80).aspx) 
              * [Anonymous methods](http://msdn2.microsoft.com/en-us/library/0yw3tz5k(VS.80).aspx) 
                  * [Lambda expressions](http://msdn2.microsoft.com/en-us/library/bb397687(VS.90).aspx)*</ul> 
                Anonymous methods may not be very prevalent in C# 2.0, but there are still quite a few classes in the DNF that use delegate arguments for method parameters.&nbsp; I ran the following code against .NET 3.5 assemblies:
                
                <div class="CodeFormatContainer">
                  <pre>var types = from name <span class="kwrd">in</span> assemblyNames
            select Assembly.LoadWithPartialName(name) into a
            from c <span class="kwrd">in</span> a.GetTypes()
            <span class="kwrd">where</span> (c.IsClass || c.IsInterface) && c.IsPublic && !c.IsSubclassOf(<span class="kwrd">typeof</span>(Delegate))
            select c.GetMethods(BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static) into methods
            from method <span class="kwrd">in</span> methods
            <span class="kwrd">where</span> method.GetParameters().Any(pi =&gt; pi.ParameterType.IsSubclassOf(<span class="kwrd">typeof</span>(Delegate)))
                && !method.Name.StartsWith(<span class="str">"add_"</span>, StringComparison.OrdinalIgnoreCase)
                && !method.Name.StartsWith(<span class="str">"remove_"</span>, StringComparison.OrdinalIgnoreCase)
            select <span class="kwrd">new</span> { TypeName = method.DeclaringType.FullName, MethodName = method.Name };

<span class="kwrd">int</span> methodCount = types.Count();
<span class="kwrd">int</span> typeCount = types.GroupBy(t =&gt; t.TypeName).Count();

Debug.WriteLine(<span class="str">"Method count: "</span> + methodCount.ToString());
Debug.WriteLine(<span class="str">"Type count: "</span> + typeCount.ToString());
</pre>
                </div>
                
                And I found that there are 1019 methods with delegate parameters spread out over 155 types.&nbsp; With the System.Linq.Enumerable extension methods in .NET 3.5, methods with delegate parameters will be used much more often.
                
                #### Only one developer supports it
                
                Well&#8230;not exactly true.&nbsp; There are two developers, Joe and I, so that&#8217;s a 100% improvement, right? 🙂
                
                #### Wrapping it up
                
                I really like [Dan North&#8217;s](http://dannorth.net/) [rbehave](http://dannorth.net/2007/06/introducing-rbehave).&nbsp; Behave# closely matches rbehave&#8217;s usage and intent.&nbsp; Are a lot of the same issues regarding Behave# also valid for rbehave?&nbsp; Ruby lends itself well to BDD, especially when combining rbehave and [rspec](http://rspec.rubyforge.org/), with the elegance of dynamic typing and language features like blocks.
                
                Behave# is still getting started, and we have some kinks to iron out, but I do think we&#8217;re on the right track, following in Dan North&#8217;s footsteps.