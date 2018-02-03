---
wordpress_id: 283
title: Language feature parity and the polyglot programmer
date: 2009-02-15T21:36:10+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/02/15/language-feature-parity-and-the-polyglot-programmer.aspx
dsq_thread_id:
  - "264716059"
categories:
  - Misc
---
For the average .NET developer, language features in the other .NET language don’t matter 99% of the time.&#160; Unless of course, you’re using a framework designed for features that don’t exist for the language you’re using.

Such is the plight for a Visual Basic.NET developer.

Major “ALT.NET” frameworks simply weren’t designed with VB.NET in mind.&#160; This makes sense, as they are designed and used primarily in C#.&#160; For example, Rhino Mocks makes extensive use of delegates and expressions as method parameters.&#160; VB9 only supports single-line function lambdas, which are anonymous functions that return a value.&#160; VB.NET makes a clear distinction between functions that return a value, with the Function keyword, and functions that _don’t_ return a value, with the Sub keyword.

Basically, the Action family of delegates is severely limited in VB9.

This can make it especially difficult for OSS and other framework developers.&#160; If you’re trying to build an OSS or any other framework for public consumption, do you include both major .NET languages, or target features just for one, usually C#?

I’m leaving out the question for earlier versions of languages, as VS 2008 allows you to target a framework on a project-by-project basis, so any question of “I’m only on C# 2.0” rather moot.

However, looking at the feature specs for VB10, **all of these issues have simply disappeared**.&#160; With VB10 and C# 4.0, each language team is embracing “co-evolution” going forward, where a major feature added to one language will be added to the other.&#160; In a nutshell, VB10 will include most of the common C# 3.0 features, including:

  * Auto-implemented properties
  * Single and multi-line anonymous Subs and Functions (i.e., any lambda under the sun)
  * Collection initializers

For framework developers, the introduction of VB10 and C# 4.0 mean that the differences between the languages no longer matter.&#160; If you want to build a fluent interface with extension methods, method chaining and nested closures, you no longer need to worry about leaving VB developers behind.

### The future polyglot

The polyglot programmer would no longer include the “VB vs. C#” distinction after the VS 2010 release.&#160; Instead, we’ll see a clearer focus on broader language features, such as:

  * Static vs. dynamic
  * Functional vs. ???
  * Scripted vs. compiled

An average web developer today needs to know at least 4 different programming languages:

  * Server language (C# or VB.NET for average ASP.NET development)
  * HTML
  * CSS
  * JavaScript

JavaScript, widely used, is so completely different than C#, yet its syntax is similar, that many of the familiar operations you might like to use in JavaScript (such as the “new” operator), are strongly discouraged.&#160; I see the future of development to shift strongly towards a polyglot world, where we’ll use specific languages in circumstances where each language shines, while some languages grow to incorporate more and more features from other worlds.

But what we _won’t_ need to worry about is the difference between the two dominant languages in .NET.