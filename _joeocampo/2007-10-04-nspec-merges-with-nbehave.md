---
id: 71
title: NSpec merges with NBehave!
date: 2007-10-04T20:37:00+00:00
author: Joe Ocampo
layout: post
guid: /blogs/joe_ocampo/archive/2007/10/04/nspec-merges-with-nbehave.aspx
dsq_thread_id:
  - "262089795"
categories:
  - BDD (Behavior Driven Development)
---
I am pleased to announce that [Tim Haughton](http://agilemicroisv.com/) has agreed to join his NSpec project with NBehave!

So what does this mean for you the developers? Well it means that you have **one** OSS project team supporting multiple BDD frameworks for the .Net framework! Think of it more as a centralized project for the many facets of BDD in the .Net community.

But Joe I have invested allot of time in setting up my NSpec test. Not to worry. We are firmly committed to giving the community options!

What we have done is break up the NBehave project into the following assemblies.

  * NBehave 
      * NBehave.Spec <&#8211;This is basically the core NSpec assertion framework 
      * NBehave.Performer <&#8211;Contains the fluent interface behavior constructs and references NBehave.Spec (Think [JBehave](http://jbehave.org/)) 
      * NBehave.Narrator <&#8211; Contains the story builder fluent interface and leverages NBehave.Performer and NBehave.Spec 
      * NBehave.Runner <&#8211; Global console runner capable of running any test that uses Spec, Performer, or Narrator. 

This is really great because now we get to utilize our own assertion framework in the creation of all these new projects (as seen below). Which is essence should create a better framework for everyone.

<div>
  <div>
    <pre><span style="color: #0000ff">using</span> System;</pre>
    
    <pre><span style="color: #0000ff">using</span> NBehave.Spec.Framework;</pre>
    
    <pre><span style="color: #0000ff">using</span> System.IO;</pre>
    
    <pre></pre>
    
    <pre><span style="color: #0000ff">namespace</span> NBehave.Runner.Console.Specifications</pre>
    
    <pre>{</pre>
    
    <pre> [Context]</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ParseGoodArgumentsSpec</pre>
    
    <pre> {</pre>
    
    <pre> <span style="color: #0000ff">const</span> <span style="color: #0000ff">string</span> assemblyName = <span style="color: #006080">"NSpec.Console.exe"</span>;</pre>
    
    <pre> <span style="color: #0000ff">const</span> <span style="color: #0000ff">string</span> xmlFileName = <span style="color: #006080">"Bob.xml"</span>;</pre>
    
    <pre> <span style="color: #0000ff">const</span> <span style="color: #0000ff">string</span> txtFileName = <span style="color: #006080">"Bob.xml"</span>;</pre>
    
    <pre></pre>
    
    <pre> <span style="color: #0000ff">const</span> <span style="color: #0000ff">string</span> assemblyArg = <span style="color: #006080">"/assembly:"</span> + assemblyName;</pre>
    
    <pre> <span style="color: #0000ff">const</span> <span style="color: #0000ff">string</span> outputArg = <span style="color: #006080">"/output:"</span> + xmlFileName;</pre>
    
    <pre> <span style="color: #0000ff">const</span> <span style="color: #0000ff">string</span> behaviourOutputArg = <span style="color: #006080">"/behaviourOutput:"</span> + txtFileName;</pre>
    
    <pre></pre>
    
    <pre> Arguments args;</pre>
    
    <pre></pre>
    
    <pre> [SetUp]</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Setup()</pre>
    
    <pre> {</pre>
    
    <pre> <span style="color: #0000ff">string</span>[] argArray = <span style="color: #0000ff">new</span> <span style="color: #0000ff">string</span>[] { assemblyArg, outputArg, behaviourOutputArg };</pre>
    
    <pre> args = Arguments.Parse( argArray );</pre>
    
    <pre> }</pre>
    
    <pre></pre>
    
    <pre> [Specification]</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> ShouldParseAssemblyFileName()</pre>
    
    <pre> {</pre>
    
    <pre> Specify.That( args.Assembly ).ShouldEqual( Path.GetFullPath( assemblyName ) );</pre>
    
    <pre> }</pre>
    
    <pre></pre>
    
    <pre> [Specification]</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> ShouldParseOutputFileName()</pre>
    
    <pre> {</pre>
    
    <pre> Specify.That( args.Output ).ShouldEqual( Path.GetFullPath( xmlFileName ) );</pre>
    
    <pre> }</pre>
    
    <pre></pre>
    
    <pre> [Specification]</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> ShouldParseBehaviourOutputTextFileName()</pre>
    
    <pre> {</pre>
    
    <pre> Specify.That( args.BehaviourOutput ).ShouldEqual( Path.GetFullPath( txtFileName ) );</pre>
    
    <pre> }</pre>
    
    <pre> }</pre>
    
    <pre></pre>
    
    <pre> [Context]</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ParseBadArgumentsSpec</pre>
    
    <pre> {</pre>
    
    <pre> <span style="color: #0000ff">const</span> <span style="color: #0000ff">string</span> badArg = <span style="color: #006080">"badstring"</span>;</pre>
    
    <pre> Arguments args;</pre>
    
    <pre></pre>
    
    <pre> [SetUp]</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Setup()</pre>
    
    <pre> {</pre>
    
    <pre> args = Arguments.Parse( <span style="color: #0000ff">new</span> <span style="color: #0000ff">string</span>[] { badArg } );</pre>
    
    <pre> }</pre>
    
    <pre> </pre>
    
    <pre> [Specification]</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> ShouldReturnNull()</pre>
    
    <pre> {</pre>
    
    <pre> Specify.That( args ).ShouldBeNull();</pre>
    
    <pre> }</pre>
    
    <pre> }</pre></p>
  </div>
</div>

This also allows the developers to utilize different aspects of BDD. You can use NBehave.Spec.Framework for you lower level testing and for your Story and Behavioral Domain test you can use NBehave.Narrator.Framework. Look at how by simply adding the Spec framework increased the readability of the Narrator Story framework (see below).

<div>
  <div>
    <pre><span style="color: #0000ff">using</span> System;</pre>
    
    <pre><span style="color: #0000ff">using</span> NBehave.Narrator.Framework;</pre>
    
    <pre><span style="color: #0000ff">using</span> NBehave.Spec.Framework;</pre>
    
    <pre></pre>
    
    <pre><span style="color: #0000ff">namespace</span> TestAssembly</pre>
    
    <pre>{</pre>
    
    <pre> [Theme(<span style="color: #006080">"Account transfers and deposits"</span>)]</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> AccountSpecs</pre>
    
    <pre> {</pre>
    
    <pre> [Story]</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Transfer_to_cash_account()</pre>
    
    <pre> {</pre>
    
    <pre> Account savings = <span style="color: #0000ff">null</span>;</pre>
    
    <pre> Account cash = <span style="color: #0000ff">null</span>;</pre>
    
    <pre></pre>
    
    <pre> Story transferStory = <span style="color: #0000ff">new</span> Story(<span style="color: #006080">"Transfer to cash account"</span>);</pre>
    
    <pre></pre>
    
    <pre> transferStory</pre>
    
    <pre> .AsA(<span style="color: #006080">"savings account holder"</span>)</pre>
    
    <pre> .IWant(<span style="color: #006080">"to transfer money from my savings account"</span>)</pre>
    
    <pre> .SoThat(<span style="color: #006080">"I can get cash easily from an ATM"</span>);</pre>
    
    <pre></pre>
    
    <pre> transferStory</pre>
    
    <pre> .WithScenario(<span style="color: #006080">"Savings account is in credit"</span>)</pre>
    
    <pre> .Given(<span style="color: #006080">"my savings account balance is"</span>, 100,</pre>
    
    <pre> <span style="color: #0000ff">delegate</span>(<span style="color: #0000ff">int</span> accountBalance) { savings = <span style="color: #0000ff">new</span> Account(accountBalance); })</pre>
    
    <pre> .And(<span style="color: #006080">"my cash account balance is"</span>, 10,</pre>
    
    <pre> <span style="color: #0000ff">delegate</span>(<span style="color: #0000ff">int</span> accountBalance) { cash = <span style="color: #0000ff">new</span> Account(accountBalance); })</pre>
    
    <pre> .When(<span style="color: #006080">"I transfer to cash account"</span>, 20,</pre>
    
    <pre> <span style="color: #0000ff">delegate</span>(<span style="color: #0000ff">int</span> transferAmount) { savings.TransferTo(cash, transferAmount); })</pre>
    
    <pre> .Then(<span style="color: #006080">"my savings account balance should be"</span>, 80,</pre>
    
    <pre> <span style="color: #0000ff">delegate</span>(<span style="color: #0000ff">int</span> expectedBalance) { Specify.That(savings.Balance).ShouldEqual(expectedBalance); })</pre>
    
    <pre> .And(<span style="color: #006080">"my cash account balance should be"</span>, 30,</pre>
    
    <pre> <span style="color: #0000ff">delegate</span>(<span style="color: #0000ff">int</span> expectedBalance) { Specify.That(cash.Balance).ShouldEqual(expectedBalance); })</pre>
    
    <pre></pre>
    
    <pre> .Given(<span style="color: #006080">"my savings account balance is"</span>, 400)</pre>
    
    <pre> .And(<span style="color: #006080">"my cash account balance is"</span>, 100)</pre>
    
    <pre> .When(<span style="color: #006080">"I transfer to cash account"</span>, 100)</pre>
    
    <pre> .Then(<span style="color: #006080">"my savings account balance should be"</span>, 300)</pre>
    
    <pre> .And(<span style="color: #006080">"my cash account balance should be"</span>, 200)</pre>
    
    <pre></pre>
    
    <pre> .Given(<span style="color: #006080">"my savings account balance is"</span>, 500)</pre>
    
    <pre> .And(<span style="color: #006080">"my cash account balance is"</span>, 20)</pre>
    
    <pre> .When(<span style="color: #006080">"I transfer to cash account"</span>, 30)</pre>
    
    <pre> .Then(<span style="color: #006080">"my savings account balance should be"</span>, 470)</pre>
    
    <pre> .And(<span style="color: #006080">"my cash account balance should be"</span>, 50);</pre>
    
    <pre></pre>
    
    <pre> transferStory</pre>
    
    <pre> .WithScenario(<span style="color: #006080">"Savings account is overdrawn"</span>)</pre>
    
    <pre> .Given(<span style="color: #006080">"my savings account balance is"</span>, -20)</pre>
    
    <pre> .And(<span style="color: #006080">"my cash account balance is"</span>, 10)</pre>
    
    <pre> .When(<span style="color: #006080">"I transfer to cash account"</span>, 20)</pre>
    
    <pre> .Then(<span style="color: #006080">"my savings account balance should be"</span>, -20)</pre>
    
    <pre> .And(<span style="color: #006080">"my cash account balance should be"</span>, 10);</pre>
    
    <pre> }</pre></p>
  </div>
</div>

<div>
</div>

<div>
  We haven&#8217;t released a stable build just yet but if you want to take a look at the root you can. Simply navigate to:
</div>

<div>
</div>

<div>
  <a href="http://www.codeplex.com/nbehave">http://www.codeplex.com/nbehave</a>
</div>

<div>
</div></p> 

<div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  del.icio.us Tags:<br /> <a href="http://del.icio.us/popular/NBehave" rel="tag">NBehave</a><br /> ,<br /> <a href="http://del.icio.us/popular/BDD" rel="tag">BDD</a>
</div>