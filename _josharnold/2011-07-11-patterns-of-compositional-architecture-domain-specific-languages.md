---
wordpress_id: 28
title: 'Patterns of Compositional Architecture: Domain Specific Languages'
date: 2011-07-11T04:48:16+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=28
dsq_thread_id:
  - "354963763"
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
This is the second post in the [Patterns of Compositional Architecture series](http://lostechies.com/josharnold/tag/composition-patterns/) that I mentioned in my [introductory post](http://lostechies.com/josharnold/2011/07/09/patterns-of-compositional-architecture/).

## Introduction

It’s important to note two things before I begin with this section: 1) I will not do the problem space of DSLs justice and 2) this is key to understanding how FubuMVC actually works. So, now that I’ve set myself up for success, let me see what I can do.

Through the course of this [mini-series](http://lostechies.com/josharnold/tag/dsls/ "mini-series") on Domain Specific Languages (DSLs), I will be focusing on Internal DSLs. More specifically, I will discuss patterns used for implementing these concepts in C#.

> Note:
  
> For further reading, I recommend Martin Fowler’s [Domain Specific Languages book](http://martinfowler.com/books.html#dsl).

## The Pattern

Define a programming API as a language with rich semantics, language features, and convention-driven operations.

## Overview

This pattern is broken down into patterns of DSLs to accomplish our goal. Given the definition of this particular pattern, let’s break it down a little further:

  1. [Semantic Models – The result of parsing the language](http://lostechies.com/josharnold/2011/07/12/patterns-of-compositional-architecture-dsls-semantic-models/)
  2. [Registries – The primary entry point into the language](http://lostechies.com/josharnold/2011/07/12/patterns-of-compositional-architecture-dsls-registries/)
  3. [Conventions – Operations executed on the Semantic Model](http://lostechies.com/josharnold/2011/07/13/patterns-of-compositional-architecture-dsls-conventions/)
  4. [Wrapping it Up](http://lostechies.com/josharnold/2011/07/23/patterns-of-compositional-architecture-dsls-wrap-up/ "Wrapping it Up")

Each of these concepts deserve their own post so that I can properly address each one. I will write a wrap up post afterwards to tie this all together.