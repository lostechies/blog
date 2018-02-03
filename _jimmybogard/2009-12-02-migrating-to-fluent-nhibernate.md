---
wordpress_id: 370
title: Migrating to Fluent NHibernate
date: 2009-12-02T02:07:45+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/12/01/migrating-to-fluent-nhibernate.aspx
dsq_thread_id:
  - "264716346"
categories:
  - NHibernate
---
Recently, I’ve been entrenched in migrating our existing hbm.xml mapping files to Fluent NHibernate.&#160; Having been through other OSS upgrades, I was expecting something along the lines of pulling teeth.&#160; I pictured a branch, tedious work to try and move mappings over, all the while making parallel changes to changes going on back in the trunk’s hbm files.&#160; Instead, Fluent NHibernate supports a painless migration path, really surprising me.&#160; I haven’t finished the migration, but all of the difficult mappings are behind me, and I haven’t run into a situation that couldn’t be migrated yet.&#160; However, I have found a few things along the way that have helped make the migration much easier.

But first, let’s see how we can take an existing NHibernate application, chock full of hbm goodness, and start the migration to Fluent NHibernate.

### Switching configuration

When migrating our mapping configuration, the name of the game is to preserve as much as we can, so that we make as few changes as possible.&#160; The more changes we introduce, the harder time we will have figuring out if our application doesn’t work because of Fluent NHibernate not configured correctly.&#160; Although Fluent NHibernate provides fluent code-based configuration, we’re not going to do that _yet_.&#160; First, we’ll take our existing configuration strategy, whether it’s using the Configuration object, the hibernate.cfg.xml file, or .config file, and simply augment it so that we can integrate it into Fluent NHibernate’s configuration model.

In our case, we used the hibernate.cfg.xml file, but it all comes down to how you originally create the Configuration object.&#160; One thing we need to augment in our configuration file:

<pre><span style="color: blue">&lt;?</span><span style="color: #a31515">xml </span><span style="color: red">version</span><span style="color: blue">=</span>"<span style="color: blue">1.0</span>" <span style="color: red">encoding</span><span style="color: blue">=</span>"<span style="color: blue">utf-8</span>" <span style="color: blue">?&gt;
&lt;</span><span style="color: #a31515">hibernate-configuration </span><span style="color: red">xmlns</span><span style="color: blue">=</span>'<span style="color: blue">urn:nhibernate-configuration-2.2</span>' <span style="color: blue">&gt;
    &lt;</span><span style="color: #a31515">session-factory</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">property </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">connection.driver_class</span>"<span style="color: blue">&gt;</span>NHibernate.Driver.SqlClientDriver<span style="color: blue">&lt;/</span><span style="color: #a31515">property</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">property </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">connection.connection_string</span>"<span style="color: blue">&gt;</span>Data Source=.sqlexpress;Initial Catalog=IBuySpy;Integrated Security=true<span style="color: blue">&lt;/</span><span style="color: #a31515">property</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">property </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">show_sql</span>"<span style="color: blue">&gt;</span>false<span style="color: blue">&lt;/</span><span style="color: #a31515">property</span><span style="color: blue">&gt;

        &lt;</span><span style="color: #a31515">property </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">dialect</span>"<span style="color: blue">&gt;</span>NHibernate.Dialect.MsSql2005Dialect<span style="color: blue">&lt;/</span><span style="color: #a31515">property</span><span style="color: blue">&gt;

        &lt;</span><span style="color: #a31515">property </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">cache.provider_class</span>"<span style="color: blue">&gt;</span>NHibernate.Caches.SysCache.SysCacheProvider,NHibernate.Caches.SysCache<span style="color: blue">&lt;/</span><span style="color: #a31515">property</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">property </span><span style="color: red">name</span><span style="color: blue">=</span>'<span style="color: blue">proxyfactory.factory_class</span>'<span style="color: blue">&gt;</span>NHibernate.ByteCode.Castle.ProxyFactoryFactory, NHibernate.ByteCode.Castle<span style="color: blue">&lt;/</span><span style="color: #a31515">property</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">property </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">cache.use_query_cache</span>"<span style="color: blue">&gt;</span>true<span style="color: blue">&lt;/</span><span style="color: #a31515">property</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">property </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">adonet.batch_size</span>"<span style="color: blue">&gt;</span>1000<span style="color: blue">&lt;/</span><span style="color: #a31515">property</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">property </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">hbm2ddl.keywords</span>"<span style="color: blue">&gt;</span>none<span style="color: blue">&lt;/</span><span style="color: #a31515">property</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">mapping </span><span style="color: red">assembly</span><span style="color: blue">=</span>"<span style="color: blue">IBuySpy.Core</span>" <span style="color: blue">/&gt;

    &lt;/</span><span style="color: #a31515">session-factory</span><span style="color: blue">&gt;
&lt;/</span><span style="color: #a31515">hibernate-configuration</span><span style="color: blue">&gt;</span></pre>

