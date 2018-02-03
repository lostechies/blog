---
wordpress_id: 29
title: Simple BDD/TDD
date: 2009-09-02T02:47:00+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2009/09/01/simple-bdd-tdd.aspx
dsq_thread_id:
  - "425624308"
categories:
  - BDD
  - TDD
---
Todays theory is **most tests and specs should be very short (2-3 lines), have at most a setup for context establishment, avoid the majority of test framework features as they should be used as an exception and not as a rule.**&nbsp; Note: I practice BDD nowadays and do not like using the term &#8220;test&#8221;, but these rules apply for BDD as well as TDD, and I imagine most of you practice TDD so I&#8217;ll be using primarily TDD terminology.

If you look at my first attempts at TDD they are very similar to my current BDD work with only changes in language. But the contexts, conditions and tests are similar. Most importantly they&#8217;re easy to read. They&#8217;re all very short, very descriptive, make limited use of arguments in the NUnit Attributes, and make very limited use of mocking.

Of course along the way I went down all sorts of terrible wrong paths, and with the help of [Gerrard Meszaros](http://www.amazon.com/xUnit-Test-Patterns-Refactoring-Code/dp/0131495054/ref=sr_1_1?ie=UTF8&s=books&qid=1251858264&sr=8-1) plus some of my own experimentation I&#8217;m much happier with the time it takes to implement tests and the limited pain in refactoring my code.

Bad ideas I had along the way include: 

  * Ran everything in TestFixtureSetup and TestFixtureTearDown or equivalent. Tests were all linked to one another
  * Mocked EVERYTHING and doing so with Record/Replay was double awful. Simple refactorings would break way more tests than they should. Test methods were 8-40 lines and unreadable at that.
  * Tried to sort everything by category with NUnit attributes. Took a fair amount of time for no payoff I can see (think about changing a category name when all you have is seemingly unrelated strings)
  * Tried to create &#8220;Story Classes&#8221; for testing. I know some people like this approach, I find them to be heavily coupled, fragile and noisy. Also this made finding individual examples of usage of individual classes difficult as now its &#8220;rules&#8221; were spread everywhere

&nbsp;

Summary point avoid some of my mistakes, if you write short unit tests now..thats probably a good thing. If you are struggling with testability of your classes and you find your tests getting big, try and stop, sit down and make sure you are testing &#8220;one thing&#8221; and not really a big thing with many small pieces.