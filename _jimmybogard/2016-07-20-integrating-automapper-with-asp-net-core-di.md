---
wordpress_id: 1225
title: Integrating AutoMapper with ASP.NET Core DI
date: 2016-07-20T16:30:46+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1225
dsq_thread_id:
  - "5000616649"
categories:
  - ASPNetCore
  - AutoMapper
  - DependencyInjection
---
Part of the release of ASP.NET Core is a new DI framework that’s completely integrated with the ASP.NET pipeline. Previous ASP.NET frameworks either had no DI or used service location in various formats to resolve dependencies. One of the nice things about a completely integrated container (not just a means to resolve dependencies, but to register them as well), means it’s much easier to develop plugins for the framework that bridge your OSS project and the ASP.NET Core app. I [already did this with MediatR](https://lostechies.com/jimmybogard/2016/07/19/mediatr-extensions-for-microsoft-dependency-injection-released/) and [HtmlTags](https://lostechies.com/jimmybogard/2016/07/18/htmltags-4-1-released-for-asp-net-4-and-asp-net-core/), but wanted to walk through how I did this with AutoMapper.

Before I got started, I wanted to understand what the pain points of integrating AutoMapper with an application are. The biggest one seems to be the Initialize call, most systems I work with use [AutoMapper Profiles](https://github.com/AutoMapper/AutoMapper/wiki/Configuration#profile-instances) to define configuration (instead of one ginormous Initialize block). If you have a lot of these, you don’t want to have a bunch of AddProfile calls in your Initialize method, you want them to be discovered. So first off, solving the Profile discovery problem.

Next is deciding between the static versus instance way of using AutoMapper. It turns out that most everyone really wants to use the static way of AutoMapper, but this can pose a problem in certain scenarios. If you’re building a resolver, you’re often building one with dependencies on things like a DbContext or ISession, an ORM/data access thingy:

{% gist e4eae02aa893fee5993d5176e65754c9 %}

With the new DI framework, the DbContext would be a scoped dependency, meaning you’d get one of those per request. But how would AutoMapper know how to resolve the value resolver correctly?

The easiest way is to also scope an IMapper to a request, as its constructor takes a function to build value resolvers, type converters, and member value resolvers:

{% gist f3aad0c72689bb171cfd9342c6c3c728 %}

The caveat is you have to use an IMapper instance, not the Mapper static method. There’s a way to pass in the constructor function to a Mapper.Map call, but you have to pass it in \*every single time\*, and thus not so useful:

{% gist e433f4a6404b5591229042f0af01ed7f %}

Finally, if you’re using AutoMapper projections, you’d like to stick with the static initialization. Since the projection piece is an extension method, there’s no way to resolve dependencies other than passing them in, or service location. With static initialization, I know exactly where to go to look for AutoMapper configuration. Instance-based, you have to pass in your configuration to every single ProjectTo call.

In short, I want static initialization for configuration, but instance-based usage of mapping. Call Mapper.Initialize, but create mapper instances from the static configuration.

### Initializating the container and AutoMapper

Before I worry about configuring the container (the IServiceCollection object), I need to initialize AutoMapper. I’ll assume that you’re using Profiles, and I’ll simply scan through a list of assemblies for anything that is a Profile:

{% gist c714b3c4a89b23d72a241cb9cf2da2d6 %}

The assembly list can come from a list of assemblies or types passed in to mark assemblies, or I can just look at what assemblies are loaded in the current DependencyContext (the thing ASP.NET Core populates with discovered assemblies):

{% gist ac5d48395d6d547fed392244282719be %}

Next, I need to add all value resolvers, type converters, and member value resolvers to the container. Not every value resolver etc. might need to be initialized by the container, and if you don’t pass in a constructor function it won’t use a container, but this is just a safeguard just in case something needs to resolve these AutoMapper service classes:

{% gist 8a090d7c7fde0f4166919a67b8c7fcc9 %}

I loop through every class and see if it implements the open generic interfaces I’m interested in, and if so, registers them as transient in the container. The “ImplementsGenericInterface” doesn’t exist in the BCL, but it probably should :).

Finally, I register the mapper configuration and mapper instances in the container:

{% gist e2ddafe4c18fa7afcdd15a673c225786 %}

While the configuration is static, every IMapper instance is scoped to a request, passing in the constructor function from the service provider. This means that AutoMapper will get the correct scoped instances to build its value resolvers, type converters etc.

With that in place, it’s now trivial to add AutoMapper to an ASP.NET Core application. After I create my Profiles that contain my AutoMapper configuration, I instruct the container to add AutoMapper (now released as a NuGet package from the [AutoMapper.Extensions.Microsoft.DependencyInjection package](https://www.nuget.org/packages/AutoMapper.Extensions.Microsoft.DependencyInjection/)):

{% gist d3a19a961700b72d9117d1aecb13657b %}

And as long as I make sure and add this after the MVC services are registered, it correctly loads up all the found assemblies and initializes AutoMapper. If not, I can always instruct the initialization to look in specific types/assemblies for Profiles. I can then use AutoMapper statically or instance-based in a controller:

{% gist bd96f5c1c8e2c072bb1af602305c12f6 %}

The projections use the static configuration, while the instance-based uses any potential injected services. Just about as simple as it can get!

### Other containers

While the new AutoMapper extensions package is specific to ASP.NET Core DI, it’s also how I would initialize and register AutoMapper with any container. Previously, I would lean on DI containers for assembly scanning purposes, finding all Profile classes, but this had the unfortunate side effect that Profiles could themselves have dependencies – a very bad idea! With the pattern above, it should be easy to extend to any other DI container.