---
id: 26
title: Refactoring NAnt and MSBuild build scripts
date: 2007-05-29T17:22:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/05/29/refactoring-nant-and-msbuild-build-scripts.aspx
dsq_thread_id:
  - "265196760"
categories:
  - MSBuild
  - Refactoring
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/refactoring-nant-and-msbuild-build.html)._

A while back, I talked about the [harmful effects of &#8220;Copy Paste&#8221;](http://developer.us.dell.com/blog/jimmyb/archive/2007/04/16/256.aspx).&nbsp; While editing some NAnt and MSBuild&nbsp;build scripts, I forgot about the evil twin of&nbsp;&#8220;Copy Paste&#8221;, which is &#8220;Find and Replace&#8221; (I guess both twins are evil).&nbsp; I needed to update an MSBuild script to have the correct version numbers of an application we&#8217;re starting on.&nbsp; Here&#8217;s what the abridged MSBuild script looked&nbsp;like before any modifications:

<div class="CodeFormatContainer">
  <pre>&lt;Project&gt;<br />
&nbsp;&nbsp;&lt;PropertyGroup&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath1&gt;E:buildsV2.1USecommCoreBusinessObjectsDistribution&lt;/LocalPath1&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath2&gt;E:buildsV2.1USecommOrderWorkflowDistribution&lt;/LocalPath2&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath3&gt;E:buildsV2.1USecommStore.BusinessObjects.Ecommerce&lt;/LocalPath3&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath4&gt;E:buildsV2.1USecommStore.UI&lt;/LocalPath4&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath5&gt;E:buildsV2.1USecommStore.Utilities.Ecommerce&lt;/LocalPath5&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath6&gt;E:buildsV2.1USecommMyCompany.Store.UI.Ecommerce&lt;/LocalPath6&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath7&gt;E:buildsV2.1USecommMyCompany.Store.UI&lt;/LocalPath7&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath8&gt;E:buildsV2.1USecommstore&lt;/LocalPath8&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath9&gt;E:buildsV2.1USecomm&lt;/LocalPath9&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath10&gt;E:buildsV2.1USecommDeploy&lt;/LocalPath10&gt;<br />
&nbsp;&nbsp;&lt;/PropertyGroup&gt;<br />
&lt;/Project&gt;</pre>
</div>

This file was targeting our &#8220;V2.1&#8221; release, but I needed to update it to &#8220;V2.1.5&#8221;,&nbsp;so all of the directory names had to be changed.&nbsp; I started to whip out the ever-faithful &#8220;Ctrl-H&#8221; to perform a &#8220;Find and Replace&#8221;, but I stopped myself.&nbsp; This was a great opportunity for a refactoring.

### Eliminating duplication

One of the major [code smells](http://c2.com/xp/CodeSmell.html) is [duplicated code](http://c2.com/cgi/wiki?DuplicatedCode).&nbsp; But duplications don&#8217;t always have to occur in code, as the previous MSBuild script showed.&nbsp; I needed to change all of the references of &#8220;V2.1&#8221; to &#8220;V2.1.5&#8221;, and there were two dozen examples of these, which I would need to change through &#8220;Find and Replace&#8221;.

The problem with &#8220;Find and Replace&#8221; is that it can be error-prone.&nbsp; The search can be case-sensitive, I might pick &#8220;Search entire word&#8221;, etc.&nbsp; There are so many options, I would need to try several combinations&nbsp;to make sure I found all of the instances I wanted to replace.&nbsp; Instead of wallowing through the &#8220;Find and Replace&#8221; mud, can&#8217;t I just eliminate the duplication so I only need to make one change?&nbsp; Why don&#8217;t we take a look at our catalog of refactorings to see if one fits for MSBuild.

### Refactoring the script

Detailed in Martin Fowler&#8217;s refactoring [book](http://www.amazon.com/Refactoring-Improving-Design-Existing-Code/dp/0201485672) and [website](http://www.refactoring.com/), I can look up a specific code smell and find an appropriate refactoring.&nbsp; There are some&nbsp;[websites](http://wiki.java.net/bin/view/People/SmellsToRefactorings) that also&nbsp;list out &#8220;smells to refactorings&#8221;.&nbsp; The one that looks the most promising is [Extract Method](http://wiki.java.net/bin/view/People/SmellsToRefactorings).&nbsp; MSBuild scripts don&#8217;t exactly have methods, but they do have the concepts of properties and tasks.

I can introduce a property that encapsulates the commonality between all of the &#8220;LocalPathXxx&#8221; properties, which is namely the root directory.&nbsp; I&#8217;ll give the extracted property a good name, and then make all properties and tasks that use the root directory use my new property instead of hard-coding the path.&nbsp; Here&#8217;s the final script:

<div class="CodeFormatContainer">
  <pre>&lt;Project&gt;<br />
&nbsp;&nbsp;&lt;PropertyGroup&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPathRoot&gt;E:buildsV2.1.5ecomm&lt;/LocalPathRoot&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath1&gt;$(LocalPathRoot)CoreBusinessObjectsDistribution&lt;/LocalPath1&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath2&gt;$(LocalPathRoot)OrderWorkflowDistribution&lt;/LocalPath2&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath3&gt;$(LocalPathRoot)Store.BusinessObjects.Ecommerce&lt;/LocalPath3&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath4&gt;$(LocalPathRoot)Store.UI&lt;/LocalPath4&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath5&gt;$(LocalPathRoot)Store.Utilities.Ecommerce&lt;/LocalPath5&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath6&gt;$(LocalPathRoot)MyCompany.Store.UI.Ecommerce&lt;/LocalPath6&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath7&gt;$(LocalPathRoot)MyCompany.Store.UI&lt;/LocalPath7&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath8&gt;$(LocalPathRoot)store&lt;/LocalPath8&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath9&gt;$(LocalPathRoot)&lt;/LocalPath9&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&lt;LocalPath10&gt;$(LocalPathRoot)Deploy&lt;/LocalPath10&gt;<br />
&nbsp;&nbsp;&lt;/PropertyGroup&gt;<br />
&lt;/Project&gt;</pre>
</div>

Now in future versions (V2.2 maybe?) we&#8217;ll only need to make one change, instead of several dozen.&nbsp; Any time I eliminate duplication,&nbsp;I&nbsp;greatly reduce the chances for error.

### So where are we?

The code smells laid out in Martin Fowler&#8217;s book don&#8217;t apply only to code.&nbsp; As we&#8217;ve seen with this MSBuild script, they can apply to all sorts of other domains where duplication causes problems.&nbsp; All we have to do is find appropriate mappings to the new domain&nbsp;for the refactorings laid out for that particular smell.&nbsp; Of course, if you don&#8217;t know about code smells and how to recognize them, the duplication will probably continue to live on and wreak havoc on your productivity.

My next step is to replace these horrible &#8220;LocalPathXxx&#8221; property names with intention-revealing names.&nbsp; Originally, this script had comments around each property explaining what it meant.&nbsp; There&#8217;s nothing like using intention-revealing names to eliminate the need for comments.