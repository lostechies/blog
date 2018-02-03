---
wordpress_id: 4104
title: 'FubuValidation: Have validation your way'
date: 2013-05-30T13:23:49+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=263
dsq_thread_id:
  - "1339188369"
categories:
  - general
---
I&#8217;m happy to announce that another member of the Fubu family of projects has been documented. The project of the day is: [FubuValidation](http://darthfubumvc.github.io/fubuvalidation/topics/). As usual, the docs go into far greater detail than I will here but I&#8217;ll provide some highlights.

**Overview**

FubuValidation is a member of the Fubu-family of frameworks &#8212; frameworks that aim to get out of your way by providing rich semantic models with powerful convention-driven operations. It aims to provide a convention-driven approach to validation while supporting more traditional approaches when needed.

> An important thing to note: FubuValidation is NOT coupled to FubuMVC. In fact, it maintains no references to the project.

**What&#8217;s different about it?**

Inspired by the modularity patterns used in the Fubu ecosystem (and previous work with validation), FubuValidation utilizes the concept of an &#8220;IValidationSource&#8221;. That is, a source of rules for any particular class.

Any number of IValidationSource implementations can be registered and they can pull rules anywhere from attributes to generating them on the fly. You can use the built-in attributes, DSL, or write your own mechanism for creating rules based on NHibernate/EF mappings. The docs have plenty of examples of each.

On top of the extensibility, FubuValidation was designed with diagnostics in mind. While they are currently only surfaced in FubuMVC, the data structures used to query and report on validation rules are defined in FubuValidation. At any point you can query the ValidationGraph and find out not only what rules apply to your class but WHY they apply.

**Read the docs**

Enough from me. [Checkout the new documentation](http://darthfubumvc.github.io/fubuvalidation/topics/) and let us know what you think.