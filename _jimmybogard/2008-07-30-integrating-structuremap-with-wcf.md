---
wordpress_id: 211
title: Integrating StructureMap with WCF
date: 2008-07-30T02:44:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/07/29/integrating-structuremap-with-wcf.aspx
dsq_thread_id:
  - "264738879"
categories:
  - StructureMap
  - Tools
  - WCF
redirect_from: "/blogs/jimmy_bogard/archive/2008/07/29/integrating-structuremap-with-wcf.aspx/"
---
When developing with an IoC container like StructureMap, eventually some place in your code you will need to call the [registry](http://martinfowler.com/eaaCatalog/registry.html) to instantiate your classes with their dependencies.&nbsp; With StructureMap, this means a call to ObjectFactory.GetInstance.&nbsp; Ideally, we&#8217;d like to limit the number of places the registry is called, so that we don&#8217;t have a lot of StructureMap concerns sprinkled throughout our application.

Suppose we have the following WCF service:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerSearchService </span>: <span style="color: #2b91af">ICustomerSearchService
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICustomerRepository </span>_customerRepository;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICustomerSummaryMapper </span>_customerSummaryMapper;

    <span style="color: blue">public </span>CustomerSearchService(<span style="color: #2b91af">ICustomerRepository </span>customerRepository, <span style="color: #2b91af">ICustomerSummaryMapper </span>customerSummaryMapper)
    {
        _customerRepository = customerRepository;
        _customerSummaryMapper = customerSummaryMapper;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">CustomerSearchResult </span>FindCustomerByName(<span style="color: blue">string </span>fullName)
    {
        <span style="color: #2b91af">Customer </span>customer = _customerRepository.FindCustomerByName(fullName);

        <span style="color: blue">if </span>(customer == <span style="color: blue">null</span>)
        {
            <span style="color: blue">return new </span><span style="color: #2b91af">CustomerSearchResult
                       </span>{
                           IsSuccessful = <span style="color: blue">false</span>,
                           FailureReasons = <span style="color: blue">new</span>[] {<span style="color: #a31515">"Customer not found."</span>}
                       };
        }

        <span style="color: #2b91af">CustomerSummary </span>summary = _customerSummaryMapper.MapFrom(customer);

        <span style="color: blue">return  new </span><span style="color: #2b91af">CustomerSearchResult </span>{IsSuccessful = <span style="color: blue">true</span>, Result = summary};
    }
}
</pre>

[](http://11011.net/software/vspaste)

Nothing too exciting, just a search service that returns customer summary information from a name search.&nbsp; Now, if we just try to use this service as is, we get a fun exception:

_The service type provided could not be loaded as a service because it does not have a default (parameter-less) constructor. To fix the problem, add a default constructor to the type, or pass an instance of the type to the host._

That makes sense, as WCF is in charge of instantiating my service class (CustomerSearchService), but it only knows how to call a no-args constructor.&nbsp; For a quick fix, we can add this constructor:

<pre><span style="color: blue">public </span>CustomerSearchService()
    : <span style="color: blue">this</span>(<span style="color: #2b91af">ObjectFactory</span>.GetInstance&lt;<span style="color: #2b91af">ICustomerRepository</span>&gt;(), 
        <span style="color: #2b91af">ObjectFactory</span>.GetInstance&lt;<span style="color: #2b91af">ICustomerSummaryMapper</span>&gt;())
{
}
</pre>

[](http://11011.net/software/vspaste)

Each of our WCF services would need to the same thing, have a bunch of ObjectFactory calls to set up the dependencies appropriately.&nbsp; But we can find a better way, and have all of our services wired up automatically, with only one call to StructureMap in the entire application.&nbsp; To do this, we&#8217;ll need to plug in to a few WCF extension points to make it happen.

### A custom instance provider

WCF provides an interface just for this purpose, [IInstanceProvider](http://msdn.microsoft.com/en-us/library/system.servicemodel.dispatcher.iinstanceprovider.aspx), that allows us to create custom instantiation behavior.&nbsp; This interface has basically two methods:

  * CreateInstance &#8211; needs to return the right service
  * ReleaseInstance &#8211; if we have some custom cleanup to do

Just creating the IInstanceProvider isn&#8217;t enough, we&#8217;ll have to tell WCF to use our instance provider, instead of its own default instance provider.&nbsp; This requires a custom endpoint behavior.&nbsp; We can&#8217;t configure the instance provider directly, through configuration or other means.&nbsp; Instead, we&#8217;ll use a custom service behavior through the [IServiceBehavior](http://msdn.microsoft.com/en-us/library/system.servicemodel.description.iservicebehavior.aspx) interface.&nbsp; Here&#8217;s the implementation of our custom service behavior:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">StructureMapServiceBehavior </span>: <span style="color: #2b91af">IServiceBehavior
</span>{
    <span style="color: blue">public void </span>ApplyDispatchBehavior(<span style="color: #2b91af">ServiceDescription </span>serviceDescription, <span style="color: #2b91af">ServiceHostBase </span>serviceHostBase)
    {
        <span style="color: blue">foreach </span>(<span style="color: #2b91af">ChannelDispatcherBase </span>cdb <span style="color: blue">in </span>serviceHostBase.ChannelDispatchers)
        {
            <span style="color: #2b91af">ChannelDispatcher </span>cd = cdb <span style="color: blue">as </span><span style="color: #2b91af">ChannelDispatcher</span>;
            <span style="color: blue">if </span>(cd != <span style="color: blue">null</span>)
            {
                <span style="color: blue">foreach </span>(<span style="color: #2b91af">EndpointDispatcher </span>ed <span style="color: blue">in </span>cd.Endpoints)
                {
                    ed.DispatchRuntime.InstanceProvider = 
                        <span style="color: blue">new </span><span style="color: #2b91af">StructureMapInstanceProvider</span>(serviceDescription.ServiceType);
                }
            }
        }
    }

    <span style="color: blue">public void </span>AddBindingParameters(<span style="color: #2b91af">ServiceDescription </span>serviceDescription, <span style="color: #2b91af">ServiceHostBase </span>serviceHostBase, <span style="color: #2b91af">Collection</span>&lt;<span style="color: #2b91af">ServiceEndpoint</span>&gt; endpoints, <span style="color: #2b91af">BindingParameterCollection </span>bindingParameters)
    {
    }

    <span style="color: blue">public void </span>Validate(<span style="color: #2b91af">ServiceDescription </span>serviceDescription, <span style="color: #2b91af">ServiceHostBase </span>serviceHostBase)
    {
    }
}
</pre>

[](http://11011.net/software/vspaste)

For all of the endpoints in all of the channels, we need to give WCF our custom instance provider.&nbsp; Also, since StructureMap needs to know what type to create, we have to pass that information along to our instance provider.&nbsp; This comes from the ServiceDescription passed in above.

With our service behavior done, let&#8217;s create the actual instance provider, which will call StructureMap:

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

Pretty straightforward, we just capture the service type (passed in from our service behavior earlier), then use ObjectFactory to create an instance of that service when asked.&nbsp; There&#8217;s no information on the InstanceContext about the service type, or we could have just used it instead.

Now that we have our IInstanceProvider and IServiceBehavior, it&#8217;s time to hook up this new service behavior to the rest of WCF.&nbsp; We have a few choices:

  * Attributes
  * Custom service host
  * Configuration

With attributes, we&#8217;d decorate all of our services with something like [StructureMapServiceBehavior] or something similar, so that WCF would know to attach our IServiceBehavior to the ServiceDescription behaviors.&nbsp; Attributes are okay, but again, we&#8217;d have to put something on all of our services.&nbsp; Since the whole point of this exercise was to reduce the footprint, let&#8217;s go the custom service host route.

As for configuration, I can&#8217;t stand XML, so let&#8217;s just pretend that one doesn&#8217;t exist.

### A custom service host

By going the custom ServiceHost route, we&#8217;ll just need to plug in to the right event to add our custom service behavior to the mix.&nbsp; Here&#8217;s what we wind up creating:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">StructureMapServiceHost </span>: <span style="color: #2b91af">ServiceHost
</span>{
    <span style="color: blue">public </span>StructureMapServiceHost()
    {
    }

    <span style="color: blue">public </span>StructureMapServiceHost(<span style="color: #2b91af">Type </span>serviceType, <span style="color: blue">params </span><span style="color: #2b91af">Uri</span>[] baseAddresses)
        : <span style="color: blue">base</span>(serviceType, baseAddresses)
    {
    }

    <span style="color: blue">protected override void </span>OnOpening()
    {
        Description.Behaviors.Add(<span style="color: blue">new </span><span style="color: #2b91af">StructureMapServiceBehavior</span>());
        <span style="color: blue">base</span>.OnOpening();
    }
}
</pre>

[](http://11011.net/software/vspaste)

Nothing too exciting, we just add our custom service behavior to the ServiceDescription Behaviors collection, right before the service host is opened in the OnOpening method.

Next, to plug in our custom service host, we&#8217;ll need a custom service host factory:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">StructureMapServiceHostFactory </span>: <span style="color: #2b91af">ServiceHostFactory
</span>{
    <span style="color: blue">public </span>StructureMapServiceHostFactory()
    {
        <span style="color: #2b91af">StructureMapConfiguration
            </span>.ScanAssemblies()
            .IncludeTheCallingAssembly()
            .With&lt;<span style="color: #2b91af">DefaultConventionScanner</span>&gt;();
    }

    <span style="color: blue">protected override </span><span style="color: #2b91af">ServiceHost </span>CreateServiceHost(<span style="color: #2b91af">Type </span>serviceType, <span style="color: #2b91af">Uri</span>[] baseAddresses)
    {
        <span style="color: blue">return new </span><span style="color: #2b91af">StructureMapServiceHost</span>(serviceType, baseAddresses);
    }
}
</pre>

[](http://11011.net/software/vspaste)

The overridden method makes sense, override the CreateServiceHost to&#8230;create our custom service host.&nbsp; However, there&#8217;s quite a bit going on in the constructor.

At this point, it will start to matter how you&#8217;d like StructureMap to be configured:

  * Attributes
  * XML config
  * Code

I&#8217;m liking the code way, as we don&#8217;t have to have crazy XML or a bunch of attributes everywhere.&nbsp; Which way you configure is up to you, but if you go the code route, you&#8217;ll need to put the StructureMap configuration in the constructor here.

Finally, we&#8217;ll need to configure our WCF service to use this service host factory.&nbsp; I&#8217;m using IIS to host, so I&#8217;ll just need to change my .svc file:

<pre><span style="background: #ffee62">&lt;%</span><span style="color: blue">@ </span><span style="color: #a31515">ServiceHost </span><span style="color: red">Language</span><span style="color: blue">="C#" </span><span style="color: red">Debug</span><span style="color: blue">="true" 
    </span><span style="color: red">Service</span><span style="color: blue">="SMExample.Wcf.CustomerSearchService" 
    </span><span style="color: red">Factory</span><span style="color: blue">="SMExample.Wcf.StructureMapServiceHostFactory" </span><span style="background: #ffee62">%&gt;
</span></pre>

[](http://11011.net/software/vspaste)

Other hosting solutions will use different ways of using the custom service host factory.

### Recap

We wanted to use StructureMap with WCF, but this initially presented us with some problems.&nbsp; WCF requires a no-args constructor, which means we&#8217;ll have to use a lot of ObjectFactory.GetInstance calls on every service implementation.

Instead, we can use WCF extension points to use StructureMap to create the service for us, without needing that messy constructor.&nbsp; We created two extensions:

  * IInstanceProvider
  * IServiceBehavior

Once we had our custom instance provider and service behavior, we needed to decide how our custom service behavior would get attached to our service.&nbsp; We chose the custom service host route, which meant two more custom WCF implementations:

  * ServiceHost
  * ServiceHostFactory

The ServiceHostFactory implementation forced us to decide how our dependencies should be configured in StructureMap, and we went the code route.&nbsp; Finally, we configured our service host in IIS to use the right service host factory.

With all this in place, none of our service classes nor their implementations need to know anything about StructureMap, allowing their design to grow and change outside of WCF construction concerns.&nbsp; We also reduced the footprint of StructureMap in our application, where we now had exactly one call to the StructureMap infrastructure, ObjectFactory.GetInstance.&nbsp; With this one place StructureMap is used, it will be easier to swap out IoC container implementations (just kidding, [Jeremy](http://codebetter.com/blogs/jeremy.miller/)).