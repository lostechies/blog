---
wordpress_id: 802
title: Run tests explicitly in xUnit.net
date: 2013-06-20T18:53:15+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=802
dsq_thread_id:
  - "1415942251"
categories:
  - Testing
---
I’ve more or less ditched NUnit as my default automated testing platform in .NET, preferring the more sensible defaults of xUnit.net. Switching wasn’t so bad – it mostly involved moving setup/teardown methods to constructors/Dispose methods. One piece that was missing was the ability to have explicit tests. Those are tests that are run only if I explicitly select them to run in the UI (using ReSharper, TestDriven.NET etc.), but won’t run if part of an entire test suite.

NUnit also has the concept of an Ignore attribute, which skips a test. xUnit does support this, along with [most other NUnit concepts](http://xunit.codeplex.com/wikipage?title=Comparisons), but not the ExplicitAttribute. Unfortunately, NUnit has this baked in to its framework. What I’d like to do is skip tests only when explicitly run inside Visual Studio, and not run when part of my local build or CI build.

The most consistent way I’ve found to do so is to skip the tests only when a debugger is not attached. I can’t do things like when the process is launched by a certain host or in a certain folder – that’s too brittle. Luckily, xUnit is easily extensible in this way, so we can create a Fact attribute that only works if a debugger is attached:

[gist id=5822765]

Inside my test that I only want to run explicitly from an attached debugger, I replace the Fact attribute with one I created above. In my case, I’m wiping a database conditionally:

[gist id=5822782]

If I run this test through the IDE, it gets skipped. If I run it through the automated build, it gets skipped. If I run the test with an attached debugger, it does run. Not exactly the behavior we had with NUnit, but close enough!