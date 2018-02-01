---
id: 353
title: The case for two-way mapping in AutoMapper
date: 2009-09-18T01:33:17+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/09/17/the-case-for-two-way-mapping-in-automapper.aspx
dsq_thread_id:
  - "265042450"
categories:
  - AutoMapper
---
I’m getting more and more requests around the area of two-way mapping, meaning you’d do something like:

Product –> ProductDTO

ProductDTO –> Product

Product being an entity, I can’t for the life of me understand why I’d want to dump a DTO straight back in to a model object.&#160; To get some understanding of how we use AutoMapper, we have:

  * 1500 individual mapping definitions
  * 75 custom value resolvers
  * 38 custom value formatters
  * 5 individual profiles

So what are we using AutoMapper for?&#160; Our five profiles include:

  * From Domain to ViewModel (strongly-typed view models for MVC)
  * From Domain to EditModel (strongly-typed view models for forms in MVC)
  * From EditModel to CommandMessages – going from the loosely-typed EditModel to strongly-typed, broken out messages.&#160; A single EditModel might generate a half-dozen messages.
  * From Domain to ReportModel – strongly-typed Telerik reports
  * From Domain to EDI Model – flattened models used to generate EDI reports

There is no two-way mapping because we never need two-way mapping.&#160; There was a point very early on where we were at a critical junction, and could decide to do two-way mapping.&#160; **But we didn’t**.&#160; Why?&#160; Because then our mapping layer would influence our domain model.&#160; I strongly believe in POCOs, and a very writeable domain model meant that POCOs were out.&#160; What exactly would two-way mapping do to our domain layer?

  * Force mutable, public collection , like “public EntitySet<Category> Categories { get; }” <- NO.
  * Make testing much, much harder, as we only ever wanted to update a portion of a domain model
  * Force our domain model to be mutable everywhere

So my question to those wanting two-way mapping:

  * What scenarios are you looking at doing two-way mapping?
  * What impact would two-way mapping have on the originating source type?
  * How would you test two-way mappings?

I think using AutoMapper because you don’t want to use the “=” operator is a bit lazy.&#160; Instead, we use it to flatten and reshape, optimizing for the destination type’s environment.&#160; Remember, my original motivation for AutoMapper was:

  * Enable protecting the domain layer from other layers by mapping to DTOs
  * Enable easy testing of the mappings, which would otherwise prevent us from creating the mapping in the first place

So…why two-way mapping?