---
id: 339
title: My ideal IDE
date: 2009-07-29T01:57:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/07/28/my-ideal-ide.aspx
dsq_thread_id:
  - "264716254"
categories:
  - Tools
---
The old joke goes something like, “Oh Visual Studio?&#160; Yeah, that’s the tool I use to host ReSharper.”&#160; Visual Studio has made lots of strides since the old VS 2002 edition.&#160; Before then, it was Visual Studio 6.0, on the much too often occasion I needed to update some old VB6 COM components.&#160; But for me, my current IDE still has a ways to go.

At this point, none of the whiz-bang toolbars and such are even visible, and my daily use looks something like this:

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="434" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_3C45BFB0.png" width="644" border="0" />](http://lostechies.com/jimmybogard/files/2011/03/image_3C756F70.png) 

Notice anything missing?&#160; Zero toolbars or navigation helpers.&#160; Those are actually on another screen, out of the way so I can view the code, if I use them at all.&#160; Even with today’s large monitors, screen real estate should go to only the most important things.&#160; Since I’m writing code 99% of the time I’m in an IDE, my experience should be optimized for writing code.

But there are still some things missing in my ideal IDE experience.

### ****

### Mouse-less by default

If an IDE forces me to pick up my mouse for the 99% slice of what I need to do every day, the IDE has already failed.&#160; Navigation and refactoring tools like ReSharper allow me to jump around far, far more efficiently through keystrokes than picking up my mouse would.

One of the really bothering aspects of many of the ASP.NET MVC demos and sample blog posts is how much they highlight wizards.&#160; Code generation is fantastic, but wizards are a productivity sink.&#160; Take Rails.&#160; Want to generate all the starter code needed for a controller, model and view?&#160; How about this: “ruby script/generate scaffold Product” from the command line.&#160; That one line generates the controller, view, model and a bunch of other stuff.&#160; Why waste time right-clicking around, when you could have a powerful script do all the work?

If I need to add a new file to my project, I _still_ don’t lift my hands off the keyboard.&#160; ReSharper allows me to locate a file in Solution Explorer, add a new file from a template, and begin editing without ever needing to fumble around a gigantic file tree.

### Multiple-monitor friendly

Since I get paid to code (and not muck around ridiculous entity model diagrams), I like to see as much code as possible.&#160; Right now, I flip a 24” monitor into portrait mode, so that I can have two code windows open one on top of the other.&#160; It’s not my ideal manner of working, however, as right now VS does not allow me to move code files to another window easily.&#160; I can stretch VS across multiple monitors, but then it becomes a game of mouse-hockey of getting all the screens lined up.

Code windows should be the first-class citizen in my IDE, not menus or toolbars.&#160; What I’d like to be able to do is put any code window anywhere I like, and not even worry about the containing application.&#160; I realize some of this is constrained by OS windowing limitations, but this is just my ideal.

### Devoid of designers and wizards for code

If I have to use a designer to code, other than for designing something visual (like WinForms or reports), the IDE has failed.&#160; I haven’t used the visual designer for HTML in several years, as the browser is the true realization of code, and HTML, CSS and JavaScript are the true code behind it.&#160; If something requires me to visualize a picture to generate code, the tools and IDE have failed.&#160; I really don’t understand the notion that if only we can drag and drop our code, it will make it easier to develop.&#160; In my first foray into drag-and-drop development with typed DataSets, I realized it wasn’t the tooling that was failing me, but the underlying assumption that code is meant to be created through visual representation.

IDEs should optimize for typing on a keyboard, and something like a real command window for VS would help.&#160; Things like Rails generators should provide a great inspiration for great code generation/templating solutions.

### Profiles for multiple development environments

This is more for laptops, as I use my laptop in a variety of scenarios.&#160; Sometimes I’m at home with one extra monitor, sometimes I’m only on my laptop, and sometimes I’m docked at work with two monitors and my laptop closed.&#160; In each of these, I want to switch my IDE experience, ideally with a few keystrokes (and NOT mouse clicks).&#160; Every morning I have the same pre-work ritual of re-arranging my windows back to where they were.&#160; There seem to be some semblance of profiles, with “Debug”, “Full Screen” and “Regular” seemingly all having their own window profiles.&#160; But for the life of me I can’t see how to create these profiles at will, without resorting to crazy macro-fu.

### An actual extensibility model

If I have to develop against COM or program a macro, fail.&#160; Ideally, I could develop extensions in a scripting language like Ruby, whose dynamic capabilities and terseness are ideal for plugins.

It’s funny, my first foray into Rails led me to IDEs like Aptana, because of my Visual Studio biases that IDEs need to be heavy and intrusive.&#160; But all Rails development can be done through a simple text editor and the command line.&#160; Seeing other IDEs and other platforms really led me away from the out-of-the-box experience of VS, so much so that it’s barely recognizable.&#160; So what’s in your ideal IDE?