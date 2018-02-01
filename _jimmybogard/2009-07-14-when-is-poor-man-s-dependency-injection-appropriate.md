---
id: 336
title: When is Poor Man’s Dependency Injection appropriate?
date: 2009-07-14T22:21:46+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/07/14/when-is-poor-man-s-dependency-injection-appropriate.aspx
dsq_thread_id:
  - "264716257"
categories:
  - Design
---
When is Poor Man’s Dependency Injection appropriate?

**Only in legacy code situations**.

That’s it.&#160; I was called out appropriately on forgetting this, but legacy code, where I have to apply dependency-breaking techniques, does not always afford the opportunity to apply Dependency Injection and IoC properly.

Perhaps another question would be – for what situation would it be appropriate to apply the Dependency Inversion Principle, but NOT DI and IoC?&#160; For me, just _one class_ implemented with PMDI is pain over using an IoC container.

If your application is so small that PMDI seems appropriate, then why bother at all?&#160; Why not use RAD tools, go for a Linq2Sql backend, and slap it all together in a controller action?&#160; If my app was so small that IoC is too much, there are LOT more optimizations I’d make towards that end.&#160; If my app was so small that it won’t change enough to need DIP, then who cares?&#160; I’m wasting the business’ money otherwise.

Also, I do not buy the legal argument.&#160; If you can only use Microsoft products, then use the Microsoft container, [Unity](http://www.codeplex.com/unity)!

Classes should be very clear on what they do, and what they require to function.&#160; If I see two constructors, one without arguments, this would imply the overloaded parameter-ful constructor contains _optional_ dependencies, not _required_ dependencies.