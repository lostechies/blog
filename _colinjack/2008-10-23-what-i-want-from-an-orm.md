---
id: 7
title: What I want from an ORM
date: 2008-10-23T19:53:30+00:00
author: Colin Jack
layout: post
guid: /blogs/colinjack/archive/2008/10/23/what-i-want-from-an-orm.aspx
categories:
  - Uncategorized
---
Thought I&#8217;d blog about some of the things I&#8217;d like to see in an ORM in the future, particularly to support DDD cleanly: 

  1. **No enforced associations** &#8211; I never want to create an association in the model just to support persistence, regardless of where keys are stored. So if I want to use uni-directional associations then I should be able to do that without having to go [for workarounds](http://colinjack.blogspot.com/2007/08/nhibernate-gotchas-living-with-legacy.html). 
      * **Aggregate locking** &#8211; Currently, with NHibernate at least, its difficult to lock an entire aggregate. For example NHibernate&#8217;s optimistic concurrency approach involves applying a version to rows, however aggregates can span tables so we really want to be able to give each aggregate a shared version ([coarse-grained locking approach](http://colinjack.blogspot.com/2007/05/nhibernate-and-coarse-grained-locking.html)). See [coarse-grained lock pattern](http://martinfowler.com/eaaCatalog/coarseGrainedLock.html). 
          * **Validating before saving** &#8211; I&#8217;d like hooks to automatically and cleanly validate an entire aggregate before persistence. 
              * **Disabling unit of work** &#8211; I&#8217;d like to be able to disable my unit of work, in many cases when working with DDD the UOW becomes more of a hindrance than anything else. I really want to be 100% sure that the only way to save a _Customer_ is through a _CustomerRepository_. 
                  * **Revalidate value objects when reloading** &#8211; Value objects only validate their data in their constructors, if your ORM does not ensure that a constructor that performs the validation is also used when reloading the object then its possible to end up with an invalid Value object. This is something you definitely want to avoid. Greg Young has raised this issue a few times, including in the [NHibernate forum](http://groups.google.com/group/nhusers/browse_thread/thread/f10a2328dd4b11eb/938bb50c534e8fee?lnk=gst&q=Greg+Young#938bb50c534e8fee), and made some very good points. 
                      * **Value objects** &#8211; Choosing to view something as a value object is a design decision that you make irrespective of the underlying DB design, so whilst the NHibernate component mapping is useful it should be as powerful as the mappings used elsewhere. Unfortunately with NHibernate [components don&#8217;t support inheritance](http://colinjack.blogspot.com/2007/08/nhibernate-gotchas-living-with-legacy.html) [nicely](http://colinjack.blogspot.com/2008/03/nhibernate-working-around-lack-of.html) and if your value object is stored in a separate table [things get confusing](http://tech.groups.yahoo.com/group/domaindrivendesign/message/5270).</ol> 
                    There may be other things I&#8217;d want but those are the ones that come to mind.