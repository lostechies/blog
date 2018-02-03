---
wordpress_id: 34
title: 'Demeter Helps You Fend Off the One True Constant: Change'
date: 2009-07-20T04:33:00+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2009/07/20/demeter-helps-you-fend-off-the-one-true-constant-change.aspx
dsq_thread_id:
  - "262055700"
categories:
  - Law of Demeter
  - Software Design
  - SOLID
---
There have been some [good](http://haacked.com/archive/2009/07/14/law-of-demeter-dot-counting.aspx) [discussion](http://codebetter.com/blogs/jeremy.miller/archive/2009/07/18/what-i-ve-learned-over-the-last-five-years.aspx) lately around the [Law of Demeter](http://en.wikipedia.org/wiki/Law_of_Demeter).&nbsp; The worst thing about Law of Demeter is that it has the word &ldquo;Law&rdquo; in it.&nbsp; Like all of the SOLID principles, it should be considered a rule of thumb and your experience and knowledge of the domain should tell you when it it appropriate.&nbsp; However, I would consider staying consistent with this principles (as with all of the others) the starting point and transgress only under special circumstances.

If you haven&rsquo;t heard of Demeter, the formal definition is that methods of a given class should only access:

  1. Fields and Methods on the object.
  2. Any object created within the method.
  3. Any direct properties or methods of an argument to the method

By following Demeter, you have stronger encapsulation in your objects.&nbsp; This will lead to fewer coupling points in your application and thereby lowering coupling in your system.&nbsp; When you do violate this principle it is easy to get into the situation where a change in one part of system has repercussions in other parts that were not touched for a specific release.&nbsp; That&rsquo;s when your day after release becomes a nightmare of chasing down bugs in production you can&rsquo;t explain.

Recently I was was brought on to a very large application that has been in development for over a year.&nbsp; When pairing with one the devs on a new feature, the implementation he proposed broke Demeter in several places, accessing child properties and methods a few levels deep.&nbsp; When I brought this to his attention and explained to him that if you&rsquo;re absolutely sure the object in question will always be created with the Properties in question, then you can considerate an allowable break of the rule.

The developer I was partnering did not think it was possible to construct the object in which this violation would ever cause a problem.&nbsp; He&rsquo;s a smart guy and I have no reason to doubt him, but as the title of of this post states, change is the one true constant.&nbsp; We know that requirements change over time.&nbsp; We also know that end users are very creative in using applications for solving problems they are not designed for.

Staying consistent with Demeter is my default way of developing new features.&nbsp; Even if I think the chances of getting into an invalid state are infinitesimal, I still try to stay consistent with this principle.&nbsp; It gives me greater flexibility to change the system as necessary and keeps my dependencies to getting to &ldquo;sticky&rdquo;, where I have to worry about who is accessing a property inappropriately&nbsp; when it is time to change them.