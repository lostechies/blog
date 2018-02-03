---
wordpress_id: 4686
title: Design Dithering
date: 2008-06-02T18:40:00+00:00
author: Colin Ramsay
layout: post
wordpress_guid: /blogs/colin_ramsay/archive/2008/06/02/design-dithering.aspx
categories:
  - practices pragmatism
---
When you break out of the &#8220;new programmer&#8221; mindset and begin thinking in terms of organisation, patterns, and good design, I think there&#8217;s a real danger of hitting a development wall. What actually is the correct way of implementing a shopping cart? Should you use a three or four tier application design? My outlook on this is pretty simple:

It doesn&#8217;t matter.

The [Domain Driven Design book](http://www.domaindrivendesign.org/books/index.html#DDD) teaches a lot of interesting stuff, some of which can contribute to a brain freeze. So many new concepts can mean that there are a lot of possible avenues of approach for any given problem. But in my eyes, one of the most valuable lessons that Eric Evans gives in that book is that refactoring is key. If I find myself struggling to adapt the right approach, I take the simplest route, safe in the knowledge that if I&#8217;ve done it wrong, my application will let me know, big time. If I&#8217;m following a loosely coupled design, no single refactoring should have a huge impact on the rest of the application.

So if you find that you&#8217;re struggling for a solution, take the simplest, quickest &#8211; even do a dirty hack! &#8211; and know that next week, if that decision comes back to bite you, you can just refactor it out.