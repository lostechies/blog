---
wordpress_id: 322
title: Defining and refining conventions
date: 2009-06-09T13:35:34+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/06/09/defining-and-refining-conventions.aspx
dsq_thread_id:
  - "265260169"
categories:
  - Design
redirect_from: "/blogs/jimmy_bogard/archive/2009/06/09/defining-and-refining-conventions.aspx/"
---
At last night’s [ADNUG](http://adnug.org/) talk, [Jeremy Miller](http://codebetter.com/blogs/jeremy.miller/) talked about Convention over Configuration, and many of the principles the Rails community embraces.&#160; He showed a few examples of opinionated software, such as FubuMVC.&#160; One thing I would have liked more conversation around (but no time, alas), was the process of discovering conventions and forming the opinions that make up [opinionated software](http://gettingreal.37signals.com/ch04_Make_Opinionated_Software.php).

Opinionated software, as I see it, is a framework that provides intentionally chosen axes of change, where other axes are fixed to adhere to agreed-upon principles.&#160; In Rails Active Record for example, by default my entity’s shape is whatever shape my table structure is, optimizing for very little configuration.&#160; Because Ruby is a dynamic language, it can get away with this easily with meta-programming tricks.

But how do we arrive at such opinions?&#160; How do we decide which principles are acceptable, which are not?&#160; Every design decision has a tradeoff, and frameworks like Rails aren’t going to satisfy everyone’s opinion.&#160; We need some mechanism to form these opinions and craft our conventions.

### Integrating evolutionary design

With our [wall of pain](https://lostechies.com/blogs/jimmy_bogard/archive/2009/06/03/fighting-technical-debt-with-the-wall-of-pain.aspx), we strive to ensure that we have one design vision.&#160; Introduce a refactoring, and we want to retrofit and remove duplication everywhere.&#160; Often, this is architectural duplication, such as the knowledge of a required field propagated throughout every layer in the system.&#160; To eliminate this architectural duplication through conventions and opinions, it would likely take several iterations of that design before everyone is happy with the result.

But the cost of propagating that design does have a real, tangible cost.&#160; Iterating a design along with propagating it will cause a very real churn, even to the point where it could frustrate developers and discourage innovation.&#160; On the flip side, iterating endlessly and never retrofitting our opinions leads to chaos, as well fall into the trap of having a hundred truths in our system, all of them correct at one point in time.&#160; A new developer that came on recently vented his frustration with this problem, as he was spinning his wheels on an old design, simply because he picked the wrong version of the truth to model from.

So we need to both iterate and propagate our design, ideally at key tipping points where we’ve arrived at a sound design, and no important unanswered questions remain.&#160; We might have questions about our design, but answers might only come through applying our design in a variety of scenarios.

### Past the tipping point

From my experience, these tipping points are fairly obvious, and follow Evans’ concept of breakthrough refactorings.&#160; We make incremental enhancements, slowly improving our design over time.&#160; At a critical mass of awareness of problems and understanding of the domain, we introduce a change that dramatically improves the design.

These tipping points can’t be anticipated, nor can they be prognosticated.&#160; In fact, trying to form opinions in absence of any context for these opinions is very likely to lead to awkward, friction-inducing development.&#160; Another word for premature opinions might be BDUF.

The middle ground here is one where we become finely attuned to the pain induced by our design, not try to invent problems where they don’t exist, iterate our design, and retrofit after each breakthrough.&#160; Opinionated software is a fantastic concept, but we can’t confuse opinion formation with misguided attempts to make all design decisions upfront in the absence of agreeing upon the principles that led to the opinions.