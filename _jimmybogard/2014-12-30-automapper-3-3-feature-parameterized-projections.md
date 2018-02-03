---
wordpress_id: 991
title: 'AutoMapper 3.3 feature: parameterized projections'
date: 2014-12-30T14:44:29+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=991
dsq_thread_id:
  - "3373634378"
categories:
  - AutoMapper
---
Back in AutoMapper 3.1, I added a feature to allow for runtime values to be used in mappings:

[gist id =76afda61ae5a9e7e1bde]

This worked great for runtime mappings, but wasn’t supported in the LINQ projections. These days, I’m pretty much solely using the LINQ projections in concert with some sort of data access object/ORM (ISession, DbContext, IDocumentSession etc.).

Allowing for runtime values in LINQ queries is fairly straightforward without AutoMapper – you can create a closure that gets captured in the resulting expression tree:

[gist id=3d32258891ff3e0c60c7]

The resulting closure “helper” class effectively allows for a parameterized query. So how might we accomplish this with AutoMapper? Our first thought might be to use the “MapFrom” method with the runtime value supplied:

[gist id=28090a005431a5a32cbd]

But the problem here is mapping definitions are static, defined once and reused throughout the lifetime of the application. Before 3.3, you would need to re-define the mapping on every request, with the hard-coded value. And since the mapping configuration is created in a separate location than our mapping execution, we need some way to introduce a runtime parameter in our configuration, then supply it during execution.

This is accomplished in two parts: the mapping definition where we create a runtime parameter, then at execution time when we supply it. To create the mapping definition with a runtime parameter, we “fake” a closure that includes a named local variable:

[gist id=f2e17ff2c10f7ef1c879]

We can’t access the “real” value we’d use during execution in our configuration, so we create a stand-in that still creates a closure for us. The underlying expression tree that gets built recognizes this external input and creates a placeholder parameter to be supplied at runtime. When executing the projection, we can supply our parameter value with either a dictionary or an anonymous object:

[gist id=ccae8c0917798e40e3c3]

When the projection is executed by the underlying LINQ provider, the correct runtime value is replaced in the expression, letting you use per-map runtime values in your projections. You can use these runtime values in any configuration option that works off an expression:

  * MapFrom
  * ConstructProjectionUsing

Very cool stuff!