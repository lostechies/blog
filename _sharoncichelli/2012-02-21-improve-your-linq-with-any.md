---
wordpress_id: 163
title: Improve your LINQ with .Any()
date: 2012-02-21T15:31:39+00:00
author: Sharon Cichelli
layout: post
wordpress_guid: http://lostechies.com/sharoncichelli/?p=163
dsq_thread_id:
  - "1002054102"
categories:
  - Refactoring
tags:
  - LINQ
---
LINQ&#8217;s `.Any()` method is under-utilized, given the benefits it brings in making your code briefer, clearer, and more efficient. LINQ in general improves the expressiveness of your collection-manipulating code by using declarative statements instead of imperative `foreach` loops; `.Any()` is a great tool in that regard.

Here&#8217;s a representative example:

[gist id=1877234]

I want to determine if my to-do list has any items that are late, so I use `.Where()` to filter my list of deliverables down to items with a deadline in the past; then I take a `.Count()` of the resulting list, and see if that number is greater than zero. This is a plausible solution, and our years of SQL lead us to write LINQ this way. But it can be better.

Testing &#8220;count greater than zero&#8221; is a programmer&#8217;s way of saying &#8220;are there any?&#8221; So let&#8217;s just say _any_. As you might expect, `.Any()` returns a Boolean indicating whether the collection contains any items. Further, you can pass a lambda expression to specify the predicate &#8220;any _like this_.&#8221; (`.Count()` takes a predicate, too, by the way, but I really have seen &#8220;`.Where().Count()`&#8221; in use, so I wanted to start from there.)

Here&#8217;s the new version:

[gist id=1877236]

In addition to being shorter, this version more directly and declaratively states my intent: &#8220;Are there any late deliverables?&#8221;

This code also executes more efficiently. For `.Count()` to return a value, LINQ must iterate over all items in the collection, even though I don&#8217;t care _how many_ items there are. `.Any()` will return as soon as it encounters an item that satisfies the predicate. It evaluates as few items as possible, giving me an efficient and readable solution.