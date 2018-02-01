---
id: 75
title: Are Story Runners appropriate?
date: 2007-10-09T13:30:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/10/09/are-story-runners-appropriate.aspx
dsq_thread_id:
  - "279553072"
categories:
  - NBehave
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/10/are-story-runners-appropriate.html)._

Scott recently voiced his opinion on the validity of story runners (i.e. the xBehave tools) in an agile shop.&nbsp; First, let me say that I sincerely appreciate the passion Scott has for BDD, and it&#8217;s that passion that will drive the community forward.&nbsp; Second, in recognizing that passion, I won&#8217;t respond to&nbsp;comments about technology fetishes and code-sturbation for now, but I do honestly understand the concerns behind them.

Scott sees a tool in search of a problem, and in completely disagreeing with the problem it&#8217;s trying to solve, questions the motivation of those developing the tool, which he sees as seemingly selfish and egotistical reasons.&nbsp; From that point of view, again, I completely understand Scott&#8217;s concerns, and luckily I have a Bellwarese translator to get to the heart of those concerns.

I did feel it unfortunate that the BDD conversation revolved around tools.&nbsp; BDD is far too nascent to argue tooling, and instead the&nbsp;discussion&nbsp;should have focused getting the language, values, and concepts right.

So Scott&#8217;s core question is:

**Are Story Runners appropriate for executable requirements?**

As an aside, not once in my experience have I had a BA come up to me and say &#8220;hey, while you&#8217;re delivering this, it would be great if you had some automated tests for it too&#8221;.&nbsp; I&#8217;ve never had anyone from the business ask me to use any kind of automated testing tool, such as NUnit, FitNesse, NSpec, or NBehave.&nbsp; These tools will always be pushed by geeks, as it is the geeks that see the value of these tools first.

For me personally, capturing stories in code was never about traceability.&nbsp; Specifically, the tangible benefits Joe and I saw were:

  * Providing a more complete description of the behavior of the system
  * Unit tests too granular
  * Even specifications can be difficult to organize

  * Stories provide a better overall, macro view of the system
  * Executable stories remind us of our final goal
  * For us, the final goal isn&#8217;t the unit tests, but that the story is satisfied.
  * Capturing in code helps direct us towards that final goal

  * Executable stories can help capture the conversation
  * Executable stories can help shape our domain model and infuse the ubiquitous language into the system

The more appropriate venue for our discussion was Jeremy&#8217;s topic Sunday on executable requirements.&nbsp; Stories are part of BDD, as we can all agree, but **should stories be used as executable requirements**?

The result from the discussion was &#8220;**let&#8217;s see, as nothing else has worked great so far**&#8220;.&nbsp; Start with stories, end with stories.&nbsp; Stories -> Scenarios or Aspects -> Specifications (NSpec)&nbsp;-> Unit tests (NUnit)&nbsp;-> Integration Tests (FitNesse/NUnit)&nbsp;-> Functional/Acceptance Tests (FitNesse/NBehave).

I do&nbsp;appreciate this dialogue, as only through debate with the truly passionate can clarity be achieved.

&nbsp;

&nbsp;

p.s.&nbsp;please don&#8217;t suggest exploding laptops, we&#8217;ve had enough problems with that here&#8230;