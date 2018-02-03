---
wordpress_id: 46
title: 'Patterns of Compositional Architecture: DSLs &#8211; Conventions'
date: 2011-07-13T06:08:10+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=46
dsq_thread_id:
  - "356963467"
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
This is the fourth post in the [Patterns of Compositional Architecture series](http://lostechies.com/josharnold/tag/composition-patterns/) that I mentioned in my [introductory post](http://lostechies.com/josharnold/2011/07/09/patterns-of-compositional-architecture/).

#### Prerequisites

Before reading this post, please read the following posts:

  * [Domain Specific Languages Introduction](http://lostechies.com/josharnold/2011/07/11/patterns-of-compositional-architecture-domain-specific-languages/)
  * [Semantic Models](http://lostechies.com/josharnold/2011/07/12/patterns-of-compositional-architecture-dsls-semantic-models/)
  * [Registries](http://lostechies.com/josharnold/2011/07/12/patterns-of-compositional-architecture-dsls-registries/)

## The Pattern

Provide an ability to modify the underlying semantic model.

## Overview

The implementation of this pattern is actually quite simple if you have a true semantic model. The interface looks something like this:



## Pattern in Action

Our sample is simplistic so we don’t have a lot going on during the build up of our model. The most common applications of DSL patterns will have the Build method create a new instance of the model and then systematically apply conventions.

Since the creation and initialization is often order-sensitive, conventions are used to allow users of your DSL to apply changes to the model after it has been created and initialized with baseline data.

Let’s revisit our Stringifier example and modify the StringifierRegistry to leverage conventions:



During the construction of the model (although trivial in this example), we run through and execute each convention. Now, just for sake of examples, let’s write a sample convention:



I should note that one of the benefits of conventions is the modularity of your opinions. They can be broken out into reusable pieces that get applied to your projects and help structure your work.

## Real-World Example

You’ve seen the pattern with a primitive example. Let’s wrap it up by showing off an example of where we use it in FubuMVC.

#### The Convention

[IConfigurationAction](https://github.com/DarthFubuMVC/fubumvc/blob/master/src/FubuMVC.Core/Registration/IConfigurationAction.cs). This is the interface used by the [FubuRegistry](https://github.com/DarthFubuMVC/fubumvc/blob/master/src/FubuMVC.Core/FubuRegistry.cs) to register conventions that operate on FubuMVC’s semantic model: the [BehaviorGraph](https://github.com/DarthFubuMVC/fubumvc/blob/master/src/FubuMVC.Core/Registration/BehaviorGraph.cs).

#### The Registry

[FubuRegistry.BuildGraph()](https://github.com/DarthFubuMVC/fubumvc/blob/master/src/FubuMVC.Core/FubuRegistry.cs#L138). This method makes use of a simple extension method on IList<IConfigurationAction> to avoid a DRY violation of looping through multiple collections of conventions and applying them to the behavior graph.

Almost all of the core configuration of the behavior graph is done through internal conventions. Since order matters, there are multiple collections of conventions that are exposed through the language (conventions and policies), and others used for internal use (explicits and system policies).