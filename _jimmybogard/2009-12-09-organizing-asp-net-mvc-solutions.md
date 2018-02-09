---
wordpress_id: 374
title: Organizing ASP.NET MVC solutions
date: 2009-12-09T02:27:14+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/12/08/organizing-asp-net-mvc-solutions.aspx
dsq_thread_id:
  - "264716372"
categories:
  - ASPNETMVC
redirect_from: "/blogs/jimmy_bogard/archive/2009/12/08/organizing-asp-net-mvc-solutions.aspx/"
---
Recently, a question came up on Twitter around your favorite project structure/solution organizing for ASP.NET MVC projects.&#160; I’ve toyed around with quite a few different strategies for structuring projects, and I’m currently settled around one that gives me the most flexibility.&#160; It’s extremely simple:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_71130189.png" width="253" height="237" />](http://lostechies.com/jimmybogard/files/2011/03/image_6B385DF0.png) 

That’s it, two projects.&#160; So what goes in each project?&#160; Let’s first look at the UI project.&#160; The UI project **contains only website content** and **contains no code**.&#160; And I mean _no code_.&#160; This includes:

  * No controllers
  * No models
  * No Global.asax.cs
  * NO CODE AT ALL

Why no code?&#160; Because when the UI project contains only UI content and no code, my UI project now matches the deployment structure.&#160; It contains:

  * Views
  * CSS
  * Images
  * Global.asax
  * Web.config
  * Reference to the Core project

Since my UI project structure matches my deployment structure, it makes it a lot easier to figure out how the deployment should work.&#160; With controllers, models and so on in the mix, it becomes more difficult to see what gets included for deployment (the Content, Scripts and Views folder) versus what is left out.&#160; We can then organize two different concerns separately: our content and our code.

So where does code go?&#160; That’s the other project.&#160; I call it “Core”, but it can be anything.&#160; All code goes in one project, that includes our persistence model, view model, controllers, repositories, ORM mapping definitions, **EVERYTHING**.

### Organizing the code

As far as organizing the code – I prefer keeping things simple.&#160; If I had my druthers, the UI project wouldn’t compile at all – it would just be a folder, holding content.&#160; Its “bin” folder would merely get populated by the output of the Core project.

Otherwise, I use folders to organize code.&#160; Projects are okay for organization, but they’re pretty rigid and tend to lock you in to layers and structure that are quite, quite difficult to change.&#160; I’ve already been burned a couple of times on large projects making a mistake in my project structure, and found that this approach tends not to scale.&#160; I’ve even run into teams with upwards of 100 projects, with only a half-dozen actual deploy targets!&#160; Remember, compile time is largely a function of the _number of projects._&#160; 1000 files in a single project will compile _much much faster_ than 100 files in 10 projects.&#160; At least an order of magnitude faster in cases I’ve seen.

Another issue I ran into was the difficulty in re-organizing code if you’re locked into a project structure.&#160; Besides just a sloooooooow Ctrl+F5 experience, it can be quite frustrating to realize you’re going to hose your entire source control log history because you want to move a file to a different project.&#160; In one recent hair-pulling re-organization experience, we basically lost our entire log history because we couldn’t do basic source control commands for a re-organization.&#160; This is exacerbated with source control systems like TFS which embed source control information in the actual project files.&#160; In our case, we had to delete all of our projects and re-create them by hand.&#160; Moving folders is waaaaaaay easier than dealing with projects and dependencies.&#160; You _will_ want to re-organize your code, in a major, major way at some point.

If you’re having problems with layering your codebase – projects are a great way of dealing with this problem.&#160; It enforces dependencies quite nicely, basically forcing you to follow certain rules.&#160; However, once you get to the point where you’re starting to create a “Common” project, a “Configuration” project, a “Mappings” project and so on, consider rolling things back up into one project.&#160; Continuing down the project path will introduce friction in just basic everyday coding tasks, so at some point, it’s just not worth it.

So why not just do one UI project?&#160; Put all the code in there, and get the absolute fastest and the most flexible experience?&#160; Content structure is a _completely different concern_ with _completely different reasons for change_ than organizing code.&#160; However you decide to organize your code, keeping the code out of the UI project ensures that you don’t mix code and content organization.