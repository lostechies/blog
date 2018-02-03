---
wordpress_id: 816
title: AutoMapper 3.0, Portable Class Libraries and PlatformNotSupportedException
date: 2013-09-04T16:26:42+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=816
dsq_thread_id:
  - "1710242241"
categories:
  - AutoMapper
---
One of the major additions of AutoMapper 3.0 is the support of multiple frameworks through [Portable Class Libraries](http://msdn.microsoft.com/en-us/library/gg597391.aspx). A Portable Class Library (PCL) allows a library developer to easily target multiple frameworks, as Scott Hanselman pointed on in a blog on [cross platform development](http://www.hanselman.com/blog/CrossPlatformPortableClassLibrariesWithNETAreHappening.aspx). This allows me as the developer of AutoMapper to target, in 3.0:

  * .NET 4 and higher
  * Silverlight 4 and higher (yes I know it’s pretty much dead, but this was as easy as me checking a checkbox)
  * Windows Phone 8
  * Windows Store apps
  * And in AutoMapper 3.1 pre-release, MonoDroid (and hopefully soon MonoTouch)

I had Silverlight 4 support a while back, but it was a huge pain to support as I had to effectively manage two codebases and a bunch of compiler directives separating the two.

With PCLs, I manage one codebase and let the PCL itself manage API differences. Another big plus is the compiler letting you know when members and types aren’t available based on the frameworks you’ve chosen.

Which brings me to the above exception, “Platform Not Supported”.

### When things are different

In my previous mode, if I had differences between libraries I’d use compiler directives (#if) to conditionally include code. In PCLs, those compiler directives don’t exist. So how do I include different code for different runtimes? For example, AutoMapper supports mapping to interfaces, but that requires Reflection.Emit, which is only included in the .NET 4 target pack.

But I don’t want to lose that feature!

There are many other examples of missing types, but the end result is that I have to create separate targeting assemblies for “Extra Features” supported by your runtime. So the assemblies created from the build are:

  * AutoMapper.dll <- the core PCL
  * AutoMapper.Net4.dll
  * AutoMapper.SL4.dll
  * AutoMapper.WP75.dll
  * AutoMapper.WinRT.dll

Those are all easy to manage, just a handful of different classes in each. It’s small things like .NET 4 having System.Data, the others not, to bigger things like SL4 using the slower reflection calls and the other platforms using highly optimized calls.

In order to dynamically load different behavior at runtime, I use dependency injection to test for the existence of those other assemblies, and check for classes that override behavior. Sometimes, I don’t find what I need, and I throw a PlatformNotSupportedException – something that should never, ever be seen at runtime.

### MSBuild and copying references

MSBuild has an interesting (ahem) algorithm in how it determines which assembly references to copy for project references. It actually doesn’t use what your project references, but what your _assembly_ references. That’s extremely problematic for types discovered at runtime. Suppose you have the following project structure/references:

  * Core
  * AutoMapper.dll
  * AutoMapper.Net4.dll

  * UI
  * Core

Because Core references AutoMapper, then AutoMapper.dll will be copied over. However, AutoMapper.Net4.dll is NOT directly references, it only contains classes discovered at runtime. At compile time, UI looks like this:

  * UI
  * Core
  * AutoMapper.dll

We have an incomplete assembly, and pieces in Core trying to use features that don’t exist in UI. So how can we fix this? Rather easily, **add a reference to AutoMapper in UI**:

  * UI
  * Core
  * AutoMapper.dll
  * AutoMapper.Net4.dll

That’s a fix that anyone using AutoMapper 3.0 can do. I’ve run into this problem before in .NET for many, many years. Assemblies references in web.config, but not in code, are not copied over either. It’s just funny in my situation.

### Fix going forward

I intend to fix this issue in AutoMapper 3.1. I never ran into it simply because I just reference AutoMapper in my application projects. However, this behavior is not completely obvious, nor is the exception helpful (although it is semantically correct). My options include:

  * A build warning, saying you must add a reference in every project. This is what the [Microsoft BCL team does](http://blogs.msdn.com/b/bclteam/archive/2013/04/17/microsoft-bcl-async-is-now-stable.aspx).
  * Modify the NuGet package to also treat AutoMapper.Net4.dll as content, copied always. This seems like a viable, but weird, strategy
  * Force users of AutoMapper to reference the derived package by moving some core, always used class (like the Mapper class) to the .Net4.dll, .SL4.dll etc. assemblies. I REALLY don’t like this approach – clients that have a “Core” PCL project now can’t use AutoMapper there – and that sort of defeats the purpose

Likely I’ll go either the first or second option, but for now, just add the AutoMapper package to the applications that use them.

**And if you whine about UI projects shouldn’t reference this library directly because of some silly faux architect-y reason (even referencing a certain smelly round vegetable), I will drive to your house and slap you silly. Get off your high horse and start being productive.**