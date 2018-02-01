---
id: 444
title: Composite Applications with NHibernate
date: 2009-06-21T12:12:00+00:00
author: Derek Greer
layout: post
guid: http://www.aspiringcraftsman.com/2009/06/composite-applications-with-nhibernate/
dsq_thread_id:
  - "318481824"
categories:
  - Uncategorized
tags:
  - Composite Application Development
  - NHibernate
---
Composite application architecture is an approach to software development which seeks to produce applications which can be constructed from pre-built components, thus allowing a single platform to be more easily customized for end users.

The pre-built components, or modules, comprising a composite application often share data access concerns such as the need to access a central database. The use of object-relational mapping frameworks are an increasingly common strategy for facilitating data access needs. This is due to their ability to minimize much of the repetitive, low-level data access coding often required by more traditional approaches, and their ability to abstract much of the idiosyncrasies of specific database vendors, providing greater potential for portability between vendors.

NHibernate, arguably the leading object-relational mapping framework for the .Net platform, facilitates object-relational mapping through a centrally configured component called the SessionFactory. A SessionFactory is configured with the connection parameters for a specific database along with the mapping meta-data required for associating objects to the relational data within the database.

It is generally advised that a single SessionFactory be created per database. This is both due to the overhead required in its creation, and in order to facilitate various caching strategies such as the caching of generated SQL statements, and of entities across sessions (referred to as the second-level cache).

For composite applications, configuration of the SessionFactory can pose a bit of an obstacle given that any centralization of the mapping configuration would tend to couple otherwise independent and optional modules together. Additionally, a centralized configuration of the mappings for each of the modules precludes encapsulation of the configuration needs within each module, and can introduce maintenance complexity for modules developed by separate development teams or organizations. On the other hand, allowing modules to maintain their own SessionFactory for a shared database instance introduces startup overhead and precludes taking advantage of the caching features of the framework.

As demonstrated in the remainder of this article, one approach to solving these challenges is to create a staged application bootstrapping process which both facilitates decentralized mapping registration and centralized SessionFactory initialization.

While potentially applicable in other usage scenarios, the following approach is based upon the use of Fluent NHibernate, the Prism composite application library, and the staged bootstrapping strategy presented within the article: [Enhancing the Prism Module Initialization Lifecycle](2009/05/enhancing-the-prism-module-initialization-lifecycle/).

Our first step in demonstrating this strategy will be to create a module named DataModule which will serve as an infrastructure-only Prism module for configuring NHibernate. Using the ModuleBase implementation of IModule presented in the aforementioned article, the OnPreInitialization() and OnPostInitialization() methods will be overridden.

<pre class="brush:csharp">namespace CompositeSpike.Data.Module
{
    public class DataModule : ModuleBase
    {
        readonly IUnityContainer _container;

        public DataModule(IUnityContainer container)
        {
            _container = container;
        }

        protected override void OnPreInitialization()
        {
        }

        protected override void OnPostInitialization()
        {
        }
    }
}
</pre>

The OnPreInitialization() method will be used to register services to be consumed by other modules while the OnPostInitialization phase will be used to perform the final database configuration.

Next, let’s create a CustomerModule which represents a module using NHibernate for its data access needs. This module need only override the OnInitialization() method to gain access to services registered during the Pre-Initialization bootstrapping phase.

<pre class="brush:csharp">namespace CompositeSpike.Data.Module
{
    public class CustomerModule : ModuleBase
    {
        readonly IUnityContainer _container;

        public DataModule(IUnityContainer container)
        {
            _container = container;
        }

        protected override void OnInitialization()
        {
        }
    }
}
</pre>

Next, we’ll define a mapping service to be used by our CustomerModule for registering which map types and/or assemblies are to be included during the configuration of the SessionFactory.

<pre class="brush:csharp">namespace CompositeSpike.Data.Services
{
    public interface IMappingRegistryService
    {
        void AddMap() where T : IClassMap;
        void AddMap(Type classMap);
        void AddMapsFromAssemblyOf();
        void AddMapsFromAssembly(Assembly assembly);
    }
}
</pre>

Next, we’ll provide an internal implementation of the mapping service to be contained within t
  
he DataModule. Two additional properties, Assemblies and Types, are provided to enable the DataModule to access any mapping types and assemblies registered by modules during the Initialization phase.

<pre class="brush:csharp">namespace CompositeSpike.Data.Module.Services
{
    class MappingRegistryService : IMappingRegistryService
    {
        readonly IList _assemblies;
        readonly List _types;

        public MappingRegistryService()
        {
            _assemblies = new List();
            _types = new List();
        }

        public IEnumerable Assemblies
        {
            get { return _assemblies; }
        }

        public IEnumerable Types
        {
            get { return _types; }
        }

        public void AddMap() where T : IClassMap
        {
            AddMap(typeof (T));
        }

        public void AddMap(Type type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            if (!_types.Contains(type))
            {
                _types.Add(type);
            }
        }

        public void AddMapsFromAssemblyOf()
        {
            AddMapsFromAssembly(typeof (T).Assembly);
        }

        public void AddMapsFromAssembly(Assembly assembly)
        {
            if (!_assemblies.Contains(assembly))
            {
                _assemblies.Add(assembly);
            }
        }
    }
}
</pre>

With the service defined, let’s return to the DataModule and complete the body of the initialization methods.

To ensure the mapping service is available during the initialization phase of the other modules within the application, the IMappingRegistryService and its internal implementation need to be registered as a singleton with the Unity container during the PreInitialization bootstrapping phase:

<pre class="brush:csharp">protected override void OnPreInitialization()
        {
            _container.RegisterType(new ContainerControlledLifetimeManager());
        }
</pre>

After modules have been given an opportunity to register mappings with our service during the Initialization phase, the service can be retrieved and used to supply the class map types and/or assemblies required for the Fluent NHibernate configuration:

<pre class="brush:csharp">protected override void OnPostInitialization()
        {
            var service = _container.Resolve() as MappingRegistryService;

            ISessionFactory sessionFactory = Fluently.Configure()
                .Database(OracleConfiguration.Oracle9
                              .ConnectionString(
                              c =&gt; c.Is(ConfigurationManager.ConnectionStrings["example"].ConnectionString))
                              .ShowSql())
                .Mappings(m =&gt;
                    {
                        service.Types.ForEach(t =&gt; m.FluentMappings.Add(t));

                        service.Assemblies.ForEach(a =&gt; m.FluentMappings.AddFromAssembly(a));
                    })
                .BuildSessionFactory();

            _container
                .RegisterInstance(new NHibernateDatabaseContext(sessionFactory),
                                  new ContainerControlledLifetimeManager());
        }
</pre>

Our final step is to complete the initialization method within our CustomerModule to register any desired mappings to be used by the DataModule:

<pre class="brush:csharp">protected override void OnInitialization()
        {
            var dataMappingService = _container.Resolve();
            if (dataMappingService != null) dataMappingService.AddMapsFromAssemblyOf();
        }
</pre>

That concludes our example.

By utilizing a mapping service in conjunction with a multi-phased initialization strategy, a proper level of separation of concerns can be maintained for the modules within a composite application while at the same time utilizing NHibernate’s SessionFactory in the prescribed manner.
