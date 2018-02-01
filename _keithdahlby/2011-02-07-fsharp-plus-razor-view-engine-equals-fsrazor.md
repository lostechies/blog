---
id: 39
title: 'F# + Razor View Engine = FSRazor'
date: 2011-02-07T02:39:00+00:00
author: Keith Dahlby
layout: post
guid: /blogs/dahlbyk/archive/2011/02/06/fsharp-plus-razor-view-engine-equals-fsrazor.aspx
dsq_thread_id:
  - "262493392"
categories:
  - ASP.NET MVC
  - 'F#'
  - fsharp
  - fsrazor
  - mvc 3
  - razor
---
Last month InfoQ [posted](http://www.infoq.com/news/2011/01/Razor-Extensions "Razor with F# and Other Languages") some info from the ASP.NET team about using F# with the new Razor view engine. It seemed like it should be pretty simple, so I thought I&#8217;d give it a shot. My (very rough) progress so far is available on [GitHub](https://github.com/dahlbyk/FSRazor "dahlbyk/FSRazor - GitHub"). The solution includes a sample project with a simple F# view using expression blocks:

<pre>﻿&lt;h2&gt;@("FS" + "Razor")&lt;/h2&gt;<br />&lt;p&gt;@(<br />&nbsp;&nbsp;&nbsp; let even_odd s =<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; match s % 2 with<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 0 -&gt; sprintf "%i is even!" s<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | _ -&gt; sprintf "%i is odd!" s<br />&nbsp;&nbsp;&nbsp; DateTime.Now.Second |&gt; even_odd<br />&nbsp;&nbsp;&nbsp; )&lt;/p&gt;</pre>

A useless example, but it works&#8230;as long as there aren&#8217;t unmatched parentheses (within a string or comment). So far the parser is a simple port of the C# parser, and as such is very procedural&mdash;it&#8217;s unclear if the underlying parser model will afford much wiggle room to take advantage of F#.

It&#8217;s been an interesting learning experience, as my first attempt to do &#8220;normal .NET&#8221; inheritance-based development in F#. Some random thoughts based on work so far&#8230;

  * I still struggle to remember F#&#8217;s syntax for familiar class constructs (ctor, method, property, etc)
  * I&#8217;ve been disappointed so far by my attempts to F#-ize the C# port
  * I finally bothered to look up how to add [assembly information in F#  
](http://thevalerios.net/matt/2009/01/assembly-information-for-f-libraries/ "Assembly Information for F# Libraries") 
  * I learned about a few [new ASP.NET 4 features](http://haacked.com/archive/2010/05/16/three-hidden-extensibility-gems-in-asp-net-4.aspx "Three Hidden Extensibility Gems in ASP.NET 4 by Phil Haack"), in particular [PreApplicationStartMethodAttribute](http://msdn.microsoft.com/en-us/library/system.web.preapplicationstartmethodattribute.aspx "System.Web.PreApplicationStartMethodAttribute on MSDN") which uses a magic string (read: undiscoverable) to identify a method which can register the .fshtml build provider

There&#8217;s still a bunch of work yet to do, and I&#8217;d love some help if anyone is actually interested in using this in production&#8230;

  * Tests for the parser and code generator
  * Handling implicit transitions (@ without explicit block) 
  * Handling strings/comments
  * Handling statement blocks
  * Figuring out where F# needs special treatment in Razor (extra features or syntax that won&#8217;t work)
  * MVC support? (@model)
  * WebPages support? ([branch](https://github.com/dahlbyk/FSRazor/tree/WebPages) doesn&#8217;t work yet)