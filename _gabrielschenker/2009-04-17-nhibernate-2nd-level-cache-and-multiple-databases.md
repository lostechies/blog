---
wordpress_id: 21
title: NHibernate 2nd level cache and multiple databases
date: 2009-04-17T00:56:59+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2009/04/17/nhibernate-2nd-level-cache-and-multiple-databases.aspx
dsq_thread_id:
  - "263908853"
categories:
  - NHibernate
---
Today we had an issue with our system. The application was showing unexpected behavior when different people where working with different databases. The application is a **Silverlight** based application. What we found out was that although the application was using different **NHibernate** session factories all of these factories used the same _2nd level cache_. That was a total surprise to us since the documentation of **NHibernate** clearly states that the _2nd level cache_ is tied to a _session factory_.

A quick chat with [Fabio Maulo](http://fabiomaulo.blogspot.com/) brought light into the dark. **NHibernate** indeed assigns a different 2nd level cache instance to each session factory. But it depends on the 2nd level cache provider what happens in reality!

In our application we use the **ASP.NET** cache (**NHibernate.Caches.SysCache**). The provider for this cache is part of the **NHibernate** [contributions](https://nhcontrib.svn.sourceforge.net/svnroot/nhcontrib/trunk/). A quick analysis of the code showed that the provider does NOT automatically differentiate how the content is stored in the cache when originating from or targeting different databases (that is different session factories).

Fortunately we quickly found a solution by using an undocumented configuration property called “**regionPrefix**”. We now just configure each of our session factories with a different **regionPrefix** and as a result the 2nd level cache is working as expected.

We use a function similar to this to get the necessary properties needed by the **NHibernate** configuration to build a session factory. Each factory has a distinct region prefix and connection string.

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">private</span> <span style="color: #0000ff">static</span> IDictionary&lt;<span style="color: #0000ff">string</span>, <span style="color: #0000ff">string</span>&gt; GetNHConfigProperties(<span style="color: #0000ff">string</span> regionPrefix, <span style="color: #0000ff">string</span> connectionString)</pre>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <pre><span style="color: #606060">   3:</span>     IDictionary&lt;<span style="color: #0000ff">string</span>, <span style="color: #0000ff">string</span>&gt; props = <span style="color: #0000ff">new</span> Dictionary&lt;<span style="color: #0000ff">string</span>, <span style="color: #0000ff">string</span>&gt;();</pre>
    
    <pre><span style="color: #606060">   4:</span>&#160; </pre>
    
    <pre><span style="color: #606060">   5:</span>     props.Add(<span style="color: #006080">"connection.connection_string"</span>, connectionString);</pre>
    
    <pre><span style="color: #606060">   6:</span>     props.Add(<span style="color: #006080">"connection.provider"</span>, <span style="color: #006080">"NHibernate.Connection.DriverConnectionProvider"</span>);</pre>
    
    <pre><span style="color: #606060">   7:</span>     props.Add(<span style="color: #006080">"dialect"</span>, <span style="color: #006080">"NHibernate.Dialect.MsSql2005Dialect"</span>);</pre>
    
    <pre><span style="color: #606060">   8:</span>     props.Add(<span style="color: #006080">"connection.driver_class"</span>, <span style="color: #006080">"NHibernate.Driver.SqlClientDriver"</span>);</pre>
    
    <pre><span style="color: #606060">   9:</span>     props.Add(<span style="color: #006080">"cache.provider_class"</span>, <span style="color: #006080">"NHibernate.Caches.SysCache.SysCacheProvider, NHibernate.Caches.SysCache"</span>);</pre>
    
    <pre><span style="color: #606060">  10:</span>     props.Add(<span style="color: #006080">"cache.use_second_level_cache"</span>, <span style="color: #006080">"true"</span>);</pre>
    
    <pre><span style="color: #606060">  11:</span>     props.Add(<span style="color: #006080">"cache.use_query_cache"</span>, <span style="color: #006080">"true"</span>);</pre>
    
    <pre><span style="color: #606060">  12:</span>     props.Add(<span style="color: #006080">"show_sql"</span>, <span style="color: #006080">"true"</span>);</pre>
    
    <pre><span style="color: #606060">  13:</span>     props.Add(<span style="color: #006080">"expiration"</span>, <span style="color: #006080">"180"</span>);</pre>
    
    <pre><span style="color: #606060">  14:</span>     props.Add(<span style="color: #006080">"regionPrefix"</span>, regionPrefix);</pre>
    
    <pre><span style="color: #606060">  15:</span>     props.Add(<span style="color: #006080">"proxyfactory.factory_class"</span>, <span style="color: #006080">"NHibernate.ByteCode.Castle.ProxyFactoryFactory, NHibernate.ByteCode.Castle"</span>);</pre>
    
    <pre><span style="color: #606060">  16:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  17:</span>     <span style="color: #0000ff">return</span> props;</pre>
    
    <pre><span style="color: #606060">  18:</span> }</pre></p>
  </div>
</div>

Note the definition of **regionPrefix** on line 14. We assign a value that is provided as a parameter to the function like the connection string.

Once again the [NHibernate profiler](http://nhprof.com/) was an invaluable help for us when monitoring the behavior of the system!