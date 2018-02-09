---
wordpress_id: 867
title: Converting AutoMapper to a Portable Class Library
date: 2014-02-19T23:11:46+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=867
dsq_thread_id:
  - "2290724497"
categories:
  - AutoMapper
---
In the early days of AutoMapper, I got requests to support AutoMapper in other platforms (mainly Silverlight). I didn’t have any experience in those other platforms, but I thought it would be easy. It was not. I wound up with a picture like this:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2014/02/image_thumb4.png" width="188" height="244" />](http://lostechies.com/jimmybogard/files/2014/02/image4.png)

A separate project per platform, and using tricks like “Add as Link” to have multiple projects share the same source file. The problem with this approach is I have to remember to add files across all projects, and some features aren’t available in some platforms. I resorted to compiler directives, and ultimately, dropped support for the other platforms because it slowed me down.

I gave up on supporting multiple platforms, until Portable Class Libraries entered the picture. Converting AutoMapper to a PCL was a bit of a journey, but a worthwhile one, as now I get to support with one library:

  * .NET 4
  * Silverlight 5
  * Windows Phone 8
  * Metro (whatever it’s called now)
  * Android
  * iOS

And even more important, now that I’ve made the journey, new features/refactorings/whatever is much, much easier as now I have one library to go from.

Well, almost. We’ll get back to that. First, let’s look at the journey for going PCL.

### Initial conversion

My first step was to simply understand what was supported and what wasn’t. I started by converting the existing library to PCL, and just see what didn’t work.

PCLs work by creating subset targeting libraries of different platform choices, and using type forwarding at runtime to direct calls to the correct platform API. But not every feature is supported on every platform, so you’ll find different profiles created for the different combinations of platforms you select, representing those common set of APIs. Don’t have the API supported for _all_ the platforms? Not available for you. The profiles have figured out the hard part of what is common across all the APIs, and exposed it directly for you.

At first, I had a lot of compile errors. Things that weren’t available across my initial set of profiles I supported included:

  * Anything System.Data
  * Concurrent collections
  * Random other types (HashSet, TypeDescriptor, etc)
  * Reflection.Emit
  * Expression tree compilation (!)
  * Random overloads (not all type metadata method overloads exist, just the most parameter-ful)

The last one was easy, the BCL team didn’t port _every_ overload of a method, that’s time better spent exposing other types. Remember, just because a type exists in all platforms doesn’t mean that it’s supported in PCL – the BCL team has to expose it in their profile-specific assembly.

After the easy fixes, I had a choice. I wanted to still keep all the features and performance of the major users of AutoMapper – .NET 4, but how to expose that behavior? I had two options:

  * Feature-specific extensions
  * Platform-specific extensions

I decided to go with the latter, as the current usage scenario is just to do “install-package AutoMapper” and go from there. Luckily, NuGet supports PCL out-of-the-box, so I can create a single NuGet package and include platform-specific assemblies.

### 

### Platform-specific assemblies through dependency injection

Looking through the different unsupported objects in my base portable class library, I saw two main types:

  * Behavior that exists, but accomplishable in a different way
  * Behavior that does not exist and is not possible

One example is something like a ConcurrentDictionary – sure, that doesn’t exist in some platforms, but does my core AutoMapper assembly need to depend directly on ConcurrentDictionary? Or can it use an abstraction? In my case, I wound up creating abstractions for different implementations, like:

  * Lazy<T>
  * ReaderWriterLockSlim
  * IDictionary<TKey, TValue>

And then each of these would have an interface for a factory:

{% gist 9103212 %}

A platform-specific library could then provide an override implementation for that type:

{% gist 9103240 %}

