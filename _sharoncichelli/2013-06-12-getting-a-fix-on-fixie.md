---
wordpress_id: 202
title: Getting a Fix on Fixie
date: 2013-06-12T22:54:41+00:00
author: Sharon Cichelli
layout: post
wordpress_guid: http://lostechies.com/sharoncichelli/?p=202
dsq_thread_id:
  - "1396619539"
categories:
  - Open Source Software
  - Unit Testing
---
My friend [Patrick Lioi](https://lostechies.com/patricklioi/) ([@plioi](https://twitter.com/plioi)) is writing [Fixie, a testing framework](http://fixie.github.io/), and I&#8217;m using it in one of my projects, a [genogram generator](https://github.com/scichelli/genogram-generator) (which I will write about once it does something interesting).

Why make a testing framework when we already have xUnit, NUnit, MbUnit&#8230;? Patrick has a few reasons, my favorite of which is: **to learn what can be learned from writing a testing framework**. Really, who needs more reason than that? He&#8217;s writing a great blog series about it, gathered up on [Fixie&#8217;s project page](http://plioi.github.io/fixie/).

## Making the switch

Rolling it into my project was simple. In my case, it was also quick, because I didn&#8217;t yet have many tests. But even if I did, the steps are still simple to understand.

  1. Put your tests into their own project.
  2. Use [NuGet](http://nuget.org/) to install [Fixie](http://nuget.org/packages/Fixie/) and an assertion library, such as [Should](http://nuget.org/packages/Should/).  
    <span style="font-size: 0.8em">And there&#8217;s one of the points that make this project interesting: Finding and executing tests really has <strong>nothing to do with assertions</strong>; therefore, Fixie doesn&#8217;t impose an assertion library on you. Use what you like.</span>
  3. If you&#8217;re using the [default convention for discovering tests](http://fixie.github.io/docs/default-convention/), **clear all the clutter** off your test classes and methods.  
    <span style="font-size: 0.8em">Or you can <a href="http://fixie.github.io/docs/custom-conventions/">define a convention to mimic your existing test framework</a>, to make conversion easier.</span>
  * The biggest NUnit-to-Fixie change I had to make is that, instead of a `[SetUp]` method, Fixie&#8217;s default convention uses the fixture class&#8217;s constructor for setup, and its `IDisposable.Dispose()` method for teardown. This has a definite advantage if you have inheritance amongst your test fixtures (not my favorite, but suit yourself): The order in which those constructors and disposers are called is **well defined and free from surprises**.

  4. Run your tests using [TestDriven.Net](http://www.testdriven.net/) or the Fixie.Console included in its NuGet package.
  5. Use NuGet to remove the old test framework.  
    <span style="font-size: 0.8em">Whee!</span>

## Why use Fixie

Patrick would shoot me if I said it was ready for prime time. There&#8217;s lots to build yet. But I&#8217;m having fun using it in my small project for a bunch of reasons:

  1. It inspires me to ask myself, what conventions would _I_ like to use for test discovery and execution.
  2. The ctor/IDispose pattern for setup/teardown is totally predictable.  
    <span style="font-size: 0.8em">I once discovered, unpleasantly, that the ReSharper test runner and the NUnit console would run inherited <code>[TestFixtureSetUp]</code>s in different orders. That was&#8230; <em>tough</em> to track down.</span>
  3. Using conventions means my tests have much less cruft.
  4. And I&#8217;m helping my friend, by putting his code to use. 🙂

## Okay then, why _read_ Fixie

Oh, now _that_, even if you&#8217;re not shopping for a new unit-testing framework, is worth your time. Patrick&#8217;s blog posts [documenting the Fixie project](http://plioi.github.io/fixie/)&mdash;documenting the birth and design of an open-source project, really&mdash;are fun and insightful. (Still probably going to get shot. Ah, well.) Check &#8217;em out.

## Try something new

Sometimes the best help you can contribute to a fledgling open-source project is to be an enthusiastic early adopter. Use their framework to give them more examples of how it might be used, how another developer interprets their API, and what features would be most useful next.

Any projects you&#8217;d like to highlight here that would welcome some early adopters? Tell us about them!