---
id: 131
title: fubu new project
date: 2011-12-17T06:09:43+00:00
author: Josh Arnold
layout: post
guid: http://lostechies.com/josharnold/?p=131
dsq_thread_id:
  - "507197179"
categories:
  - general
tags:
  - fubu
  - fubumvc
  - tooling
---
## Overview

**fubu new** is a command that is available via the Fubu Command Line tool. So, think “rails new” for fubu. Sort of.

> If you’re waiting on pins and needles for how to just start using it, [skip ahead to the end](#tldr).

## Templates

First let’s talk templates. Why? Because that’s what powers this fun little command and they come into two shapes: 1) zip files and 2) git repositories. Yep, I just said git repositories. But first…

### What’s in a template?

A template is a folder structure that you want copied over after a set of replacements has occurred. The replacements are pretty simple:

  * FUBUPROJECTNAME – The projectName argument specified (fubu new projectName)
  * FUBUPROJECTSHORTNAME – The last value of projectName split on “.” (e.g., FubuMVC.Plugin => Plugin)
  * GUIDx (where x is a valid number) – A generated and cached guid (more on this)

### What all gets replaced?

File contents, file names, and directory names.

### I don’t get the “GUIDx” thing

Let’s say you have a template with two projects: 1) A standard class library and 2) a class library used as a testing project for the first.

#### Problem:

You want a new GUID for both projects but need a way to correlate them so that your second project can reference the first and provide metadata.

#### Solution:

The first project uses “GUID1” as its ID. The second project uses “GUID2” as its ID. The second project then uses “GUID1” when [referring to the first project](https://github.com/DarthFubuMVC/bottle-template/blob/master/FUBUPROJECTNAME.Tests/FUBUPROJECTNAME.Tests.csproj#L90).

### How do I specify a template?

As I mentioned before, there are two ways:

#### Zip Files

You can specify a zip file using the –z flag.

> fubu new MyProject –z my-template.zip

#### Git Repositories

You can specify a git repository using the –g flag.

> fubu new MyProject –g git://my-repo.git

#### What if I don’t want to type/remember the git url?

I’m glad you asked. You can place a [.fubunew-alias file](https://gist.github.com/1489386) right alongside the fubu.exe executable. The aliases specified in that file can then be used for the –g flag.

We also ship with two default aliases (regardless of the existence of the file):

  * fubusln = [git://github.com/DarthFubuMVC/rippletemplate.git](git://github.com/DarthFubuMVC/rippletemplate.git "git://github.com/DarthFubuMVC/rippletemplate.git")
  * fububottle = [git://github.com/DarthFubuMVC/bottle-template.git](git://github.com/DarthFubuMVC/bottle-template.git "git://github.com/DarthFubuMVC/bottle-template.git")

## New vs. Existing Solutions

The examples above show fubu new working for brand new solutions. That’s great but we’ve found that adding a new project/test project/integration project (etc.) can be a royal pain. No, it’s not hard but it is time consuming.

### Appending to an existing solution

Specifying the –s flag and providing the location of a solution file will do a few things for you.

First, we explode the contents and move them into the solution directory (if you have weird folder structures, you can override the output location with the –o flag). Then we loop through the new projects we just created and append them to the solution file that you specified with the –s flag.

## What about custom one-off scenarios?

The whole “one-off” scenario first occurred during testing. Then we realized that any useful template will almost ALWAYS have some custom one-off scenario. So we added a nifty little idea:

### rake callback script

You can specify a rake file to execute after the templating is finished using the –r flag. You can do whatever you’re capable of doing with rake here. Check out our [bottle template](https://github.com/DarthFubuMVC/bottle-template) for a simple example.

### But I always want to execute the script

If you don’t want to have to remember to specify the –r flag, simply name your rake file “.fuburake” and it will automatically get run.

## What if I want to exclude certain files in the templating?

Some files exist in your template just for executing (e.g., rake callbacks, a placeholder file to read a value). Simply create a .fubuignore file in your template (the syntax is the same as .gitignore). Any files will be excluded in the copy.

For an example of everything in action, take a look at our [ripple-ized solution template](https://github.com/DarthFubuMVC/rippletemplate).

<a name="tldr"></a>

## How do I start using it?

Well, a couple of things to note…

### Is it available right now?

Yes and No…the new FubuMVC.References nuget will be published on 12/19. At which point, all of the information I just provided will be valid. As of right now, fubu new doesn’t do very much. Sorry, but I wanted to write this blog while I had the chance.

If you want to play with it today, simply clone FubuMVC and build the solution. The exe will be located in src/Fubu/bin/Debug.

### When it is available through NuGet, how do I use it?

Add a reference to FubuMVC.References and fubu.exe will be in the tools directory of that package.