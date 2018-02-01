---
id: 159
title: Running Jasmine in .NET
date: 2012-02-25T05:50:01+00:00
author: Josh Arnold
layout: post
guid: http://lostechies.com/josharnold/?p=159
dsq_thread_id:
  - "588558550"
categories:
  - general
tags:
  - fubu
  - jasmine
  - js
  - serenity
---
I’m going to deviate from my usual style of “I’m going to tell you about something I think is cool without giving you any context” and write an informative post. I know. Brace yourselves.

## What is Jasmine?

From the Jasmine docs:

> Jasmine is a behavior-driven development framework for testing your JavaScript code. It does not depend on any other JavaScript frameworks. It does not require a DOM. And it has a clean, obvious syntax so that you can easily write tests.

If you’ve done any work with Jasmine (even if it’s a simple “Hello, World!”), you know that the basic setup is the [Jasmine Standalone Runner](http://www.watchmecode.net/jasmine-standalone).

## What’s wrong with the Standalone runner?

The standalone Jasmine runner requires some basic boilerplate content within html and javascript files to execute your specs. This works great for a very simple setup but as you try to use this in an actual project, you may find yourself feeling the following pains:

  * Lack of build/rake/CI integration
  * Tedious/repetitive setup required to organize your specs

Let me elaborate on that last one: the standalone runner works great for a single spec file. For each spec file that you want to test, you need an equivalent test runner html file.

My team needed a solution to alleviate this pain…so naturally, I waited for Jeremy to do something about it ;).

## Introducing Serenity

The Jasmine Runner within Serenity leverages Bottles and the Fubu Kayak host to spin up a content-only Fubu application that sits on top of your file system. There are lot of technologies and concepts in play here so I will unpack that statement by way of a nice and detailed example.

> All of this is available via my [jasmine-example](https://github.com/jmarnold/jasmine-examples) repo on github. You may wish to clone it locally and follow along.

### Getting Started

You can obtain the Serenity tools in a variety of ways. The easiest way is simply to install the Serenity package via NuGet. In this example, I began with a simple ASP.NET Empty Web Application and installed the Serenity NuGet package.

After installing the NuGet package, we begin by following the directory structure used by FubuMVC’s Asset Pipeline. All this means is that we have a folder named “content” in the root of our application. Within that content folder is a “scripts” folder. We then place all of our scripts within said folder.

You can view the sample structure [here](https://github.com/jmarnold/jasmine-examples/tree/master/src/JasmineExample/content).

> **Note:
  
>** The example repo makes use of Fubu’s [ripple infrastructure](http://geek.ianbattersby.com/2011/12/01/ripple-tastic) and rake. If you’re wondering where the NuGets are, simply run a default rake and ripple will pull them down.

### Creating your first spec

The Serenity Jasmine runner (from now on I’m just going to refer to it as “the runner”) takes care of pairing up your script and your spec file and it does so by the following convention:

  * simple.js (the script)
  * specs/ 
      * simple.spec.js

Let me further explain that one…

Each folder underneath content/scripts is considered a SpecificationFolder. Any files that exist in each of these SpecificationFolders are automatically paired with files within the relative specs folder. The naming convention is simple: “x.js”, “x.spec.js”.

Ok, now that I’m confused you how about we start the runner and you can see it all come together?

### Running the spec

There’s a little bit of rake-fu in the repo to make this nice and easy:

> rake open_jasmine

This launches the runner in _interactive_ mode (read “development” mode) and provides simple “auto-test” functionality. That is, any file modifications trigger an automatic refresh of the browser.

[<img style="background-image: none; margin: 0px auto 24px; padding-left: 0px; padding-right: 0px; display: block; float: none; padding-top: 0px; border: 0px;" title="start" src="http://clayvessel.org/clayvessel/wp-content/uploads/2012/02/start_thumb.png" border="0" alt="start" width="644" height="250" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/02/start.png)

As Figure 1 shows, the start page displays all of the available specifications and then lets you drill down to execute them (like R# groups projects in your solution).

### Is it that simple?

In a perfect world, you could install a NuGet via the CLI and be able to just launch the runner immediately. But hey, we’re getting closer, right? I’ve wrapped up all the boiler plate stuff involved in getting started with the runner in this repo so that you don’t have to.

### What else can it do?

Here a few highlights that I can dive into more in depth if you’re interested:

  * A file named jasmine.helper.js within any specs folder is loaded for your specs. There is an example of this in the repo w/ complex.spec.js
  * The runner can also be simply ran as an exe and integrated into your build via exit codes. The default rake task in the repo is an example of how to do this

### Any “gotchas”?

There a few very specific things to note here:

  1. The runner needs a “serenity.txt” file relative to where your project lies. You can specify the location of the file (and the name) but the contents are used to configure the runner (e.g., “include:MyProject”)
  2. The runner makes use of Fubu’s asset pipeline. It tries to be helpful by automatically requiring a script asset named “core”. If you don’t have a “core” (e.g., aliased file, set) then the runner will likely bomb. The example repo has a core.script.config that shows a workaround for this.

### Are there any examples in the wild?

[FubuValidation](https://github.com/DarthFubuMVC/fubuvalidation) recently merged in the fubuvalidation.js work and now leverages the Serenity Jasmine runner as part of its build.