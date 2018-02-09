---
wordpress_id: 402
title: 'Dependency Injection in ASP.NET MVC: Contextual controller injection'
date: 2010-04-28T12:57:41+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/04/28/dependency-injection-in-asp-net-mvc-contextual-controller-injection.aspx
dsq_thread_id:
  - "264716473"
categories:
  - ASPNETMVC
  - DependencyInjection
redirect_from: "/blogs/jimmy_bogard/archive/2010/04/28/dependency-injection-in-asp-net-mvc-contextual-controller-injection.aspx/"
---
In the last post, we looked at the basic DI usage in ASP.NET MVC – instantiating controllers.&#160; However, there are quite a few other things we can do with controllers besides merely instantiate them.&#160; One thing to keep in mind with the Controller base class is that although you can inject your controller’s dependencies, quite a few others are around via properties.

For example, the IActionInvoker and ITempDataProvider are two replaceable services the base Controller class uses to do its work, but to replace these items with your own behavior you usually need to rely on either an inheritance hierarchy or doing service location in a custom controller factory.

So why would you want to replace these items?&#160; For one, the IActionInvoker is basically the entire action execution pipeline, with all the filter usage and what not.&#160; If you wanted to extend this pipeline or change it, you’d want to replace the IActionInvoker (or extend the default ControllerActionInvoker).

I don’t like this all hard-wired in to the controller factory, because hey, that’s what a container is for!

### 

### Property injecting the remaining dependencies

If we want to supply the property-injected dependencies to our controllers, we first need to configure the container to supply the correct instances.&#160; With StructureMap, that’s pretty straightforward in our custom registry:

<pre>For&lt;<span style="color: #2b91af">IActionInvoker</span>&gt;().Use&lt;<span style="color: #2b91af">ControllerActionInvoker</span>&gt;();
For&lt;<span style="color: #2b91af">ITempDataProvider</span>&gt;().Use&lt;<span style="color: #2b91af">SessionStateTempDataProvider</span>&gt;();
For&lt;<span style="color: #2b91af">RouteCollection</span>&gt;().Use(<span style="color: #2b91af">RouteTable</span>.Routes);

SetAllProperties(c =&gt;
{
    c.OfType&lt;<span style="color: #2b91af">IActionInvoker</span>&gt;();
    c.OfType&lt;<span style="color: #2b91af">ITempDataProvider</span>&gt;();
});</pre>

