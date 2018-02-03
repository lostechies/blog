---
wordpress_id: 352
title: AutoMapper 1.0 RC1 released
date: 2009-09-15T00:34:23+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/09/14/automapper-1-0-rc1-released.aspx
dsq_thread_id:
  - "264716305"
categories:
  - AutoMapper
---
It’s been quite a long journey with [AutoMapper](http://automapper.codeplex.com/), with the origins written just over a year ago now.&#160; I’ve focused on stability and performance since the 0.3.1 release back in May, and from here to the 1.0 release, I’ll just be doing bug fixes.&#160; I did work in quite a few new enhancements, but I’m waiting on bigger changes until after the 1.0 release.&#160; From the [CodePlex download site](http://automapper.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=32994):

### New Features

  * Added non-generic CreateMap overload 
  * Can specify custom mapping ordering for individual destination members 
  * Before/After map callbacks for custom pre/post processing 
  * Registration of custom pre- and postfixes on member type names (i.e. CustomerKey can map to Customer) 
  * Mapping from dictionaries to split out key-value pairs 
  * Basic support for IDataReader/IDataRecord 
  * Support for custom naming conventions 
  * Support for IListSource (for Entity Framework)

### Enhancements

  * AllowNullDestinationValues now defaults to "true" 
  * Mapping operations thread-safe 
  * Performance improvements for mapping pipeline, including late-bound expression trees and Lightweight Code Generation 
  * Allowing using the destination value for individual members 
  * Lots of internal refactoring around the mapping engine to support various IoC scenarios 
  * Assembly marked as CLS compliant 
  * Registering global and profile-specific aliases for names 
  * Support for custom destination type constructors 
  * Upgraded to latest LinFu release

### Bug Fixes

  * Validation errors on explicitly implemented interfaces 
  * Collections with null elements caused exceptions 
  * Readonly destination members were causing validation errors 
  * Removed null checking in custom value resolvers

Enjoy!!!