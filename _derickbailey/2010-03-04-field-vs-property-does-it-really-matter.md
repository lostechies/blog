---
wordpress_id: 107
title: 'Field Vs. Property: Does It Really Matter?'
date: 2010-03-04T20:27:47+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/03/04/field-vs-property-does-it-really-matter.aspx
dsq_thread_id:
  - "262068445"
categories:
  - .NET
  - Pragmatism
  - Principles and Patterns
  - Ruby
redirect_from: "/blogs/derickbailey/archive/2010/03/04/field-vs-property-does-it-really-matter.aspx/"
---
Given my recent experiences with Ruby, my cursory knowledge of Java, and my past experiences with other object oriented systems, I find myself asking a lot of questions about why we do things the way we do in the C#/.NET space. Today’s questioning is about one of those fundamental things that I have been preaching for a long time, yet suddenly find myself unable to answer ‘why’: 

> ### field vs property: does it really matter?

As I sit and think about in the back of my head while writing code or this post, I can’t really say that I have any good reason for saying “you should use a property instead of a field” other than the defacto answer of encapsulation. But what if encapsulation doesn’t matter when you just want to store and retrieve a simple piece of data? Why is oh so important to use a property as the public API for a class?

Ruby doesn’t really have properties. It just has methods that allow you to use an = sign, but those methods are not even required to “set” a value. It’s only the conventional use of = methods that say you should. Java doesn’t have properties at all. It’s convention to use getWhatever and setWhatever methods, but it’s better design to [not use mutators](http://codebetter.com/blogs/david_laribee/archive/2008/07/08/super-models-part-2-avoid-mutators.aspx) and I like the general reasons behind that.

So why does it matter if it’s a field vs. a property? Someone convince me that it’s important. Someone convince me that it’s not.&#160; Better yet – someone explain the contexts in which it is important and the contexts in which it’s not, and someone point out where it’s important to hide the data behind the process through a mutator-less API of service methods.

…

Question everything – especially your own assumptions.