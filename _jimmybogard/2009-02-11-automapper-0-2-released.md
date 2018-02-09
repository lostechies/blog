---
wordpress_id: 282
title: AutoMapper 0.2 released
date: 2009-02-11T23:10:18+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/02/11/automapper-0-2-released.aspx
dsq_thread_id:
  - "264716069"
categories:
  - AutoMapper
redirect_from: "/blogs/jimmy_bogard/archive/2009/02/11/automapper-0-2-released.aspx/"
---
With quite a few community patches submitted, I dropped [AutoMapper](http://www.codeplex.com/AutoMapper) [version 0.2](http://www.codeplex.com/AutoMapper/Release/ProjectReleases.aspx?ReleaseId=23119) today.&#160; Here’s the release notes:

Added:

  * Better mapping exceptions that capture current mapping context 
  * Custom instantiation expressions for value formatters 
  * Custom instantiation expressions for value resolvers 
  * Support for nullable types 
  * Support for better subclass resolution 
  * Custom member resolution can be any lambda expression 
  * Mapping enumerations by name/value 
  * Support for nullable enumerations 
  * Support for filling an existing object, instead of AutoMapper creating the destination object itself 
  * Support for enumerable target types, including: 
      * IEnumerable 
      * IEnumerable<T> 
      * ICollection 
      * ICollection<T> 
      * IList 
      * IList<T> 
      * List<T>

Fixed:

  * Destination properties with no setters are now ignored 
  * Assembly is now strong-named 

Naturally there is no documentation for any of this yet, but you can find full examples of all of these features in the source code’s unit tests.&#160; You can find the release over at the [CodePlex site](http://www.codeplex.com/AutoMapper/Release/ProjectReleases.aspx?ReleaseId=23119).