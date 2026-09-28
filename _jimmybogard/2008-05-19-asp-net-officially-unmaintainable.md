---
wordpress_id: 184
title: 'ASP.NET: officially unmaintainable'
date: 2008-05-19T02:13:26+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/05/18/asp-net-officially-unmaintainable.aspx
dsq_thread_id:
  - "264715710"
categories:
  - ASPdotNET
  - MonoRail
redirect_from: "/blogs/jimmy_bogard/archive/2008/05/18/asp-net-officially-unmaintainable.aspx/"
---
Recent forays back into &#8220;classic&#8221; ASP.NET (i.e. not MVC) have me completely convinced that ASP.NET is inherently unmaintainable.&nbsp; Not partially convinced, not on the fence, but completely convinced that the presentation layer of ASP.NET cannot be maintained in any reasonable manner.

I remember a presentation on [MonoRail](http://www.castleproject.org/monorail/index.html) some time ago, where the presenter asked the audience &#8220;how many of you work with ASP.NET in a professional manner?&#8221;&nbsp; A hundred or so hands went into the air.&nbsp; The presenter then asked, &#8220;Now keep your hands in the air if you actually enjoy working with ASP.NET?&#8221;&nbsp; Only a handful of hands stayed in the air.

Now, obviously some peer pressure skewed these results, and it wasn&#8217;t a double-blind survey, but it was clear that developing with ASP.NET is a frustrating experience.&nbsp; My own personal frustrations include:

  * The ridiculous amount of time I spend in Reflector trying to figure out why things that are supposed to &#8220;just work&#8221; when wired up &#8220;just don&#8217;t&#8221;
  * Not having control over the HTML that is spit out.
  * Trying to do anything with AJAX or DHTML with the insane control names
  * That ASP.NET is the king of leaky abstractions

I try to make the ASP.NET layer as thin as possible, so that the bulk of the application is maintainable.&nbsp; But even in a MVP setting, the V is still dreadful to maintain.&nbsp; In the end, HTML is the application, not controls.&nbsp; HTML is what gets delivered to the client, not crazy post-back event server nonsense.

I knew early on I would have troubles with ASP.NET, back in 2003-4 or so, when I had to use Reflector to get even basic scenarios to work with a DataGrid.&nbsp; Debugging why control event isn&#8217;t getting fired pushes my sanity to the brink.

It also doesn&#8217;t help the fact that I&#8217;ve never seen an ASP.NET application with unit tests for the code-behinds.&nbsp; Without tests, your code is unmaintainable.&nbsp; Since you can&#8217;t unit tests code-behinds, you have an immediate charge in your technical debt.&nbsp; For this reason, I can&#8217;t really recommend using plain ASP.NET, almost ever.&nbsp; Using a real MVC framework in MonoRail was not only a breath of fresh air, it felt like I was the frog getting rescued from the pot of boiling water, never noticing the temperature going up.

So do yourself a favor, take the one week [MonoRail](http://www.castleproject.org/monorail/index.html) challenge.&nbsp; Try building one aspect or one story in MonoRail, and see how it feels.&nbsp; Personally, it felt like a crushing weight was finally lifted.&nbsp; You might feel the same, and with a one-week spike (or even one day), what have you got to lose?