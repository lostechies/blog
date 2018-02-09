---
wordpress_id: 45
title: 'Project Management in Java: A Confused .NET Developer’s Perspective'
date: 2010-07-12T11:00:00+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2010/07/12/project-management-in-java-a-confused-net-developer-s-perspective.aspx
dsq_thread_id:
  - "425624441"
categories:
  - Ivy
  - Java
  - Maven
  - MSBuild
redirect_from: "/blogs/rssvihla/archive/2010/07/12/project-management-in-java-a-confused-net-developer-s-perspective.aspx/"
---
When I was first introduced to workplace Java the amount of ways one could define a project appeared to be restrictive, confusing and a point of frequent friction. While those things may all be true, it’s a great deal better than I would have expected since I was coming from a world where an upgrade to a newer version of Visual Studio requires your whole team to sync up to that same version!&#160; So how do cross IDEA teams get any work done in the Java workplace? Do Java OSS projects require everyone uses Eclipse, NetBeans, or IntelliJ?&#160; Does every new IDE need to have import/export filters for all of the other existing ones and if it becomes popular do the already present IDE’s have to include this? Which system is the best and what matters?

To answer these questions let break down what makes a project and while doing so compare and contrast the Java perspective with the .NET one.

### Compilation

Java IDE’s (Intellij/Eclipse/Netbeans) – basically run “make” on the fly and pass everything to javac.

JAVA IDE (Maven, Gradle) -agnostic project systems – adding all the references contained directly to the classpath and then calling javac.

.NET (Visual Studio,MSBuild)&#160; – MSBuild feeds all references to csc.

In summary, there is more similar than different here.

### Strong Versioning

Java IDE’s – at least in the case of IntelliJ I ended up manually writing a MANIFEST.MF file.

Java IDE-agnostic project systems – still manual editing a lot of the time but usually just one line already filled out by your template that you edit.&#160; I know NetBeans gives you a GUI to edit this. 

.NET – GUI but you can manually edit an assembly.cs file. 

In summary,&#160; Java IDE’s at least in the case of IntelliJ really are using default Java by hand stuff.

### Dependencies

Java IDE’s&#160; – All use convention! Basically, search for jar files in your source tree, if the IDE finds them it assumes you need them and adds them as references in your project format. Works pretty nice on a whole and allows for manual tweaking in the oddball cases.

Java IDE &#8211; agnostic project systems&#160; – requires explicit dependency reference by version, however they will download them automatically from remote locations and put them in your file-system in a specific way (defined by them unless overridden by you). Since both of these are also responsible for your compilation you have to basically run everything through them or your IDE has to be aware of them.

.NET – requires explicit reference to DLL’s on the file system.

In summary, .NET and the Java IDE-agnostic systems are VERY similar here in approach, whereas the Java IDE’s take a convention over configuration approach. I’d say there are times I definitely prefer the Java IDE approach and there are times the capabilities of the Java IDE-agnostic systems are worth it.

### 

### Source References

All Java solutions – do reference by directory structure and wild card matching.

.NET – explicit references to **<u>each class file</u>** .

In summary, this is the HUGE difference. Java takes more of a Make based approach where it’s EXPECTED this will not be the only IDE/project system ever used on this source tree, and this is where the Visual Studio/.NET experience starts to fall apart when trying to use cross-ide’s or versions. It has forced everyone to implement and keep up with MSBuild’s format to enable other IDE’s to be used, and don’t talk about actual alternatives to MSBuild. At this point even though things like NAnt and Rake/Albacore are more popular among agile .NET teams than scripting MSBuild almost all of those scripts still call MSBuild to do the compile step! 

### Questions Answered

Q. How do Java OSS projects deal with all the different IDE’s out there and even different project formats?/How do cross IDE teams get work done?

A. They don’t have to worry about it as much as .NET devs. A friend of mine who a lead contributor to the Apache Cassandra project in fact included a Maven file for the “enterprise types” but by and large use Ant’s to do their builds and he himself has used a number of IDE’s on that same codebase. .NET OSS development is still a bit hamstrung by MSBuild and really alternative IDE’s are keeping in sync with that project management format. There are real problems with style and code format guidelines, but there are usually workarounds or ways of solving this if code style guidelines is something you really care about ( which I don’t).

Q. Which system is the best?

A. There is no one size fits all answer here. I now know Apache Maven solves some problems for people and even though I don’t appreciate it’s approach to things, it’s done some valuable good for the community.&#160; The IDE-centric approach really works pretty well a lot of the time for projects. Gradle, while being the closest to what I want is very young and has limited IDE support, at least it’s not easy enough for this Java n00b to figure out how to use with IntelliJ without some friction.

### Summary

I hope that all wasn’t too confusing, it sure was for me to go through while I had all these options , and in a completely different environment to what I was used to. Worse a lot of the folks I talked to saw these IDE-agnostic project systems as solving problems they didn’t have. Maven, Ivy, etc was a world that was buzzword laden (I’m really looking at you Maven and Ivy), involved heavy setup time for relatively simple tasks, incomplete documentation (looking at you Gradle) and was frequently badly misused (those who know me know what I’m referring too here). In the end an IDE-centric approach in the Java world does not seem to tie you to that IDE in any way I can find, and for getting started had little friction, and for people new to Java it seemed to be the best way to get started. Besides in Java at least it’s easy to change your mind later.