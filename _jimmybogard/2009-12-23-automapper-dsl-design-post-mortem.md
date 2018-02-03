---
wordpress_id: 378
title: AutoMapper DSL design post-mortem
date: 2009-12-23T05:28:32+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/12/23/automapper-dsl-design-post-mortem.aspx
dsq_thread_id:
  - "264716384"
categories:
  - AutoMapper
---
As I move towards the 1.0 release of AutoMapper, I’m already running in to things I wish I had done differently.&#160; I still will probably fix all of these eventually, but none of these design issues should prevent a release, especially since it’s not any public functionality.&#160; A lot of it came from trying out designs in the open, but it can be difficult to change direction once it’s out in the open and in production.&#160; The Fluent NHibernate guys have changed their API quite a bit up to release, for better or worse, and I wasn’t too keen to follow that same path.

That said, in no particular order:

### Static gateway

Everything in AutoMapper drives through a static class, “Mapper”.&#160; Both configuration and the mapping engine can be accessed through this one class, so you have a responsibility of:

  * Configuring the global settings
  * Configuring individual mappings
  * Performing mappings
  * Managing configuration and mapping engine instances

The first three are too much for one class, but it’s the last one that’s gotten me into the most trouble.&#160; Writing thread-safe code is hard, and I’ve had to rely on bug reports from the field to make sure it works correctly in a multi-threaded environment.&#160; This design mostly came from inspiration from StructureMap, unbeknownst to me that its creators had already ditched this design (even though its creator works in the same town :P).&#160; I had already been warned by my boss, [Jeffrey](http://jeffreypalermo.com/), to ditch the static-central design.

I did eventually ditch it, but only to create a static facade.&#160; Instead, I should have gone the NHibernate route for configuration, where configuration objects are just regular objects, and it’s up to you to decide how you want these things to stick around.&#160; In the future, I’m thinking of obsoleting the public static methods and going more of the NHibernate route, where you use the configuration object as a factory object to create the engine.

### Ad-hoc versus nested closure for configuration

If you check out Fluent NHibernate, a configuration object is created through a [nested closure](http://www.martinfowler.com/dslwip/NestedClosure.html):

<pre><span style="color: blue">return </span><span style="color: #2b91af">Fluently</span>.Configure(configuration)
    .Mappings(cfg =&gt;
    {
        cfg.HbmMappings.AddFromAssemblyOf&lt;<span style="color: #2b91af">Customer</span>&gt;();
        cfg.FluentMappings.AddFromAssemblyOf&lt;<span style="color: #2b91af">Customer</span>&gt;();
    }).BuildConfiguration();</pre>

[](http://11011.net/software/vspaste)

See that whole lambda block with the “cfg” object?&#160; That’s a nested closure.&#160; What’s nice about that pattern is that it allows me to collect all the configuration, basically record it, and then act upon after you’re done.&#160; Compare it to “Mapper.CreateMap”, I don’t know when you’re done creating mappings.

One other thing Fluent NHibernate does is that it actually returns the configuration object, for you to do what you want with it.&#160; Because NHibernate needs to support all sorts of deployment scenarios, they’ve basically left it up to you to manage that instance as you want.&#160; For most installations, Configuration (and SessionFactory) is static/singleton.&#160; The same applies to the corresponding AutoMapper objects, except I’ve put in code to manage these internal objects, that I’d _love_ to delete.

Not to mention that I could pre-optimize all of the mapping algorithms at the end of the configuration operation, making things speedy from the get-go.&#160; With [method chaining](http://martinfowler.com/dslwip/MethodChaining.html), you never really know that a configuration operation is finished, unless you put in some hokey “Finalize()” method or something.

### Semantic model design

In an internal DSL, the [semantic model](http://martinfowler.com/dslwip/SemanticModel.html) is basically the domain model of the DSL.&#160; To simplify things early, I let the population model be the same as the operational model.&#160; That is, when you call methods in the configuration operations of AutoMapper, you’re literally setting up the configuration objects.&#160; This works for simple scenarios, but you can run into problems later.&#160; For example, if you don’t make the piece setting up the “ConstructServicesWith” in AutoMapper as basically the first thing, your subsequent setup won’t get this configuration.

With a combined operational/population model, it makes it impossible to perform a better two-step configuration process, where you first record the configuration, and then apply it in the right order to the operational model.&#160; Luckily, I used explicit interface implementation to not bleed the two APIs publicly, but all my configuration objects implement both a population and operational interface.

It’s a subtle thing, but moving towards a nested closure model for creating configuration (as already exists in a limited form with AutoMapper.Initialize) makes doing a separated population/operation model a much stronger proposition.

### The wacky Configure method on Profile

It’s wacky, and was already recognized as a bad design in StructureMap when I put it into AutoMapper.&#160; In AutoMapper Profiles, you inherit from the Profile object, which provides [Object Scoping](http://martinfowler.com/dslwip/ObjectScoping.html) for creating profile-specific maps.&#160; If you haven’t noticed by now, [Martin Fowler’s DSL-WIP](http://martinfowler.com/dslwip/index.html) collection is practically _the_ resource for DSL design.&#160; So why did I have this wacky Configure() method that you have to override?&#160; Well, besides it’s what Fowler had in his example, I’m forced into this corner because I didn’t separate the operational and population interface of the semantic model.

When a Profile object is created, I need to perform some initialization on it before any configuration calls are made.&#160; So, you have this one method to override, instead of just doing everything in the constructor.&#160; Small issue, but something I’ll almost surely change in the future.

None of these design changes will affect the public API much, as I’d likely continue the existing API and provide a migration path if I do decide to make any big changes.&#160; The nice thing about the current design is that it’s very, very simple to get started.&#160; However, this simplicity tends to demo well, but doesn’t scale in real-world settings.&#160; As I move towards 2.0, I’ll make sure I balance a better DSL design, but keep the essence of the existing simplicity.