Finally, I need a way to, at runtime, load the correct platform-specific implementation. I used a technique found in the [PCL Contrib project](http://pclcontrib.codeplex.com/) called the “[Probing Adapter Resolver](http://pclcontrib.codeplex.com/SourceControl/latest#Source/Portable.Runtime/Adaptation/ProbingAdapterResolver.cs)”. A class that needs a specific platform-specific implementation will ask a common resolver for one:

{% gist 9103309 %}

At runtime, the probing resolver scans for assemblies named “AutoMapper.Xyz” where “Xyz” is a known platform name (NET4, SL4, WP8 etc.). If there is an implementation of that interface in that platform-specific assembly, I’ll use that one. Otherwise, I fall back on what is defined in AutoMapper.

Because NuGet only installs specific assemblies for your platform, I can make sure that for .NET 4, only AutoMapper.dll and AutoMapper.Net4.dll are referenced, even though all the platform assemblies are in the NuGet package.

This also means that I can supply additional features for platforms that support them. .NET 4 supports IDataReader, so that feature is supported in that platform, discovered dynamically at runtime. The resolver caches those probes, so it’s fast once the correct override type is resolved. It also means that I can supply different strategies based on what’s available. Windows Phone 8 doesn’t support Reflection.Emit or compiling expression trees, so it gets a slower reflection-based implementation of mapping to classes.

I got all of this up and running, and compiling, and tested, and released in AutoMapper 3.0. Then a fun (ha) exception started cropping up on the mailing list and in GitHub issues.

### MSBuild, indirect dependencies and you

Those that have used ELMAH or NHibernate might have run into this issue already. Suppose we have the following solution structure:

  * Core
  * Elmah

  * UI
  * Core

My Core project references Elmah, and my UI project references Core (but not Elmah). Nothing in Core actually _uses_ Elmah, but instead it’s the Web.config in the UI project that configures it. What you’ll find is that even though you’ve explicitly referenced Elmah in Core, because your assembly doesn’t actually link to that other assembly, MSBuild will not copy the Elmah assembly over to the UI project.

For AutoMapper, this meant that because the platform-specific assemblies were never referenced by user code, and discovered dynamically at runtime, the possibility existed that MSBuild would not copy the assembly over to your ultimate application’s output folder. I detailed the problem [in a post a few months ago](http://lostechies.com/jimmybogard/2013/09/04/automapper-3-0-portable-class-libraries-and-platformnotsupportedexception/), along with a few solutions.

It’s a stupid, annoying problem, but isn’t going away any time soon. My options were to:

  * Instruct users to reference AutoMapper in every project
  * Create a build warning
  * Include the platform-specific assembly as content, to force it to be copied over

I wound up going with the last option. Initially, I did this in your project itself, and you’d see “AutoMapper.Net4.dll” in your project as content. Confusing to users, and not always wanted. Instead, I wound up creating an MSBuild hook to do this dynamically, and I now will inject into the build pipeline directly to dynamically add the platform-specific assembly as content:

{% gist 9103524 %}

This method doesn’t modify your project file to include the assembly at content, but it does dynamically insert that content item during the build. Your project file doesn’t change, and you don’t see the platform-specific assembly as content in your solution. The only change to your project file is to reference this new targets file, but that’s a common approach NuGet packages do to provide build-time behavior. This change isn’t released, but is in the latest pre-release package.

It’s not bullet-proof, but it’s much better than my previous approaches. If you manually delete bin folders, MSBuild can be tricked into thinking nothing has changed and won’t execute this script. It’s a corner case, and one I can live with.

### 

### Conclusion

Overall, I’m happy with the overall approach, and it’s made AutoMapper more pluggable. I now have better ways of extending AutoMapper’s behavior, simply because I was forced to. I can target multiple platforms quite easily, and can rely on PCLs to work out the differences.

If you’re developing a reusable library, I’d go PCL from the start, as it’s much easier to do so now than later. I’d worry about target platforms, as the more platforms you support the greater chance some feature doesn’t exist across platforms. But there are ways around this, as I’ve found, and the end result is still light years better than my old approach of just copying a bunch of files around, hoping for the best.