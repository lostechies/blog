---
wordpress_id: 4206
title: SPWeb.AssociatedGroups.Contains Lies
date: 2010-01-27T11:00:00+00:00
author: Keith Dahlby
layout: post
wordpress_guid: /blogs/dahlbyk/archive/2010/01/27/spweb-associatedgroups-contains-lies.aspx
dsq_thread_id:
  - "262493322"
categories:
  - Extension Methods
  - SharePoint
  - SPExLib
---
While working on [SPExLib](http://solutionizing.net/2009/06/01/spexlib-release-these-are-a-few-of-my-favorite-things/ "SPExLib Release: These Are A Few Of My Favorite Things") (several months ago), I revisited [this post](http://solutionizing.net/2009/03/19/more-sharepoint-higher-order-functions/ "More SharePoint Higher-Order Functions"), which presented a functional approach to a solution Adam describes [here](http://www.sharepointsecurity.com/blog/sharepoint/sharepoint-2007-development/get-spgroup-if-not-available-create/ "Get SPGroup, If Not Available, Create!"). Both posts include logic to add an `SPWeb` group association, which most simply could look something like this:

<pre>SPGroup group = web.SiteGroups[groupName];<br />if (!web.AssociatedGroups.Contains(group))<br />{<br />    web.AssociatedGroups.Add(group);<br />    web.Update();<br />}</pre>

While testing on a few groups, I noticed that the `Contains()` call lies, always returning `false`. This behavior can also be verified with PowerShell:

<pre>PS &gt; $w.AssociatedGroups | ?{ $_.Name -eq 'Designers' } | select Name<br /><br />Name<br />----<br />Designers<br /><br />PS &gt; $g = $w.SiteGroups['Designers']<br />PS &gt; $w.AssociatedGroups.Contains($g)<br />False</pre>

Of course, it&#8217;s not actually lying&mdash;it just doesn&#8217;t do what we expect. Behind the scenes, `AssociatedGroups&nbsp;` is implemented as a simple `List<SPGroup>` that is populated with group objects retrieved by IDs stored in the `SPWeb`&#8216;s `vti_associategroups` property. The problem is that `List<T>.Contains()` uses `EqualityComparer<T>.Default` to find a suitable match, which defaults to reference equality for reference types like `SPGroup` that don&#8217;t implement `IEquatable<T>` or override `Equals()`.

To get around this, [SPExLib](http://spexlib.codeplex.com/ "SharePoint Extensions Lib") provides a few extension methods to make group collections and `SPWeb.AssociatedGroups` easier to work with and more closely obey the [Principle of Least Surprise](http://en.wikipedia.org/wiki/Principle_of_least_astonishment "Principle of Least Astonishment - Wikipedia"):

<pre>public static bool NameEquals(this SPGroup group, string name)<br />{<br />    return string.Equals(group.Name, name, StringComparison.OrdinalIgnoreCase);<br />}<br /><br />public static bool Contains(this SPGroupCollection groups, string name)<br />{<br />    return groups.Any&lt;SPGroup&gt;(group =&gt; group.NameEquals(name));<br />}<br /><br />public static bool HasGroupAssociation(this SPWeb web, string name)<br />{<br />    return web.AssociatedGroups.Contains(name);<br />}<br /><br />public static bool HasGroupAssociation(this SPWeb web, SPGroup group)<br />{<br />    if (group == null)<br />        throw new ArgumentNullException("group");<br />    return web.HasGroupAssociation(group.Name);<br />}<br /><br />public static void EnsureGroupAssociation(this SPWeb web, SPGroup group)<br />{<br />    if (web.HasGroupAssociation(group))<br />        web.AssociatedGroups.Add(group);<br />}</pre>

The code should be pretty self-explanatory. The name comparison logic in `NameEquals()`
  
is written to align with how SharePoint compares group names
  
internally, though they use their own implementation of case
  
insensitivity because the framework&#8217;s isn&#8217;t good enough. Or something
  
like that.

There should be two lessons here:

  1. Don&#8217;t assume methods that have a notion of equality, like `Contains()`, will behave like you expect.
  2. Use [SPExLib](http://spexlib.codeplex.com/ "SharePoint Extensions Lib") and contribute other extensions and helpers you find useful. 🙂