---
wordpress_id: 3140
title: Testing MonoRail Filters
date: 2007-10-04T17:32:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2007/10/04/testing-monorail-filters.aspx
dsq_thread_id:
  - "268123688"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2007/10/04/testing-monorail-filters.aspx/"
---
I was trying to test an Authentication Filter today that needed to redirect the user to a login page.


  


The problem was that it used context.Controller.Url, context was a MockRailsEngineContext and the Url property throws a NotImplementedException. Ayende quickly jumped on the ball and resolved the problem! Dang that was fast.


  


If you need to do the same just grab the trunk and it now that property will return a value rather than an exception.


  


&nbsp;Thanks Ayende!