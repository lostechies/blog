---
wordpress_id: 331
title: How not to do Dependency Injection, in NerdDinner
date: 2009-07-03T16:19:29+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/07/03/how-not-to-do-dependency-injection-in-nerddinner.aspx
dsq_thread_id:
  - "264716204"
categories:
  - ASPNETMVC
  - Refactoring
  - StructureMap
redirect_from: "/blogs/jimmy_bogard/archive/2009/07/03/how-not-to-do-dependency-injection-in-nerddinner.aspx/"
---
Checking out the [NerdDinner](http://nerddinner.codeplex.com/) code the other day, I found a common Dependency Injection anti-pattern.&#160; One of the core concepts of DI is that components are not responsible for locating their own dependencies.&#160; The code went part of the way to full-on DI, but not quite far enough.&#160; Here’s the offending code:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">SearchController </span>: <span style="color: #2b91af">Controller </span>{

<span style="color: #2b91af">IDinnerRepository </span>dinnerRepository;

<span style="color: green">//
// Dependency Injection enabled constructors

</span><span style="color: blue">public </span>SearchController()
    : <span style="color: blue">this</span>(<span style="color: blue">new </span><span style="color: #2b91af">DinnerRepository</span>()) {
}

<span style="color: blue">public </span>SearchController(<span style="color: #2b91af">IDinnerRepository </span>repository) {
    dinnerRepository = repository;
}</pre>

[](http://11011.net/software/vspaste)

The second constructor is correct – the SearchController’s dependencies are passed in through the constructor.&#160; This is because the IDinnerRepository is a required, or primal dependency.&#160; SearchController depends on IDinnerRepository to function properly, and won’t work without it.&#160; But on the first constructor, we violate DI by having the SearchController create a concrete DinnerRepository!&#160; We’re now back to concrete, opaque dependencies.&#160; We have a small benefit of easier testability, but we still force our controller to locate its own dependencies.

So why is this a Bad Thing?

For one, it’s confusing to have two constructors.&#160; Why go through all the trouble of creating the IDinnerRepository interface if I’m just going to depend directly on an implementer?&#160; Now what if DinnerRepository now needs some dependency?&#160; What if it now needs some ILogger, security or policy dependency?&#160; Do I now need to go fix all of my calls to “new”?

And that’s the whole point of Dependency Injection, and the Dependency Inversion Principle.&#160; I only know about my first level dependencies, and abstractions on top of that.&#160; If we check out DinnerRepository, we see another issue:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DinnerRepository </span>: NerdDinner.Models.<span style="color: #2b91af">IDinnerRepository </span>{

    <span style="color: #2b91af">NerdDinnerDataContext </span>db = <span style="color: blue">new </span><span style="color: #2b91af">NerdDinnerDataContext</span>();</pre>

[](http://11011.net/software/vspaste)

A private, opaque dependency to NerdDinnerDataContext.&#160; If we wanted to make that opaque dependency explicit, we’d have to fix our SearchController (and all the other controllers as well).&#160; It’s these kinds of ripple effects that prevent refactoring and improvement.

### 

### Fixing it

But we can fix this, quite easily.&#160; From [MvcContrib](http://www.codeplex.com/MVCContrib), we can grab any one of the ControllerFactory implementations for the IoC container of our choice.&#160; For me, that’s [StructureMap](http://structuremap.sourceforge.net/Default.htm).&#160; First, we’ll need to configure StructureMap to wire up all of our dependencies.&#160; The preferred way to do so is to create a Registry:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">NerdDinnerRegistry </span>: <span style="color: #2b91af">Registry
</span>{
    <span style="color: blue">public </span>NerdDinnerRegistry()
    {
        Scan(scanner =&gt;
        {
            scanner.TheCallingAssembly();
            scanner.WithDefaultConventions();
        });

        ForRequestedType&lt;<span style="color: #2b91af">NerdDinnerDataContext</span>&gt;()
            .CacheBy(<span style="color: #2b91af">InstanceScope</span>.HttpContext)
            .TheDefault.Is.ConstructedBy(() =&gt; <span style="color: blue">new </span><span style="color: #2b91af">NerdDinnerDataContext</span>());
    }
}</pre>

[](http://11011.net/software/vspaste)

In the first part, we just tell StructureMap to scan the calling assembly with default conventions.&#160; This will wire up IDinnerRepository to DinnerRepository.&#160; Probably 99% of our dependencies will be taken care of in that one call.&#160; Next, we need to wire up the NerdDinnerDataContext (for reasons we’ll see soon).&#160; Since that class has multiple constructors, StructureMap likes to use the greediest dependency, with the most arguments.&#160; I don’t want that, so I override it to use the no-arg constructor.&#160; Finally, I cache it by HttpContext, though I could probably go Singleton if it’s expensive to instantiate.

Next, I need a wrapper class to initialize StructureMap:

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">IoCContainer
</span>{
    <span style="color: blue">public static void </span>Configure()
    {
        <span style="color: #2b91af">ObjectFactory</span>.Initialize(init =&gt;
        {
            init.AddRegistry&lt;<span style="color: #2b91af">NerdDinnerRegistry</span>&gt;();
        });
    }
}</pre>

[](http://11011.net/software/vspaste)

Initialize only needs to get called once per AppDomain, and all I need to do is add the NerdDinnerRegistry I created earlier.&#160; I _could_ wire up everything here, but again, the preferred configuration method is through registries.&#160; The next piece is to wire up ASP.NET MVC to both call our configuration method and use the StructureMapControllerFactory:

<pre><span style="color: blue">void </span>Application_Start()
{
    RegisterRoutes(<span style="color: #2b91af">RouteTable</span>.Routes);

    <span style="color: #2b91af">IoCContainer</span>.Configure();
    <span style="color: #2b91af">ControllerBuilder</span>.Current.SetControllerFactory(<span style="color: blue">new </span><span style="color: #2b91af">StructureMapControllerFactory</span>());

    <span style="color: #2b91af">ViewEngines</span>.Engines.Clear();
    <span style="color: #2b91af">ViewEngines</span>.Engines.Add(<span style="color: blue">new </span><span style="color: #2b91af">MobileCapableWebFormViewEngine</span>());
}</pre>

[](http://11011.net/software/vspaste)

I put all this in with the other MVC configuration in the Global.asax Application_Start method.&#160; One final piece is to remove the extra constructors on our controller:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DinnersController </span>: <span style="color: #2b91af">Controller </span>{

    <span style="color: #2b91af">IDinnerRepository </span>dinnerRepository;

    <span style="color: green">//
    // Dependency Injection enabled constructors

    </span><span style="color: blue">public </span>DinnersController(<span style="color: #2b91af">IDinnerRepository </span>repository) {
        dinnerRepository = repository;
    }</pre>

[](http://11011.net/software/vspaste)

And make our DinnerRepository expose its dependencies explicitly:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DinnerRepository </span>: NerdDinner.Models.<span style="color: #2b91af">IDinnerRepository </span>{
    
    <span style="color: blue">private readonly </span><span style="color: #2b91af">NerdDinnerDataContext </span>db;

    <span style="color: blue">public </span>DinnerRepository(<span style="color: #2b91af">NerdDinnerDataContext </span>db)
    {
        <span style="color: blue">this</span>.db = db;
    }</pre>

[](http://11011.net/software/vspaste)

Note that there are no no-arg constructors to be found!&#160; When StructureMap creates a DinnersController, it will look to resolve the IDinnerRepository dependency.&#160; That’s a DinnerRepository, which in turn needs the NerdDinnerDataContext.&#160; But that’s all hidden from us, we never need to wire up an entire graph, as we would if we stuck to the “new” operator.&#160; Just to make sure everything works, I can navigate to view upcoming dinners:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_34149D1D.png" width="644" height="437" />](http://lostechies.com/jimmybogard/files/2011/03/image_411EA2FB.png) 

## 

### Wrapping it up

In the original NerdDinner code, dependency inversion was only partially implemented as the original controllers still contained a constructor that called a constructor of a concrete class.&#160; To fix this, we added StructureMap to the mix, configuring ASP.NET MVC to use StructureMap to create controllers instead of the default controller factory.&#160; Finally, we pushed the dependency inversion principle all the way down to our repository, removing the opaque dependencies where we found them.&#160; When we finished, all of our classes exposed their dependencies explicitly through their constructor.&#160; No one class knew more than one level of depth, and our controllers now properly depended exclusively on the IDinnerRepository abstraction.

In the future, we can add things like logging, policies and the like to custom IDinnerRepository implementations, without needing to change any of our controllers.&#160; Once we introduce inversion of control to our application, we open a lot of doors for functionality and simplicity, but only going halfway won’t give us the full benefit.