---
wordpress_id: 311
title: AutoMapper and IoC
date: 2009-05-12T03:23:58+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/05/11/automapper-and-ioc.aspx
dsq_thread_id:
  - "264716147"
categories:
  - AutoMapper
redirect_from: "/blogs/jimmy_bogard/archive/2009/05/11/automapper-and-ioc.aspx/"
---
Since we’re a big user of IoC containers, namely [StructureMap](http://structuremap.sourceforge.net/Default.htm) (which was obviously a big inspiration in the design of the configuration), I tried to make AutoMapper IoC-friendly out of the box.&#160; It wasn’t friendly at first, [Jeffrey Palermo](http://jeffreypalermo.com/) had to prod me…a few times on this one.&#160; All of the examples of AutoMapper right now use the static Mapper class like this:

<pre><span style="color: green">// Configure AutoMapper
</span><span style="color: #2b91af">Mapper</span>.CreateMap&lt;<span style="color: #2b91af">Order</span>, <span style="color: #2b91af">OrderDto</span>&gt;();

<span style="color: green">// Perform mapping
</span><span style="color: #2b91af">OrderDto </span>dto = <span style="color: #2b91af">Mapper</span>.Map&lt;<span style="color: #2b91af">Order</span>, <span style="color: #2b91af">OrderDto</span>&gt;(order);</pre>

[](http://11011.net/software/vspaste)

But the Mapper class is merely a wrapper around two classes that do the real work – the Configuration class and the MappingEngine class.&#160; The Mapper class provides a singleton implementation of Configuration, but you’re not limited to just using Mapper.&#160; Instead, we can configure our container to provide everything for us.&#160; First, we need to worry about the Configuration class.

### 

### Configuring…Configuration

AutoMapper configuration, like many other configuration tasks, needs to happen **only once per AppDomain**, and at the startup of the application.&#160; In a current project, we have AutoMapper, StructureMap, NHibernate, and I believe even some log4net configuration executed once at application startup.&#160; Depending on the application environment, this could mean the Application_Start event in global.asax for ASP.NET applications, or just Main() for WinForms apps.&#160; In any case, we have a BootStrapper class that wraps configuration for all of our tools.&#160; This is where we can configure both our container and AutoMapper.&#160; Since I’ve only really used StructureMap, we’ll use that as an example.

To configure the Configuration class correctly in our container (alliteration, BOOM), we need to accomplish a few things:

  * Make it singleton
  * Point requests for IConfiguration to Configuration
  * Point requests for IConfigurationProvider to Configuration
  * Set up the IObjectMapper[] dependency

The reason for the two interfaces is that AutoMapper separates the operational from the configuration interface in its [semantic model](http://martinfowler.com/dslwip/SemanticModel.html).&#160; The Configuration class depends on a set of IObjectMappers to do things like configuration validation, and the actual mapping engine will use whatever IObjectMappers we supply.&#160; Here’s the Configuration constructor we care about:

<pre><span style="color: blue">public </span>Configuration(<span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">IObjectMapper</span>&gt; mappers)
{
    _mappers = mappers;
}</pre>

[](http://11011.net/software/vspaste)

Thanks to a community patch, we can get the default list of mappers from a registry:

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">MapperRegistry
</span>{
    <span style="color: blue">public static </span><span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">IObjectMapper</span>&gt;&gt; AllMappers = () =&gt; <span style="color: blue">new </span><span style="color: #2b91af">IObjectMapper</span>[]
    {
        <span style="color: blue">new </span><span style="color: #2b91af">CustomTypeMapMapper</span>(),
        <span style="color: blue">new </span><span style="color: #2b91af">TypeMapMapper</span>(),
        <span style="color: blue">new </span><span style="color: #2b91af">NewOrDefaultMapper</span>(),
        <span style="color: blue">new </span><span style="color: #2b91af">StringMapper</span>(),
        <span style="color: blue">new </span><span style="color: #2b91af">FlagsEnumMapper</span>(),
        <span style="color: blue">new </span><span style="color: #2b91af">EnumMapper</span>(),
        <span style="color: blue">new </span><span style="color: #2b91af">AssignableMapper</span>(),
        <span style="color: blue">new </span><span style="color: #2b91af">ArrayMapper</span>(),
        <span style="color: blue">new </span><span style="color: #2b91af">DictionaryMapper</span>(),
        <span style="color: blue">new </span><span style="color: #2b91af">EnumerableMapper</span>(),
        <span style="color: blue">new </span><span style="color: #2b91af">TypeConverterMapper</span>(),
        <span style="color: blue">new </span><span style="color: #2b91af">NullableMapper</span>(),
    };
}</pre>

[](http://11011.net/software/vspaste)

In case we want to supply different mappers, we can simply replace this function with something else.&#160; It’s this location where we can provide the list of mappers for our Configuration object.&#160; We don’t have to, as our Configuration type only depends on an enumerable collection of mappers, but this is a convenient place to pull from.

Let’s look at our StructureMap configuration for our Configuration object:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">ConfigurationRegistry </span>: <span style="color: #2b91af">Registry
</span>{
    <span style="color: blue">public </span>ConfigurationRegistry()
    {
        ForRequestedType&lt;<span style="color: #2b91af">Configuration</span>&gt;()
            .CacheBy(<span style="color: #2b91af">InstanceScope</span>.Singleton)
            .TheDefault.Is.OfConcreteType&lt;<span style="color: #2b91af">Configuration</span>&gt;()
            .CtorDependency&lt;<span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">IObjectMapper</span>&gt;&gt;().Is(expr =&gt; expr.ConstructedBy(<span style="color: #2b91af">MapperRegistry</span>.AllMappers));

        ForRequestedType&lt;<span style="color: #2b91af">IConfigurationProvider</span>&gt;()
            .TheDefault.Is.ConstructedBy(ctx =&gt; ctx.GetInstance&lt;<span style="color: #2b91af">Configuration</span>&gt;());

        ForRequestedType&lt;<span style="color: #2b91af">IConfiguration</span>&gt;()
            .TheDefault.Is.ConstructedBy(ctx =&gt; ctx.GetInstance&lt;<span style="color: #2b91af">Configuration</span>&gt;());
    }
}</pre>

[](http://11011.net/software/vspaste)

In our custom StructureMap [Registry](http://structuremap.sourceforge.net/RegistryDSL.htm), we first configure the Configuration object to be singleton, to default to the Configuration type, and configure the constructor dependency to be constructed by our mapper registry.&#160; The next two configuration pieces set up the two semantic model interfaces to resolve to the Configuration class.&#160; We use the “ConstructedBy” and “GetInstance” to ensure that resolutions for the two interfaces use the configuration we already set up for Configuration.&#160; This is so both interfaces resolve to the _exact same instance_.

Next, we need to focus on the other major piece of AutoMapper – the mapping engine.

### Configuring the mapping engine

The AutoMapper mapping engine does all the nitty gritty work of performing a mapping.&#160; It is defined by the IMappingEngine interface, and implemented by the MappingEngine class.&#160; Our MappingEngine class has a single dependency:

<pre><span style="color: blue">public </span>MappingEngine(<span style="color: #2b91af">IConfigurationProvider </span>configurationProvider)
{
    _configurationProvider = configurationProvider;
}</pre>

[](http://11011.net/software/vspaste)

The MappingEngine, unlike our Configuration object, does _not_ need any special caching/lifetime behavior.&#160; The MappingEngine is very lightweight, as it’s really a bunch of methods doing interesting things with Configuration.&#160; MappingEngine can be singleton if we want, but there’s no need.&#160; Configuring the last piece for the IMappingEngine interface is very simple:

<pre>ForRequestedType&lt;<span style="color: #2b91af">IMappingEngine</span>&gt;().TheDefaultIsConcreteType&lt;<span style="color: #2b91af">MappingEngine</span>&gt;();</pre>

[](http://11011.net/software/vspaste)

I didn’t feel like scanning the entire assembly, so I just manually set up this pair.

### Putting it all together

Finally, let’s show our entire AutoMapper and StructureMap configuration:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Example()
{
    <span style="color: #2b91af">ObjectFactory</span>.Initialize(init =&gt;
    {
        init.AddRegistry&lt;<span style="color: #2b91af">ConfigurationRegistry</span>&gt;();
    });

    <span style="color: blue">var </span>configuration1 = <span style="color: #2b91af">ObjectFactory</span>.GetInstance&lt;<span style="color: #2b91af">IConfiguration</span>&gt;();
    <span style="color: blue">var </span>configuration2 = <span style="color: #2b91af">ObjectFactory</span>.GetInstance&lt;<span style="color: #2b91af">IConfiguration</span>&gt;();
    configuration1.ShouldBeTheSameAs(configuration2);

    <span style="color: blue">var </span>configurationProvider = <span style="color: #2b91af">ObjectFactory</span>.GetInstance&lt;<span style="color: #2b91af">IConfigurationProvider</span>&gt;();
    configurationProvider.ShouldBeTheSameAs(configuration1);

    <span style="color: blue">var </span>configuration = <span style="color: #2b91af">ObjectFactory</span>.GetInstance&lt;<span style="color: #2b91af">Configuration</span>&gt;();
    configuration.ShouldBeTheSameAs(configuration1);
    
    configuration1.CreateMap&lt;<span style="color: #2b91af">Source</span>, <span style="color: #2b91af">Destination</span>&gt;();

    <span style="color: blue">var </span>engine = <span style="color: #2b91af">ObjectFactory</span>.GetInstance&lt;<span style="color: #2b91af">IMappingEngine</span>&gt;();

    <span style="color: blue">var </span>destination = engine.Map&lt;<span style="color: #2b91af">Source</span>, <span style="color: #2b91af">Destination</span>&gt;(<span style="color: blue">new </span><span style="color: #2b91af">Source </span>{Value = 15});

    destination.Value.ShouldEqual(15);
}</pre>

[](http://11011.net/software/vspaste)

In this test, I initialize StructureMap with the registry created earlier.&#160; Next, I pull various objects from StructureMap, and do some tests to ensure that all configuration types resolve to the exact same instance.&#160; Once I have an IConfiguration instance, I can configure AutoMapper as needed.

Once AutoMapper configuration is complete, I can query StructureMap for an IMappingEngine instance, and use it to perform a mapping operation from some source and destination object.&#160; Note that I didn’t need to specify the IConfigurationProvider instance for the IMappingEngine resolution, StructureMap wired this dependency up for me.

But this isn’t the only way to do IoC with AutoMapper.

### Scenario 2 – Keeping the static class for configuration/lifetime management

If you only want to do IoC for the mapping engine, configuration will be quite a bit shorter.&#160; In that scenario, you basically don’t care about the Configuration class.&#160; You use the Mapper static class to do all of your configuration, and only configure the IMappingEngine-MappingEngine pair.&#160; This is useful if you inject IMappingEngine in places, but not Configuration.&#160; We will let Mapper do all of our instance/lifetime management, and simply point our container to Mapper for the mapping engine.&#160; In this case, all we need to do is point the MappingEngine’s constructor dependency to the static Mapper class ConfigurationProvider property:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">MappingEngineRegistry </span>: <span style="color: #2b91af">Registry
</span>{
    <span style="color: blue">public </span>MappingEngineRegistry()
    {
        ForRequestedType&lt;<span style="color: #2b91af">IMappingEngine</span>&gt;()
            .TheDefault.Is.ConstructedBy(() =&gt; <span style="color: #2b91af">Mapper</span>.Engine);
    }
}</pre>

[](http://11011.net/software/vspaste)

We do nothing more than point StructureMap to the static Mapper.Engine property for any request of an IMappingEngine type.&#160; In our code, we configure everything through the Mapper class:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Example2()
{
    <span style="color: #2b91af">ObjectFactory</span>.Initialize(init =&gt;
    {
        init.AddRegistry&lt;<span style="color: #2b91af">MappingEngineRegistry</span>&gt;();
    });

    <span style="color: #2b91af">Mapper</span>.Reset();

    <span style="color: #2b91af">Mapper</span>.CreateMap&lt;<span style="color: #2b91af">Source</span>, <span style="color: #2b91af">Destination</span>&gt;();

    <span style="color: blue">var </span>engine = <span style="color: #2b91af">ObjectFactory</span>.GetInstance&lt;<span style="color: #2b91af">IMappingEngine</span>&gt;();

    <span style="color: blue">var </span>destination = engine.Map&lt;<span style="color: #2b91af">Source</span>, <span style="color: #2b91af">Destination</span>&gt;(<span style="color: blue">new </span><span style="color: #2b91af">Source </span>{Value = 15});

    destination.Value.ShouldEqual(15);
}</pre>

[](http://11011.net/software/vspaste)

In practice, classes that need to perform a map will depend on the IMappingEngine, which, at runtime, will resolve through StructureMap simply to the static Mapper.Engine property.&#160; In this scenario, we are able to use the Mapper static class directly for configuration, but reserve the ability to depend on an IMappingEngine when needed, where we need to make our dependencies explicit.

Much like other frameworks, the static Mapper class is merely a facade over the Configuration and MappingEngine objects, providing only instance management.&#160; If need be, we can use any of our favorite IoC containers to manage this lifetime ourselves, eliminating a dependency on a static class.&#160; Whether this is needed or not is up to the end user.