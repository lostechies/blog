---
id: 914
title: Survey of two large MVC projects
date: 2014-06-25T15:17:00+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=914
dsq_thread_id:
  - "2794400812"
categories:
  - ASPNETMVC
---
A large-ish MVC project in which I led the architecture is hitting a milestone of 12 months in development (though released to production for some months now). It’s a similar project to the one where AutoMapper came from, but this time targeting a more focused domain, and subject of the [How We Do MVC](http://lostechies.com/jimmybogard/2013/07/17/how-we-do-mvc-4-years-later/) post.

Much of the patterns discussed come from a certain context, especially on optimizations I look at for accelerating delivery that don’t necessarily apply to other systems. Some comparison stats between these two projects:

**Project A**

  * ~6 years of continuous development at various pace
  * Over 100 deployments to customers statewide
  * 352 Controllers
  * 1079 Actions
  * 3 actions/controller

**Project B**

  * 12 months of continuous development at continuous pace
  * At least one deployment to a customer, a few more planned this year, then dozens the next
  * 71 Controllers
  * 534 Actions
  * 7.5 actions/controller

So while B only has 20% of the controllers of A, it has half the actions. This is for a couple of reasons:

  * 6 years ago AJAX was difficult for accessibility. Not the case any more, so AJAX plays a much bigger role
  * Task-based UIs mean a lot more contextual actions take place on one screen, depending a large number of factors

All these “put XYZ” on a diet talks, preferring slices over layers, and in general wanting new features to only add classes and files and not modify them is because of the scope of projects I generally deal with. I have to come up with tools and techniques to address design challenges of this scope, so tools like AutoMapper, the mediator pattern, feature folders, HTML conventions, slices over layers, no convoluted project structure and so on are critical to allow this sort of project to continue at a pace without slowing down under its own weight.

In this project, we had no repositories. No layered project structure. No abstractions over dependencies. No vegetable-based architectures. The last 12 months had roughly 250 working days, which averages out to a new controller every 3.5 days and a little over 2 new controller actions every single day. That sort of pace can only come from a laser focus on highly cohesive code, where each new feature only added requisite classes for feature where pieces differed, and allowing conventions to fill in mundane details that we intended to be consistent site-wide.

I’ve already covered our [designs in our controllers](http://lostechies.com/jimmybogard/2013/12/19/put-your-controllers-on-a-diet-posts-and-commands/), next, I’ll pick up the conventional HTML post that allowed us to create a highly streamlined process for building out our views (and how we extended this concept to client-side templates).