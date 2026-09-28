---
wordpress_id: 78
title: When is it a Good Idea to write Bad Code?
date: 2014-01-09T14:08:18+00:00
author: Brad Carleton
layout: post
wordpress_guid: http://lostechies.com/bradcarleton/?p=78
dsq_thread_id:
  - "2102451338"
categories:
  - Project Management
  - Technical Debt
tags:
  - technical debt
---
Imagine an asteroid is barreling towards earth and the head of NASA tells you and your development team that they have 12 months to code the guidance system for the missile that will knock the asteroid off it’s earthbound trajectory.

Your first thought may be, “Sh$@*t!”  But let’s say you agree.  What does the quality of your code look like after 12 months?  Is it perfect?

Now imagine an asteroid is barreling towards earth and you have only 1 month to code the guidance system.  Now, imagine a worse scenario, you only have 24 hours to code the guidance system or the earth is a goner.

<h2 dir="ltr">
  What is Technical Debt?
</h2>

<p dir="ltr">
  You should read Martin Folwer’s excellent <a title="Technical Debt - Martin Fowler" href="http://martinfowler.com/bliki/TechnicalDebt.html" target="_blank">introduction to technical debt</a>.  Technical debt could be defined as the difference between the application that you would like to build and the application that you actually build.
</p>

<p dir="ltr">
  <strong>All software projects with limited resources will accumulate technical debt.  </strong>
</p>

<p dir="ltr">
  Technical debt is often viewed as a negative or pejorative term.  However, in reality, technical debt can be leveraged to actually launch successful applications and features.  The key to leveraging technical debt is to understand:
</p>

<li dir="ltr">
  What types of technical debt can you afford to accumulate?
</li>
<li dir="ltr">
  Where in your codebase can you afford to accumulate technical debt?
</li>
<li dir="ltr">
  When do you need to make a payment on your technical debt (when to refactor)?
</li>

Application development typically involves a variety of groups and individuals, for example the development team, business stakeholders, and your end users.  To understand technical debt, it&#8217;s important to realize the following:

**Technical debts are always paid by someone.**

<h2 dir="ltr">
  Types of Technical Debt
</h2>

<p dir="ltr">
  To understand technical debt, it is important to understand the different types of technical debt that can accumulate in an application.
</p>

<h3 dir="ltr">
  <strong>Missing Functionality</strong>
</h3>

<p dir="ltr">
  Missing functionality can make the user experience of your application more awkward to use, but on the up side it doesn’t pollute the codebase.  Chopping features can be a useful technique for reaching deadlines and launching your application.
</p>

_**Tradeoffs**_

<li dir="ltr">
  User experience can suffer from missing functionality.
</li>
<li dir="ltr">
  Overall utility of your product or service may be compromised.
</li>
<li dir="ltr">
  Future development will be more costly, if the feature must be added later.
</li>

<h3 dir="ltr">
  <strong>Broken Functionality</strong>
</h3>

<p dir="ltr">
  Broken functionality refers to code that “straight up” does not work under some or all circumstances.
</p>

<p dir="ltr">
  <em><strong>Tradeoffs</strong></em>
</p>

<li dir="ltr">
  Possible increased risk of catastrophe (system failure, security compromise, data corruption, etc.)  Sometimes code can cause serious damage to people and systems.
</li>
<li dir="ltr">
  User experience may suffer as users run into bugs that inhibit their ability to use your application.
</li>
<li dir="ltr">
  Utility of your application can decrease significantly.
</li>
<li dir="ltr">
  Plan on adding the broken functionality to your bug list, so future development will suffer.
</li>

<h3 dir="ltr">
  <strong>Bad Architecture Design</strong>
</h3>

<p dir="ltr">
  Systems benefit from being loosely coupled, and highly independent.  Conversely, highly coupled systems with lots of dependencies or interdependencies can be highly erratic and difficult to maintain and upgrade.  They can also be very difficult to reason about.
</p>

<p dir="ltr">
  Bad architecture decisions can be some of the most expensive to fix, as architecture is the core underpinning of your application.
</p>

<p dir="ltr">
  <em><strong>Tradeoffs</strong></em>
</p>

<li dir="ltr">
  Certain solutions may not scale with traffic based on their initial design or could be cost prohibitive to effectively scale in the future.
</li>
<li dir="ltr">
  Logical complexities, for instance in the case of a poorly designed database, can ripple through the entire application.  Making future development slow to a crawl.
</li>

<h3 dir="ltr">
  <strong>Bad User Experience Design</strong>
</h3>

<p dir="ltr">
  If you&#8217;re users don&#8217;t know how to user your application or make mistakes while using your application because of an overly complex user interface, than it will surely be your user base that is paying down this form technical debt.
</p>

<p dir="ltr">
  Bad user experience design can be very expensive to fix since the whole of the application development process depends on it.  Leaving the very real possibility that you&#8217;ve spent your limited development resources creating subsystems and code that don&#8217;t properly solve the problems of your end users.
</p>

<p dir="ltr">
  <em><strong>Tradeoffs</strong></em>
</p>

  * Decreased utility as your users struggle to fully take advantage of the application.
  * Very complex refactorings, since user interface inherently tend to be highly coupled, so again more possible drag on future development.

<h3 dir="ltr">
  <strong>Lack of Testing</strong>
</h3>

<p dir="ltr">
  The main purpose of testing, both automated and manual is to answer the simple question, does your code work?  If you can’t answer this question, then you&#8217;d be better off heading to the casino rather than launching your application.
</p>

<p dir="ltr">
  In a lot of ways, &#8220;lack of testing&#8221;, can be viewed through the lens of understanding what you&#8217;re application is capable of.
</p>

<p dir="ltr">
  <em><strong>Tradeoff</strong></em>
</p>

<li dir="ltr">
  Maintaining the quality of an application is not possible if you can&#8217;t answer the &#8220;does it work?&#8221; question effectively and efficiently.
</li>
<li dir="ltr">
  Future development can be more difficult without a way to tell when functionality stops working or when new features break old ones.
</li>

<h3 dir="ltr">
  <strong>Bad Code Readability</strong>
</h3>

<p dir="ltr">
  This is usually referred to as code smell, and again I like Martin Fowler’s <a title="Code Smell" href="http://martinfowler.com/bliki/CodeSmell.html" target="_blank">explanation</a>.  Bad code readability is easy for a developer to spot, because they simply look at the code and decide if it makes sense to them or not.  Therefore it can also be subjective.
</p>

<p dir="ltr">
  Being able to read and understand code is critical to being able to debug and modify it later.  This should not be confused with broken functionality, which is a different concept.
</p>

<p dir="ltr">
  In developer circles, there is a somewhat innate bias towards overemphasizing this form of technical debt (the reason being that it is the developer, that will ultimately pay for it).  Just remember that you can have &#8220;Bad Code&#8221; that doesn&#8217;t smell (silent but deadly).
</p>

<p dir="ltr">
  <em><strong>Tradeoffs</strong></em>
</p>

<li dir="ltr">
  Future development can become much more difficult, if not impossible (rewriting working code is common if the readability is bad enough)
</li>
<li dir="ltr">
  Risk of being highly dependent on the original developer/team for information about the system (see the <a title="Bus Factor" href="http://5whys.com/blog/the-bus-factor-why-your-best-developer-is-your-biggest-probl.html" target="_blank">bus factor</a>)
</li>
<li dir="ltr">
  Loss of the ability to understand your entire application, what it does and how it works.
</li>

All applications will have some level of technical debt in each of the above categories, but again, it is in managing this debt that gives a development team the ability to successfully launch their application.