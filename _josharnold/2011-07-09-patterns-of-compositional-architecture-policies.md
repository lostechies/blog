---
wordpress_id: 19
title: 'Patterns of Compositional Architecture: Policies'
date: 2011-07-09T22:50:03+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=19
dsq_thread_id:
  - "354136072"
categories:
  - general
tags:
  - architecture
  - composition
  - composition-patterns
  - design
  - fubumvc
  - Patterns
---
This is the first post in the Patterns of Compositional Architecture series that I mentioned in [my previous post](http://lostechies.com/josharnold/2011/07/09/patterns-of-compositional-architecture/).

## The Pattern

Define an algorithm that is interchangeable and selected at runtime.

## Overview

This is really just a specific application of the [Strategy pattern](http://www.dofactory.com/Patterns/PatternStrategy.aspx). The basic interface looks something like this:

Since these are designed to make decisions at runtime, typically you’ll want to provide context to the Matches and Execute methods via parameters.

## Pattern in Action

More often that not, this pattern is employed to allow default behavior to be overridden. So given our simple IPolicy interface from above, let’s assume we have a default implementation that we use: 

Since we have a default implementation, we want the consumption of our policies to work like this:

  * Use a custom policy if any match
  * Otherwise, fallback to the DefaultPolicy

Here’s an example consumer:



We can have any number of policies configured within the system. These policies then should be represented as a dependency of our consumer. We add these policies to the beginning of our internal collection and add our default to the end. This allows any custom policies to match before our default policy does.
  
<a name="real-world"></a>

## Real-World Example

So I’ve described the pattern and shown some examples. Now let’s wrap it all up with showing off an example of how we do this in FubuMVC.
  
<a name="urlpolicy"></a>

#### The Interface

[IUrlPolicy](https://github.com/DarthFubuMVC/fubumvc/blob/master/src/FubuMVC.Core/Registration/Conventions/IUrlPolicy.cs) &#8211; This interface is used to define routes for each ActionCall in your FubuMVC application.

Custom implementations of this interface can be applied through the [Routes property on your FubuRegistry](http://guides.fubumvc.com/configuring_actions_fuburegistry.html).

#### The Default Implementation

[UrlPolicy](https://github.com/DarthFubuMVC/fubumvc/blob/master/src/FubuMVC.Core/Registration/Conventions/UrlPolicy.cs) – This is the default implementation of IUrlPolicy. The DSL for defining routes actually dynamically configures this instance in the background. If no policies match for a particular ActionCall, then this is used.

#### The Consumer

[RouteDefinitionResolver](https://github.com/DarthFubuMVC/fubumvc/blob/master/src/FubuMVC.Core/Registration/Conventions/RouteDefinitionResolver.cs#L61) – The Apply method does something very similar to the consumer that I describe above. The difference here is just a matter of implementation.

## Wrapping it Up

Strategies have always helped accomplish the Open/Closed Principle. This particular use of strategies helps enable default functionality to reduce configuration but enable overrides to account for more complex scenarios.