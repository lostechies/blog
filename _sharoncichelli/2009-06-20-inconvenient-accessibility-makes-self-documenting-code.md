---
id: 3856
title: Inconvenient Accessibility Makes Self-Documenting Code
date: 2009-06-20T12:11:00+00:00
author: Sharon Cichelli
layout: post
guid: /blogs/sharoncichelli/archive/2009/06/20/inconvenient-accessibility-makes-self-documenting-code.aspx
dsq_thread_id:
  - "311645159"
categories:
  - DDD
---
Intentional use of [access modifiers](http://msdn.microsoft.com/en-us/library/ms173121.aspx) (public, private, etc.) is like a clear memo to your team. This came up during [Steve Bohlen](http://unhandled-exceptions.com/blog/)&#8216;s [Virtual Alt.Net](http://www.virtualaltnet.com/) talk on [domain-driven design](http://en.wikipedia.org/wiki/Domain-driven_design).

Steve explained the distinction between Entity objects, which have a unique identity independent of their properties (Even when I change my name, I&#8217;m still me.), and Value objects, which are defined by their properties (If you change the house number in an address, you have a new address.). When dealing with Entities, code should not be able to change the unique id&mdash;that would be like someone claiming your social security number and thereby _becoming_ you. Therefore, Entity classes should have _private_ setters for their unique identifiers.

A meeting attendee asked why, since this gets inconvenient when you&#8217;re creating an object based on a record fetched from the persistence repository. It&#8217;s a big pain; why bother? The analogy I would offer is this. When you&#8217;re defining a class to represent an Entity in your business domain, you know it&#8217;s an Entity. You intend for it to behave and be treated like an Entity. You don&#8217;t want any of your teammates setting its unique id in their code. So you send them an email: &#8220;Don&#8217;t set Person.UniqueId, okay?&#8221; Uh hunh. How well is _that_ going to work over time?

Instead, if you simply don&#8217;t provide a public accessor to the UniqueId property, your teammates will get the message loud and clear. Granted, someone could edit the code and change the accessibility, but the fact that he or she needs to is a flashing neon sign saying &#8220;Stop. Think. Are you barking up the wrong tree?&#8221; You&#8217;ve made your code communicative. Its structure conveys your intent. No need for comments; this is an example of self-documenting code.