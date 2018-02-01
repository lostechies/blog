---
id: 193
title: 'Forbidden Void type in C#'
date: 2008-06-06T02:26:11+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/06/05/forbidden-void-type-in-c.aspx
dsq_thread_id:
  - "264715793"
categories:
  - 'C#'
---
I&#8217;ve had this come up a couple of times.&nbsp; I&#8217;d really like to be able to do something like this:

<pre><span style="color: #2b91af">Func</span>&lt;<span style="color: blue">bool</span>, <span style="color: #2b91af">Void</span>&gt; whyNot = test =&gt; <span style="color: #2b91af">Console</span>.WriteLine(test);</pre>

[](http://11011.net/software/vspaste)

This is equivalent to:

<pre><span style="color: #2b91af">Action</span>&lt;<span style="color: blue">bool</span>&gt; okThisWorks = test =&gt; <span style="color: #2b91af">Console</span>.WriteLine(test);</pre>

[](http://11011.net/software/vspaste)

Although an [actual Void type exists](http://msdn.microsoft.com/en-us/library/system.void.aspx) in the .NET Framework.&nbsp; There error is very specific:

<pre>error CS0673: System.Void cannot be used from C# -- use typeof(void) to get the void type object</pre>

[](http://11011.net/software/vspaste)

It even calls out the C# language!&nbsp; Having a first class, supported Void type helps out quite a bit in various Functional Programming scenarios I&#8217;ve run into, and I&#8217;ve always had to resort to using the Action delegates.

I&#8217;m sure there&#8217;s a good reason for the explicit forbidding here, much like the generic variance issues.&nbsp; Not being on the C# team, I can&#8217;t really think of any.&nbsp; Anyone else have any insight here?