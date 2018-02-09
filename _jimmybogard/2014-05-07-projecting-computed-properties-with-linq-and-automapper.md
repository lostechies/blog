---
wordpress_id: 904
title: Projecting computed properties with LINQ and AutoMapper
date: 2014-05-07T17:06:39+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=904
dsq_thread_id:
  - "2667916510"
categories:
  - AutoMapper
---
Another from the “wicked awesome” category of AutoMapper. Other blogs about AutoMapper and LINQ:

  * [Efficient querying with LINQ, AutoMapper and Future queries](http://lostechies.com/jimmybogard/2014/03/11/efficient-querying-with-linq-automapper-and-future-queries/) 
      * [Using AutoMapper to prevent SELECT N+1 problems](http://lostechies.com/jimmybogard/2014/04/03/using-automapper-to-prevent-select-n1-problems/) 
          * [Using AutoMapper to perform LINQ aggregations](http://lostechies.com/jimmybogard/2014/04/08/using-automapper-to-perform-linq-aggregations/) </ul> 
        One current limitation of ORM LINQ projections in general is that it can’t project computed properties:
        
        {% gist d5382766981c264f46b6 %}
        
        If you try this using LINQ, you’ll get some error in your LINQ provider about not being able to use a computed property in an expression. Your options at this point are to duplicate the computed property on the destination type, to switch over to the regular Mapper.Map call, or modify your ORM such that the database column itself is defined as a computed column. All of these are fairly intrusive.
        
        But wait, all is not lost! What if we could peer inside the computed property, examine what it’s doing, and include that in our LINQ projection? That sounds hard, but luckily [someone](http://hazzik.ru/) has already figured it out in the [DelegateDecompiler](https://github.com/hazzik/DelegateDecompiler) project.
        
        So how might we put this together? First, we’ll reference the NuGet package for the DelegateDecompiler project
        
        > Install-Package DelegateDecompiler
        
        Next, let’s create an extension method for AutoMapper to make it easy to wrap our projection calls with the delegate decompilation:
        
        {% gist 0462e5b7474d1e80033a %}
        
        See that extra “Decompile” method? That’s modifying our existing expression tree that AutoMapper built and replacing computed properties with our own. Underneath the covers, it’s taking this LINQ expression:
        
        {% gist dccffce40add560b9817 %}
        
        And replacing it with this:
        
        {% gist fed5807b30d38f271ffe %}
        
        The only change to our models was to indicate to the delegate decompiler that this is a computed property. In our domain model, we decorate with the Computed attribute, and now everything works!
        
        {% gist d33241ab923959c8be7d %}
        
        Looking at the underlying SQL generated, since the LINQ provider can understand that LINQ expression, we’ll see something like:
        
        {% gist 5446e56e74bcef0c7f26 %}
        
        I can build computed properties on my domain model, project them automatically using AutoMapper, and have computed properties evaluated all the way down at the database tier with that opt-in “Computed” attribute.
        
        That, I think, is wicked awesome.