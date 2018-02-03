---
wordpress_id: 33
title: Multi-Targeting support for VS 2008
date: 2007-06-21T14:02:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/06/21/multi-targeting-support-for-vs-2008.aspx
dsq_thread_id:
  - "337034183"
categories:
  - Misc
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/multi-targeting-support-for-vs-2008.html)._

So the official name for Visual Studio &#8220;Orcas&#8221; is Visual Studio 2008 &#8211; which is not as nice as &#8220;Silverlight&#8221;, but it does give Microsoft a year of leeway to delay release.&nbsp; One of the biggest pain points we&#8217;ve had is migrating to Visual Studio 2005 from Visual Studio 2003.&nbsp; We wanted the nice new IDE, but that meant we had to upgrade all of our projects to .NET 2.0 to take advantage of the new IDE features.&nbsp; This was complicated even more since the project files completely changed to MSBuild files, so migration was a such a huge pain, we didn&#8217;t ever want to do it again.

In Visual Studio 2008, Microsoft introduced &#8220;Multi-Targeting&#8221;, which allows the developer to select which version of the .NET Framework to target (2.0, 3.0, or 3.5).&nbsp; Check out [Scott Guthrie&#8217;s blog](http://weblogs.asp.net/scottgu/default.aspx) entry on Multi Targeting for more details:

<http://weblogs.asp.net/scottgu/archive/2007/06/20/vs-2008-multi-targeting-support.aspx>

So we&#8217;ll be able to get all the cool VS 2008 features such as JavaScript Intellisense for our VS 2005 projects, without needing to migrate the projects themselves.&nbsp; Since the project file format won&#8217;t change, migration to .NET 3.5 will be much smoother than from .NET 1.1 to .NET 2.0.

Some might see this as just a nice thing MS did to help developers out.&nbsp; Since migration to VS 2005 left such a bad taste in so many developers mouths, I&nbsp;think this feature was absolutely necessary to provide to remove that barrier of entry for VS 2008.