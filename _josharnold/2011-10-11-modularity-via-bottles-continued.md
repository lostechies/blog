---
id: 123
title: 'Modularity via Bottles &#8211; Continued'
date: 2011-10-11T05:12:22+00:00
author: Josh Arnold
layout: post
guid: http://lostechies.com/josharnold/?p=123
dsq_thread_id:
  - "439846509"
categories:
  - general
tags:
  - bottles
  - fubu
---
## Overview

We’ve had even more questions arising about “what are Bottles” since my last post and our sessions at Pablos Fiesta. I think my favorite question after our explanations is: “WTF is a Bottle?”

Forgive me, you’ll find me mixing “Bottles” and “packages” often. I won’t promise that I’m not going to do this, but I will promise that I’ll be consistent: Bottles (capitalized) means the framework. “bottles” (not capitalized) and “packages” mean the actual files.

### WTF is a bottle?

I like this question. Let’s take away all the glamour and expose the interface that changes everything:



This is a cornerstone of the Bottles framework as it represents the smallest unit of data that we’re concerned with. This unit is comprised of a few things. Let me draw your attention to two of them: 1) assemblies and 2) data.

They come in all shapes and sizes. Our most commonly used implementations are: 1) AssemblyPackageInfo and 2) PackageInfo (just a file/directory – typically a zip file).

### Playing with your AppDomain

I mentioned that Bottles provides assemblies. That’s great and all, but if you’ve ever spent time loading those into your AppDomain and making every thing play nice, then you understand the pains that are involved. If Bottles does nothing else right as a framework, I’d call it a success because it makes dealing with this a breeze.

Don’t worry, I’ll dive into details but at a high-level Bottles gives you the ability to conventionally load assemblies into your AppDomain and give you a uniform way of responding to them.

## So how does it all work?

### Execution Flow

The execution of all of Bottles occurs through the static LoadPackages method in the PackageRegistry class. This little gem gives you a DSL for hooking into the loading mechanism while Bottles does it magic.

### IPackageFacility

This is the abstraction that allows various frameworks to plugin and make use of the Bottles infrastructure (e.g., FubuMVC, Topshelf). You can specify custom IPackageLoader implementations here and let Bottles know about how you want to find your bottles.

### IPackageLoader

These tell Bottles how you want to find your bottles. FubuMVC ships with a few (ZipFilePackageLoader being an important one) and Bottles has its own internal ones.

In fact, Bottles ships with a very important one: LinkedFolderPackageLoader. This allows a “.links” file to be included in your projects so that you can dynamically load other projects in your solution as bottles (rather than installing/uninstalling or dealing with DLL references).

### IBootstrapper

So you’ve loaded up your bottles…now what? When you’re configuring Bottles, you can specify custom IBootstrapper implementations which tells Bottles about the all important IActivator interface. This interface is here so that you can find these IActivator implementations however you like (e.g., scan the assembly for implementations with a default constructor, pull them from your IoC container).

### IActivator

This little gem allows for “start up” operations within Bottles. FubuMVC actually leverages this internally for some of the Bottles interoperability. For example, we have a Bottles-friendly virtual path provider that gets registered through an IActivator.

This interface has full access to anything in your AppDomain so that options are pretty limitless. On top of that, you are given information about the available packages – which gives access to any files that are part of said package. FubuMVC uses this to register content files (scripts, images, styles, etc.) into its asset pipeline.

The most common custom uses of IActivator that I come across are IoC container-related (e.g., register additional implementations, replace a service).

## How does this fit into the NuGet world?

This is a very common question. Here’s my typical answer:

> Bottles starts where NuGet leaves off. We’re not in the business of defining the shipping process, just what to do with the contents after they’ve been shipped. In fact, we often use NuGet as our shipping provider for reusable packages.

## Why Bottles?

Hopefully my short explanation has already answered this question but I’ll try one more time.

Bottles grew out of a need for dynamic content/assembly loading in FubuMVC. Since it was all sparked during a conversation between Jeremy Miller and Dru Sellers, Bottles was abstracted out into what it is today with the intention of making it consumable through TopShelf.

Assembly loading and all the other tedious crap that comes with this need is not something you want to repeat if you can avoid it. Thus, dev cycles were used to make sure that we never have to do this ever again.

## What else can Bottles do?

It’s not ready for prime time yet but there is currently a deployment story in the works for Bottles. This can be everything from “deploy this bottle to topshelf” to “deploy this FubuMVC package to IIS/nginx”.