---
wordpress_id: 4525
title: 'Fixie&#8217;s Elevator Pitch'
date: 2013-07-23T14:01:46+00:00
author: Patrick Lioi
layout: post
wordpress_guid: http://lostechies.com/patricklioi/?p=7
dsq_thread_id:
  - "1524623006"
categories:
  - Uncategorized
---
I&#8217;ve been developing a .NET test framework, [Fixie](https://github.com/plioi/fixie), over the last few months, documenting my progress each week on my old blog. The relevant posts are reachable via the [Fixie github page](https://plioi.github.io/fixie). For my inaugural Los Techies post, I thought I&#8217;d catch everyone up with the elevator pitch. The elevator is in a fairly tall building.

First, I found myself favoring xUnit over NUnit, mainly for the brevity that it gives you as a result of its simpler test class lifecycle. When you get one instance of a test class for each test method, concepts like construction, [SetUp], and [TestFixtureSetUp] collapse into simple construction. Trading away boilerplate in order to use built-in language constructs like constructors feels right.

Next, I made a [customization to xUnit](http://patrick.lioi.net/2012/09/13/low-ceremony-xunit/) which gave me even more brevity. Instead of having no attribute on my test classes but a [Fact] on each test method, I flipped it around so that I needed a [Facts] attribute on the test class and no attributes on each test method. Why bother repeatedly saying, &#8220;This method, which is obviously a test method, is in [Fact] a test method&#8221;?

However, xUnit&#8217;s means of customization proved a little frustrating. I had to work with a pretty big [ISP](http://en.wikipedia.org/wiki/Interface_segregation_principle) violation, so big that I punted and threw NotImplementedException for the parts of the interface I really didn&#8217;t want to have to reinvent.

Also, the means of customization was still too opinionated about what a test class has to look like. In order to step in and say, &#8220;Hold on xUnit, I know what test methods look like, so just let me tell you what tests I found on this class,&#8221; I still had to use a special attribute on the test classes. Every test class I wrote had a name ending in &#8220;Tests&#8221; and an unfortunate [Facts] attribute as well. Why should I have to say the same thing twice?

I found myself wishing that NUnit and xUnit were less opinionated about test discovery as well as the test lifecycle. A test framework should focus on the boring parts: reflection, exception handling, and pass/fail counting. The rest should be exceptionally easy to customize.

With Fixie, you tell it what your test classes and test methods look like, and it uses those descriptions to go out and find them. Similarly, you can tell it how to perform the test class lifecycle: when and how to construct the test class, what to do before/after each test, and the like. By taking responsibilities _away_ from the test framework, the end developer gains more degrees of freedom.