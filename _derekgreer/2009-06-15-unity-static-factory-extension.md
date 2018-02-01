---
id: 445
title: 'Unity: The Static Factory Extension'
date: 2009-06-15T06:34:00+00:00
author: Derek Greer
layout: post
guid: http://www.aspiringcraftsman.com/2009/06/unity-the-static-factory-extension/
dsq_thread_id:
  - "317209734"
categories:
  - Uncategorized
tags:
  - Unity
---
The Unity Inversion of Control container comes with an extension called the StaticFactoryExtension. The purpose of this extension is to add the ability to register types within the container while deferring the instantiation of the type to a factory method. This enables a number of scenarios where finer-grained control over the construction of an object is desired.

As the name suggests, one example use of the extension is with a static factory method. In the following test, an ILoggingService is registered with the container by configuring it to call the LoggingService.GetLoggingService() static method via the IStaticFactoryConfiguration.

<pre class="brush:csharp">namespace StaticFactoryExample
{
    public class StaticFactoryExampleSpecs
    {
        [TestFixture]
        public class When_a_logging_service_is_resolved_using_a_static_factory_method
        {
            UnityContainer _container;

            [SetUp]
            public void SetUp()
            {
                _container = new UnityContainer();

                _container
                    .AddNewExtension()
                    .Configure()
                    .RegisterFactory(container =&gt;
                                     LoggingService.GetLoggingService());
            }

            [Test]
            public void A_logging_service_should_be_returned()
            {
                Assert.IsNotNull(_container.Resolve());
            }
        }
    }

    public interface ILoggingService
    {
    }

    public sealed class LoggingService : ILoggingService
    {
        readonly Log4NetLogger _logger;

        LoggingService(Log4NetLogger logger)
        {
            _logger = logger;
        }

        public static ILoggingService GetLoggingService()
        {
            return Nested.instance;
        }

        static class Nested
        {
            internal static readonly ILoggingService instance = new LoggingService(new Log4NetLogger());
        }
    }

    public interface ILogger
    {
    }

    public class Log4NetLogger : ILogger
    {
    }
}
</pre>

While use with actual static factory methods may have been the driving factor for the creation of this extension, there is nothing inherently prescriptive about the extension which necessitates that the methods used be static.

Another example use of the StaticFactoryExtension is to conceal dependencies of resolved types which you may not want to be accessible through the container. Consider the following alternate example registration of the ILoggingService:

<pre class="brush:csharp">namespace StaticFactoryExample
{
    public class StaticFactoryExampleSpecs
    {
        [TestFixture]
        public class When_a_logging_service_is_resolved_using_a_static_factory_method
        {
            UnityContainer _container;

            [SetUp]
            public void SetUp()
            {
                _container = new UnityContainer();

                _container
                    .AddNewExtension()
                    .RegisterType(new ContainerControlledLifetimeManager())
                    .Configure()
                    .RegisterFactory(container =&gt;
                                     new LoggingService(new Log4NetLogger()));
            }

            [Test]
            public void A_logging_service_should_be_returned()
            {
                Assert.IsNotNull(_container.Resolve());
            }

            [Test]
            public void The_logging_service_returned_should_always_be_the_same_instance()
            {
                Assert.AreSame(
                    _container.Resolve(),
                    _container.Resolve());
            }
        }
    }

    public interface ILoggingService
    {
    }

    public class LoggingService : ILoggingService
    {
        readonly ILogger _logger;

        public LoggingService(ILogger logger)
        {
            _logger = logger;
        }
    }

    public interface ILogger
    {
    }

    public class Log4NetLogger : ILogger
    {
    }
}
</pre>

In this example, the LoggingService is implemented as a class with an ILogger dependency which must be supplied through the constructor. The factory method responsible for returning the ILoggingService has been rewritten as an expression which returns a newly instantiated instance of the LoggingService and supplies an instance of Log4NetLogger as its dependency implementation. Additionally, the ILoggingService has been registered with a ContainerControlledLifetimeManager. A lifetime manager within Unity is a type responsible for governing how instances of types registered with the container are managed. The ContainerControlledLifetimeManager holds a single instance of the registered type once created and returns the same instance upon all requests. This effectively causes the container to manage the instance as a singleton without placing this responsibility upon the class itself, and without otherwise incurring the drawbacks that the singleton design pattern imposes upon a class.

While enabling the ILoggingService to be resolved by the container could have been achieved without the use of the StaticFactoryExtension by simply registering the LoggingService implementation and the ILogger dependency type, this would have made the instance of ILogger available to types within the system which may not be desired. In this case, the ILoggingService is intended as the public API to be used by types within the system for logging needs. The ILogger type is simply a strategy for how this is accomplished. This approach enables the ILoggingService to be lazy-loaded by the container without exposing the ILogger type.

While the StaticFactoryExtension provides useful behavior to the Unity container, one might argue that the API leaves something to be desired. One of the strengths of the Unity container is its extensibility model. In fact, all of Unity’s functionally is facilitated through extensions. Unfortunately, this means additional functionality such as that provided by the StaticFactoryExtension requires calling the Configure
  
() method to obtain a reference to the extension. The result is that some degree of ceremony is required each time a factory method needs to be registered for a type.

One approach to improving the API is to encapsulate the required calls to configure a factory method within an extension method. Consider the following extension methods:

<pre class="brush:csharp">public static class UnityExtensions
    {
        public static IUnityContainer RegisterType(this IUnityContainer container, FactoryDelegate factoryMethod)
        {
            container.Configure().RegisterFactory(factoryMethod);
            return container;
        }

        public static IUnityContainer RegisterType(this IUnityContainer container, FactoryDelegate factoryMethod,
                                                   LifetimeManager lifetimeManager)
        {
            container
                .RegisterType(lifetimeManager)
                .Configure().RegisterFactory(factoryMethod);
            return container;
        }
    }
</pre>

In the case of the eariler ILoggingService example, where the desired behavior is to always return the same instance, using the extension method which accepts a FactoryDelegate and a LifetimeManager allows the StaticFactoryExtension behavior to be used as follows:

<pre class="brush:csharp">[SetUp]
        public void SetUp()
        {
            _container = new UnityContainer();

            _container
                .AddNewExtension()
                .RegisterType(container =&gt; new LoggingService(new Log4NetLogger()),
                              new ContainerControlledLifetimeManager());
        }
</pre>
