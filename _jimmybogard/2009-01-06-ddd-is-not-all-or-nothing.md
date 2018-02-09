---
wordpress_id: 270
title: DDD is not all-or-nothing
date: 2009-01-06T02:33:38+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/01/05/ddd-is-not-all-or-nothing.aspx
dsq_thread_id:
  - "264716028"
categories:
  - DomainDrivenDesign
redirect_from: "/blogs/jimmy_bogard/archive/2009/01/05/ddd-is-not-all-or-nothing.aspx/"
---
The Domain-Driven Design book (or, the Blue Bible), is chock-full of patterns.&#160; Software patterns, team patterns, integration patterns and so on.&#160; As a consequence, many readers might assume that DDD requires these patterns, that you must apply these patterns, and not following these patterns means that you’re doing DDD.

But DDD is an architectural style, not a blueprint for building applications nor a pattern cookbook.&#160; Because DDD is an architectural style, we can’t make any of the following assumptions when applying DDD:

  * Implementing certain patterns implies we’re applying DDD
  * Applying DDD means we implement certain patterns

One question Rob Conery asked me during a conversation on DDD was, “How do I recognize an application built with DDD?”&#160; We’ve already noted that you can’t look towards a set of patterns, so how do we recognize one?&#160; **A DDD application is one whose design is driven by the domain**, hence “Domain-Driven Design”.

If I look at a clean domain model, well-factored with explicit responsibilities, I as a lay person could make no judgment on whether the application followed DDD or not.&#160; If however, I talked to the domain experts, learned about their domain, learned how the domain knowledge was distilled, I would then go back and look at the application to find if it models the domain.&#160; If the development team calls a concept an “OrderForm” and the domain experts call the concept a “ShoppingCart”, then immediately we see an impedance mismatch.&#160; The team is not sharing the same model language with the domain experts, losing the benefits of a Ubiquitous Language.&#160; They are likely not following DDD.

Another tactic to recognizing DDD is have both the domain experts and team explain the domain.&#160; Counting the number of clarifications and special cases, “well, except, but” and “we” versus “they” provides a good indication that the domain experts and team are not on the same page.

The patterns laid out in the DDD book are a guide to help achieve the true goal of DDD: **a shared model expressed as software**.&#160; Concepts like Entities, Repositories and others are in place to reinforce the architectural style of DDD by defining explicit responsibilities of recurring patterns.&#160; Like other pattern languages, the DDD book creates a common Ubiquitous Language for practitioners of DDD, both lowering the barrier to entry and creating a basis for comparing notes between disparate teams and developer communities.

DDD is certainly easier to implement with the patterns described in the DDD book, but they are not required.&#160; We can use the Active Record pattern and follow DDD.&#160; We can use the Entity Framework or LINQ to SQL and follow DDD.&#160; We can use hand-rolled ADO.NET, constrained to a 5-year-old legacy application, and follow DDD.&#160; We can eschew Services for eventing, and follow DDD.

DDD is an architectural style that encourages model-driven design and a domain-driven model.&#160; Following this style is following DDD, and merely implementing patterns only indicates that we can implement patterns.