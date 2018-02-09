---
wordpress_id: 301
title: AutoMapper 0.3 Beta released
date: 2009-04-05T02:03:15+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/04/04/automapper-0-3-beta-released.aspx
dsq_thread_id:
  - "267050675"
categories:
  - AutoMapper
redirect_from: "/blogs/jimmy_bogard/archive/2009/04/04/automapper-0-3-beta-released.aspx/"
---
Today, I dropped [AutoMapper](http://automapper.codeplex.com/) [0.3 Beta](http://automapper.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=25697).&#160; From the release notes:

### New Features 

  * **Mapping to interfaces** 
      * Do not need any implementation configured 
      * Implementation is created at runtime using proxies 
  * **Dynamic mapping** 
      * Do not need to configure source/destination type 
      * Used with Mapper.DynamicMap 
      * Checks configuration before executing the map 
      * Allows mapping from anonymous types source 
  * Mapping to fields on the destination type 
  * Configuring null destination objects behavior 
  * Mapping to IDictionary<,> 
  * Configuring global constructors for IValueFormatters, IValueResolvers, and ITypeConverters 
      * Common use is to substitute an IoC container 

### Enhancements 

  * Configuration validation does a dry run, includes array element type checking 
  * Better configuration exception messages 
  * Better mapping exception messages, gives resolution context hierarchy 
  * Mapping to camelCase members 
  * Custom top-level type converters with ITypeConverter<TSource, TDestination> 

### Bugs Fixed 

  * Configuration validation did not respect ignored destination members 
  * Support for international characters in member names 

### Thanks 

Thanks to the following peeps that sent in patches or made contributions otherwise:   
jordanterrell, Jeffrey Palermo, hallgrim.flatland, smh, pacoaw

This release was a lot of fun, as I got to play with dynamic proxies, and cleaned up quite a bit of the semantic model.&#160; As a reminder, you can always check out the samples or the unit tests in the trunk for specific examples on how to use all the features.&#160; Enjoy!