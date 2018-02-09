---
wordpress_id: 264
title: Why we need named parameters
date: 2008-12-18T14:10:55+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/12/18/why-we-need-named-parameters.aspx
dsq_thread_id:
  - "264716020"
categories:
  - 'C#'
redirect_from: "/blogs/jimmy_bogard/archive/2008/12/18/why-we-need-named-parameters.aspx/"
---
[C# 4.0](http://code.msdn.microsoft.com/csharpfuture) brings the idea of named parameters to C#.&#160; While optional/default arguments are of questionable value (this is from my VB.NET days), named parameters can really clear up the meaning of a method call.&#160; We’re already faking named parameters, as seen here in the ASP.NET MVC codebase:

<pre><span style="color: blue">return </span>GenerateUrl(
    <span style="color: blue">null </span><span style="color: green">/* routeName */</span>, 
    actionName, 
    <span style="color: blue">null </span><span style="color: green">/* controllerName */</span>, 
    <span style="color: blue">new </span><span style="color: #2b91af">RouteValueDictionary</span>(valuesDictionary));</pre>

[](http://11011.net/software/vspaste)

Obviously the above example isn’t compile-time safe and comments lie to you, so it will be nice to be able to provide named parameters, especially when the number of arguments grows in a method call.&#160; Something to look forward to.