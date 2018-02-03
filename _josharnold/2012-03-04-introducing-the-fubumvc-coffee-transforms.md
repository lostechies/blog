---
wordpress_id: 162
title: Introducing the FubuMVC.Coffee transforms
date: 2012-03-04T06:01:34+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=162
dsq_thread_id:
  - "597901664"
categories:
  - general
tags:
  - assets
  - bottles
  - fubu
  - fubumvc
---
If you’re a fan of CoffeeScript and FubuMVC, then please take a moment and give a round of applause to [Alex Henning Johannessen](https://twitter.com/#!/ahjohannessen) for his hard work on the CoffeeScript and Less transforms.

In this post, I am going to provide an example of how to use the FubuMVC.Coffee NuGet in your FubuMVC application.

## Where’s the code?

I’ve created a repository to show of example of all of this in action: <https://github.com/jmarnold/FubuOnCoffee>

## Getting Started

A nice introductory post to FubuMVC’s Asset pipeline is well overdue. I’m going to touch on the simplest configuration and just promise that I’ll get to a more in-depth blog about it later.

First, we start by creating an asset config file (*.asset.config):



For more examples on the syntax, check out the [dsl reader](https://github.com/DarthFubuMVC/fubumvc/blob/master/src/FubuMVC.Core/Assets/AssetDslReader.cs#L15).

## Configuring the Transform

Running your application with above asset configuration will “run”, but you’re going to get the raw contents of the coffeescript file. In order to enable the transformation, you can install the [FubuMVC.Coffee nuget](https://nuget.org/packages/FubuMVC.Coffee):

> Install-Package FubuMVC.Coffee

This will install a zip file inside of a fubu-content directory at the root of your web application. [Thanks to the beauty of Bottles](http://lostechies.com/josharnold/2011/09/05/modularity-via-bottles/), this zip file will be exploded out and the CoffeeScript configuration will be invoked automatically.

Now running your application with above asset configuration will give you the transformed contents of example.coffee.