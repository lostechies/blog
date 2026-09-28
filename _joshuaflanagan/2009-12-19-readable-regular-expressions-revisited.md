---
wordpress_id: 3954
title: Readable Regular Expressions Revisited
date: 2009-12-19T16:24:47+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2009/12/19/readable-regular-expressions-revisited.aspx
dsq_thread_id:
  - "262113226"
categories:
  - Uncategorized
redirect_from: "/blogs/joshuaflanagan/archive/2009/12/19/readable-regular-expressions-revisited.aspx/"
---
Many, many years ago (internet time), I proposed a <a href="http://flimflan.com/blog/ReadableRegularExpressions.aspx" target="_blank">fluent interface for composing regular expressions</a>. People either loved the idea or hated it (or thought it was just ok). The intention was to try and tackle the opaqueness of regular expressions that might be embedded in your otherwise familiar C# source code.

I’ll confess I never used that approach in production code. It started as a thought experiment, and that’s as far as it went (for me, at least). However, I did pick up a great technique from the comments. <a href="http://www.omegacoder.com/" target="_blank">William “OmegaMan” Wegerson</a> suggested using RegexOptions.IgnorePatternWhitespace along with liberal usage of in-line comments. Here is a recent example from the <a href="http://code.google.com/p/fubumvc/" target="_blank">fubumvc</a> source:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>const string propertyFindingPattern = @"
{              # start variable
(?&lt;varname&gt;w+) # capture 1 or more word characters as the variable name
(:              # optional section beginning with a colon
(?&lt;default&gt;w+) # capture 1 or more word characters as the default value
)?              # end optional section
}              # end variable"; 
</pre>
</div>

Notice that the comments violate one of the main rules of good commenting: do not restate what the code says. Usually, someone reading your code is literate enough in the programming language that they can figure out “what” the code does, it just isn’t always clear “why”. But when it comes to regular expressions, I would guess that a majority of C# programmers need to look at a regex reference every time they try and decipher a pattern. Do them a favor and document what each part of the pattern does while you are writing it, since you’re probably looking at the reference already anyway. This should make it much easier for someone to follow (and modify) the code going forward. No fancy fluent interface required.