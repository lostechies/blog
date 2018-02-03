---
wordpress_id: 388
title: AutoMapper 1.0 RTW
date: 2010-02-01T22:44:31+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/02/01/automapper-1-0-rtw.aspx
dsq_thread_id:
  - "264977440"
categories:
  - AutoMapper
---
[AutoMapper](http://automapper.codeplex.com/) is now officially 1.0.&#160; You can go grab the latest binaries here:

[AutoMapper 1.0 RTW](http://automapper.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=39791)

Here are the release notes:

### New Features

  * Changing the null substitute method name and allow any type of null substitute 
  * Consolidating custom constructor configuration to just one 
  * Adding UseValue option for member mappings when you want to just map from a single custom value 
  * Added ValueFormatter<T>

### Enhancements

  * Adding custom mapping action objects (in addition to just functions) 
  * Removing configuration validation from dynamic mapping 
  * Adding overloads for mapping to existing objects for dynamic mapping 
  * Modified ITypeConverter to only use ResolutionContext as the input 
  * Added TypeConverter to ease generic scenarios 
  * Custom value resolvers now have access to the current resolution context 
  * Switching the MapFrom from using Expression to just Func, but with the return type retained 
  * Some performance improvements around caching and sealing (only for Initialize scenarios) 
  * Fixed profiles so you don&#8217;t have to provide a name (defaults to type name)

### Bugs Fixed

  * Fixed bug where a zero-length sequence would throw an exception 
  * Applying patch to fix duplicate CreateMap call issue 
  * Fixing bug where type map resolution did not attempt to find a map for the underlying member type 
  * Fixed bug where destination collections were not cleared before mapping 
  * Integrating patch to fix ambiguous match exceptions on multiple IEnumerable implementors 
  * Fixed bug where read-only string destination properties had to be marked as ignored 
  * Applied patch to fix issue where the DataReader mapper blew up on nullable fields 
  * Fixing bug where a bi-directional relationship with an array was messing up 
  * Fixed bug where type-specific formatters were not found correctly at the global level

I tried to get all the documentation done…and failed.&#160; Instead, I’m building up a comprehensive set of examples first.&#160; So what’s up for the next release?&#160; Here’s my current plan of action:

  1. Move source to github – DVCS better suited for OSS anyway
  2. Get build/deployment/TeamCity.CodeBetter migrated to github
  3. Add in patches for SL 3.0, CF and Mono (and integrate into the build)
  4. Look at v.next

And as always, if you have any questions, feel free to post them up on StackOverflow or put them on the [mailing list](http://groups.google.com/group/automapper-users/).&#160; The mailing list shows up in my inbox, while the SO posts show up in my feed reader, so I may not personally answer SO posts right away (but others tend to first).&#160; Enjoy!