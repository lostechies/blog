---
id: 4098
title: 'Patterns of Compositional Architecture: DSLs &#8211; Wrap Up'
date: 2011-07-23T07:35:07+00:00
author: Josh Arnold
layout: post
guid: http://lostechies.com/josharnold/?p=52
dsq_thread_id:
  - "366019145"
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
This is the fifth post in the [Patterns of Compositional Architecture series](http://lostechies.com/josharnold/tag/composition-patterns/) that I mentioned in my [introductory post](http://lostechies.com/josharnold/2011/07/09/patterns-of-compositional-architecture/).

## Prerequisites

Before reading this post, please read the following posts:

  * [Domain Specific Languages Introduction](http://lostechies.com/josharnold/2011/07/11/patterns-of-compositional-architecture-domain-specific-languages/)
  * [Semantic Models](http://lostechies.com/josharnold/2011/07/12/patterns-of-compositional-architecture-dsls-semantic-models/)
  * [Registries](http://lostechies.com/josharnold/2011/07/12/patterns-of-compositional-architecture-dsls-registries/)
  * [Conventions](http://lostechies.com/josharnold/2011/07/13/patterns-of-compositional-architecture-dsls-conventions/)

## Wrapping it Up

I’ve touched on quite a few concepts in this mini-series. Let me see if I can’t try to wrap it up with a quick summary:

1. Semantic Models are used to model many things but in our examples we use it to model the configuration of an entire application.

2. These Semantic Models are built up through use of Registries by subclassing off of our primary Registry.

3. Registries can allow for ultimate flexibility by allowing programmatic access to the semantic model by way of conventions. These conventions can be used for a variety of things – including the actual build up of the model using internal conventions.