---
wordpress_id: 3377
title: Unique Keys versus IDs in Web Applications
date: 2010-02-25T04:08:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2010/02/24/unique-keys-versus-ids-in-web-applications.aspx
dsq_thread_id:
  - "262175094"
categories:
  - Best Practices
  - development
redirect_from: "/blogs/chrismissal/archive/2010/02/24/unique-keys-versus-ids-in-web-applications.aspx/"
---
An ID is a fine way to uniquely identify an object, the common usage is also very user un-friendly. A while back I was watching a presentation by Jeffrey Palermo on <a href="http://www.c4mvc.net/" rel="nofollow">Community For MVC.Net</a>, then later at a live presentation and discussion at the local user group in Cedar Rapids. Not that it’s a new idea, but the idea of a Key and the IKeyable<T> interface was mentioned. This idea being a unique, human readable string. Throughout the rest of this post, when I mention “ID”, I’m speaking of an auto-generated number or meaningless string. When I mention a “Key”, I’m speaking of a meaningful string identifier that gives some sense as to what it is representing when a human reads it.

## IDs in an Web Application

Sequential integers in a database are easy to come by and are guaranteed to be unique by the database. This makes things simpler since you’re not required to check for uniqueness. Another option is to use [GUIDs](http://msdn.microsoft.com/en-us/library/system.guid.aspx). These are good because the chance of collision is extremely small and gives you hundreds of billions of combinations. Another unique ID that I’m seeing appear more recently is the incremented strings, where “ab89Fh” is the prior ID to something like “ab89Fg”. All of these solutions are great for keeping things unique from the data perspective, but are horrible for human memory.

## Unique Keys in an Web Application

The concept is simple: a human-readable key that uniquely identifies an object. Why is a unique human-readable key a good idea? A key that is generated from some meaningful text is likely going to exist within a URL when in a web application. This is good for many reasons:

  1. They’re easier to remember 
  2. Search engines see them as text and not garbage. 
  3. You can make some assumptions as to what the content is, given the key. 

Use keys over (or in conjunction with) IDs. They’re nice, they’re good and you’ll love them.

### More Resources

  * Phil Haack recently posted a good solution to using keys (or slugs) in your MVC application. With [Phil’s friendly URLs](http://haacked.com/archive/2010/02/21/manipulating-action-method-parameters.aspx), you don’t have to sacrafice your precious integer IDs either. 
  * Derick Bailey had posts last summer (2009) with some [thoughts on Database IDs](http://www.lostechies.com/blogs/derickbailey/archive/2009/07/14/database-id-int-vs-bigint-vs-guid.aspx) and [the storage implications](http://www.lostechies.com/blogs/derickbailey/archive/2009/07/15/storage-size-and-performance-implications-of-a-guid-pk.aspx). (_Good comments!_)