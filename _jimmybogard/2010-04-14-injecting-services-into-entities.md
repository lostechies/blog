---
wordpress_id: 399
title: Injecting services into entities
date: 2010-04-14T13:09:57+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/04/14/injecting-services-into-entities.aspx
dsq_thread_id:
  - "264716433"
categories:
  - DomainDrivenDesign
redirect_from: "/blogs/jimmy_bogard/archive/2010/04/14/injecting-services-into-entities.aspx/"
---
One of the comments that came up from the [Strengthen your Domain](https://lostechies.com/blogs/jimmy_bogard/archive/2010/02/03/strengthening-your-domain-a-primer.aspx) series was the idea of injecting services into your entities, instead of using domain services, double dispatch or domain events.&#160; For quite a long time, this was not easily possible technically, but some of the more mature ORM frameworks [now support this scenario](http://nhforge.org/blogs/nhibernate/archive/2008/12/12/entities-behavior-injection.aspx).

It’s a question that gets routinely asked on various ORM and DDD mailing lists, “How do I inject services into my entities”?&#160; Even if it’s now technically possible, the answer is the same now as it was before: **you don’t.**

It seems like this ability could solve quite a few problems, where behavior in my entities gets too large, but I don’t want to completely remove the entry points for this behavior from my entities.&#160; This is a good goal, but injecting services into entities (or worse, having the entity service locate them) is a wolf in sheep’s clothing.

![](http://777denny.files.wordpress.com/2009/07/wolves_in_sheeps_clothing.jpg)

It turns out that following this path for dependencies introduces a few not-so-obvious problems in your domain model design.

### 

### Problem 1: Confusion on what the dependency is used for

One of the design smells you’ll often find early when following dependency injection practices are services that take several dependencies whose usage is highly fractured.&#160; One method uses dependency A, B and C, while another method uses D and E.&#160; When changing the behavior of this class, it’s difficult to understand the nature, size and side effects of the change.

With a service in an entity constructor, the confusion can increase.&#160; Typically, entity constructors are used to provide the invariants.&#160; A Transaction cannot be described as such unless I provide the Transaction Type (deposit/withdrawal/transfer) and the amount.&#160; With an additional service in the constructor, it’s not immediately clear why exactly I need this extra service.&#160; Is it for some core behavior, or just one method or property?&#160; When I start to modify this entity through unit tests, I now have to make a decision every time I use the entity on whether or not I need to supply this extra parameter, or just leave it null.&#160; Typically, when a service has dependencies that are used for only certain operations, I just let the test fail and through trial and error try and figure out what is needed.&#160; Which brings us to the next problem.

### Problem 2: Difficulty testing

When a constructor requires a dependency, but only uses it for a subset of the object’s operations, then the dependency only becomes _partially_ required.&#160; I could supply a null value or pass in just a no-op stub, but it leaves us with a rather strange design.&#160; This object says it needs all these parameters to do its job, but it only needs some of the parameters some of the time.&#160; This is what I run into with an entity that takes a dependency.&#160; The behaviors on an entity can grow over time, but a constructor usually stays fairly static.&#160; Once the invariants are determined, these aren’t likely to change much over time.

As behaviors grow, some operations may need to rely on services.&#160; For unrelated operations on an entity, I don’t want to be effectively punished for the complexity required in a separate operation.&#160; Forcing me to supply a constructor dependency introduces pain.

### Solutions

I have found that optional dependencies seem to fit just fine with entities.&#160; For example, if I want to integrate logging into my operations, I can fairly easily implement the Null Object pattern, and allow my entity to be used without that optional dependency.&#160; Because that logging class might be supplied as a property, it communicates explicitly that this dependency is not required.

Otherwise, I’ll stick to the more obvious solutions of domain services, double dispatch and domain events.&#160; Injecting services into entities just makes them harder to understand and use.