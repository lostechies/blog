---
wordpress_id: 906
title: 'Missing EF Feature Workarounds: Cascade delete orphans'
date: 2014-05-08T14:07:25+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=906
dsq_thread_id:
  - "2670009544"
categories:
  - EntityFramework
---
Currently, Entity Framework cannot [cascade delete orphans](http://www.nhforge.org/doc/nh/en/#manipulatingdata-graphs). In fact, there’s not a real concept of parent-child relationships, there’s only navigation properties, collection properties, and a notion of required/optional relationships. You can [cascade delete if a parent is deleted](http://msdn.microsoft.com/en-us/data/jj591620.aspx#CascadeDelete), but if you try something like this:

[gist id=2b76d0cb69a7ed74e9cd]

You’ll have an orphaned address! In a parent-child relationship, you’d like the parent to completely own the relationship to the child. Children cannot live on their own, so even if you configure EF to have a required relationship from child to parent:

[gist id=dfd8c2a0612dcb70ae9f]

You’ll get an error on SaveChanges about a required relationship not being available. What we’d like to do is when true child entities get detached from their parent, they get deleted. There’s no way to do this in the entity mapping, but we can override SaveChanges in our custom DbContext class to detect orphans and then delete them:

[gist id=b92f7b5ba0b156744708]

Not terrible, but it preserves the encapsulation of my parent-child relationship from Customer and Address.