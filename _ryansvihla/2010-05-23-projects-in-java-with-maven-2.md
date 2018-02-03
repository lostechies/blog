---
wordpress_id: 40
title: Projects in Java with Maven 2
date: 2010-05-23T02:56:22+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2010/05/22/projects-in-java-with-maven-2.aspx
dsq_thread_id:
  - "1088470090"
categories:
  - Uncategorized
---
NOTE: due to issues with spam I’ve turned off comments, I’ve cross posted on my [old blogger account](http://ryansvihla.blogspot.com/2010/05/projects-in-java-with-maven-2.html) if you have comments.

For those of you who don’t know Maven is a build tool/dependency manager/project model. Those in the Microsoft space can probably imagine MSBuild + the ability to download all dll’s for you.

### What I liked

  1. Dependency Resolution. Automatic downloading of dependencies rocks in concept. Just specify library name and version and when you compile again it’s there.&#160; No need to check in jar’s into your source tree. 
  2. IDE Independence. In practical terms lets you use whatever IDE you want with no import/export.&#160; Intellij, Eclipse and Netbeans all understand maven as a full project format. So your team can all have different IDE’s and not create havoc with one another. 
  3. Good Default Project Structure. Tests are in the same location by default, resources for tests and your prod code are in expected places. 

### What I hated

  1. Inefficient with already downloaded dependencies. It will check remote repositories _every time_ you build even when you specified version number. Now I can see why they did that but not as a default. I mean sure version 1.12 may have had a bad bug and the project hotfixed in a new one with the same version number, but I’d say that’s really unlikely.&#160; In a larger project with several repositories the difference in time to build between this and an alternate dependency manager Apache Ivy is stark. 
  2. Very opinionated view of the build process. Those of you used to (N)Ant or Rake will miss the lack of control. The AntRun plugin will help mitigate some of the lose of control. 
  3. HOME/.m2/settings.xml . Specific system wide settings do not belong in a build language. The bad heavy friction ideas that it enabled were legion. Just one example was I had to connect to my work VPN even when working on my home OSS projects hosted on github. 
  4. Way too XML for for sometimes simple things. To specify the version of java target language version see the figure below, this specifies Java 1.6. 

&#160;

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <div style="font-family:consolas,lucida console,courier,monospace">
    <span style="color:#008000"><b><build></b></span><br /> &#160;&#160;<span style="color:#008000"><b><plugins></b></span><br /> &#160;&#160;&#160;&#160;<br /> &#160;&#160;&#160;&#160;<span style="color:#008000"><b><plugin></b></span><br /> &#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b><artifactId></b></span>maven-compiler-plugin<span style="color:#008000"><b></artifactId></b></span><br /> &#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b><configuration></b></span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b><source></b></span>1.6<span style="color:#008000"><b></source></b></span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b><target></b></span>1.6<span style="color:#008000"><b></target></b></span><br /> &#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b></configuration></b></span><br /> &#160;&#160;&#160;&#160;<span style="color:#008000"><b></plugin></b></span><br /> &#160;&#160;&#160;&#160;<br /> &#160;&#160;<span style="color:#008000"><b></plugins></b></span><br /> <span style="color:#008000"><b></build></b></span>
  </div>
</div>

### Summary

If you have a cross IDE team or are running an OSS java project I find it very hard to ignore Maven. If you are looking for easier dependency management, less verbose build files, and do not care about IDE independence I suggest any number of alternatives such as Apache Buildr, Apache Ivy, Gradle or many others I’m sure I’m forgetting.