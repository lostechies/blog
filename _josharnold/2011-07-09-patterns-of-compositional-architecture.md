---
wordpress_id: 18
title: Patterns of Compositional Architecture
date: 2011-07-09T21:01:13+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=18
dsq_thread_id:
  - "354134243"
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
## Introduction

[Chad Myer](https://lostechies.com/chadmyers)’s most [recent series of posts](https://lostechies.com/chadmyers/category/cool-stuff-in-fubu) have inspired me to start writing. A lot. My most recent focus and passion has been concentrated on the [Fubu Family](https://github.com/DarthFubuMVC) of frameworks. After doing some reflecting, I’ve begun to discover a common barrier of entry for new users of these projects – a missing link, if you will.

You see, there are patterns in play in the Fubu family that take advantage of static typing. These patterns promote highly compositional designs that make the most out of the language features found in C#. We’ve been focusing on documenting the capabilities of these frameworks but I believe that the missing link is the understanding of these patterns.

> Note:
  
> These &#8220;patterns&#8221; are not &#8220;formal patterns&#8221; that you would find in a book. I&#8217;m simply cataloging common approaches that we use.

## The Format

Each item will be presented with an overall description, a very basic example, and then I will describe how we use it in the Fubu Family of frameworks.

## Patterns of Compositional Architecture

In an effort to close this gap, this series will cover the patterns that we employ and how they’ve benefited us and the frameworks:

  1. [Policies – Compositional Strategies](https://lostechies.com/josharnold/2011/07/09/patterns-of-compositional-architecture-policies "Patterns of Compositional Architecture: Policies")
  2. [Domain-Specific-Languages](https://lostechies.com/josharnold/2011/07/11/patterns-of-compositional-architecture-domain-specific-languages/ "Domain Specific Languages") 
      1. [Semantic Models](https://lostechies.com/josharnold/2011/07/12/patterns-of-compositional-architecture-dsls-semantic-models/)
      2. [Registries](https://lostechies.com/josharnold/2011/07/12/patterns-of-compositional-architecture-dsls-registries/)
      3. [Conventions](https://lostechies.com/josharnold/2011/07/13/patterns-of-compositional-architecture-dsls-conventions/)
      4. [Wrap Up](https://lostechies.com/josharnold/2011/07/23/patterns-of-compositional-architecture-dsls-wrap-up/)
  3. Chain of Responsibility