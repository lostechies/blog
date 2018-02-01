---
id: 889
title: 'Separation of Concerns:  Application Builds &#038; Continuous Integration'
date: 2016-02-28T17:28:24+00:00
author: Derek Greer
layout: post
guid: https://lostechies.com/derekgreer/?p=889
dsq_thread_id:
  - "4620125366"
categories:
  - Uncategorized
---
I’ve always had an interest in application build processes. From the start of my career, I’ve generally been in the position of establishing the solution architecture for the projects I’ve participated in and this has usually involved establishing a baseline build process.

My career began as a Unix C developer while still in college where much of my responsibilities required writing tools in both C and various Unix shell scripting languages which were deployed to other workstations throughout the country. From there, I moved on to Unix C-CGI Web development and worked a number of years with Make files. With the advent of Java, I begin using tools like Ant and Maven for several more years before switching to the .Net platform where I used open source build tools like NAnt until Microsoft introduced MSBuild with its 2.0 release. Upon moving to the Austin, TX area, I was greatly influenced by what was the early seat of the Alt.Net movement. It was there where I abandoned what in hindsight has always been a ridiculous idea … trying to script a build using XML. For the next 4-5 years, I used Rake to define all of my builds. Starting last year, I began using Gulp and associated tooling on the Node platform for authoring .Net builds.

Throughout this journey of working with various build technologies, I’ve formed a few opinions along the way. One of these opinions is that the Build process shouldn’t be coupled to the Continuous Integration process.

A project should have a build process which exists and can be executed independent of the particular continuous integration tool one chooses. This allows builds to be created and maintained on the developer&#8217;s local machine. The particular build steps involved in building a given application are inherently part of its ontology. What compilers and preprocessors need to be used, how dependencies are obtained and published, when and how configuration values are supplied for different environments, how and where automated test suites are run, how the application distribution is created &#8230; all of these are concerns whose definition and orchestration are particular to a given project. Such concerns should be encapsulated in a build script which lives with the rest of the application source, not as discrete build steps defined within your CI tool.

Ideally, builds should never break, but when they do it’s important to resolve the issue as quickly as possible. Not being able to run a build locally means potentially having to repeatedly introduce changes until the build is fixed. This tends to pollute the source code commit history with comments like: “_Fixing the build_”, “_Fixing the build for realz this time_”, and “_Please let this be it … I’m ready to go home_”. Of course, there are times when a build can break because of environmental issues that may not be mirrored locally (e.g. lack of disk space, network related issues, 3rd-party software dependencies, etc.), but encapsulating as much of your build as possible goes a long way to keeping builds running along smoothly. Anyone on your team should be able to clone/check-out the project, issue a single command from the command line (e.g. gulp, rake, psake, etc.) and watch the full build process execute including any pre-processing steps, compilation, distribution packaging and even deployment to a target environment.

Aside from being able to run a build locally, decoupling the build from the CI process allows the technologies used by each to vary independently. Switching from one CI tool to another should ideally just require installing the software, pointing it to your source control, defining the single step to issue the build, and defining the triggers that initiate the process.

The creation of a project distribution and the scheduling mechanism for how often this happens are separate concerns. Just because a CI tool allows you to script out your build steps doesn’t mean you should.
