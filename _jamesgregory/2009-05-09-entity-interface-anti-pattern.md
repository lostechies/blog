---
wordpress_id: 4496
title: Entity interface anti-pattern
date: 2009-05-09T01:35:00+00:00
author: James Gregory
layout: post
wordpress_guid: /blogs/jagregory/archive/2009/05/09/entity-interface-anti-pattern.aspx
dsq_thread_id:
  - "273364812"
categories:
  - Design
  - ORM
  - things we all already knew
---
This has been discussed many times before on various mailing lists, and I&#8217;m sure there are blog posts about it that are eluding me currently, but I&#8217;ll put it out there anyway.

&nbsp;

<p style="padding-left: 30px">
  <span><span style="font-size: large">Interfaces on entities are an anti-pattern</span></span>
</p>

<p style="padding-left: 30px">
  <span style="font-size: x-small"><span style="background-color: #ffffff"><span style="color: #888888">(when they&#8217;re in the vein of ICustomer and Customer)</span></span></span>
</p>

&nbsp;

This smells of applying a rule a little too broadly. People are (rightly) being urged to program to abstractions, to decouple and explicitly reveal their dependencies. Programming to abstractions is nearly always a good thing, but rules are often accompanied by exceptions, and in this case it&#8217;s entities that are the exception.

Lets take a step back and remind ourselves why abstractions are useful, specifically programming to interfaces.

  1. It lets us program against a contract, rather than a concrete implementation
  2. We can design multiple implementations of an interface, without altering dependencies
  3. We can substitute implementations at will

Taking a typical service example, it&#8217;s much better for a TextWriter to depend on a IStream than it is to depend on a FileStream, because we could substitute the stream for a MemoryStream or a more high-level XmlStream without changing the design; if we didn&#8217;t have this abstraction we wouldn&#8217;t have the flexibility. A side-effect of this ability is greatly improved testability.

Back to entities. Here are some tell-tale signs that you&#8217;re might be implementing an anti-pattern:

  1. Your interface signature identical to your class
  2. There&#8217;s only one implementation of your interface
  3. Your entity has no behavior to abstract, yet you&#8217;ve created an abstraction anyway

### Signatures

A contract specifies what functionality an instance should provide. An implementation will rarely be of the same size (method count wise) as the contract because it will have additional code dedicated to how it provides the expected behavior. If the only thing your class does is exist purely to provide backing fields for your interface&#8217;s properties and methods, then it&#8217;s fairly redundant to have both the class and interface. It&#8217;s duplication for the sake of an abstraction that provides no benefits.

### Implementations

Excluding cases when you have an inheritance hierarchy mapped, you won&#8217;t have more than one implementor of an entity interface; you&#8217;ll simply have ICustomer and Customer, IProduct and Product. What&#8217;s the point in being able to substitute implementations when there&#8217;s guaranteed to only ever be one? Again, a redundant design when used with entities.

### Behavior

Abstraction is about allowing consumers of your object to use it without knowledge of the actual implementation. The behavior that an entity contains should mostly concern only itself (such as state changes, adding and removing children, etc&#8230;); this kind of behavior has no side-effects and can rarely vary in implementation, therefore entities don&#8217;t need abstractions.

What about testability? With changes only affecting itself, the entities themselves can be used in tests, so there&#8217;s no need to mock them.

### What&#8217;s a good example of interfaces on an entity?

Like any rule, there are exceptions; in this case it&#8217;s when your interface doesn&#8217;t fit the 3 rules mentioned above. Interfaces should be logical components that are combined to make a single unit; they can be used to contain sub-sections of behavior that are implemented by multiple entities. This design allows you to create services that depend on the specific piece of behavior, rather than an a whole entity, thus giving you a service that can be used with many entities (and ones that don&#8217;t exist yet) without changing the design. For example, given House, Car, and Wall classes, if each of these implemented an IPaintable interface, a service could instruct these entities to be painted without knowing (or caring) what kind of entity it was dealing with (specifically, without creating an overload for each entity type).

&nbsp;

Don&#8217;t apply rules blindly, understand what you&#8217;re doing and why you&#8217;re doing it.

File this one under things we all already knew.

&nbsp;

**Edit:** Updated the behavior section to be less&nbsp;controversial&nbsp;(and more correct!) and added the good example