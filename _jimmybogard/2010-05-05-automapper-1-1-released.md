---
wordpress_id: 407
title: AutoMapper 1.1 released
date: 2010-05-05T15:34:19+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/05/05/automapper-1-1-released.aspx
dsq_thread_id:
  - "266329476"
categories:
  - AutoMapper
---
Today I pushed out the [1.1 release of AutoMapper](http://automapper.codeplex.com/releases/view/44802).&#160; From the release notes:

### Features

  * Adding support for Silverlight 3.0 
  * Auto-implementing INotifyPropertyChanged 
  * Conditional member mapping 
  * Destination member prefixes, postfixes and naming transformers

### Enhancements

  * Nullable destination types more obvious 
  * Late binding configuration 
  * More members made public 
  * Support generic ICollection 
  * Enums match on value or name

### Bugs

  * Formatting null values 
  * Undefined enum values not getting mapped 
  * Configuration validation around missing members 
  * Profile resolution 
  * ForAllMembers skipped missing members 
  * Interface mapping overwritten 
  * Inheritance chain now evaluated by default

Head over to the [AutoMapper project site](http://automapper.codeplex.com/) to download the latest version.

The big change for 1.1 is that Silverlight 3.0 is now officially supported.&#160; I was able to support all of the features of regular AutoMapper, except for a few pieces that just don’t exist in Silverlight, such as IDataReader etc.&#160; Also, I moved the source to [GitHub](http://github.com/jbogard/AutoMapper) from Google Code, which has made my life much, much easier for dealing with new features, bugs, issues and releases.&#160; Enjoy!