---
wordpress_id: 43
title: Java Dependency Management with Apache Ivy
date: 2010-06-29T13:10:00+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2010/06/29/java-dependency-management-with-apache-ivy.aspx
dsq_thread_id:
  - "1070316389"
categories:
  - Uncategorized
---
Not wanting to ditch your already built well working ant scripts for the plugin-centric view of Maven, especially if your project structure doesn&#8217;t line up quite right with Maven&#8217;s point of view? Enter Apache Ivy which like Maven can automatically download and resolve all of your dependencies and their dependencies for you with just a few simple lines of XML (if only I could get rid of the XML Part).

<span style="font-size: 14px;font-weight: bold">Pros</span>

  * Integrates with Ant, but can still be run standalone.
  * By default dumps all dependencies into your lib folder which makes it super easy to use with most IDE&#8217;s.
  * Works with existing Maven 2 repositories, allowing you to leverage work already done by the Maven community.

### Cons

  * Despite lots of documentation, too much focus on theory with little practical example of how to do simple things. Maybe I&#8217;m missing something but I did waste a fair amount of time trying to get a custom 3rd party repository working without crippling the defaults for Ivy. Again I may be just dense, but this was harder for me than either Gradle or Maven to do, and I ran into a couple of hiccups from there.
  * Limited IDE support compared to say Maven at least in the case of Intellij. Part of this is Maven has some pretty snazzy integration with Maven and I know on more than a couple of occasions I&#8217;ve just started projects with Maven because Intelij makes it super simple and gives me lots of nice integration for adding dependencies with the classic alt+enter .

I decided to include the default scripts I start with. This should get you up and running and give you a template for solving some of the hassle I went through. Just place next to each other in your top level project directory, ivy.xml, ivysettings.xml, and build.xml if you plan on using Ant integration. Also for ant integration make sure you have ivy-2.1.0.jar in &#8220;$ANT_HOME/lib&#8221; and all should be well. Please ask for clarification on anything, I&#8217;ll do another post if I get enough questions.

&nbsp;</p>