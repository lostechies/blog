---
id: 48
title: Automated Build ADNUG Presentation
date: 2010-06-20T01:58:28+00:00
author: John Teague
layout: post
guid: /blogs/johnteague/archive/2010/06/19/automated-build-adnug-presentation.aspx
dsq_thread_id:
  - "262055744"
categories:
  - automated-builds, ADNUG
---
The last ADNUG presentation was on Automated Builds.&#160; We (were supposed) briefly discuss the different build tools available for .Net.&#160; I gave a demo of using Nant, Derrick Bailey demonstrated Rake / [Albacore](http://github.com/derickbailey/Albacore), Jorge Matos demonstrated powereshell / [psake](http://github.com/JamesKovacs/psake) and Eric Hexter demonstrated [pstrami](http://pstrami.codeplex.com/), his automated deployment stack.&#160; It was really cool having so many project contributors to be able to talk about their projects. Note to Session Organizers: 4 speakers in one session is way to many, won’t make that mistake again.

## Why Use Automated Build Scripts in the First Place

Because we ran long, we really didn’t get a chance to discuss the why’s of using an build script, so I thought I would sum up my reasons for using them.

### Build vs. Compile

A distinction needs to be made build _building_ an application as opposed to _compiling_ an application.&#160; Compiling only gives you whatever your statically typed language provides to verify that your application works, and if you’re using lots of reflection / late binding you get even little. (And I should even have to mention if you’re using a dynamic language right) To make sure your application actually works, you need to do a whole lot more.

**Run Tests.** Hopefully you have a comprehensive suite of tests that can verify the behavior of your application.&#160; These tests need to be ran often and by everyone on your team.

**Build Your Database**.&#160; You can automated the process of building and updating your database to make sure that it is up to date.

**Set Up Your Environment.** Almost every application needs some amount of environment configuration.&#160; Using the tools you can: set up configuration files, create Registry settings,&#160; create and configure websites, start and stop processes, create Queues, the list goes on.&#160; 

You want this process automated because it’s very annoying when small things like this cause your app to blow up and it keeps all dev machines, QA systems, and Production working correctly. 

## Let the Machines Do It

Having to these things manually sucks.&#160; It’s error prone. It requires a great deal of institutional knowledge to manually deploy an application to any system, whether a new developer system or to QA or Production.&#160; Relying on documentation is not much better, because it’s really easy for docs to get out of date.&#160; But if you’re build script gets out of date, you’re going to know really fast and it will only need to be fixed once.

If you need to perform these tasks very frequently to make sure everything is up date. Using a build script in a continuous integration will let you run these everytime someone commits changes to your source code repository, ensuring that your system runs correctly every time some one makes a change.

## Which Tool To Choose

This is somewhat a personal preference.&#160; I’ve used all of these tools at one client or another, so I’ll give you my opinion on each of these.

**NANT**: I’ve used this tool the most, but it’s my least favorite.&#160; Mainly because I’m stuck in angle bracket hell and it’s difficult to test changes.

**Rake / Albacore**:&#160; This is my tool of choice for standard web applications.&#160; I like using Ruby.&#160; I’m betting better at it.&#160; There are a lot of really cool tools you can use (yes, there is more to Ruby than Rails) to make automation tasks very easy.

**psake**:&#160; I use psake for distributed applications.&#160; Often times when building or deploying these types of applications, you need to do a lot with the system or network and no other scripting tool on a Windows machine gives you as much power and flexibility than Powershell at the moment. (IronRuby is likely to catch up).&#160; using Powershell, I cans set up my message queues, start and stop processes and access remote servers.&#160; I’m still not a big fan of the the Powershell syntax but both psake and pstrami have done a good job of creating a dsl that hides a lot of that from you.&#160;&#160; 

The bottom line is they are all good tools and they are all better than manually building and deploying your application.&#160; Invest a few hours in these and they will save many more in a very short time and maybe even a few gray hairs.