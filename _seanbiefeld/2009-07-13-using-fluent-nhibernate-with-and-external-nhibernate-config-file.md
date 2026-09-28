---
wordpress_id: 4454
title: Configuring Fluent NHibernate with an External NHibernate Config File
date: 2009-07-13T16:12:00+00:00
author: Sean Biefeld
layout: post
wordpress_guid: /blogs/seanbiefeld/archive/2009/07/13/using-fluent-nhibernate-with-and-external-nhibernate-config-file.aspx
dsq_thread_id:
  - "449608152"
categories:
  - configuration
  - Fluent NHibernate
  - infrastructure
  - NHibernate
redirect_from: "/blogs/seanbiefeld/archive/2009/07/13/using-fluent-nhibernate-with-and-external-nhibernate-config-file.aspx/"
---
A while ago I was having issues using configuring fluent NHibernate with an external configuration file. I kept running into the issue of mappings not being registered. I was finally able to get it working appropriately and thought I would share my solution. The key is to configure the normal mappings first and then pass that configuration in when configuring fluent NHibernate.

<pre style="background-color: #141414;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #BEBEC8;font-size: 10pt"><span style="color: #cda869">string</span> configFile = <span style="color: #8f9d6a">"hibernate.cfg.xml"</span>;<br /><br /><span style="color: #5f5a5f">//setup the normal map configuration</span><br /><span style="color: #cda869">Configuration</span> normalConfig = <span style="color: #cda869">new</span> <span style="color: #7386a5">Configuration</span>().Configure(configFile);<br /><br /><span style="color: #5f5a5f">//setup the fluent map configuration</span><br /><span style="color: #7386a5">Fluently</span>.Configure(normalConfig)<br />	.Mappings(<br />		m =&gt; m.FluentMappings<br />		.ConventionDiscovery.Add(<span style="color: #7386a5">DefaultLazy</span>.AlwaysFalse())<br />		.AddFromAssemblyOf&lt;<span style="color: #7386a5">UserMap</span>&gt;())<br />	.BuildConfiguration();<br /></pre>