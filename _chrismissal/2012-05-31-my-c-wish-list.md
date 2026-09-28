---
wordpress_id: 134
title: 'My C# Wish List'
date: 2012-05-31T20:19:38+00:00
author: Chris Missal
layout: post
wordpress_guid: http://lostechies.com/chrismissal/?p=134
dsq_thread_id:
  - "710161998"
categories:
  - 'C#'
tags:
  - .net
  - 'c#'
  - language
---
I really like C#, but I wish there were a bit more to the language. The Visual Studio team has set up a [UserVoice page](http://visualstudio.uservoice.com/forums/121579-visual-studio/category/30931-languages-c-) so you can vote on your own favorites. I have placed some votes already, but here&#8217;s what I&#8217;m wanting:

### String Interpolation

{% gist 2843776 %}

I want something like this mostly because I hate writing string.Format and/or creating .Format() type extension methods.

### Overriding the ?? Operator

I would love to be able to override/extend the null-coalescing operator (??) in C#. This way &#8220;string like&#8221; objects could combine checks for null, empty, whitespace, etc. Like anything, I&#8217;m guessing this could be abused if not used properly. Also, I know I&#8217;ve wanted to do this, but can&#8217;t come up with a good example to share. I know others have thought that this would be helpful, anybody willing to share an example?

### &#8220;Anonymous Tuples&#8221;

I don&#8217;t know what this is actually called, but I&#8217;d like to write this code in some instances:

{% gist 2847833 %}

I think this could make things cleaner and easier to read in several circumstances.