---
id: 6
title: 'Coffeescript vs. Javascript: Dog eat Dog'
date: 2013-10-23T03:15:25+00:00
author: Brad Carleton
layout: post
guid: http://lostechies.com/bradcarleton/?p=6
dsq_thread_id:
  - "1889232642"
categories:
  - coffeescript
  - JavaScript
---
I&#8217;m happy to say that I&#8217;m now an official los techies &#8220;techie&#8221;!  Thanks to Chris Missal and all the other amazingly smart people who let me join the Los Techies crew.  Without further ado, this article is going to focus on the pros and cons of javascript vs coffeescript.

<h2 style="font-size: 24px;">
  The Case against Javascript
</h2>

**Javascript has a bad reputation** of being a flaky scripting language, because let&#8217;s face it, that&#8217;s exactly how it started out.  There are a number of let&#8217;s say, _quirks_, in the language that make most developers cringe:

  * Strange type coercision and overloading of <code style="color: darkgreen;">+</code>
  * Strange results for equality testing <code style="color: darkgreen;">==</code> or <code style="color: darkgreen;">===</code>, <code style="color: darkgreen;">!=</code> and <code style="color: darkgreen;">!==</code>
  * Prototypal inheritance vs. class based object orientation
  * Noisy syntax, lots of curly braces, function keywords, and semicolons
  * Global variables are as easy a missing a <code style="color: darkgreen;">var</code> statement
  * Lack of any sort of design aesthetic
  * Lots of bad javascript progammers (think graphic designers)
  * Lots of bad javascript code (think code that a graphic designer would write)
  * Hundreds of implementations for every browser, version and other javascript dependent platform (and yes, some of them are buggy)

Now those last three are more a reflection of the javascript ecosystem than the language design, but they are worth a mention, because they contribute to javascript&#8217;s overall poor repuation.

<h2 style="font-size: 24px;">
  There&#8217;s actually some great stuff about Javascript
</h2>

While javascript may look gnarly on the outside, there are actually some pretty nice features from a semantic standpoint:

  * Awesomely dynamic (basically you can do anything you want, type safety and common sense be damned)
  * Top-notch functional programming
  * Largest community of developers
  * Largest install base on the planet
  * No corporate ownership of the standard
  * Sophisticated javascript runtimes (most modern browsers, node.js etc)

<h2 style="font-size: 24px;">
  Coffeescript:  It&#8217;s Better than Javascript right?
</h2>

A few years ago, coffeescript jumped onto the scene as an alternative to _straight-up javascript_. (If you want to take a closer peak at the syntax, then I advise you checkout their site, <a href="http://coffeescript.org" target="_blank">coffeescript.org</a>.)

> **CoffeeScript is a little language that compiles into JavaScript.** Underneath that awkward Java-esque patina, JavaScript has always had a gorgeous heart. CoffeeScript is an attempt to expose the good parts of JavaScript in a simple way.

What a novel idea!?  A precompiled language that fixes all of the nastiness and awkwardness of the javascript language.

Well, it turns out that it&#8217;s not that simple.  Here&#8217;s an excellent rant/explanation of <a href="http://ryanflorence.com/2011/case-against-coffeescript/" target="_blank">why coffeescript is not so great</a>.

<h2 style="font-size: 24px;">
  The Subjective Argument against Coffeescript
</h2>

The subjective argument against coffeescript can be summed up pretty easily:

> Do you like C-style syntax or Ruby/Python-style syntax?

Coffeescript was designed in the vein of Python and Ruby, so if you hate those languages then you will probably hate coffeescript.  As far as programming languages go, I believe that a developer will usually be more productive in the language that they like programming in.  This may seem like a no-brainer, but there are quite a few articles out there trying to argue the objective truth of **_and_** vs **_&&_**.

<h2 style="font-size: 24px;">
  The Hard Objective Arguments against Coffeescript
</h2>

Here are what I consider the most pertinent arguments against coffeescript.

  * Added debugging complexity
  * Added compile complexity
  * Smaller development community

<h2 style="font-size: 24px;">
  How to Decide which language for your Project
</h2>

I&#8217;ve worked on large projects in both javascript and coffeescript, and guess what?  You can build an application in either one, and your decision of javascript or coffeescript is not going to make or break you.

If you are working on a project by yourself, then I would pick whichever language you prefer working in.  It&#8217;s totally subjective, but you are going to be more productive coding in a language that you like coding in vs. one that you hate coding in.

Now, for the tricky part.  What if you&#8217;re working on a team?

<h2 style="font-size: 24px;">
  Coffeescript ate my Homework
</h2>

This is where coffeescript can be a huge problem.  If you are working with a tight group of skilled engineers, and you decide to work in coffeescript, and everyone is on board, then my opinion is that you might very well end up being more productive.  Especially with programmers that have a Ruby or Python background.

However, for projects that have a revolving team of contractors or that have junior developers that hardly understand the semantics of javascript to begin with, then I would say watch out!

This may seem paradoxical, but I think part of the problem comes back to the debugging cycle.  Debugging is a critical part of learning a new language, and for someone with a good javascript background, the coffeescript debugging problem shouldn&#8217;t be that much of an issue.  However, for a noob, it can be a killer.  They don&#8217;t grasp if their mistakes are part of coffeescript or javascript which leads to major time sinks on very mundane syntax errors.

In short&#8230; it depends 🙂

&nbsp;

&nbsp;