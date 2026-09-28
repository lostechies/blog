---
wordpress_id: 247
title: 'Thoughts on C# 4.0'
date: 2008-11-05T03:01:41+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/11/04/thoughts-on-c-4-0.aspx
dsq_thread_id:
  - "264715958"
categories:
  - 'C#'
redirect_from: "/blogs/jimmy_bogard/archive/2008/11/04/thoughts-on-c-4-0.aspx/"
---
It looks like VB.NET.

<strike>Dynamic</strike> late-bound typing.

Optional parameters.

Am I missing something?&#160; Or does this just look like what VB.NET had since .NET 1.0? Option Strict Off – that’s a trick we’ve had for a long time.&#160; It doesn’t help when a lot of the scenarios demonstrated are of Office COM integration – that’s what VB.NET was good at.

Named parameters are nice, but optional parameters are things we avoided like the plague, simply because versioning killed them.&#160; Optional parameter default values were bound to the version they were compiled against, not what they were run against.&#160; This led to really strange behavior if you ever changed the default values, similar to using consts versus static fields.&#160; Honestly, the big reason I went away from VB.NET so many years ago besides its verbosity and its crazy line continuator baloney was the lack of ReSharper support at the time.

Personally, I’m still waiting for a true hash implementation a la Ruby, first class regular expressions, and a real Void type that could put to sleep the strange separation between the Action and Func delegate types.

A good step, but not nearly as big as C# 3.0 was.