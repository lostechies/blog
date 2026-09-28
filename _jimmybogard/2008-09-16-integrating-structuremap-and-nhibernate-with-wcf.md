---
wordpress_id: 229
title: Integrating StructureMap and NHibernate with WCF
date: 2008-09-16T19:47:43+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/09/16/integrating-structuremap-and-nhibernate-with-wcf.aspx
dsq_thread_id:
  - "264715904"
categories:
  - NHibernate
  - StructureMap
  - WCF
redirect_from: "/blogs/jimmy_bogard/archive/2008/09/16/integrating-structuremap-and-nhibernate-with-wcf.aspx/"
---
Following many examples I found online for other IoC containers, I <strike>borrowed</strike> utilized those designs to create a [StructureMap instance provider](https://lostechies.com/blogs/jimmy_bogard/archive/2008/07/29/integrating-structuremap-with-wcf.aspx).&nbsp; One problem we ran into with that design was dealing with NHibernate.&nbsp; Mainly, there are two types that are very important to care about when using NHibernate:

  * ISessionFactory 
      * ISession</ul> 
    The first type, as the name implies, is responsible for creating the ISession object.&nbsp; The ISession acts as a Unit of Work, allowing me to execute queries, save entities, and pretty much any other persistence operation with my persistent types.
    
    Typically, in an ASP.NET environment, we&#8217;ll follow a Session per Request pattern, and only one ISession object is associated with one request by storing the ISession in HttpContext.Items.&nbsp; In WCF, configuration of instance contexts and configurable threading makes the picture a little more interesting.&nbsp; In WCF, we can configure our services to be instantiated as a singleton, per call or per session.&nbsp; The safest of these three options is per call, as we can be certain on the server side when call-context level items get created and later cleaned up.
    
    There are a [few](http://vanryswyckjan.blogspot.com/2008/05/integrating-castle-windsor-and.html) [examples](http://igloocoder.com/archive/2008/07/21/nhibernate-on-wcf.aspx) of integrating Windsor and NHibernate with WCF, and this solution is inspired by those designs.&nbsp; Before we get started, let&#8217;s create a wrapper for our ISessionFactory and ISession.
    
    ### Creating the ISessionFactory abstraction
    
    Because ISessionFactory is rather expensive to instantiate, only one of these should be created per application.&nbsp; Since the ISessionFactory built from the NHibernate Configuration class is thread-safe and meant to be used across threads, we can just make a static reference to it.&nbsp; The main reason behind an ISessionFactory abstraction is that it&#8217;s easier to control lifetime of the ISession we need to provide to our Repository implementations.&nbsp; This is merely a personal preference, but it makes managing the ISession a little easier.&nbsp; First, here&#8217;s our wrapper interface:
    
    <pre><span style="color: blue">public interface </span><span style="color: #2b91af">ISessionBuilder
</span>{
    <span style="color: #2b91af">ISession </span>GetSession();
    <span style="color: blue">void </span>CloseSession();
}
</pre>
    
    [](http://11011.net/software/vspaste)
    
    We need to both create and close the ISession as part of our Session per Request pattern.&nbsp; The actual ISessionBuilder implementation isn&#8217;t that interesting:
    
    <pre><span style="color: blue">public class </span><span style="color: #2b91af">SessionBuilder </span>: <span style="color: #2b91af">ISessionBuilder
</span>{
    <span style="color: blue">private static </span><span style="color: #2b91af">ISessionFactory </span>_sessionFactory;
    <span style="color: blue">private </span><span style="color: #2b91af">ISession </span>_session;

    <span style="color: blue">public </span><span style="color: #2b91af">ISession </span>GetSession()
    {
        Initialize();
        <span style="color: blue">if </span>(_session == <span style="color: blue">null</span>)
            _session = _sessionFactory.OpenSession();

        <span style="color: blue">return </span>_session;
    }

    <span style="color: blue">public void </span>CloseSession()
    {
        <span style="color: blue">if </span>(_session == <span style="color: blue">null</span>)
            <span style="color: blue">return</span>;

        _session.Close();
        _session.Dispose();
        _session = <span style="color: blue">null</span>;
    }

    <span style="color: blue">private static void </span>Initialize()
    {
        <span style="color: blue">var </span>sessionFactory = _sessionFactory;
        <span style="color: blue">if </span>(sessionFactory == <span style="color: blue">null</span>)
            _sessionFactory = <span style="color: blue">new </span><span style="color: #2b91af">Configuration</span>().Configure()
                                    .BuildSessionFactory();
    }
}
</pre>
    
    [](http://11011.net/software/vspaste)
    
    When it comes to the repositories that need an ISession, they&#8217;ll instead depend on an ISessionBuilder to build the ISession for them:
    
    <pre><span style="color: blue">public class </span><span style="color: #2b91af">ProductRepository </span>: <span style="color: #2b91af">IProductRepository
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ISessionBuilder </span>_sessionBuilder;

    <span style="color: blue">public </span>ProductRepository(<span style="color: #2b91af">ISessionBuilder </span>sessionBuilder)
    {
        _sessionBuilder = sessionBuilder;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">Product</span>[] GetExpensiveProducts()
    {
        <span style="color: blue">var </span>session = _sessionBuilder.GetSession();
        <span style="color: blue">var </span>criteria = session.CreateCriteria(<span style="color: blue">typeof</span>(<span style="color: #2b91af">Product</span>));
        criteria.Add(<span style="color: #2b91af">Restrictions</span>.Gt(<span style="color: #a31515">"UnitPrice"</span>, 100m));

        <span style="color: blue">var </span>results = criteria.List&lt;<span style="color: #2b91af">Product</span>&gt;();

        <span style="color: blue">return </span>results.ToArray();
    }
}
</pre>
    
    [](http://11011.net/software/vspaste)
    
    I like this implementation of finding ISession rather than a service locator or static property, as it fits in well with TDD.&nbsp; I don&#8217;t have to worry about some opaque dependency being up to test my repositories.
    
    Now that we have our ISessionFactory and ISession wrapper in place, let&#8217;s look at modifying our original IInstanceProvider.
    
    ### Modifying the IInstanceProvider
    
    The IInstanceProvider is a WCF extension that allows custom instantiation of the service instance.&nbsp; Our original StructureMapInstanceProvider used StructureMap&#8217;s service locator to build up the service:
    
    <pre><span style="color: blue">public class </span><span style="color: #2b91af">StructureMapInstanceProvider </span>: <span style="color: #2b91af">IInstanceProvider
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">Type </span>_serviceType;

    <span style="color: blue">public </span>StructureMapInstanceProvider(<span style="color: #2b91af">Type </span>serviceType)
    {
        _serviceType = serviceType;
    }

    <span style="color: blue">public object </span>GetInstance(<span style="color: #2b91af">InstanceContext </span>instanceContext)
    {
        <span style="color: blue">return </span>GetInstance(instanceContext, <span style="color: blue">null</span>);
    }

    <span style="color: blue">public object </span>GetInstance(<span style="color: #2b91af">InstanceContext </span>instanceContext, <span style="color: #2b91af">Message </span>message)
    {
        <span style="color: blue">return </span><span style="color: #2b91af">ObjectFactory</span>.GetInstance(_serviceType);
    }

    <span style="color: blue">public void </span>ReleaseInstance(<span style="color: #2b91af">InstanceContext </span>instanceContext, <span style="color: blue">object </span>instance)
    {
    }
}
</pre>
    
    [](http://11011.net/software/vspaste)
    
    Normally, we wouldn&#8217;t have to do anything to this implementation, if only one class depended on ISessionBuilder.&nbsp; But we want every repository participating in a call to use the exact same ISessionBuilder implementation.&nbsp; This ensures that everyone uses the same ISession instance in one call.&nbsp; Otherwise, the Unit of Work and Identity Map would be split amongst each repository, leading to concurrency and identity problems.
    
    What we need is to ensure that for this _one call_ to GetInstance, only one implementation of ISessionBuilder is used.&nbsp; We can configure caching of the ISessionBuilder implementation, but that won&#8217;t allow us to get access to the ISessionBuilder that was used.&nbsp; In addition to guaranteeing only one instance of ISessionBuilder is used, we need to close and dispose of the ISession at the end of the WCF call.&nbsp; Instead of using InstanceScope.PerRequest caching in StructureMap, we&#8217;ll need to use the With method.
    
    The With method allows us to make a call to the service locator GetInstance, and substitute a specific instance of a dependency during instantiation.&nbsp; This will allow us to create an instance of the ISessionBuilder, store it for closing later, and use it for the service location of the WCF service instance.&nbsp; Here&#8217;s the new Session per Request instance provider:
    
    <pre><span style="color: blue">public class </span><span style="color: #2b91af">SessionPerCallInstanceProvider </span>: <span style="color: #2b91af">IInstanceProvider
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">Type </span>_serviceType;
    <span style="color: blue">private </span><span style="color: #2b91af">ISessionBuilder </span>_sessionBuilder;

    <span style="color: blue">public </span>SessionPerCallInstanceProvider(<span style="color: #2b91af">Type </span>serviceType)
    {
        _serviceType = serviceType;
    }

    <span style="color: blue">public object </span>GetInstance(<span style="color: #2b91af">InstanceContext </span>instanceContext)
    {
        <span style="color: blue">return </span>GetInstance(instanceContext, <span style="color: blue">null</span>);
    }

    <span style="color: blue">public object </span>GetInstance(<span style="color: #2b91af">InstanceContext </span>instanceContext, <span style="color: #2b91af">Message </span>message)
    {
        _sessionBuilder = <span style="color: #2b91af">ObjectFactory</span>.GetInstance&lt;<span style="color: #2b91af">ISessionBuilder</span>&gt;();

        <span style="color: blue">return </span><span style="color: #2b91af">ObjectFactory
                </span>.With(_sessionBuilder)
                .GetInstance(_serviceType);
    }

    <span style="color: blue">public void </span>ReleaseInstance(<span style="color: #2b91af">InstanceContext </span>instanceContext, <span style="color: blue">object </span>instance)
    {
        <span style="color: blue">if </span>(_sessionBuilder != <span style="color: blue">null</span>)
        {
            _sessionBuilder.CloseSession();
            _sessionBuilder = <span style="color: blue">null</span>;
        }
    }
}
</pre>
    
    [](http://11011.net/software/vspaste)
    
    In the above WCF extension, WCF will call GetInstance to&#8230;get an instance of the service.&nbsp; Inside that method, we first create an instance of the ISessionBuilder, and store it in a local variable.&nbsp; Next, we use the With method to tell StructureMap to use that specific instance of ISessionBuilder for the following call to GetInstance.&nbsp; Adding some debug messages looking at hash codes confirms that the same instance is used here as well in any repositories, at any depth in the dependency graph.&nbsp; Finally, we add the ReleaseInstance implementation, which closes the ISession at the end of each request.
    
    We&#8217;re still not quite finished, we still need to tell WCF to use this instance provider.&nbsp; For that, we&#8217;ll need to create a custom service behavior.
    
    ### Creating the Session per Request service behavior
    
    In the previous post on using StructureMap to instantiate our service, I used a custom ServiceHostFactory and ServiceHost to attach the StructureMap service behavior at runtime.&nbsp; This time, I&#8217;ll use an attribute instead.&nbsp; That way, the Session per Request behavior can be opted in for each service implementation by using an attribute.&nbsp; There&#8217;s not much interesting about this service behavior, other than it also inherits from Attribute:
    
    <pre><span style="color: blue">public class </span><span style="color: #2b91af">SessionPerCallServiceBehavior </span>: <span style="color: #2b91af">Attribute</span>, <span style="color: #2b91af">IServiceBehavior
</span>{
    <span style="color: blue">public void </span>ApplyDispatchBehavior(<span style="color: #2b91af">ServiceDescription </span>serviceDescription, 
        <span style="color: #2b91af">ServiceHostBase </span>serviceHostBase)
    {
        <span style="color: blue">foreach </span>(<span style="color: #2b91af">ChannelDispatcherBase </span>cdb <span style="color: blue">in </span>serviceHostBase.ChannelDispatchers)
        {
            <span style="color: #2b91af">ChannelDispatcher </span>cd = cdb <span style="color: blue">as </span><span style="color: #2b91af">ChannelDispatcher</span>;
            <span style="color: blue">if </span>(cd != <span style="color: blue">null</span>)
            {
                <span style="color: blue">foreach </span>(<span style="color: #2b91af">EndpointDispatcher </span>ed <span style="color: blue">in </span>cd.Endpoints)
                {
                    ed.DispatchRuntime.InstanceProvider =
                        <span style="color: blue">new </span><span style="color: #2b91af">SessionPerCallInstanceProvider</span>(serviceDescription.ServiceType);
                }
            }
        }
    }

    <span style="color: blue">public void </span>AddBindingParameters(<span style="color: #2b91af">ServiceDescription </span>serviceDescription, 
        <span style="color: #2b91af">ServiceHostBase </span>serviceHostBase, 
        <span style="color: #2b91af">Collection</span>&lt;<span style="color: #2b91af">ServiceEndpoint</span>&gt; endpoints, 
        <span style="color: #2b91af">BindingParameterCollection </span>bindingParameters)
    {
    }

    <span style="color: blue">public void </span>Validate(<span style="color: #2b91af">ServiceDescription </span>serviceDescription, 
        <span style="color: #2b91af">ServiceHostBase </span>serviceHostBase)
    {
    }
}
</pre>
    
    [](http://11011.net/software/vspaste)
    
    The only thing I need to do here is to attach the instance provider (with the correct service type) to the dispatch runtime.&nbsp; Finally, I just need to decorate my services with the SessionPerCallServiceBehavior attribute:
    
    <pre>[<span style="color: #2b91af">SessionPerCallServiceBehavior</span>]
[<span style="color: #2b91af">ServiceBehavior</span>(InstanceContextMode = <span style="color: #2b91af">InstanceContextMode</span>.PerCall)]
<span style="color: blue">public class </span><span style="color: #2b91af">ComboService </span>: <span style="color: #2b91af">IComboService
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IProductRepository </span>_productRepository;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICategoryRepository </span>_categoryRepository;

    <span style="color: blue">public </span>ComboService(<span style="color: #2b91af">IProductRepository </span>productRepository, 
                        <span style="color: #2b91af">ICategoryRepository </span>categoryRepository)
    {
        _productRepository = productRepository;
        _categoryRepository = categoryRepository;
    }

</pre>
    
    [](http://11011.net/software/vspaste)
    
    Notice we also configured our service to use the PerCall instance context mode.&nbsp; We want this service to be instantiated for every single call to ensure that our ISession is not used across multiple client calls.&nbsp; Configuring to the PerCall setting ensures that we only get one ISession per request.
    
    Although we have our behavior up and running, we still need to find a place to configure StructureMap.
    
    ### Configuring StructureMap
    
    There&#8217;s just one more piece left to this puzzle.&nbsp; I need to inject the StructureMap fluent configuration somewhere in this pipeline.&nbsp; It only needs to happen once, so a custom service host factory would do the trick:
    
    <pre><span style="color: blue">public class </span><span style="color: #2b91af">DIServiceHostFactory </span>: <span style="color: #2b91af">ServiceHostFactory
</span>{
    <span style="color: blue">public </span>DIServiceHostFactory()
    {
        <span style="color: #2b91af">StructureMapConfiguration
            </span>.ScanAssemblies()
            .IncludeTheCallingAssembly()
            .With&lt;<span style="color: #2b91af">DefaultConventionScanner</span>&gt;();
    }
}
</pre>
    
    [](http://11011.net/software/vspaste)
    
    The service host factory above isn&#8217;t coupled in any way to our custom service behavior, but we need to inject the StructureMap configuration so StructureMap knows where to look for our dependencies.&nbsp; Finally, we need to configure our endpoint to use this service host factory, which is done in our case by editing the .svc file:
    
    <pre><span style="background: #ffee62">&lt;%</span><span style="color: blue">@ </span><span style="color: #a31515">ServiceHost </span><span style="color: red">Language</span><span style="color: blue">="C#" </span><span style="color: red">Debug</span><span style="color: blue">="true" 
    </span><span style="color: red">Service</span><span style="color: blue">="Wcf.ComboService"
    </span><span style="color: red">Factory</span><span style="color: blue">="Wcf.DIServiceHostFactory" </span><span style="background: #ffee62">%&gt;</span></pre>
    
    [](http://11011.net/software/vspaste)
    
    With all of these pieces in place, our WCF endpoints can now follow the Session per Request pattern.
    
    ### Wrapping it up
    
    To configure our WCF application to use the Session per Request pattern, we needed to:
    
      * Create a wrapper around ISession for our repositories to depend on
      * Create an IInstanceProvider implementation that:
      * Creates an ISessionBuilder and stores it locally
      * Uses the With method on ObjectFactory to scope a specific instance of a dependency for a single call to GetObject
      * Closes the ISession when the service instance is released by WCF
    
      * Create the custom IServiceBehavior and Attribute that attaches the custom IInstanceProvider
      * Decorate our WCF service implementation with the custom IServiceBehavior _and_ set the instance context mode to PerCall
      * Create a custom ServiceHostFactory to house our StructureMap configuration code
      * Modify our endpoint .svc file to use that custom ServiceHostFactory
    
    With the Session per Request pattern in place, we can better control our transaction boundaries as we now have access to the underlying ISession instance used in each call.&nbsp; Some additional WCF extension code allowed us to decorate each of our services that participates in the Session per Request pattern.&nbsp; Although it can take quite a bit of code to configure WCF to follow these patterns, the good news is that we were able to do so, working with the framework.