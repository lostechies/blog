---
id: 25
title: 'Introducing SpecMaker “Rspec style” BDD in C#'
date: 2009-08-08T12:00:00+00:00
author: Ryan Svihla
layout: post
guid: /blogs/rssvihla/archive/2009/08/08/introducing-specmaker-rspec-style-bdd-in-c.aspx
dsq_thread_id:
  - "426147963"
categories:
  - BDD
  - 'C#'
  - Context
  - Spec
  - SpecMaker
---
So I&rsquo;m certain this will be met with mixed response, because really .Net already has several decent BDD frameworks and many of you will chastise me for adding yet another framework when really BDD has nothing to do with what testing framework you use.&nbsp; So why you ask?

  1. Most of the BDD frameworks I&rsquo;ve looked at are Acceptance style and trying to make stories into executable code (NBehave, StoryTeller, Fitnesse.Net ,Acceptance, etc).&nbsp; I want something that describes to other developers in a behavior centric way what my code is doing (like RSpec&rsquo;s default DSL does).&nbsp; This is not aimed at business analysts.
  2. The other RSpec style framework for C# I&rsquo;ve played with while very nice, did not go over well with people I&rsquo;ve tried to introduce to BDD.
  3. Using NUnit in a context BDD style is normally what I do but produces a lot of artifacts, is underscore heaven and provides no guidance to newer practitioners of BDD.

With all this in mind how does SpecMaker improve our situation at all?&nbsp; First lets look at how I might approach a BDD test with NUnit

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <div style="font-family:consolas,lucida console,courier,monospace">
    &nbsp;&nbsp;&nbsp;[TestFixture]<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">public</span>&nbsp;<span style="color: #0000ff">class</span>&nbsp;<span style="color: #2b91af">SpecGameWhenStartingUp</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">{</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">private</span>&nbsp;Game&nbsp;_game;<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">private</span>&nbsp;<span style="color: #0000ff">void</span>&nbsp;startGame()<span style="color: #0000ff">{</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000">//&nbsp;left&nbsp;out&nbsp;for&nbsp;clarity<br /> </span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">}</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[SetUp]<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">public</span>&nbsp;<span style="color: #0000ff">override</span>&nbsp;<span style="color: #0000ff">void</span>&nbsp;SetUp()<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">{</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;startGame();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">}</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Test]<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">public</span>&nbsp;<span style="color: #0000ff">void</span>&nbsp;should_have_3_lives()<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">{</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(3,&nbsp;_game.lives);<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">}</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">}</span>
  </div>
</div>

On the surface there isn&rsquo;t much wrong with this. Asserts are less than ideal (Rspec matchers would be nice), underscores on my &ldquo;should_&rdquo; are so so, context in the class name leads to lots of classes and me playing around a bunch with inheritance. However, none of this is a game breaker and for those of you who have a good workable flow with this approach and are happy with it, please continue to use it. I however, am not happy with the flow, also BDD really is not easy for me to teach. Some of you may get it easily and teach it easily, but .Net developers as a whole seem to be driven towards framework specific knowledge (telling them to not think &ldquo;test&rdquo; when test is staring at them on the method messes with their heads), and even then it&rsquo;d better not be too &ldquo;cutting edge&rdquo; in language features or friction becomes a risk where someone may end up learning more than just BDD.

So what are my goals then for SpecMaker? 

  1. It has to be terse, and be shorter than the NUnit approach.
  2. Eliminate underscores where possible.
  3. Act as a series of guidelines to beginning BDD&rsquo;ers.
  4. Output spec results in a variety of formats.
  5. Remove the &ldquo;Test&rdquo; entirely from the vocabulary.
  6. Use convention over configuration where possible.
  7. Provide custom matchers and a DSL to make your own custom matchers.

What will it not do or be?

  1. Do acceptance testing. This could change in the future, but then I&rsquo;d be inclined to borrow code from others that do this well already.
  2. Make BDD a &ldquo;click next&rdquo; thing. There is no substitute for continually trying to refine your approach and understand &ldquo;behavior&rdquo; and what that means. I&rsquo;m not sure there is one true right answer here and that makes it so incredibly hard to make a framework that does that.
  3. Be as nice as RSpec. 
  4. Integration tests. This is setup very much one-to-one. Again this was a simplicity choice and as I dog food this I may completely change my mind here.

So with all the ceremony out of the way here is where I&rsquo;m at so far for the same BDD code above only with SpecMaker

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <div style="font-family:consolas,lucida console,courier,monospace">
    &nbsp;<span style="color: #0000ff">public</span>&nbsp;<span style="color: #0000ff">class</span>&nbsp;<span style="color: #2b91af">GameSpec</span>&nbsp;:&nbsp;BaseSpec<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">{</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">private</span>&nbsp;<span style="color: #0000ff">void</span>&nbsp;startGame()<span style="color: #0000ff">{</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000">//left&nbsp;out&nbsp;for&nbsp;clarity<br /> </span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">}</span>&nbsp;&nbsp;<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">public</span>&nbsp;<span style="color: #0000ff">void</span>&nbsp;when_starting_a_game()<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">{</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;startGame();<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;should(<span style="color: #a31515">&#8220;have&nbsp;3&nbsp;lives&#8221;</span>,&nbsp;()=><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">{</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_game.lives.Has(3).Total();<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">}</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;);<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;should(<span style="color: #a31515">&#8220;require&nbsp;valid&nbsp;username&#8221;</span>,&nbsp;RuleIs.Pending);<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">}</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">}</span>
  </div>
</div>

Running specmaker.exe on the the dll where this spec is located outputs something like this:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" alt="Picture 2" src="//lostechies.com/ryansvihla/files/2011/03/Picture2_thumb_14E6D816.png" border="0" width="750" height="82" />](//lostechies.com/ryansvihla/files/2011/03/Picture2_42D19A1D.png)

&nbsp;

&nbsp;

At this time specs come from the class name minus &ldquo;Spec&rdquo; at the end. Context start with &ldquo;when&rdquo; or the method will not get picked up as context.&nbsp; This is also staggeringly new and may have bugs, issues, bad docs, ugly code, etc. But since I&rsquo;ve moved this to Github I encourage everyone to have a go and improve it as they see fit or for their own purposes.&nbsp; I have a number of plans and ideas to improve this, but I feel this is a good start to get some positive work done and save myself some grief over my NUnit based tests.

Let me know what you think, any and all criticism is appreciated, but at the end of the day this does actually fulfill an itch that I myself have had for some time.