[](http://11011.net/software/vspaste)Is that piece at the bottom – the “mapping assembly” piece.&#160; We need to remove that, as we’re going to switch to use Fluent NHibernate to pick up all of our entity mapping configuration.&#160; But other than that, leave that configuration file alone!&#160; Whether you do web.config, hibernate.cfg.xml, or programmatic configuration, leave it alone.&#160; Again, we don’t want to change too many things at once to make the switch to Fluent NHibernate.

The next piece is to find that part in your application that creates the Configuration NHibernate object.&#160; That object is used to create the SessionFactory, so you’ll likely only find it in one place in your application, and only called once per AppDomain.&#160; In any case, find the piece that instantiates a Configuration object, it might look something like this:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">NHibernateBootstrapper
</span>{
    <span style="color: blue">public static </span><span style="color: #2b91af">Configuration </span>Build()
    {
        <span style="color: blue">var </span>configuration = <span style="color: blue">new </span><span style="color: #2b91af">Configuration</span>();

        configuration.Configure();

        <span style="color: blue">return </span>configuration;</pre>

[](http://11011.net/software/vspaste)

From here, you can now [download the latest Fluent NHibernate release](http://fluentnhibernate.org/downloads) and add a reference to whatever project you load NHibernate (the Core project for us).&#160; Next, change that final piece that returns Configuration object and replace it with this:

<pre><span style="color: blue">public static </span><span style="color: #2b91af">Configuration </span>Build()
{
    <span style="color: blue">var </span>configuration = <span style="color: blue">new </span><span style="color: #2b91af">Configuration</span>();

    configuration.Configure();

    <span style="color: blue">return </span><span style="color: #2b91af">Fluently</span>.Configure(configuration)
        .Mappings(cfg =&gt;
        {
            cfg.HbmMappings.AddFromAssemblyOf&lt;<span style="color: #2b91af">Customer</span>&gt;();
        }).BuildConfiguration();
}</pre>

[](http://11011.net/software/vspaste)

The Fluently class is the main window into Fluent NHibernate configuration.&#160; We’ll use the overload of Configure() and pass in the _existing_ Configuration object we created through our previous setup.&#160; In our case, this means we get all the configuration from the hibernate.cfg.xml file.&#160; This is important because we have quite a bit of deployment code around this XML file that we’d not want to change right now.

Next, we tell FNH to load up our existing entity configuration in the form of hbm.xml configuration that’s included as embedded resources in our assembly with the Customer (or any type in the assembly where you keep your HBMs).&#160; This lets us keep all of our existing hbm’s, but just use FNH to load them up instead.

That’s it for the initial migration.&#160; We used our existing method for creating the Configuration object, but modified it such that Fluent NHibernate is responsible for the final Configuration object used.&#160; We didn’t touch any of the HBMs, but merely instructed FNH to use them.

### Migrating individual mapping files

Once the initial shim for Fluent NHibernate is in place, our application will work exactly as before.&#160; But that’s not the interesting part of FNH of course, we want to start taking advantage of the nice fluent mappings.&#160; So what’s the general migration strategy for migrating individual hbm’s?&#160; Pretty easy:

  1. Create a ClassMap for a single entity, matching the original hbm exactly 
  2. Delete the original hbm.xml 
  3. Perform a schema compare to make sure nothing’s changed 
  4. Commit, rinse and repeat for each class map 

That’s it!&#160; You can move hbm’s one at a time, with no need to do an all-or-nothing switch.&#160; FNH supports side-by-side HBM and fluent mappings seemlessly, even if you do crazy things like joined subclasses split between fluent and xml files.&#160; Of course, you will need to add your fluent mappings to the Fluenty.Configure piece, but that’s pretty straightfoward:

<pre><span style="color: blue">return </span><span style="color: #2b91af">Fluently</span>.Configure(configuration)
    .Mappings(cfg =&gt;
    {
        cfg.HbmMappings.AddFromAssemblyOf&lt;<span style="color: #2b91af">Customer</span>&gt;();
        cfg.FluentMappings.AddFromAssemblyOf&lt;<span style="color: #2b91af">Customer</span>&gt;();
    }).BuildConfiguration();</pre>

[](http://11011.net/software/vspaste)

Now as you add the fluent maps, one at a time, **don’t try to “fix” the existing maps.**&#160; You can do all that after the fluent map replaces the existing HBM.&#160; But we don’t want to change too many things at once, and modifying the DB schema and switching to FNH is too many changes at once.

However, there _are_ some things we can start doing to enhance our mappings as we go.

### Discovering and enforcing conventions

Although HBM files themselves have sensible defaults, they do not allow us to create new defaults across all of our HBMs.&#160; For example, we can’t tell our HBMs that _all_ collections are accessed through fields, all foreign keys are suffixed with “Id” and so on.&#160; However, as we add the fluent maps, we should keep an eye on any duplication in our maps.&#160; We can do things like:

  * Define naming conventions for primary/foreign key columns
  * Set access for collections
  * Configure custom NHibernate types for your own custom types (like the [Enumeration class](http://elegantcode.com/2009/11/01/state-pattern-enumeration-class-and-fluent-nhibernate-oh-my/))
  * Create inheritance hierarchies in our ClassMaps to match any layer supertype hierarchy in our entities
  * Build extension methods to encapsulate configuring common components (like that Address class everywhere)

We can still preserve our existing DB schema, but it’s quite likely that your team has already settled on things like naming conventions, access conventions and so on.&#160; But with HBMs, you couldn’t describe these things en masse.&#160; With FNH, we can add [conventions](http://wiki.fluentnhibernate.org/Conventions) as we go.&#160; Keep an eye out for these common conventions early, it’s a lot easier to put conventions in place earlier rather than when your HBMs have all been converted.

I still can’t get over how easy it was to migrate to FNH, it was completely seemless and we were able to take advantage of the conventions almost immediately.&#160; Strongly-typed mappings are great, but it’s been the conventions that have really impressed me.&#160; If you’re still on the old HBMs, upgrade now and ditch that XML!