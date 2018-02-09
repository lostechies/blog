---
wordpress_id: 348
title: My favorite NHibernate exception
date: 2009-08-28T14:35:10+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/08/28/my-favorite-nhibernate-exception.aspx
dsq_thread_id:
  - "267667133"
categories:
  - 'C#'
redirect_from: "/blogs/jimmy_bogard/archive/2009/08/28/my-favorite-nhibernate-exception.aspx/"
---
We have a rather large, connected domain model, so we use quite a bit of lazy loading to deal with the richness all these connections provide.&#160; The one thing I would have liked C# to get from Java is “virtual by default”, if only for one selfish reason: so I don’t see this exception ever, ever again:

> #### _The following types may not be used as proxies:   
> Project.Domain.Model.Customer: method GetFavorites should be &#8216;public/protected virtual&#8217; or &#8216;protected internal virtual&#8217;_

I _always_ forget to mark members as virtual, and I still haven’t hunted down all of the templates and code snippets that spit out class members and fixed them.&#160; “Virtual by default” isn’t just about testability.&#160; It’s about the false assumption that we can predict exactly how end users want to use our API.