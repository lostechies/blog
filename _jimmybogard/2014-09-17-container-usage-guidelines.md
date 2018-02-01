---
id: 948
title: Container Usage Guidelines
date: 2014-09-17T19:25:56+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=948
dsq_thread_id:
  - "3027593605"
categories:
  - Architecture
  - DependencyInjection
---
Over the years, I’ve used and abused IoC containers. While the different tools have come and gone, I’ve settled on a set of guidelines on using containers effectively. As a big fan of the [Framework Design Guidelines](http://msdn.microsoft.com/en-us/library/ms229042(v=vs.110).aspx) book and its style of “DO/CONSIDER/AVOID/DON’T”, I tried to capture what has made me successful with containers over the years in a series of guidelines below.

### Container configuration

Container configuration typically occurs once at the beginning of the lifecycle of an AppDomain, creating an instance of a container as the composition root of the application, and configuring and framework-specific service locators. StructureMap combines scanning for convention-based registration, and Registries for component-specific configuration. 

**X AVOID** scanning an assembly more than once. 

Scanning is somewhat expensive, as scanning involves passing each type in an assembly through each convention. A typical use of scanning is to target one or more assemblies, find all custom Registries, and apply conventions. Conventions include generics rules, matching common naming conventions (IFoo to Foo) and applying custom conventions. A typical root configuration would be: 

[gist id=819d10c3349c2518488a] 

Component-specific configuration is then separated out into individual Registry objects, instead of mixed with scanning. Although it is possible to perform both scanning and component configuration in one step, separating component-specific registration in individual registries provides a better separation of conventions and configuration. 

**√ DO** separate configuration concerning different components or concerns into different Registry classes. 

Individual Registry classes contain component-specific registration. Prefer smaller, targeted Registries, organized around function, scope, component etc. All container configuration for a single 3rd-party component organized into a single Registry makes it easy to view and modify all configuration for that one component: 

[gist id=7475667b018d7cbd6d54] 

**X DO NOT** use the static API for configuring or resolving. 

Although StructureMap exposes a static API in the ObjectFactory class, it is considered obsolete. If a static instance of a composition root is needed for 3rd-party libraries, create a static instance of the composition root Container in application code. 

**√ DO** use the instance-based API for configuring. 

Instead of using ObjectFactory.Initialize and exposing ObjectFactory.Instance, create a Container instance directly. The consuming application is responsible for determining the lifecycle/configuration timing and exposing container creation/configuration as an explicit function allows the consuming runtime to determine these (for example, in a web application vs. integration tests). 

X **DO NOT** create a separate project solely for dependency resolution and configuration. 

Container configuration belongs in applications requiring those dependencies. Avoid convoluted project reference hierarchies (i.e., a &#8220;DependencyResolution&#8221; project). Instead, organize container configuration inside the projects needing them, and defer additional project creation until multiple deployed applications need shared, common configuration. 

**√ DO** include a Registry in each assembly that needs dependencies configured. 

In the case where multiple deployed applications share a common project, include inside that project container configuration for components specific to that project. If the shared project requires convention scanning, then a single Registry local to that project should perform the scanning of itself and any dependent assemblies. 

**X AVOID** loading assemblies by name to configure. 

Scanning allows adding assemblies by name, &#8220;scan.Assembly(&#8220;MyAssembly&#8221;)&#8221;. Since assembly names can change, reference a specific type in that assembly to be registered.&nbsp; 

### Lifecycle configuration

Most containers allow defining the lifecycle of components, and StructureMap is no exception. Lifecycles determine how StructureMap manages instances of components. By default, instances for a single request are shared. Ideally, only Singleton instances and per-request instances should be needed. There are cases where a custom lifecycle is necessary, to scope a component to a given HTTP request (HttpContext). 

**√ DO** use the container to configure component lifecycle. 

Avoid creating custom factories or builder methods for component lifecycles. Your custom factory for building a singleton component is probably broken, and lifecycles in containers have undergone extensive testing and usage over many years. Additionally, building factories solely for controlling lifecycles leaks implementation and environment concerns to services consuming lifecycle-controlled components. In the case where instantiation needs to be deferred or lifecycle needs to be explicitly managed (for example, instantiating in a using block), depending on a Func<IService> or an abstract factory is appropriate. 

**√ CONSIDER** using child containers for per-request instances instead of HttpContext or similar scopes. 

Child/nested containers inherit configuration from a root container, and many modern application frameworks include the concept of creating scopes for requests. Web API in particular creates a dependency scope for each request. Instead of using a lifecycle, individual components can be configured for an individual instance of a child container: 

[gist id=98d8a66db08490c5a0ca] 

Since components configured for a child container are transient for that container, child containers provide a mechanism to create explicit lifecycle scopes configured for that one child container instance. Common applications include creating child containers per integration test, MVVM command handler, web request etc. 

**√ DO** dispose of child containers. 

Containers contain a Dispose method, so if the underlying service locator extensions do not dispose directly, dispose of the container yourself. Containers, when disposed, will call Dispose on any non-singleton component that implements IDisposable. This will ensure that any resources potentially consumed by components are disposed properly. 

### Component design and naming

Much of the negativity around DI containers arises from their encapsulation of building object graphs. A large, complicated object graph is resolved with single line of code, hiding potentially dozens of disparate underlying services. Common to those new to Domain-Driven Design is the habit of creating interfaces for every small behavior, leading to overly complex designs. These design smells are easy to spot without a container, since building complex object graphs by hand is tedious. DI containers hide this pain, so it is up to the developer to recognize these design smells up front, or avoid them entirely. 

**X AVOID** deeply nested object graphs. 

Large object graphs are difficult to understand, but easy to create with DI containers. Instead of a strict top-down design, identify cross-cutting concerns and build generic abstractions around them. Procedural code is perfectly acceptable, and many design patterns and refactoring techniques exist to address complicated procedural code. The behavioral design patterns can be especially helpful, combined with refactorings dealing with long/complicated code can be especially helpful. Starting with the [Transaction Script](http://martinfowler.com/eaaCatalog/transactionScript.html) pattern keeps the number of structures low until the code exhibits enough design smells to warrant refactoring. 

**√ CONSIDER** building generic abstractions around concepts, such as IRequestHandler<T>, IValidator<T>. 

When designs do become unwieldy, breaking down components into multiple services often leads to service-itis, where a system contains numerous services but each only used in one context or execution path. Instead, behavioral patterns such as the Mediator, Command, Chain of Responsibility and Strategy are especially helpful in creating abstractions around concepts. Common concepts include: 

  * Queries 
      * Commands 
          * Validators 
              * Notifications 
                  * Model binders 
                      * Filters 
                          * Search providers 
                              * PDF document generators 
                                  * REST document readers/writers</ul> 
                                Each of these patterns begins with a common interface: 
                                
                                [gist id=64c5db966e10e7de4e7a] 
                                
                                Registration for these components involves adding all implementations of an interface, and code using these components request an instance based on a generic parameter or all instances in the case of the chain of responsibility pattern. 
                                
                                One exception to this rule is for third-party components and external, volatile dependencies. 
                                
                                **√ CONSIDER** encapsulating 3rd-party libraries behind adapters or facades. 
                                
                                While using a 3rd-party dependency does not necessitate building an abstraction for that component, if the component is difficult or impossible to fake/mock in a test, then it is appropriate to create a facade around that component. File system, web services, email, queues and anything else that touches the file system or network are prime targets for abstraction. 
                                
                                The database layer is a little more subtle, as requests to the database often need to be optimized in isolation from any other request. Switching database/ORM strategies is fairly straightforward, since most ORMs use a common language already (LINQ), but have subtle differences when it comes to optimizing calls. Large projects can switch between major ORMs with relative ease, so any abstraction would limit the use of any one ORM into the least common denominator. 
                                
                                **X DO NOT** create interfaces for every service. 
                                
                                Another common misconception of SOLID design is that every component deserves an interface. DI containers can resolve concrete types without an issue, so there is no technical limitation to depending directly on a concrete type. In the book [Growing Object-Oriented Software, Guided by Tests](http://www.growing-object-oriented-software.com/), these components are referred to as Peers, and in [Hexagonal Architecture](http://alistair.cockburn.us/Hexagonal+architecture) terms, interfaces are reserved for Ports. 
                                
                                **√ DO** depend on concrete types when those dependencies are in the same logical layer/tier. 
                                
                                A side effect of depending directly on concrete types is that it becomes very difficult to over-specify tests. Interfaces are appropriate when there is truly an abstraction to a concept, but if there is no abstraction, no interface is needed. 
                                
                                **X AVOID** implementation names whose name is the implemented interface name without the &#8220;I&#8221;. 
                                
                                StructureMap&#8217;s default conventions do match up IFoo with Foo, and this can be a convenient default behavior, but when you have implementations whose name is the same as their interface without the &#8220;I&#8221;, that is a _symptom_ that you are arbitrarily creating an interface for every service, when just resolving the concrete service type would be sufficient instead.&nbsp; In other words, the mere ability to resolve a service type by an interface is not sufficient justification for introducing an interface. 
                                
                                **√ DO** name implementation classes based on details of the implementation (AspNetUserContext : IUserContext). 
                                
                                An easy way to detect excessive abstraction is when class names are directly the interface name without the prefix &#8220;I&#8221;. An implementation of an interface should describe the implementation. For concept-based interfaces, class names describe the representation of the concept (ChangeNameValidator, NameSearcher etc.) Environment/context-specific implementations are named after that context (WebApiUserContext : IUserContext). 
                                
                                ### Dynamic resolution
                                
                                While most component resolution occurs at the very top level of a request (controller/presenter), there are occasions when dynamic resolution of a component is necessary. For example, model binding in MVC occurs after a controller is created, making it slightly more difficult to know at controller construction time what the model type is, unless it is assumed using the action parameters. For many extension points in MVC, it is impossible to avoid service location. 
                                
                                **X AVOID** using the container for service location directly. 
                                
                                Ideally, component resolution occurs once in a request, but in the cases where this is not possible, use a framework&#8217;s built-in resolution capabilities. In Web API for example, dynamically resolved dependencies should be resolved from the current dependency scope: 
                                
                                [gist id=6af8ee5f46e7a7d6e7fe] 
                                
                                Web API creates a child container per request and caches this scoped container within the request message. If the framework does not provide a scoped instance, store the current container in an appropriately scoped object, such as HttpContext.Items for web requests. Occasionally, you might need to depend on a service but need to explicitly decouple or control its lifecycle. In those cases, containers support depending directly on a Func. 
                                
                                ****√ CONSIDER**** depending on a Func<IService> for late-bound services. 
                                
                                For cases where known types need to be resolved dynamically, instead of trying to build special caching/resolution services, you can instead depend on a constructor function in the form of a Func. This separates wiring of dependencies from instantiation, allowing client code to have explicit construction without depending directly on a container. 
                                
                                [gist id=eabe8b266e12ae74b547] 
                                
                                In cases where this becomes complicated, or reflection code is needed, a factory method or delegate type explicitly captures this intent. 
                                
                                **√ DO** encapsulate container usage with factory classes when invoking a container is required. 
                                
                                The Patterns and Practices Common Service Locator defines a delegate type representing the creation of a service locator instance: 
                                
                                [gist id=b292acfb9415758bf0d0] 
                                
                                For code needing dynamic instantiation of a service locator, configuration code creates a dependency definition for this delegate type: 
                                
                                [gist id=c096ee70aac656eb9103] 
                                
                                This pattern is especially useful if an outer dependency has a longer configured lifecycle (static/singleton) but you need a window of shorter lifecycles. For simple instances of reflection-based component resolution, some containers include automatic facilities for creating factories. 
                                
                                **√ CONSIDER** using auto-factory capabilities of the container, if available. 
                                
                                Auto-factories in StructureMap are available as a separate package, and allow you to create an interface with an automatic implementation: 
                                
                                [gist id=f98cbe316c25b108547a] 
                                
                                The AutoFactories feature will dynamically create an implementation that defers to the container for instantiating the list of plugins.