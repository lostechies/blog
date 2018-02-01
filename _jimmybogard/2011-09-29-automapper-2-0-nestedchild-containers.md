---
id: 539
title: 'AutoMapper 2.0 &#8211; Nested/Child Containers'
date: 2011-09-29T13:09:00+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2011/09/29/automapper-2-0-nestedchild-containers/
dsq_thread_id:
  - "429434645"
categories:
  - AutoMapper
---
One of the major features introduced with the AutoMapper 2.0 release is the ability to support nested/child containers. Service location has been in AutoMapper for a while now, but its scope was limited to configuration time:

<pre class="code"><span style="color: #2b91af">Mapper</span>.Initialize(cfg =&gt;
{
    cfg.ConstructServicesUsing(<span style="color: #2b91af">ObjectFactory</span>.GetInstance);

    cfg.CreateMap&lt;<span style="color: #2b91af">Source</span>, <span style="color: #2b91af">Destination</span>&gt;();
});
</pre></p> 

While this works, we can see above that I have to use a static service locator function to construct all supporting mapping objects AutoMapper uses (Formatters, Resolvers and Type Converters). This becomes an issue with child/nested containers, where I’m building up a specific container instance with specific scope and configuration.

In order to support this scenarios, AutoMapper allows you to pass in a custom service locator at map time, instead of configuration time:

<pre class="code"><span style="color: blue">var </span>dest = <span style="color: #2b91af">Mapper</span>.Map&lt;<span style="color: #2b91af">Source</span>, <span style="color: #2b91af">Destination</span>&gt;(<span style="color: blue">new </span><span style="color: #2b91af">Source </span>{ Value = 15 },
    opt =&gt; opt.ConstructServicesUsing(childContainer.GetInstance));
</pre></p> 

Where the “childContainer” is an individual container instance. Since the scope of resolving instances is narrowed to each mapping call, you can supply individual containers for service location for each mapping operation.