---
wordpress_id: 28
title: Article series on NHibernate and Fluent NHibernate – Part 3
date: 2009-09-02T04:49:28+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2009/09/02/article-series-on-nhibernate-and-fluent-nhibernate-part-3.aspx
dsq_thread_id:
  - "263908874"
categories:
  - Fluent NHibernate
  - How To
  - NHibernate
  - tutorial
---
Today the third part of my series on NHibernate and Fluent NHibernate went live. You can read it [here](http://dotnetslackers.com/articles/ado_net/Your-very-first-NHibernate-application-Part-3.aspx).

## Summary

In part 3 of this article series about NHibernate and Fluent NHibernate I have discussed how to let Fluent NHibernate automatically map a domain model to a data model. We have realized that FNH provides a reasonable mapping out of the box by using default conventions. I have shown how one can implement user defined conventions which will influence how the mapping is defined on a very fine grained level. I have also shown that if we use a base class in our domain which implements common functionality we can instruct FNH to ignore this class and just map the “real” entities.

FNH with its auto mapping feature reduces the task of mapping a complex domain to an underlying data model to just a few keystrokes. And as is always true: less code results in less bugs and less maintenance overhead.