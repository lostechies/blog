---
wordpress_id: 324
title: Requesting features for AutoMapper
date: 2009-06-15T01:08:09+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/06/14/requesting-features-for-automapper.aspx
dsq_thread_id:
  - "264716190"
categories:
  - AutoMapper
redirect_from: "/blogs/jimmy_bogard/archive/2009/06/14/requesting-features-for-automapper.aspx/"
---
On the [AutoMapper mailing list](http://groups.google.com/group/automapper-users), I get a lot of what I consider wacky requests.&#160; Not because the requests aren’t valid, but rarely do I get any context of what people are trying to do with [AutoMapper](http://automapper.codeplex.com/).&#160; As a reference, we are using AutoMapper in these situations:

  * Mapping from Domain/Presentation Model to ViewModel
  * Mapping from Domain/Presentation Model to EditModel (forms) <- yes, different concerns at play here
  * Mapping from Domain to a Reporting model (think printable view screens, not analytics)
  * Mapping from EditModel forms to Command objects

Some of the requests I’ve inferred include a lot of mapping from ViewModels _back_ to Domain models.&#160; Personally, this seems wacky to me, unless you’re in some sort of ActiveRecord/CRUD scenario.&#160; In those cases, I’d rather expose my model directly to my views.

If AutoMapper doesn’t do what you want, a few things might be true:

  * There is a bug
  * You’re doing something valid, but in a scenario I haven’t encountered
  * You’re doing something you shouldn’t do, and trying to attach two boards with a screw and a hammer

Object-to-object mapping is a broad spectrum of distinct scenarios, and AutoMapper really only focuses on the scenarios where your destination type looks like your source type, plus some flattening.&#160; So if you’d like a scenario to be supported by AutoMapper, two things would greatly help me:

  * Code showing a failing test
  * Description of the context for which you’re trying to use it

Context is **very** helpful for me in the overall design, as only failing tests show me contrived, Foo to FooDto scenarios.&#160; It helps if I understand at what place in your architecture you’re trying to use it, as it may not line up to how it was originally designed.&#160; But context tells me if there is a broader concept at play, and I can design (or not) for that category of usage.

Thanks again to everyone that has contributed, I’ve been consistently surprised by the number of feature requests that include a patch.&#160; To date, I’ve received around 25 patches from the community, far exceeding any expectations I had.