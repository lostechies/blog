---
wordpress_id: 509
title: Edge cases and impossibilities
date: 2011-08-10T12:53:40+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/08/10/edge-cases-and-impossibilities/
dsq_thread_id:
  - "382164815"
categories:
  - Design
---
When one nurtures a production system for a long period of time, new requirements or examinations of existing behavior typically start with a set of assumptions of how the existing system should behave. However, I’ve often found that my assumptions about how the system actually behaves, or did behave at some point or mostly wrong. Instead, when talking about a system’s behavior, we’re really talking about three things:

  1. How SHOULD the system behave?
  2. How DOES the system behave?
  3. How DID the system behave?

Three tenses there. The first drives outlines a set of assumptions of how we believe the system to work today. The second examines how the system actually behaves today. And because production systems are living systems and evolve over time, **we have to examine how the system behaved over time** given a set of constraints we want to impose.

One example is a system we have that includes a concept of a member account. We tell ourselves, the system SHOULD never allow duplicate email addresses (it’s a natural key identifying a record). When we look at the code, we see that for the most part, our system ensures no duplicates come in.

However, when we look at the data, the system DID allow duplicates. Out of millions of member accounts, there they were, a couple hundred duplicate emails. And when a system uses emails to triangulate external systems, that’s not good.

Driving down the reasons why this happened, it came down to **making assumptions about impossibilities instead of treating these scenarios like improbable, but possible, edge cases**. Once we found that we would actually consume messages from external systems that we all as humans agreed that WOULD never and SHOULD never happened, that didn’t mean that it wouldn’t happen in reality.

Edge cases in business rules need to be addressed, somehow. When we assume that business rules are enforced in other systems and accept information as already cleaned, we’re placing quite a lot of trust in that other system. Often, we’ll see users try things not knowing if it works or not, and when things “look” like they work, it becomes a new business process.

Instead, we should have written our system not to solve these edge cases, but to be able to reject or put them aside for further analysis. By silently assuming what the system SHOULD do and DOES do are the same, **we’re not deferring a decision, we’re simply punting and ignoring it**.

We can defer a resolution, but not a decision.