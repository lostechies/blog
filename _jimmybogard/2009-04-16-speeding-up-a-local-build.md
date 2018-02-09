---
wordpress_id: 306
title: Speeding up a local build
date: 2009-04-16T02:16:12+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/04/15/speeding-up-a-local-build.aspx
dsq_thread_id:
  - "264812945"
categories:
  - ContinuousImprovement
  - ContinuousIntegration
redirect_from: "/blogs/jimmy_bogard/archive/2009/04/15/speeding-up-a-local-build.aspx/"
---
For the past few years, I’ve been fairly strict about following a rigorous Continuous Integration process.&#160; That means we run a local build (NOT just a solution compile) before we check in.&#160; However, our local build was getting rather long.&#160; For us on a large team, five minutes is too long.&#160; It’s just long enough that people start to get bored.&#160; It’s just long enough that we attached a build chime to the end so that we had audible cues that our build was done (no one likes to stare at a console screen).

Once things got bad enough, we looked at ways of speeding up our local builds.&#160; There are quite a few sources on the interwebs, and here are a few that we found greatly sped things up.

### 1) Tame the solution structure

Using multiple projects to enforce dependencies is a noble cause, but quite inefficient.&#160; I’ve seen teams, with the desire to enforce a certain architecture, explode their project count from a handful to dozens.&#160; All in the name of trying to make sure I didn’t call the data access layer from the UI layer.&#160; But build time is largely affected by the **number of projects far, far more than the number of files**.&#160; What’s more insidious about large numbers of projects is that it introduces dozens and dozens of delays in day-to-day development.&#160; I can deal with a long local build time, but if it takes a minute or more to simply _run_ my application locally, my noble cause has introduced far more pain than it has solved.

The quickest way to solve this naturally is to collapse your solution structure down.&#160; Try to focus your projects more on _deployment_ dependencies and targets rather than projects or files.&#160; You can still structure your project using \*gasp\* folders however you like.&#160; But with all that file copying and compiling over and over again, large numbers of projects.&#160; Concerned about relationships and dependencies?&#160; Try NDepend.

### 2) Use file-based dependencies

Project A depends on Project B.&#160; Project B depends on Project C.&#160; I make a change in Project C, but now I have to copy files to _two_ places, Project A and Project B.&#160; As your dependencies deepen, Visual Studio can’t know when projects need to be re-compiled.&#160; Instead, you can change your project configuration to output _all_ assemblies to _one_ common folder.&#160; Control build order not through project references, but through compilation order, which is easily configurable through the solution options of Project Dependencies and Project Build Order.

Using file-based dependencies eliminates all of the needless file copying going on, and lets Visual Studio be smarter about when items need to be recompiled.&#160; Putting this in practice in your local build will also speed things along.

### 3) Batch targets in MSBuild and NAnt calls

There is a significant performance hit when starting up MSBuild, and to some extent, NAnt.&#160; But both of these allow for passing in multiple build targets in one call.&#160; Instead of:

<pre>msbuild.exe /t:Clean
msbuild.exe /t:Build</pre>

[](http://11011.net/software/vspaste)

Do this:

<pre>msbuild.exe /t:Clean /t:Build</pre>

[](http://11011.net/software/vspaste)

We get the same effect, two targets run, but now we don’t have to start MSBuild twice, have MSBuild parse the XML build files twice, and so on.

### 4) Use in-memory databases for testing

On our local builds, we run a suite of integration tests against a local database, which are orders of magnitude slower than unit tests.&#160; If you’re using an ORM like NHibernate, switching databases is as easy as changing a configuration file.&#160; This is something we’re working towards on our team (and isn’t there yet), but I’ve heard quite a few great things about tremendous speed improvements, 10X in some cases.&#160; Check out Justin Etheredge’s post on the subject for a detailed writeup:

[http://www.codethinked.com/post/2008/10/19/NHibernate-20-SQLite-and-In-Memory-Databases.aspx](http://www.codethinked.com/post/2008/10/19/NHibernate-20-SQLite-and-In-Memory-Databases.aspx "http://www.codethinked.com/post/2008/10/19/NHibernate-20-SQLite-and-In-Memory-Databases.aspx")

The interesting part I hear is “but I’m not really testing against my database anymore!”&#160; The only problems I’ve run into when switching between Oracle and SQL Server were Oracles absolutely asinine naming restrictions.&#160; And guess what, we’ve got a test for that too!

On our server, we run against the real databases we integrate with.&#160; But locally, since we don’t take advantage of database-specific grammar, functions or things of that nature, it makes sense to make this optimization.

### 5) Asynchronous build tasks

Our build steps go something like this:

  * Clean output directories
  * Reset local test database
  * Compile solution
  * Run aspnet_compiler to compile views
  * Run unit tests
  * Run integration tests

Some tasks obviously need to be run before others.&#160; I have to compile before I test.&#160; But some tasks don’t have dependencies on ones that come before it.&#160; Because we’re all running on multi-core machines, we can take advantage of Jay Flower’s [asyncexec](http://jayflowers.com/WordPress/?p=101) NAnt task.&#160; This task is identical to the “exec” NAnt task, with one difference – it doesn’t wait for the process to complete.&#160; At the end of our build, we’ll have another task, that waits for all asynchronous tasks to complete.

In our case, we made the aspnet_compiler task run asynchronously, right after our compilation.&#160; Because unit tests and integrations can take a while, it turns out that doing that resulted in an immediate 90 second drop in the time in our build, almost 20% for us at the time.&#160; Quite significant!

You can’t make everything asynchronous, as disk I/O time and the number of cores (as well as dependencies between tasks).&#160; But a couple of well-placed asynchronous tasks in place of “exec” can have quite a large impact.

### Wrapping it up

When we started our build improvements, I was at around 390 seconds locally, completely unacceptable.&#160; After our build improvements (and we still haven’t put in in-memory databases), we’re down to 180 seconds, that’s over a 50% drop.&#160; Even more important is that the build time is now down to a time where it doesn’t distract from my work, and I don’t have to worry about the time to integrate my changes.

These aren’t the only ways to speed up builds, nor speed up integrations.&#160; Other ideas include using a staging server, developer branches, gated commits, and others.&#160; All great ideas in improving our efficiency in delivering value.