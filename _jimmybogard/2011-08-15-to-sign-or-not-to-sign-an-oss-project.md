---
id: 510
title: To sign or not to sign an OSS project
date: 2011-08-15T13:30:11+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2011/08/15/to-sign-or-not-to-sign-an-oss-project/
dsq_thread_id:
  - "386497467"
categories:
  - AutoMapper
---
At one point, AutoMapper was not a signed assembly. Until someone asked for it, I went ahead and signed the assembly, and really haven’t had a complaint since. But it seems that signing of OSS projects is a bit of a contentious position in the OSS world of .NET.

In [this discussion on NuGet](http://nuget.codeplex.com/discussions/247827), I found [Brad Wilson’s](http://bradwilson.typepad.com/) position on signing to be pretty much the same as mine:

> Code signing is not a security measure. It&#8217;s not to support putting our assembly in the GAC (it actually doesn&#8217;t work in the GAC). It&#8217;s merely to satisfy those who have a requirement to sign their own code. 
> 
> We&#8217;ve suffered zero reported problems from this strategy.

The reason the issue came up for me was that I started to use the library Should in the AutoMapper unit tests project. Guess what? It wasn’t signed. And guess what? Because it wasn’t signed, it was completely unusable for me. I had to download the source and modify the project to sign the assembly (even more fun with ILMerge in the mix). 

The cons of signing basically center around the issue of versioning. When an assembly is signed, you have to use [assembly binding redirects](http://msdn.microsoft.com/en-us/library/433ysdt1.aspx) whenever you reference a new version without upgrading the others. For example: 

  * A references B
  * B references C
  * A references C

If project A is my project, and I want to upgrade C, but I don’t own B (in most cases, this would be a fairly ubiquitous OSS library, such as log4net, Castle, StructureMap etc.), I have to use binding redirects to tell B to use the new version of C.

Annoying, yes.

With signed assemblies, I’m enabling all sorts of scenarios that absolutely require signed assemblies, such as

  * [InternalsVisibleTo](http://msdn.microsoft.com/en-us/library/system.runtime.compilerservices.internalsvisibletoattribute.aspx)
  * Supporting signed assemblies (which require all references to be signed)
  * Some wacky medium trust environments

It’s definitely not the only strategy out there, as [Sebastian Lambla](http://codebetter.com/sebastienlambla/) has a great writeup on [strong naming assemblies and OpenWrap](http://codebetter.com/sebastienlambla/2011/01/05/strong-naming-assemblies-and-openwrap/). **However, given the choice between annoying or unusable, I’ll go for annoying.**