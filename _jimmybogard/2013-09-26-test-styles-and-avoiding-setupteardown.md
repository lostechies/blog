---
wordpress_id: 820
title: Test styles and avoiding setup/teardown
date: 2013-09-26T12:48:03+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=820
dsq_thread_id:
  - "1798839521"
categories:
  - TDD
  - Testing
---
Curious about NSpec, [Amir Rajan](http://amirrajan.net/) posted a challenge that posited that NSpec can make your tests cleaner. The results are summarized here:

[https://gist.github.com/amirrajan/6701522](https://gist.github.com/amirrajan/6701522 "https://gist.github.com/amirrajan/6701522")

One thing that is in stark contrast with my tests:

[https://gist.github.com/jbogard/6690905](https://gist.github.com/jbogard/6690905 "https://gist.github.com/jbogard/6690905")

And the others is that I explicitly never use Setup/Teardown for any of the Arrange/Act/Assert steps of a test (or Setup/Execute/Verify/Teardown for those [xUnit Patterns](http://xunitpatterns.com/) folks out there). The reasons are pretty simple, already well illuminated by several other folks:

[http://jamesnewkirk.typepad.com/posts/2007/09/why-you-should-.html](http://jamesnewkirk.typepad.com/posts/2007/09/why-you-should-.html "http://jamesnewkirk.typepad.com/posts/2007/09/why-you-should-.html")

[http://agileprogrammer.com/2005/07/23/assiduously-avoid-setup-and-teardown/](http://agileprogrammer.com/2005/07/23/assiduously-avoid-setup-and-teardown/ "http://agileprogrammer.com/2005/07/23/assiduously-avoid-setup-and-teardown/")

[http://agileprogrammer.com/2005/08/14/i-really-did-mean-it-avoid-setup-and-teardown/](http://agileprogrammer.com/2005/08/14/i-really-did-mean-it-avoid-setup-and-teardown/ "http://agileprogrammer.com/2005/08/14/i-really-did-mean-it-avoid-setup-and-teardown/")

In fact, the [xUnit.net testing framework](https://xunit.codeplex.com/) intentionally removed explicit support for setup/teardown.

My tests generally fall into two patterns:

  * Everything in a test method (AAA are entirely contained inside a single method)
  * Context-specification (each assert is its own method, arrange and act are lifted to fixture setup and executed once across all tests for that fixture)

The first one is fairly simple:

{% gist 6713500 %}

Arrange, act and assert are contained in each method. It’s really as simple as can be, and this code looks pretty much exactly as my code would in production. No mental gymnastics needed here to figure out what the execution lifecycle/steps are. The entire test is self-contained in a single method.

Context-specification looks a little different:

{% gist 6713536 %}

In this test, I have one setup (that private field). Depending on your test framework, this looks different. It could be a constructor, [TestFixture] attribute and so on. The key is the arrange/act steps are executed once, as described in the context of the test. The asserts are all different test methods, explicitly named. Because I’m testing multiple facets of behavioral observations, this style lets me incrementally add and verify behavior.

There are cases where we need environmental setup (not fixture setup) before and/or after a test case. I might need to reset a database, clear data, etc. If there aren’t explicit hooks for this sort of work in your test framework (xUnit has before/after test hooks), you _may_ have to use setup/teardown to do so.

If you are forced to do so, I’d consider switching to a different testing framework instead that does support AOP-style extensions. Environment setup/teardown is not important to see inside your test, but fixture setup certainly is.

It’s a simple couple of rules. Limiting yourself to these two styles will result in the clearest, most understandable tests. Ultimately, clean is good, but understandable is better. By matching our test design to good object design, we keep ourselves from getting to clever or novel, and focus on what truly matters.