---
wordpress_id: 385
title: 'Advanced StructureMap: Diagnosing problems'
date: 2010-01-22T04:21:31+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/01/21/advanced-structuremap-diagnosing-problems.aspx
dsq_thread_id:
  - "264756197"
categories:
  - StructureMap
redirect_from: "/blogs/jimmy_bogard/archive/2010/01/21/advanced-structuremap-diagnosing-problems.aspx/"
---
So you’ve set up StructureMap, got all your registries in a row, go to run the application, and you’re greeted by a rather unfortunate message:

<pre>StructureMap.StructureMapException : StructureMap Exception Code:  202
No Default Instance defined for PluginFamily</pre>

[](http://11011.net/software/vspaste)

That’s just _one_ of the issues we can run into.&#160; If you’re doing more advanced things like nested containers, lifecycle management, external plugin folders for dynamic loading, you’re bound to run into binding and other bugs at runtime.&#160; One of the things I like about StructureMap over other containers I’ve tried is the level of support for diagnosis, configuration validation, and testing.

When using any configuration tool, whether it’s IoC container configuration, Web.config or other persistent mechanism for application configuration, you _will_ run into problems.&#160; The first step to diagnosing issues is to write tests.

### Testing StructureMap configuration

The easiest way to test your StructureMap configuration is to use the ObjectFactory.AssertConfigurationIsValid() method in a test:

<pre><span style="color: #2b91af">ObjectFactory</span>.Initialize(init =&gt;
{
    init.AddRegistry&lt;<span style="color: #2b91af">HandlerRegistry</span>&gt;();
});

<span style="color: #2b91af">ObjectFactory</span>.AssertConfigurationIsValid();</pre>

[](http://11011.net/software/vspaste)

Internally, StructureMap will loop through all of your registered instances and try to instantiate them.&#160; This can catch 99% of your registration problems, as you might have forgotten a registry somewhere or an instance isn’t defined for something.&#160; The key to remember is that **StructureMap can only validate plugin types it knows about.**&#160; Just like AutoMapper, it can’t divine all the ways you’re using ObjectFactory.GetInstance() in your codebase.&#160; So typically, AssertConfigurationIsValid() is our first line of defense.

The next way to test is for specific registries.&#160; Suppose we’ve defined some custom registry:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">HandlerRegistry </span>: <span style="color: #2b91af">Registry
    </span>{
        <span style="color: blue">public </span>HandlerRegistry()
        {
            Scan(cfg =&gt;
            {
                <span style="color: green">// etc
</span></pre>

[](http://11011.net/software/vspaste)

If we have some custom registration logic (very likely), then we can then test that registry _in isolation_ from the rest of our configuration.&#160; This is what I do when I’m doing lots of meta-programming to hook up open generic types of things, and in general building highly de-coupled, SOLID stuff 😉

> _Side note: things like [ConnectImplementationsToTypesClosing()](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/12/17/advanced-structuremap-connecting-implementations-to-open-generic-types.aspx) should be **built in** to every IoC container registration.&#160; It’s one of the things I can point to on our current project and say, “that enabled some of our success”.&#160; If we had to register/build these things manually, we wouldn’t have tried to build the architecture we wound up doing, which let us scale our development very easily._

To test a single registry in isolation, you simply need a Container object:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_connect_delete_handler_by_registry()
{
    <span style="color: blue">var </span>container = <span style="color: blue">new </span><span style="color: #2b91af">Container</span>(<span style="color: blue">new </span><span style="color: #2b91af">HandlerRegistry</span>());

    <span style="color: blue">var </span>handler = container.GetInstance&lt;<span style="color: #2b91af">IHandler</span>&lt;<span style="color: #2b91af">DeleteEntityCommand</span>&lt;<span style="color: #2b91af">Customer</span>&gt;&gt;&gt;();

    handler.ShouldBeInstanceOf&lt;<span style="color: #2b91af">DeleteEntityCommandHandler</span>&lt;<span style="color: #2b91af">Customer</span>&gt;&gt;();
}</pre>

[](http://11011.net/software/vspaste)

I instantiate a new Container object, but I pass in the instance of my custom registry.&#160; From there, I can then use the Container directly to get an instance.&#160; With registry-specific tests, I can ensure some of my more complex (and insanely powerful) registration is hooked up correctly.&#160; If you’re using a container beyond just hooking up Foo to IFoo, I highly recommend doing registry-specific testing.&#160; It’s much easier to test-drive a registry in isolation than it is to try and catch things at runtime.

### Popping open the hood

Sometimes, you’ll get a “No default instance defined” exception, and in those cases, it’s best to just pop open the hood of StructureMap, and see what do I have?

<pre><span style="color: #2b91af">ObjectFactory</span>.Initialize(init =&gt;
{
    init.AddRegistry&lt;<span style="color: #2b91af">HandlerRegistry</span>&gt;();
});

<span style="color: #2b91af">Debug</span>.WriteLine(<span style="color: #2b91af">ObjectFactory</span>.WhatDoIHave());</pre>

[](http://11011.net/software/vspaste)

Wow, there’s a method, “WhatDoIHave()”.&#160; It’s on both ObjectFactory, and Container (ObjectFactory is merely a wrapper around a Container object).&#160; This method returns a nicely formatting string showing everything in our container:

<pre>=======================================================================================
PluginType                                                                             
---------------------------------------------------------------------------------------
IHandler`1&lt;DeleteEntityCommand`1&lt;TEntity&gt;&gt; (IHandler`1&lt;DeleteEntityCommand`1&lt;TEntity&gt;&gt;)
Scoped as:  String</pre>

[](http://11011.net/software/vspaste)

Well, there’s a _lot_ more information here, but it basically lists out each registered plugin type and configured instances.&#160; If you see a blank in the configured instances, that’s something that is registered, but doesn’t have a concrete instance.

### Lifecycle issues

One of the major features of modern IoC containers is the ability to provide lifecycle management.&#160; This means that we can use our container to control the lifetime of our instance, singleton, per-request, HttpContext, etc. etc.&#160; That’s an extremely powerful tool, but one that cuts very, very deep if it’s not hooked up right.&#160; Unfortunately, it’s also not one that’s easy or even possible to unit test in some cases.&#160; Lifecycle configuration in your container is application behavior, and like things such as web.config, config stored in DB, external XML configuration etc. can only really be verified with the whole app up and going.

Before understanding lifecycle issues, **it’s critical that you _fully understand_ the lifecycle of the code calling ObjectFactory/Container.GetInstance()**.&#160; Whenever I’ve had problems with lifecycle, it’s because I just misunderstood, didn’t understand, or was completely ignorant of the thread lifecycle of whatever was trying to build my lifecycle-configured instance.&#160; My WCF understanding was wrong, and my hand-coded lifecycle management totally screwed up things that were found only after it went to production.&#160; It’s really no different than if you wanted to start storing things in a static cache, but now need to deal with multiple threads, who gets what instance, and so on.

So back to debugging lifecycle issues.&#160; In practice, when things don’t work, I do a healthy dose of logging + GetHashCode() to put out messages showing exactly what gets what instance.&#160; About a year ago, I had to debug a gnarly lifecycle problem.&#160; One thing I found is that it gets much, much harder if you’re instantiating things yourself and get away from DI however, as some old code we had put too many moving parts into play, making it that much harder to understand what came from where.&#160; So my preference is to push as much instantiation into the container as you can.&#160; That said, it’s not for everyone, so you’ll have to decide how much magic juju you’re comfortable with.

That aside, here’s an example of what I like to do:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DeleteCustomerCommandHandler </span>: <span style="color: #2b91af">IHandler</span>&lt;<span style="color: #2b91af">DeleteCustomerCommand</span>&gt;
{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICustomerRepository </span>_customerRepository;

    <span style="color: blue">public </span>DeleteCustomerCommandHandler(<span style="color: #2b91af">ICustomerRepository </span>customerRepository)
    {
        <span style="color: #2b91af">Debug</span>.WriteLine(<span style="color: #a31515">"Received instance of ICustomerRepository in DeleteCustomerCommandHandler: " 
            </span>+ customerRepository.GetHashCode());
        _customerRepository = customerRepository;
    }</pre>

[](http://11011.net/software/vspaste)

It’s a primitive tool, but I use it to both build and debug lifecycle issues.&#160; It could be Debug, or it could be any logger or whatever to be able to see basically the instance ID from GetHashCode().&#160; I would see log messages of mismatched hash codes, things being instantiated more than I thought they should, and so on.&#160; Whenever I had lifecycle issues, it was because the instantiator had one lifecycle, and the plugin type had another conflicting lifecycle configuration.

Now, this is just _my_ way of debugging lifecycle issues.&#160; If there’s some other ways of doing so, I’d love to hear about it.&#160; I’m pretty sure this could be done also with AOP/profiling tools too.

### Wrapping it up

IoC containers are magic juju boxes.&#160; But they don’t have to be, if you have the right tools to test and diagnose problems.&#160; If you do wind up drinking the container kool-aid, be prepared to have something go wrong at some time.&#160; Like other sharp tools, it can really destroy a lot of time if you don’t have a good plan for diagnosing these issues.&#160; And if nothing works, you can always go to the mailing list of your respected project (as long as your project is active and OSS for the most part) for some free help.