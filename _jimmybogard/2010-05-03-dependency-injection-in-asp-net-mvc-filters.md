---
wordpress_id: 405
title: 'Dependency Injection in ASP.NET MVC: Filters'
date: 2010-05-03T16:51:31+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/05/03/dependency-injection-in-asp-net-mvc-filters.aspx
dsq_thread_id:
  - "264829959"
categories:
  - ASPNETMVC
  - DependencyInjection
---
So far, we’ve looked at extending the advantages of dependency injection to our [controllers](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/04/26/dependency-injection-in-asp-net-mvc-controllers.aspx) and [its various services](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/04/28/dependency-injection-in-asp-net-mvc-contextual-controller-injection.aspx).&#160; We started with a basic controller factory that merely instantiates controllers to one that takes advantage of the modern container feature of nested/child containers to provide contextual, scoped injection of services.&#160; With a child container, we can do things like scope a unit of work to a request, without needing to resort to an IHttpModule (and funky service location issues).

Having the nested container in place gives us a nice entry point for additional services that the base controller class builds up, including filters.&#160; Right after controllers, filters are one of the earliest extension points of ASP.NET MVC that we run into where we want to start injecting dependencies.

However, we quickly run into a bit of a problem.&#160; Out of the box, filters in ASP.NET MVC are instances of attributes.&#160; That means that we have absolutely no hook at all into the creation of our filter classes.&#160; If we have a filter that uses a logger implementation:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">LogErrorAttribute </span>: <span style="color: #2b91af">FilterAttribute</span>, <span style="color: #2b91af">IExceptionFilter
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ILogger </span>_logger;

    <span style="color: blue">public </span>LogErrorAttribute(<span style="color: #2b91af">ILogger </span>logger)
    {
        _logger = logger;
    }</pre>

[](http://11011.net/software/vspaste)

We’ll quickly find that our code using the attribute won’t compile.&#160; You then begin to see some rather heinous use of [poor man’s dependency injection](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/07/03/how-not-to-do-dependency-injection-in-nerddinner.aspx) to fill the dependencies.&#160; But we can do better, we can keep our dependencies inverted, without resorting to various flavors of service location or, even worse, poor man’s DI.

### Building Up Filters

We’ve already established that we do not have a window into the instantiation of filter attributes.&#160; Unless we come up with an entirely new way of configuring filters for controllers that doesn’t involve attributes, we still need a way to supply dependencies to already-built-up instances.&#160; Luckily for us, modern IoC containers already support this ability.

Instead of constructor injection for our filter attribute instance, we’ll use property injection instead:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">LogErrorAttribute </span>: <span style="color: #2b91af">FilterAttribute</span>, <span style="color: #2b91af">IExceptionFilter
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">ILogger </span>Logger { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }

    <span style="color: blue">public void </span>OnException(<span style="color: #2b91af">ExceptionContext </span>filterContext)
    {
        <span style="color: blue">var </span>controllerName = filterContext.Controller.GetType().Name;
        <span style="color: blue">var </span>message = <span style="color: blue">string</span>.Format(<span style="color: #a31515">"Controller {0} generated an error."</span>, controllerName);

        Logger.LogError(filterContext.Exception, message);
    }
}</pre>

[](http://11011.net/software/vspaste)

The LogErrorAttribute’s dependencies are exposed as properties, instead of through the constructor.&#160; Normally, I don’t like doing this.&#160; Property injection is usually reserved for optional dependencies, backed by the null object pattern.&#160; In our case, we don’t really have many choices.&#160; To get access to the piece in the pipeline that deals with filters, we’ll need to extend some behavior in the default ControllerActionInvoker:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">InjectingActionInvoker </span>: <span style="color: #2b91af">ControllerActionInvoker
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IContainer </span>_container;

    <span style="color: blue">public </span>InjectingActionInvoker(<span style="color: #2b91af">IContainer </span>container)
    {
        _container = container;
    }

    <span style="color: blue">protected override </span><span style="color: #2b91af">FilterInfo </span>GetFilters(
        <span style="color: #2b91af">ControllerContext </span>controllerContext, 
        <span style="color: #2b91af">ActionDescriptor </span>actionDescriptor)
    {
        <span style="color: blue">var </span>info = <span style="color: blue">base</span>.GetFilters(controllerContext, actionDescriptor);

        info.AuthorizationFilters.ForEach(_container.BuildUp);
        info.ActionFilters.ForEach(_container.BuildUp);
        info.ResultFilters.ForEach(_container.BuildUp);
        info.ExceptionFilters.ForEach(_container.BuildUp);

        <span style="color: blue">return </span>info;
    }
}</pre>

[](http://11011.net/software/vspaste)

In our new injecting action invoker, we’ll first want to take a dependency on an IContainer.&#160; This is the piece we’ll use to build up our filters.&#160; Next, we override the GetFilters method.&#160; We call the base method first, as we don’t want to change how the ControllerActionInvoker locates filters.&#160; Instead, we’ll go through each of the kinds of filters, calling our container’s BuildUp method.

The BuildUp method in StructureMap takes an already-constructed object and performs setter injection to push in configured dependencies into that object.&#160; We still need to manually configure the services to be injected, however.&#160; StructureMap will only use property injection on explicitly configured types, and won’t try just to fill everything it finds.&#160; Our new StructureMap registration code becomes:

<pre>For&lt;<span style="color: #2b91af">IActionInvoker</span>&gt;().Use&lt;<span style="color: #2b91af">InjectingActionInvoker</span>&gt;();
For&lt;<span style="color: #2b91af">ITempDataProvider</span>&gt;().Use&lt;<span style="color: #2b91af">SessionStateTempDataProvider</span>&gt;();
For&lt;<span style="color: #2b91af">RouteCollection</span>&gt;().Use(<span style="color: #2b91af">RouteTable</span>.Routes);

SetAllProperties(c =&gt;
{
    c.OfType&lt;<span style="color: #2b91af">IActionInvoker</span>&gt;();
    c.OfType&lt;<span style="color: #2b91af">ITempDataProvider</span>&gt;();
    c.WithAnyTypeFromNamespaceContainingType&lt;<span style="color: #2b91af">LogErrorAttribute</span>&gt;();
});</pre>

[](http://11011.net/software/vspaste)

We made two critical changes here.&#160; First, we now configure the IActionInvoker to use our InjectingActionInvoker.&#160; Next, we configure the SetAllProperties block to include any type in the namespace containing our LogErrorAttribute.&#160; We can then add all of our custom filters to the same namespace, and they will automatically be injected.

Typically, we have a few namespaces that our services are contained, so we don’t have to keep configuring this block too often.&#160; Unfortunately, StructureMap can’t distinguish between regular attribute properties and services, so we have to be explicit in what StructureMap should fill.

The other cool thing about our previous work with controller injection is that we don’t need to modify our controllers to get a new action invoker in place.&#160; Instead, we work with our normal DI framework, and the controller is unaware of how the IActionInvoker gets resolved, or which specific implementation is used.

Additionally, since our nested container is what’s resolved in our InjectedActionInvoker (StructureMap automatically resolves IContainer to itself, including in nested containers), we can use all of our contextual items in our filters.&#160; Although I would have preferred to use constructor injection on my filters, this design is a workable compromise that doesn’t force me to resort to less-than-ideal patterns such as global registries, factories, service location, or poor man’s DI.