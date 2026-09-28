---
wordpress_id: 40
title: 'Patterns of Compositional Architecture: DSLs – Registries'
date: 2011-07-12T16:06:51+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=40
dsq_thread_id:
  - "356409263"
categories:
  - general
tags:
  - architecture
  - composition
  - composition-patterns
  - design
  - dsls
  - fubumvc
  - Patterns
---
This is the fourth post in the [Patterns of Compositional Architecture series](https://lostechies.com/josharnold/tag/composition-patterns/) that I mentioned in my [introductory post](https://lostechies.com/josharnold/2011/07/09/patterns-of-compositional-architecture/).

## Prerequisites

Before reading this post, please read the following posts:

  * [Domain Specific Languages Introduction](https://lostechies.com/josharnold/2011/07/11/patterns-of-compositional-architecture-domain-specific-languages/)
  * [Semantic Models](https://lostechies.com/josharnold/2011/07/12/patterns-of-compositional-architecture-dsls-semantic-models/)

## The Pattern

Define an entry point into a Domain Specific Language that is responsible for building up the Semantic Model.

## Overview

The implementation of this pattern is accomplished by providing a base class. Using the “language” is done by subclassing and calling statements from the constructor.

The base class is used to provide expressions that can be consumed by the subclasses. It’s also responsible for setting up the “defaults” so that only minimal use of the language is required.

## Pattern in Action

Let’s take a look at an example base class (Registry):



There are a few things to note here:

#### SemanticModel Build()

This is the common method signature found in a Registry. For our example, we used: StringifierModel BuildModel(). The consuming component (typically some form of bootstrapping mechanism) uses this method to retrieve the semantic model.

#### Default Constructor

The default constructor is used to call methods on itself to register default values. In our example, we’re registering our default stringifier.

#### IfRequestMatches

This is where we start utilizing Fluent Interfaces to empower our language. Let’s look at the method signature: ConfigureStringifierExpression IfRequestMatches(Func<StringifyRequest, bool> predicate)

Do you remember our IStringifier interface from my previous post?



Let’s make a flexible implementation of this:



And we’ll look at the configure expression:



The idea is that IfRequestMatches is an [ExpressionBuilder](http://martinfowler.com/dslCatalog/expressionBuilder.html) for configuring an instance of LambdaStringifier.

Just to wrap it up a little, let’s look at an example of a subclass of our registry:



## Real-World Example

You’ve seen the pattern with a primitive example. Let’s wrap it up by showing off an example of where we use it in FubuMVC.

#### The Registry

[FubuRegistry](https://github.com/DarthFubuMVC/fubumvc/blob/master/src/FubuMVC.Core/FubuRegistry.cs). We have split this up into multiple pieces but this is your entry point into the language of FubuMVC and is responsible for building up the [BehaviorGraph](https://github.com/DarthFubuMVC/fubumvc/blob/master/src/FubuMVC.Core/Registration/BehaviorGraph.cs).