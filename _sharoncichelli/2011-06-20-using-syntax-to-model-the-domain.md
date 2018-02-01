---
id: 3870
title: Using Syntax to Model the Domain
date: 2011-06-20T18:26:18+00:00
author: Sharon Cichelli
layout: post
guid: http://lostechies.com/sharoncichelli/?p=42
dsq_thread_id:
  - "337742198"
categories:
  - DDD
---
I&#8217;m fascinated by the small syntactic decisions that bring code closer to representing the business domain. Never mind the class inheritance examples from text books (&#8220;Dog IS-A Pet,&#8221; which has nearly never been relevant), I mean using properties, methods, and constructors to let the compiler ensure your objects stay in a valid state. Linguistically, I think this is neat.

## Not everything deserves a setter

Consider my Bacon class with an IsCooked property:

<pre class="brush:csharp">public class Bacon
{
  public bool IsCooked { get; set; }
}
</pre>

To cook some bacon, I set IsCooked to true. Sure. But what if I set it to false? I just defied physics and the space-time continuum. Shucks.

IsCooked should be read-only, and I need a different way to change it in a one-way transition: I need a method. Bacon comes into my domain uncooked, so I&#8217;ll set that property in its constructor.

<pre class="brush:csharp">public class Bacon
{
  public bool IsCooked { get; private set; }

  public Bacon()
  {
    IsCooked = false;
  }

  public void Cook()
  {
    IsCooked = true;
  }
}
</pre>

The sanctity of thermodynamics is preserved. When the transitions get more interesting than a simple Boolean, you&#8217;re looking at a [state machine](http://en.wikipedia.org/wiki/Finite-state_machine).

## Polywhatism?

I encountered this example in the wild, but I&#8217;ve changed the domain to protect the innocent.

We&#8217;re exploring a dungeon, and in our inventory we have items that affect our health:

  * amulets add a small amount to our health each day;
  * granola bars give us a lump-sum boost to our health the moment we eat them; and
  * cursed rings sap away our health each day until the curse runs out. (Why keep a cursed ring? How else would you command your army of winged monkeys?)

Here&#8217;s a display of our inventory:

| Item                     | Daily Boost | Total Remaining |
| ------------------------ | ----------- | --------------- |
| Obsidian amulet          | 150         | &nbsp;          |
| Luck ring                | (25)        | 375             |
| Jasper amulet            | 253         | &nbsp;          |
| Granola of righteousness | &nbsp;      | 400             |

This was implemented as a collection of IHealthItem objects. Here&#8217;s what I found:

<pre class="brush:csharp">public class Amulet : IHealthItem
{
  public int? DailyBoost { get; set; }

  public int? Total
  {
    get
    {
      return null;
    }
    set
    {
      throw new NotSupportedException(
           "Amulets do not have a total");
    }
  }
}
</pre>

As if the cursed rings weren&#8217;t bad enough, now there are properties we&#8217;re not allowed to call, lurking, waiting to pounce on us with a run-time exception. The calling code, when working with an IHealthItem instance, is forced to make an &#8220;Is&#8221; check to determine the type, in order to know which properties are safe to use. Half the properties aren&#8217;t relevant half the time. The DailyBoost property on CursedRing has an additional problem: Should you set it to a negative number, or assume it should be stored as an absolute value and multiplied by -1 when being used and displayed? The IHealthItem interface does not provide any abstraction.

In fact, these are _not_ three variations of the same thing. The only quality they have in common is the user&#8217;s desire to see them displayed in a table. (Further proof that they weren&#8217;t related, in the real application, that table was labeled &#8220;Amulets/Granola Bars/Cursed Rings.&#8221;) These concepts should have been modeled as three independent entities, keeping it unambiguous in the business layer how to use them to increment and decrement the adventurer&#8217;s health. Only at the presentation (UI) layer, they could be projected into a display-only DTO (Data Transfer Object) or [view model](http://lostechies.com/jimmybogard/2009/06/30/how-we-do-mvc-view-models/), using strings for all three properties.

## Don&#8217;t let me be uninitialized

If a property must be set for an object to be in a valid state, the class&#8217;s constructor should require that value as an argument instead. That way, it&#8217;s impossible to construct the object without also putting it into a valid state.

If a method, MethodB(), uses a private field and relies on another method, MethodA(), to be called first to set it, MethodB should take that value as a parameter instead. That way, MethodB can be called only after the result of MethodA has been determined; the correct order in which to call them is unambiguous.

These types of temporal coupling are illustrated nicely with examples and remedies on Mark Seemann&#8217;s blog in &#8220;[Design Smell: Temporal Coupling](http://blog.ploeh.dk/2011/05/24/DesignSmellTemporalCoupling.aspx).&#8221; (He has a whole [series on encapsulation](http://blog.ploeh.dk/2011/05/24/PokayokeDesignFromSmellToFragrance.aspx).)

## Too, meaning drives syntax

When I find myself compelled to _explain_ in comments, to write instructions (&#8220;make sure you set this before you call that&#8221;) in the xml summary, to incorporate usage notes into method names, I pounce on that as a candidate for refactoring. Finicky methods and classes that require secret knowledge to use correctly are invitations for bugs. It&#8217;s like when I&#8217;m editing the rules for one of Jon&#8217;s games: every instance of the word &#8220;except&#8221; must justify its existence. Every special-case exception immediately draws my attention as a spot where the rules could be improved and streamlined. Similarly, when coding, certain behaviors draw my attention as opportunities for improvement. Hyper-explainy documentation is a big one.

Semantics is the study of meaning, and syntax is the study of structure. That distinction makes them sound like separate domains, but the two interpretations of &#8220;foreign car mechanic&#8221; stem from _syntactic_ ambiguity. Each word still carries the same meaning, but in one case &#8220;foreign&#8221; modifies &#8220;car,&#8221; and in the other, &#8220;foreign&#8221; modifies &#8220;mechanic.&#8221; Syntax in natural languages certainly influences meaning, so why not in code, as well?