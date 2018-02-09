---
wordpress_id: 842
title: Null collections/arrays from MVC model binding
date: 2013-11-07T14:24:13+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=842
dsq_thread_id:
  - "1944780814"
categories:
  - ASPNETMVC
---
I’m firmly in the camp of the Framework Design Guidelines guidance on collection properties and return values:

> DO NOT return null values from collection properties or from methods returning collections. Return an empty collection or an empty array instead

It just makes sense, right? Well, that’s not the default behavior in MVC. If you have a form something like:

{% gist 7355143 %}

You might expect to always have some value for that LineItems property, even if no LineItems were posted up. You would be disappointed. Instead, if there are no values found for anything in that collection, the property is null. That’s OK for primitives – I can expect default values or Nullable types to be null. For collections, I don’t want to worry about checking for null on every single item. Iterators and enumerable extension methods all blow up with nulls.

Instead, I’d rather these default to empty values. This is fairly easily done by augmenting the default model binder:

{% gist 7355190 %}

And configuring it to be the default model binder in our global.asax:

{% gist 7355207 %}

The model binder will overwrite these properties later on if those collections do have items. In fact, it’s one of the design goals of [AutoMapper](http://automapper.org/) – never allow null collections. With this code, we ensure that we never have to worry about null collections ever again on our view models, either generating them with AutoMapper or binding them with MVC.