[](http://11011.net/software/vspaste)

[](http://11011.net/software/vspaste)We first set up the implementations with the For..Use syntax.&#160; Next, we need to tell StructureMap to look for specific properties to inject, with the SetAllProperties method.&#160; We only want to set members of these two types, all others we’ll leave alone.&#160; The last For() method around the RouteCollection is important, we’ll use it in a bit for some of the various XyzHelper types.

With that configuration in place, we don’t have to touch our factories or our controllers to modify the property-injected services.&#160; We only need to modify our container configuration (which is the whole point of inversion of control).

### Nested containers for contextual objects

One of the more advanced features of modern IoC containers is the concept of nested containers.&#160; Nested containers are built from an existing container, but can be configured independently so that you can configure items that exist only for the context of that container instance.&#160; Because a nested container is built from an existing container, it inherits the configuration of the parent container.

With ASP.NET MVC, that means that many of the contextual items of a request can be configured to be injected for a controller’s services, as opposed to passed around everywhere.&#160; For example, the ControllerContext object is almost ubiquitous in the execution of a controller, and is found just about everywhere.

Instead of passing it around constantly (whether it’s needed or not), we can instead take the contextual objects as a constructor dependency, and configure our nested container to supply the correct contextual objects.&#160; So what kinds of things can we supply, on demand as needed?

  * RequestContext
  * HttpContextBase
  * ControllerContext

The last one is a bit tricky, as a ControllerContext is built from a Controller, so we can only supply a Func<ControllerContext>, to be used later.&#160; It might seem like a stretch, but it can be a lot easier to deal with a lazy dependency than dragging around the controller context everywhere we go.

So let’s look at how we’d create our controllers now:

<pre><span style="color: blue">protected override </span><span style="color: #2b91af">IController </span>GetControllerInstance(<span style="color: #2b91af">RequestContext </span>requestContext, <span style="color: #2b91af">Type </span>controllerType)
{
    <span style="color: blue">var </span>nestedContainer = _container.GetNestedContainer();

    requestContext.HttpContext.Items[_nestedContainerKey] = nestedContainer;

    <span style="color: #2b91af">ControllerBase </span>controllerBase = <span style="color: blue">null</span>;

    <span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">ControllerContext</span>&gt; ctxtCtor = () =&gt; controllerBase == <span style="color: blue">null </span>? <span style="color: blue">null </span>: controllerBase.ControllerContext;

    nestedContainer.Configure(cfg =&gt;
    {
        cfg.For&lt;<span style="color: #2b91af">RequestContext</span>&gt;().Use(requestContext);
        cfg.For&lt;<span style="color: #2b91af">HttpContextBase</span>&gt;().Use(requestContext.HttpContext);
        cfg.For&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">ControllerContext</span>&gt;&gt;().Use(ctxtCtor);
    });

    <span style="color: blue">var </span>controller = (<span style="color: #2b91af">IController</span>)nestedContainer.GetInstance(controllerType);

    controllerBase = controller <span style="color: blue">as </span><span style="color: #2b91af">ControllerBase</span>;

    <span style="color: blue">return </span>controller;
}</pre>

[](http://11011.net/software/vspaste)

We first create a nested container from the container passed in to our controller factory.&#160; Next, we stick the nested container instance into the HttpContext items, as we’ll need to dispose the container when we release the controller later.&#160; We build up a Func<ControllerContext> that supplies the ControllerContext from what’s built up from the ControllerBase class.&#160; Because we don’t have a good way to override that piece, I left it alone.

On the other side, we want to configure the ReleaseController method to dispose of our nested container:

<pre><span style="color: blue">public override void </span>ReleaseController(<span style="color: #2b91af">IController </span>controller)
{
    <span style="color: blue">var </span>controllerBase = controller <span style="color: blue">as </span><span style="color: #2b91af">Controller</span>;

    <span style="color: blue">if </span>(controllerBase != <span style="color: blue">null</span>)
    {
        <span style="color: blue">var </span>httpContextBase = controllerBase.ControllerContext.HttpContext;

        <span style="color: blue">var </span>nestedContainer = (<span style="color: #2b91af">IContainer</span>)httpContextBase.Items[_nestedContainerKey];

        <span style="color: blue">if </span>(nestedContainer != <span style="color: blue">null</span>)
            nestedContainer.Dispose();
    }

    <span style="color: blue">base</span>.ReleaseController(controller);
}</pre>

[](http://11011.net/software/vspaste)

The only change we need to do is pull the nested container our from the controller’s context items.&#160; The only strange piece I ran in to here is that the GetControllerInstance accepts a RequestContext, but I only have an IController to work with in the ReleaseController method.&#160; In any case, we pull out the nested container, and if it exists, dispose it.

### Using contextual items

To use our contextual items, we only need to make sure our controller depends on a service that uses them:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">HomeController </span>: <span style="color: #2b91af">Controller
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IFooService </span>_fooService;

    <span style="color: blue">public </span>HomeController(<span style="color: #2b91af">IFooService </span>fooService)
    {
        _fooService = fooService;
    }</pre>

[](http://11011.net/software/vspaste)

At construction time, HomeController is built with the nested container, which means all the contextual configuration rules will be used.&#160; That means our FooService implementation (and anything else it uses) can use any contextual item now, as long as it’s exposed as a dependency:

<pre><span style="color: blue">private readonly </span><span style="color: #2b91af">RequestContext </span>_requestContext;
<span style="color: blue">private readonly </span><span style="color: #2b91af">HttpContextBase </span>_httpContext;
<span style="color: blue">private readonly </span><span style="color: #2b91af">UrlHelper </span>_helper;
<span style="color: blue">private readonly </span><span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">ControllerContext</span>&gt; _context;

<span style="color: blue">public </span>FooService(
    <span style="color: #2b91af">RequestContext </span>requestContext,
    <span style="color: #2b91af">HttpContextBase </span>httpContext,
    <span style="color: #2b91af">UrlHelper </span>helper,
    <span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">ControllerContext</span>&gt; context
    )
{
    _requestContext = requestContext;
    _httpContext = httpContext;
    _helper = helper;
    _context = context;
}</pre>

[](http://11011.net/software/vspaste)

Note that third item.&#160; Because I’ve configured both RequestContext and RouteCollection, StructureMap is now able to build a UrlHelper as a dependency:

<pre><span style="color: blue">public </span>UrlHelper(<span style="color: #2b91af">RequestContext </span>requestContext, <span style="color: #2b91af">RouteCollection </span>routeCollection) {
    <span style="color: blue">if </span>(requestContext == <span style="color: blue">null</span>) {
        <span style="color: blue">throw new </span><span style="color: #2b91af">ArgumentNullException</span>(<span style="color: #a31515">"requestContext"</span>);
    }
    <span style="color: blue">if </span>(routeCollection == <span style="color: blue">null</span>) {
        <span style="color: blue">throw new </span><span style="color: #2b91af">ArgumentNullException</span>(<span style="color: #a31515">"routeCollection"</span>);
    }
    RequestContext = requestContext;
    RouteCollection = routeCollection;
}</pre>

[](http://11011.net/software/vspaste)

Having these request items around is nice, especially if you want to do things like generate URLs based on the current request context and routes, but don’t want to pass around the helper objects everywhere.&#160; With a nested container, you can configure items in the container that are only resolved for that container instance, giving you the ability to depend on any one of the typical context objects created during a request.

This is a bit more advanced usage of a container, and you can begin to see why we can’t use things like Common Service Locator in this instance.&#160; For a while, the differentiating factor in IoC containers was their registration abilities.&#160; These days, even object resolution is different among containers, with things like nested/child containers, instance swapping, auto-factories, Lazy<T> and Owned<T> support, Func<T> support and so on.

Next, we’ll look at some of the other items the Controller class new’s up and completely remove the service location/opaque dependencies inherent in the design of the ControllerBase class.