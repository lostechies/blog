---
wordpress_id: 401
title: 'Dependency Injection in ASP.NET MVC: Controllers'
date: 2010-04-27T03:03:39+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/04/26/dependency-injection-in-asp-net-mvc-controllers.aspx
dsq_thread_id:
  - "264716458"
categories:
  - ASPNETMVC
  - DependencyInjection
redirect_from: "/blogs/jimmy_bogard/archive/2010/04/26/dependency-injection-in-asp-net-mvc-controllers.aspx/"
---
After working for 5 years with WebForms, it was quite a breath of fresh air to deal with simple controllers and actions with MVC.&#160; Even better was that there is support for IoC containers built in to the framework.

However, support for dependency injection does not run very deep in an explicit manner, and some work is required to get your container to take as much control as possible over locating instances of objects.

Dependency injection is one of the most powerful tools in any advanced developer’s toolkit.&#160; The ability to remove the responsibility of instantiating, locating and controlling lifecycle of dependencies both **promotes good OO design and opens entirely new avenues of architecture that weren’t feasible before**.

But to get started, DI needs to start at the topmost layer of your application, ideally the entry point through which everything else flows.&#160; Unfortunately for us using ASP.NET MVC, there are several entry points, several of which are exposed, several of which are not.

Luckily for us, it’s still possible to ensure that we try and **banish the “new” operator for instantiating services as much as possible**.&#160; Once we do, those new doors open up to a potentially much more powerful design.

First things first, we need to tackle our first entry point: controllers

### The built-in controller factory

ASP.NET MVC uses a specific interface to control lifecycle of a controller, IControllerFactory:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IControllerFactory </span>{
    <span style="color: #2b91af">IController </span>CreateController(
        <span style="color: #2b91af">RequestContext </span>requestContext, 
        <span style="color: blue">string </span>controllerName);
    <span style="color: blue">void </span>ReleaseController(<span style="color: #2b91af">IController </span>controller);
}</pre>

[](http://11011.net/software/vspaste)

One interesting piece to note here is that this interface includes both the instantiation and releasing of the controller instance.&#160; We’ll dive into some interesting applications of this in a future post, but we’ll just leave it alone for now.&#160; The built-in controller factory is the DefaultControllerFactory class, which provides some simple out-of-the-box behavior for instantiation:

<pre><span style="color: blue">return </span>(<span style="color: #2b91af">IController</span>)<span style="color: #2b91af">Activator</span>.CreateInstance(controllerType);</pre>

[](http://11011.net/software/vspaste)

and releasing:

<pre><span style="color: blue">public virtual void </span>ReleaseController(<span style="color: #2b91af">IController </span>controller) {
    <span style="color: #2b91af">IDisposable </span>disposable = controller <span style="color: blue">as </span><span style="color: #2b91af">IDisposable</span>;
    <span style="color: blue">if </span>(disposable != <span style="color: blue">null</span>) {
        disposable.Dispose();
    }
}</pre>

[](http://11011.net/software/vspaste)

There’s some other behavior in there, as it provides a virtual member to retrieve a controller by type instead of by name (which is just a string).&#160; Since the DefaultControllerFactory provides this string –> System.Type work for us, we’ll just use it.&#160; But instead of the familiar Activator.CreateInstance call, we’ll use our container.

### Service-located controllers

Service location is bad…just about 99% of the time.&#160; But **service location has to happen _somewhere_**, and it’s ideally at the entry point of our application.&#160; We’ll need to use service location for our controller factory, but that doesn’t mean we can’t still have some control over what gets used.

First, we’ll create our own custom controller factory, and inherit from DefaultControllerFactory.&#160; One minor addition is that we’ll still supply the container use to our controller factory (using StructureMap in this example):

<pre><span style="color: blue">public class </span><span style="color: #2b91af">StructureMapControllerFactory </span>: <span style="color: #2b91af">DefaultControllerFactory
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IContainer </span>_container;

    <span style="color: blue">public </span>StructureMapControllerFactory(<span style="color: #2b91af">IContainer </span>container)
    {
        _container = container;
    }</pre>

[](http://11011.net/software/vspaste)

Once we have our container, we can now use it to override the GetControllerInstance method:

<pre><span style="color: blue">protected override </span><span style="color: #2b91af">IController </span>GetControllerInstance(
    <span style="color: #2b91af">RequestContext </span>requestContext, <span style="color: #2b91af">Type </span>controllerType)
{
    <span style="color: blue">if </span>(controllerType == <span style="color: blue">null</span>)
        <span style="color: blue">return null</span>;

    <span style="color: blue">return </span>(<span style="color: #2b91af">IController</span>)_container.GetInstance(controllerType);
}</pre>

[](http://11011.net/software/vspaste)

We’ll leave the ReleaseController method alone (for now).&#160; Finally, we just need to configure our controller factory in the global.asax implementation in Application_Start:

<pre><span style="color: blue">var </span>controllerFactory = <span style="color: blue">new </span><span style="color: #2b91af">StructureMapControllerFactory</span>(<span style="color: #2b91af">ObjectFactory</span>.Container);

<span style="color: #2b91af">ControllerBuilder</span>.Current.SetControllerFactory(controllerFactory);</pre>

[](http://11011.net/software/vspaste)

You’ll just need to make sure you configure your container before instantiating the controller factory.&#160; So why pass in the container?&#160; I can’t stand service location, as it’s a big roadblock to a lot of other interesting techniques.&#160; Because I pass in the container to the controller factory, I now remove the responsibility of the controller factory of figuring out where to get the container.

So why not use something like [Common Service Locator](http://commonservicelocator.codeplex.com/) instead of using a container-specific interface?&#160; Isn’t that coupling myself to a specific library?&#160; What about depending on abstractions?

**Common Service Locator is pretty much useless**.&#160; It’s very limiting in its interface, and only supports the least common denominator among the different containers out there.&#160; Additionally, we’ll be using some of the more powerful features in modern containers soon, and just having the simple “GetInstance<T>” method won’t be enough for what we’re looking for.

In the next post, we’ll integrating some more advanced usages of injection with our controllers, to gain control over the myriad of helper objects used throughout the controller lifecycle.