---
wordpress_id: 458
title: Another source for LINQ extensions
date: 2011-03-08T14:04:50+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2011/03/08/another-source-for-linq-extensions.aspx
dsq_thread_id:
  - "264716671"
categories:
  - 'C#'
---
While poking around for LINQ extensions, I found a project on Google Code, [morelinq](http://code.google.com/p/morelinq/), that has \*numerous\* LINQ extensions from some rock-star authors like Jon Skeet, such as:

  * Batch
  * Concat
  * Consume
  * DistinctBy
  * Pad
  * Pipe
  * Scan
  * TakeEvery
  * Zip

And many more.&#160; For those that can’t/won’t download Reactive Extensions, which subsumes nearly all of these, morelinq is a good alternative. What’s even more valuable are a couple of branches that have a number of other really cool extensions, including one I was looking for:

IEnumerable<IEnumerable<TSource>> Partition<TSource>(this IEnumerable<TSource> source, int size)

Pretty sweet…