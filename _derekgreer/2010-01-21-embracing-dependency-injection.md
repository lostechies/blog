---
id: 5
title: Embracing Dependency Injection
date: 2010-01-21T14:59:00+00:00
author: Derek Greer
layout: post
guid: http://www.aspiringcraftsman.com/2010/01/embracing-dependency-injection/
dsq_thread_id:
  - "331047535"
categories:
  - Uncategorized
tags:
  - Dependency Injection
---
Recently, a fairly notable icon within the software development community posted some thoughts on Twitter which I found surprising. The individual stated:

<p style="padding-left: 30px">
  <em> &#8220;What&#8217;s the right number of dependencies to inject? A few. In a very large system, perhaps a few dozen.&#8221; </em>
</p>

Given that I found this statement to be fairly controversial, I urged the individual to write an article explaining what had brought them to such a conclusion. Later that day, an article was published on the subject explaining their position. After reading the article, it became clear that what was being argued against was the degree of coupling to a dependency injection framework, not dependency injection in general. While minimizing an application&#8217;s degree of coupling to any given framework is a goal to be encouraged, the argument was partially based upon a lack of familiarity with the conventional use of dependency injection containers.

In an effort to demonstrate that use of a dependency injection framework is usually unnecessary,the article presents two versions of an example billing application with and without relying upon a framework. The following is a C# version approximating the examples presented within the article:

**Dependency Injection Framework Version**

<pre class="prettyprint">public class Application
    {
        public static void Main()
        {
            IContainer container = new Container().AddConfiguration(BillingConfiguration);
            BillingService billingService = container.Resolve&lt;BillingService&gt;();

            // TODO: do something with the billing service ...
        }
    }

    public class BillingConfiguration : ContainerConfiguration
    {
        protected void Configure()
        {
             Register&lt;ICreditCardService&gt;().As&lt;CreditCardService&gt;();
             Register&lt;ITransactionLog&gt;().As&lt;DatabaseTransactionLog&gt;();
        }
    }
</pre>

**Manual Dependency Injection Version**

<pre class="prettyprint">public class Application
    {
        public static void Main()
        {
            BillingService billingService = new BillingService(new CreditCardProcessor(), new TransactionLog());

            // TODO: do something with the billing service ...
        }
    }
</pre>

Comparing the two examples, the second is obviously the more straight forward and concise of the two approaches.

Foreseeing the concern that one might want to use the billing service in a lower layer of the application, the article proceeds to set forth an example which configures a globally accessible static instance of the service within the main method:

<pre class="prettyprint">public class Application
    {
        public static void Main()
        {
            BillingService billingService = new BillingService(new CreditCardProcessor(), new TransactionLog());
            BillingService.Instance = billingService;

            // Now the BillingService.Instance can be accessed anywhere within the application
        }
    }
</pre>

To further address the need to create separate instances of the billing service, the article next presents an example which configures a globally accessible Factory instance which can be accessed from other parts of the application. Perhaps in an attempt to show some recognition of the benefits of using a framework, the Factory is designed to encapsulate the registration and use of a container for retrieving instances of the billing service:

<pre class="prettyprint">public class Application
    {
        public static void Main()
        {
            IContainer container = new Container().AddConfiguration(BillingConfiguration);
            BillingService.Factory = new BillingServiceFactory(container);

            // Now we can make new instances of the billing service anywhere within the application
            BillingService billingService = BillingService.Factory.Create();
        }
    }

    public class BillingServiceFactory : ContainerConfiguration
    {
        IContainer _container;

        public BillingServiceFactory(IContainer container)
        {
            _container = container;
        }

        protected void Configure()
        {
             Register&lt;ICreditCardService&gt;().As&lt;CreditCardService&gt;();
             Register&lt;ITransactionLog&gt;().As&lt;DatabaseTransactionLog&gt;();
        }

        public BillingService Create()
        {
            return _container.Resolve&lt;BillingService&gt;() ;
        }
    }
</pre>

The article concludes by submitting that dependency injection frameworks should only be used for areas of an application that are known extension points, and that in most cases the best course of action is to manually instantiate any needed objects along with their dependencies.

While these examples may seem perfectly sensible to those unfamiliar with using a dependency injection framework, there are several problems with the techniques presented here.

First, the simplicity of these examples fail to highlight the issues involved in real-world applications. Applications designed with an adherence to low-coupling and preferring composition over inheritance often result in object grafts many levels deep. That is to say, the dependencies of one object may have dependencies of their own, which in turn have dependencies of their own, and so forth and so on. While it is possible to use the manual instantiation techniques described in the first example, the resulting code will soon become both unsightly and unwieldy. Couple that with the reuse of components across multiple types and duplication starts to arise. The examples above don&#8217;t highlight these issues since they are only working with a simple object graph.

Second, issues arise in the introduction of global variables to access instances of the billing service or the factory. For one, the design becomes more opaque. Classes which reference global resources don&#8217;t express their external dependencies through their interface thereby requiring you to look at the code to discover what dependencies are required. Two, this introduces a responsibility to the billing service which isn&#8217;t an inherent concern. The responsibility for the creation and lifetime management of the service is a separate concern from the service&#8217;s core responsibilities and one which can change for different reasons.

Third, the encapsulation of the container registration and resolution of the billing service within the factory actually serves to more tightly couple the application to the dependency injection framework. What&#8217;s been missed in the examples thus far is the fact that the billing service is itself a dependency of other types and they in turn may themselves be dependencies. By ensuring that all types within the system are using dependency injection, the entire dependency chain can be resolved by one call to the container. This eliminates the need to produce specialized factories for each type.

Consider the following example:

<pre class="prettyprint">public class Application
    {
        public static void Main()
        {
            new Bootstrapper().Run();
        }
    }

    public class Bootstrapper
    {
        public void Run()
        {
            ConfigureContainer();
            Container.Resolve&lt;IShell&gt;().Show();
        }

        void ConfigureContainer()
        {
            // Configure the container
        }
    }

    public interface IBillingService
    {
        // define billing methods
    }

    public class BillingService : IBillingService
    {
        public BillingService(ICreditCardProcessor creditCardProcessor, ITransactionLog transactionLog) { ... }

        // implement IBillingService methods here
    }

    public interface IShell
    {
         void Show();
    }

    public class Shell : IShell
    {
        public Shell(IBillingService billingService) { ... }

        public void Show() { ... }
    }
</pre>

In this example the container is only referenced from within the Bootstrapper and the container is only used to resolve an instance of the type IShell. Given that all types have been registered, the container traverses the dependency chain, building up the object graph from the bottom up. This allows the entire application to remain decoupled from the dependency injection framework as well as avoiding the need to create and further maintain type specific factories. As the application grows in complexity, there may be the need to introduce other entry points or strategies for handling lazy-loading, but coupling to the container would remain minimal.

If you find yourself needing to invert your dependencies on an inversion of control framework then you are doing it wrong.
