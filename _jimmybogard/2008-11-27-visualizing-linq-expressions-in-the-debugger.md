---
wordpress_id: 259
title: Visualizing LINQ expressions in the debugger
date: 2008-11-27T03:08:52+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/11/26/visualizing-linq-expressions-in-the-debugger.aspx
dsq_thread_id:
  - "264820126"
categories:
  - LINQ
---
In [Ben’s](http://flux88.com/) recent post on [Fluent Route Testing in ASP.NET MVC](http://flux88.com/blog/fluent-route-testing-in-asp-net-mvc/), he recalled a problem we had when trying to figure out how to deal with an Expression<> once we have one.&#160; Typically, I like to parse the Expression to get at some reflection information, whether it’s to look at model members for DTO mapping or specifying controller actions.&#160; Expression<> is very helpful for strongly-typed reflection, but the underlying type can be a pain to deal with.&#160; The base Expression type has quite a few derived types to deal with:

![](http://grabbagoftimg.s3.amazonaws.com/expression_derived.png)

What makes things worse is that the ExpressionType property, which you’re supposed to inspect, doesn’t match up in the least to the individual child Expression types.&#160; There are forty-something ExpressionType enum values, from things like “ExclusiveOr” to “SubtractChecked” to “Coalesce”.&#160; It’s mainly trial-and-error to understand how a given lambda expression would translate into an Expression tree.&#160; As Ben noted, I just broke in the debugger and expanded down and down until I saw what I needed.

As I read it this morning, I wondered, “why isn’t there a LINQ expression debugger visualizer”?&#160; This is what keeps me up at night, very sad.&#160; Some crack investigation (Google) showed me that there are two nice ones out there already.&#160; The first is a debugger visualizer that comes with Visual Studio’s samples.&#160; You can find it in the C# samples in <Program Files>Microsoft Visual Studio 9.0Samples1033.&#160; Just compile the ExpressionTreeVisualizer project and drop the resulting assembly into <Program Files>Microsoft Visual Studio 9.0Common7PackagesDebuggerVisualizers folder, and you’re set.

The other nice visualizer, which is a little prettier, is [Manuel Abadia’s visualizer](http://www.manuelabadia.com/blog/PermaLink,guid,9160035f-490f-46bd-ab55-516b5c7545af.aspx).&#160; The interesting aspect of debugger visualizers is that you can install as many as you like, and pick which one to view using the little magnifying glass:

 ![](http://grabbagoftimg.s3.amazonaws.com/expression_mag.png)

Clicking on the first sample visualizer brings up a nice TreeView control:

 ![](http://grabbagoftimg.s3.amazonaws.com/expression_vs.png)

Or, clicking on the second choice brings up the prettier, StructsViz visualizer:

 ![](http://grabbagoftimg.s3.amazonaws.com/expression_sv.png)

Along with the VisualStudio visualizer sample is a stand-alone console/WinForms application, which is nice as the debugger visualizer is a modal dialog that you can’t keep around for further development.&#160; Once you’re done debugging, the visualizer goes away.&#160; But, it’s still better than manually expanding the normal object debug visualizer.&#160;