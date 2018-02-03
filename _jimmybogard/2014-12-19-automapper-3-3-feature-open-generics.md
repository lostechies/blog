---
wordpress_id: 987
title: 'AutoMapper 3.3 feature: open generics'
date: 2014-12-19T23:10:15+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=987
dsq_thread_id:
  - "3341498360"
categories:
  - AutoMapper
---
One of the interesting features of AutoMapper 3.3 is the ability to map open generic types. Open generics are those that don’t supply type parameters, like:

[gist id=89004599f2666d5cb38e]

AutoMapper had some limited support for certain built-in open generics, but only the collection types. This changed in version 3.3, where you can now map any sort of open generic type:

[gist id=04e292aa55af6939b16a]

Instead of using the normal syntax of the generic CreateMap method, you need to use the overload that takes type objects. This is because C# only accepts closed generic types as type parameters. This also means you can use all the configuration available for you to do member-specific mappings, but can only do them by referencing as a string instead of an expression. Not a limitation per se, but just something to be aware of.

To use the open generic mapping configuration, you can execute the mapping against a closed type:

[gist id=73baa0daf2fc77210594]

Previously, I’d have to create maps for every closed type. With the 3.3 version, I can create map for the open type and AutoMapper can automatically figure out how to build a plan for the closed types from the open type configuration, including any customizations you’ve created.

Something that’s been asked for a while, but only recently have I figured out a clean way of implementing it. Interestingly enough, this feature is going to pave the way for programmatic, extensible conventions I’m targeting for 4.0.

Someday.