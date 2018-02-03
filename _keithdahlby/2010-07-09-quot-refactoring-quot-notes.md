---
wordpress_id: 4212
title: '&#8220;Refactoring&#8221; Notes'
date: 2010-07-09T04:10:00+00:00
author: Keith Dahlby
layout: post
wordpress_guid: /blogs/dahlbyk/archive/2010/07/09/quot-refactoring-quot-notes.aspx
dsq_thread_id:
  - "266640156"
categories:
  - Book Review
  - Refactoring
---
I&#8217;m not going to bother with a review of [Martin
   
Fowler](http://martinfowler.com/)&#8216;s [_Refactoring:
   
Improving the Design of Existing Code_](http://www.amazon.com/exec/obidos/ASIN/0201485672). It&#8217;s good enough that
  
its catalog, available in [expanded form online](http://www.refactoring.com/catalog/ "Refactorings in Alphabetical Order"),
   
now provides the definitive vocabulary shared by dozens of refactoring
  
tools across nearly every major development platform. Though I was
  
already familiar with the majority of the catalog, I thought it would be
   
worth reading the other chapters, the notes from which you will find
  
below with my additions indicated with _emphasis_. I&#8217;ve also
  
included thoughts on various entries in the catalog.

## Principles in Refactoring

  * 58: You don&#8217;t decide to refactor, you refactor because you want to
  
    do something else, and refactoring helps you do that other thing.
  * 62: Beck &#8211; Maintaining the current behavior of the system, how can
  
    you make your system more valuable, either by increasing its quality,
  
    or by reducing its cost. &hellip; Now you have a more valuable program because
   
    it has qualities that we will appreciate tomorrow. &hellip; There is a
  
    second, rarer refactoring game. Identify indirection that isn&#8217;t paying
  
    for itself and take it out.
  * 62: Problems with Refactoring 
      * Don&#8217;t know limitations
      * _Is refactoring because a tool tells you to a bad reason?_
  * 65: Modify your code ownership policies to smooth refactoring.
  * 66: **Code has to work before you refactor.**
  * Ward Cunningham: Unfinished refactoring = technical debt.
  * 68: You still think about potential changes, you still consider
  
    flexible solutions. But instead of implementing these flexible
  
    solutions, you ask yours, **&#8220;How difficult is it going to be to
  
    refactor a simple solution into the flexible solution?&#8221;** If, as
  
    happens most of the time, the answer is &#8220;pretty easy,&#8221; then you just
  
    implement the simple solution.
  * 70: Changes that improve performance usually make the program
  
    harder to work with.
  * If you optimize all code equally, you end up with 90 percent of the
    
    optimizations wasted, because you are optimizing code that isn&#8217;t run
  
    much.

## Bad Smells in Code

An expanded catalog of code smells is [available online](http://c2.com/cgi/wiki?CodeSmell "Code Smells on 
Software Development Wiki").

  1. Duplicate Code
  2. Long Method
  3. Large Class
  4. Long Parameter List
  5. Divergent Change 
      * One class that suffers many kinds of changes
  6. Shotgun Surgery 
      * One change that alters many classes
  7. Feature Envy
  8. Data Clumps
  9. Primitive Obsession
 10. Switch Statements
 11. Parallel Inheritance Hierarchies
 12. Lazy Class
 13. Speculative Generality
 14. Temporary Field
 15. Message Chains 
      * _a.k.a. Law of Demeter_
 16. Middle Man
 17. Inappropriate Intimacy 
      * Circular Reference => Change Bidirectional Association to
  
        Unidirectional
 18. Alternative Classes with Different Interfaces
 19. Incomplete Library Class 
      * Introduce Foreign Method => Extension Methods
 20. Data Class 
      * Favor setters and encapsulated collections
      * _Very OO-centric &#8211; FP would argue that immutable data
  
        classes are preferred_
      * Hide Method => Immutability
      * 87: &#8220;Data classes are like children. They are okay as a
  
        starting point, but to participate as a grownup object, they need
  
        to take some responsibility.&#8221;
 21. Refused Bequest 
      * Smell is stronger if the subclass is reusing behavior but does
   
        not want to support the interface of the superclass.
  
        (NotSupportedException)
      * Apply Replace Inheritance with Delegation
 22. Comments 
      * 88: When you feel the need to write a comment, first try to
  
        refactor the code so that any comment becomes superfluous.

## Building Tests

  * Tests should be fully automatic and self-checking.
  * Interesting that a distinction is drawn between unit and
  
    functional tests, but there&#8217;s no mention of integration tests as middle
  
    ground
  * 97: &#8220;When you gget a bug report, start by writing a unit test
  
    that exposes the bug.&#8221;</p> 
      * _This is my #1 use case for test-first_
  * 98: &#8220;The key is to test the areas that you are most worried
  
    about going wrong.&#8221;
  * 101: &#8220;Don&#8217;t let the fear that testing can&#8217;t catch all bugs stop
   
    you from writing the tests that will catch most bugs.&#8221;

If this is the first you&#8217;ve read of unit testing, check out a book
  
dedicated to the subject like [Pragmatic
    
Unit Testing](http://solutionizing.net/2010/05/17/review-pragmatic-unit-testing-in-c-with-nunit-2nd-edition/ "Review: Pragmatic Unit Testing  
In C# with NUnit (2nd Edition)").

## Catalog Notes

  * Composing Methods 
      * Replace Method with Method Object  
        _local variables =>
  
        method object fields to facilitate extracting methods_
  * Moving Features Between Objects 
      * Introduce Foreign Method = Extension Methods
      * Introduce Local Extension = Subclass or Proxy
  * Organizing Data 
      * Replace Data Value with Object  
         _replace primitive with a
   
        type that means something (decimal => Money)_
      * Replace Type Code with State/Strategy  
        _inheritance is
  
        often abused, but this is one of its best use cases_
  * Simplifying Conditional Expressions 
      * Introduce Null Object  
         _OO approach to avoiding null checks,
  
        also not to be abused_
  * Making Method Calls Simpler 
      * Separate Query from Modifier  
        _mutation and query operations
  
        don&#8217;t mix_
      * Replace Parameter with Method  
         _this rarely applies to
  
        new code, but rather is found in methods that have evolved over time_
      * Hide Method 
          * _Related:_ Remove from Interface &mdash; useful to let a method &#8220;hide
   
            in public&#8221; for easier testing without cluttering up its expected usage
  
            as implementer of an interface
      * Replace Error Code with Exception
  
        _if a circumstance is truly exceptional, exceptions are often better
  
        than error codes&#8230;_
      * Replace Exception with Test
  
        _&#8230;but if it&#8217;s not exceptional, don&#8217;t incur the overhead; for
  
        example, return a Null Object_
  * Dealing with Generalization 
      * Extract Subclass, Superclass and Interface
      * Collapse Hierarchy
      * Form Template Method
      * Replace Inheritance with Delegation
      * Replace Delegation with Inheritance

## Big Refactorings

  * 359: &#8220;Do as much as you need to achieve your real task. You can
   
    always come back tomorrow.&#8221;
  * 360: &#8220;You refactor not because it is fun but because there are
  
    things you expect to be able to do with your programs if you
  
    refactor that you can&#8217;t do if you don&#8217;t refactor.&#8221;</p> 
      * _I need to remember this!!_

These are hard to identify, but provide the biggest return on
  
investment. Think of them as high-level goals accomplished through
  
low-level changes from the above catalog.

  * Tease Apart Inheritance
  * Convert Procedural Design to Objects 
      * _Also,_ Convert to Functions
  * Separate Domain from Presentation 
      * _MVP, MVC, MVVM&#8230;use something!_
  * Extract Hierarchy