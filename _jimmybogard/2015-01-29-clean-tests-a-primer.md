---
wordpress_id: 1036
title: 'Clean Tests: A Primer'
date: 2015-01-29T14:25:06+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=1036
dsq_thread_id:
  - "3466400214"
categories:
  - Testing
---
Posts in this series:

  * [A Primer](http://lostechies.com/jimmybogard/2015/01/29/clean-tests-a-primer/ "Clean Tests: A Primer")
  * [Building Test Types](http://lostechies.com/jimmybogard/2015/02/05/clean-tests-building-test-types/ "Clean Tests: Building Test Types")
  * [Isolating Internal State](http://lostechies.com/jimmybogard/2015/02/17/clean-tests-isolating-internal-state/)
  * [Isolating the Database](http://lostechies.com/jimmybogard/2015/03/02/clean-tests-isolating-the-database/)
  * [Isolation with Fakes
  
](https://lostechies.com/jimmybogard/2015/03/24/clean-tests-isolation-with-fakes/) 
  * [Database Persistence](https://lostechies.com/jimmybogard/2015/04/07/clean-tests-database-peristence)

Over the course of my career, I’ve an opportunity to work with a number of long lived codebases. Ones that I’ve been a part of since commit one and continue on for six or seven years. Over that time, I’ll see how my opinions on writing tests have changed throughout the years. It’s gone from mid 2000s mock-heavy TDD, to story-driven BDD (I even wrote an ill-advised framework, NBehave), to context/spec BDD. I looked at more exotic testing frameworks, such as MSpec and NSpec.

One advantage I see in working with codebases for many years is that certain truths start to arise that normally you wouldn’t catch if you only work with a codebase for a few months. And one of the biggest truths to arise is that **simple beats clever**. Looking at my tests, especially in long-lived codebases, the ability for me to understand behavior in a test quickly and easily is the most important aspect of my tests.

Unfortunately, this has meant that for most of the projects I’ve worked with, I’ve had to fight against testing frameworks more than work with them. Convoluted test hierarchies, insufficient extensibility, breaking changes and pipelines are some of the problems I’ve had to deal with over the years.

That is, until an enterprising coworker [Patrick Lioi](http://lostechies.com/patricklioi/) started authoring a testing framework that (inadvertently) addressed all of my concerns and frustrations with testing frameworks.

In short, I wanted a testing framework that:

  * Was low, low ceremony
  * Allowed me to work with different styles of tests
  * Favored composition over inheritance
  * Actually looked like code I was writing in production
  * Allowed me to control lifecycle, soup to nuts

Testing frameworks are opinionated, but normally not in a good way. I wanted to work with a testing framework whose opinions were that it should be up to _you_ to decide what good tests are. Because what I’ve found is that testing frameworks don’t keep up with my opinions, nor are they flexible in the vectors in which my opinions change.

That’s why for every project I’ve been on in the last 18 months or so, I’ve used [Fixie](http://fixie.github.io) as my test framework of choice. I want tests as clean as this:

[gist id=027879256ea4d99cb23e]

I don’t want gimmicks, I don’t want clever, I want code that actually matches what I do. I don’t want inheritance, I don’t want restrictions on fixtures, I want to code my test how I code everything else. I want to build different rules based on different [test organization patterns](http://xunitpatterns.com/Test%20Organization.html):

[gist id=53f6fe229eed18d86e2d]

Fixie gives me this, while none others can completely match its flexibility. Fixie’s philosophy is that assertions shouldn’t be a part of your test framework. Executing tests is what a test framework should provide out of the box, but test discovery, pipelines and customization should be completely up to you.

In the next few posts, I’ll detail how I like to use Fixie to build clean tests, where I’ve stopped fighting the framework and I take control of my tests.