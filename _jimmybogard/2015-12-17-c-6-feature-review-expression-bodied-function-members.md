---
id: 1167
title: 'C# 6 Feature Review: Expression-Bodied Function Members'
date: 2015-12-17T21:07:41+00:00
author: Jimmy Bogard
layout: post
guid: https://lostechies.com/jimmybogard/?p=1167
dsq_thread_id:
  - "4412833309"
categories:
  - 'C#'
---
In the last post, I looked at [auto-property enhancements](https://lostechies.com/jimmybogard/2015/12/09/c-6-feature-review-auto-property-enhancements/), with several comments pointing out some nicer usages. I recently went through the HtmlTags codebase, [C# 6-ifying “all the things”](https://github.com/HtmlTags/htmltags/pull/64/files), and auto property and expression bodied function members were used pretty much everywhere. This is a large result of the codebase being quite tightly defined, with small objects and methods doing one thing well.

Expression-bodied function members can work for both methods and properties. If you have a method with one statement, and that statement can be represented as an expression:

[gist id=1df2e298424798419728]

Or a getter-only properties/indexers with a body that can be represented as an expression:

[gist id=4dd3be187aef431dbb8d]

You can collapse those down into something that looks like a cross between a member declaration and a lambda expression:

[gist id=79b3dbb57b437be77760]

This seems to work really well when the expression can fit neatly on one line. In my refactorings, I did have places where it didn’t look so hot:

[gist id=7ab545628028a17462c4]

After:

[gist id=e911187be9ef8294d4a3]

If the original expression looked better on multiple lines formatted out, the new expression-bodied way will look a bit weirder as you don’t have that initial curly brace. Refactoring tools try to put everything on the one line, making it pretty difficult to understand what’s going on. However, some code I have refactored down very nicely:

[gist id=eab1a15e07e60af30b40]

It was a bit of work to go through the entire codebase, so I wouldn’t recommend that approach for actual production apps. However, it’s worth it if you’re already looking at some code and want to clean it up.

**Verdict: Useful often; refactor code as needed going forward**