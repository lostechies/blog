---
wordpress_id: 446
title: Enhancing the Prism Module Initialization Lifecycle
date: 2009-05-24T16:32:00+00:00
author: Derek Greer
layout: post
wordpress_guid: http://www.aspiringcraftsman.com/2009/05/enhancing-the-prism-module-initialization-lifecycle/
dsq_thread_id:
  - "327716639"
categories:
  - Uncategorized
tags:
  - Composite Application Development
---
The [Composite Application Library](http://codeplex.com/CompositeWPF), better known as Prism, is a framework for developing composite-style applications for WPF and Silverlight. Prism facilitates simple module initialization upon application startup, but this is not always adequate for every application. This article discusses an enhanced approach for module initialization within Prism-based applications.

Within Prism, modules are identified by registering types which implement the IModule interface. This interface defines a single Initialize() method which provides an opportunity to perform any module-level configuration needed by the application. This might include such things as configuring a dependency injection container, registering views with the Region Manager, initializing a module-level [Application Controller](http://msdn.microsoft.com/en-us/library/cc304764.aspx), and other module-level initialization needs.

The IModule interface is defined as follows:

<pre class="brush:csharp">public interface IModule
    {
        void Initialize();
    }</pre>

While the specifics of module initialization can vary depending upon which dependency injection container (if any) is chosen, the initialization process followed by the UnityBoostrapper provided with Prism iterates over an enumeration of ModuleInfo instances derived from an instance of IModuleCatalog and delegates initialization to an instance of IModuleInitializer for each module. Within the default implementation of IModuleInitializer, the type derived from IModule is retrieved from the ModuleInfo instance, resolved through the Common Service Locator, and the IModule.Initialize() method is invoked on the resolved instance.

The following sequence diagram depicts a simplified view of this process:

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/PrismInitSequence.png"><img class="size-full wp-image-51 aligncenter" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/PrismInitSequence.png" alt="Prism Initialization Sequence" width="548" height="337" /></a>
</p>

While this process enables basic module initialization, it does not facilitate the ability to initialize modules which may have interdependencies with other modules. One example requiring a multi-phased initialization strategy would be the use of components which initialize application-scoped objects based upon information registered by other modules within the application. For instance, consider an infrastructure module whose purpose is to initialize a database context based upon object-relational mapping information specific to each module. To achieve this within a single-phased initialization strategy, the object-relational mapping information would need to be centralized in one location. This could negatively impact the overall decoupling provided by the Prism framework, and would violate the Open/Closed principle for registering information for newly created modules. With a multi-phased initialization strategy, such a component could register a service used as the object-relational mapping registry, and on a later phase retrieve any registered mapping information to initialize a single database context to be used later by all modules.

One approach to achieving a multi-phased initialization strategy would be to register custom implementations of the Prism types involved in the module initialization process. While this strategy is possible, there are a few disadvantages to this approach.

While many types used within the Prism library enable alternate implementations, the responsibility of initializing modules is not encapsulated by a single type, and the types which encapsulate the module initialization responsibility are not limited to this responsibility alone. To be fair, this statement is only partially true, and only realized upon attempting to replace the assumed single-phased strategy with a multi-phased strategy. The responsibility of initializing each module is assigned to an IModuleInitializer type, but unfortunately alternate implementations are limited to alternate single-phase strategies. This is because the responsibility of iterating over the module metadata resides within the IModuleManager type. Additionally, the methods responsible for iterating over the modules cannot be overridden within a derived type. Providing a new initialization strategy would thus require custom types to be implemented for both interfaces, or for the existing codebase to be modified.

It would be ideal if an alternate initialization strategy could be provided without modifying or rewriting existing framework code, but in lieu this, the existing single-phased strategy can still be leveraged to enable a separate initialization strategy.

While initially considering use of the EventAggregator to raise specific events representing each initialization phase, I chose to encapsulate the phase sequencing responsibilities within an IStagedSequenceService to arrive at a more cohesive, intention revealing, and reusable approach.

The IStagedSequenceService is declared as follows:

<pre class="brush:csharp">/// &lt;summary&gt;
    /// Defines a service for providing a staged sequence of events.
    /// &lt;/summary&gt;
    public interface IStagedSequenceService
    {
        void RegisterForStage(Action action, TStageEnum stage);
    }</pre>

The purpose of this interface is to allow components to register an Action delegate to be associated with a supplied generic enumeration stage.

The implementation of the IStagedSequenceService is declared as follows:

<pre class="brush:csharp">/// &lt;summary&gt;
    /// Provides the default implementation for &lt;see cref="IStagedSequenceService"/&gt;.
    /// &lt;/summary&gt;
    public class StagedSequenceService : IStagedSequenceService
    {
        readonly List[] stages;

        public StagedSequenceService()
        {
            stages = new List[NumberOfEnumValues()];

            for (int i = 0; i &lt; stages.Length; ++i)
            {
                stages[i] = new List();
            }
        }

        public virtual void ProcessSequence()
        {
            foreach (var stage in stages)
            {
                foreach (var action in stage)
                {
                    action();
                }
            }
        }

        public virtual void RegisterForStage(Action action, TStageEnum stage)
        {
            stages[Convert.ToInt32(stage)].Add(action);
        }

        int NumberOfEnumValues()
        {
            return typeof (TStageEnum).GetFields(BindingFlags.PublicBindingFlags.Static).Length;
        }
    }</pre>

This implementation initializes a two-dimensional array based upon the number of stages in a sequence (i.e. the number of enumeration values representing the stages). The implementation of the RegisterForStage() method is then able to store each registered Action delegate in the appropriate collection for each stage. A ProcessSequence() method is supplied with a simple two-level loop which executes the registered delegates for each stage.

Next, an enumeration type is required to define the desired stages for the application:

<pre class="brush:csharp">/// &lt;summary&gt;
    /// Defines stages used by modules requiring staged initialization.
    /// &lt;/summary&gt;
    public enum ModuleInitializationStage
    {
        /// &lt;summary&gt;
        /// The preinitialization stage is used to perform initialization
        /// required before external module initialization.
        /// &lt;/summary&gt;
        PreInitialization,

        /// &lt;summary&gt;
        /// The initialization stage is used to perform
        /// initialization required by the current module.
        /// &lt;/summary&gt;
        Initialization,

        /// &lt;summary&gt;
        /// The post-initialization stage is used to perform
        /// initialization required after external module initialization.
        /// &lt;/summary&gt;
        PostInitialization,

        /// &lt;summary&gt;
        /// The startup stage is used to perform perform initial
        /// tasks after all initialization is complete.
        /// &lt;/summary&gt;
        StartUp
    }</pre>

Next, an IModuleInitializationService and implementation is defined specifying the ModuleInitializationStage enumeration:

<pre class="brush:csharp">public interface IModuleInitializationService : IStagedSequenceService
    {
    }

    public class ModuleInitializationService : StagedSequenceService, IModuleLifecycleService
    {
        public virtual void Initialize()
        {
            base.ProcessSequence();
        }
    }</pre>

An Initialize() method is provided to wrap the ProcessSequence call. This is done to provide a more meaningful API to the specific context for this manifestation of the IStagedSequenceService.

To provide the base implementation required to take advantage of the new staged-initialization capabilities, a ModuleBase abstract class is defined which registers a protected virtual method corresponding to each of the defined stages:

<pre class="brush:csharp">public abstract class ModuleBase : IModule
    {
        public void Initialize()
        {
            var moduleLifecycleService = ServiceLocator.Current.GetInstance();

            moduleLifecycleService.RegisterForStage(OnPreInitialization, ModuleInitializationStage.PreInitialization);

            moduleLifecycleService.RegisterForStage(OnInitialization, ModuleInitializationStage.Initialization);

            moduleLifecycleService.RegisterForStage(OnPostInitialization, ModuleInitializationStage.PostInitialization);

            moduleLifecycleService.RegisterForStage(OnStartUp, ModuleInitializationStage.StartUp);
        }

        protected virtual void OnPreInitialization()
        {
        }

        protected virtual void OnInitialization()
        {
        }

        protected virtual void OnPostInitialization()
        {
        }

        protected virtual void OnStartUp()
        {
        }
    }</pre>

To drive the new initialization strategy, the new ModuleInitializationSerivce is registered with the container and the UnityBootstrapper.InitializeModules() method is overridden in the main bootstrapper class to invoke the service’s Initialize() method:

<pre class="brush:csharp">public class DesktopBootstrapper : UnityBootstrapper
    {
        // other methods

        protected override void ConfigureContainer()
        {
            _moduleInitializationService = new ModuleInitializationService();

            Container.RegisterInstance(_moduleInitializationService, new ContainerControlledLifetimeManager());

            // other configuration
        }

        protected override void InitializeModules()
        {
            base.InitializeModules();
            _moduleInitializationService.Initialize();
        }
    }</pre>

From here, modules requiring participation within the staged-initialized strategy need only implement the abstract ModuleBase class and override the appropriate method based upon the specific scenario required:

<pre class="brush:csharp">public class ExampleModule : ModuleBase
    {
        protected override void OnPreInitialization()
        {
            // TODO Register services required by other modules.
        }

        protected override void OnInitialization()
        {
            // TODO perform initialization requiring services from other modules.
        }
    }</pre>

In conclusion, while the Composite Application Library does not provide a multi-phased initialization strategy, this can still be achieved by leveraging the existing behavior to facilitate a new strategy.
