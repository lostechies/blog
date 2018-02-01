---
id: 300
title: Adventures with IL Merge
date: 2009-04-04T21:47:39+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/04/04/adventures-with-il-merge.aspx
dsq_thread_id:
  - "264914029"
categories:
  - AutoMapper
  - 'C#'
---
A recent addition to AutoMapper is the feature where I can map directly to and from interfaces.&#160; You don’t need a concrete type to do this, AutoMapper will create an implementation for you at runtime, with default property behavior.&#160; To do so, I needed to use the slick LinFu project, with its dynamic proxy abilities.&#160; This required me to add a reference to an assembly that most folks don’t have, as everything else AutoMapper uses is straight up .NET.

I don’t really care about referencing and distributing multiple assemblies, but some folks do.&#160; The solution here is to use another slick tool, [ILMerge](http://www.microsoft.com/downloads/details.aspx?FamilyID=22914587-b4ad-4eae-87cf-b14ae6a939b0&displaylang=en).&#160; Check out Daniel Cazzzzzulino’s blog for a [great example of using it](http://www.clariusconsulting.net/blogs/kzu/archive/2009/02/23/LeveragingILMergetosimplifydeploymentandyourusersexperience.aspx).&#160; In my case, I wanted to use ILMerge to merge LinFu and AutoMapper into one assembly, but make all of LinFu internal.&#160; End users will just reference AutoMapper, with little or no knowledge that I’m really using LinFu as well.

Things worked great until someone tried to use the merged assembly, and got this fun error:

<pre>System.TypeLoadException : Access is denied: 'LinFu.DynamicProxy.ProxyDummy'.
    at AutoMapper.MappingEngine.AutoMapper.IMappingEngineRunner.Map(ResolutionContext context)
    at AutoMapper.MappingEngine.Map(Object source, Type sourceType, Type destinationType)
    at AutoMapper.MappingEngine.Map[TSource,TDestination](TSource source)
    at AutoMapper.Mapper.Map[TSource,TDestination](TSource source)
    C:devautomapper-trunksrcAutoMapperSamplesInterfaces.cs(45,0): at AutoMapperSamples.Interfaces.MappingToInterfaces.Example()
    --TypeLoadException
    at System.Reflection.Emit.TypeBuilder._TermCreateClass(Int32 handle, Module module)
    at System.Reflection.Emit.TypeBuilder.CreateTypeNoLock()
    at System.Reflection.Emit.TypeBuilder.CreateType()
    at LinFu.DynamicProxy.ProxyFactory.CreateUncachedProxyType(Type[] baseInterfaces, Type baseType)
    at LinFu.DynamicProxy.ProxyFactory.CreateProxyType(Type baseType, Type[] baseInterfaces)
    at LinFu.DynamicProxy.ProxyFactory.CreateProxy(Type instanceType, IInterceptor interceptor, Type[] baseInterfaces)
    at AutoMapper.MappingEngine.AutoMapper.IMappingEngineRunner.CreateObject(Type type)
    at AutoMapper.Mappers.TypeMapMapper.Map(ResolutionContext context, IMappingEngineRunner mapper)
    at AutoMapper.MappingEngine.AutoMapper.IMappingEngineRunner.Map(ResolutionContext context)</pre>

[](http://11011.net/software/vspaste)

Blah blah blah, all this means is that I made _too_ much internal.&#160; To figure out what was going on here, I set a debug point on a unit test that used project references (instead of referencing the merged assembly).&#160; What I found was that at runtime, my runtime type implements my destination type as well as a LinFu type, “LinFu.DynamicProxy.IProxy”.&#160; This IProxy type exposes another LinFu type, “LinFu.DynamicProxy.IInterceptor”.&#160; Although most of LinFu’s types are internal in my ILMerge’d assembly, I still need these two to be public.

To do this, I created an excludes file for ILMerge.exe, which lets me specify different types to leave as-is:

<pre>^LinFu.DynamicProxy.IProxy$
^LinFu.DynamicProxy.IInterceptor$</pre>

[](http://11011.net/software/vspaste)

ILMerge.exe uses regular expressions to match each line, so I made these types use exact matching (otherwise, I’d get anything that just started with IProxy to be public).&#160; With this exclude file in place, I do have a couple of types I need to make public, which means they’ll show up in IntelliSense, but my tests now pass.