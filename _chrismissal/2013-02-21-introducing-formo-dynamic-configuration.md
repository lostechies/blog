---
wordpress_id: 3396
title: 'Introducing Formo &#8211; Dynamic Configuration'
date: 2013-02-21T09:12:25+00:00
author: Chris Missal
layout: post
wordpress_guid: http://lostechies.com/chrismissal/?p=377
dsq_thread_id:
  - "1096824777"
categories:
  - .NET
  - 'C#'
  - Open Source
tags:
  - configuration
  - dynamic
---
In the off-chance that I have to maintain your code in the future, I feel I should gamble and share this project with you. I created it, I use it, and I like it.

Something bothers me about seeing strings inside square brackets. It has always felt dirty and error-prone. Since C# is now being sucked into the universe of dynamic, I thought that was a good opportunity to use dynamic to avoid these strings. By no means does [Formo](https://github.com/ChrisMissal/Formo) fix all these issues, but it helps in a couple ways and makes me feel better when I need to reference configuration.

Given a configuration file:

{% gist 5001941 file=app.config %}

Formo can be used to:

{% gist 5001941 file=Formo.cs %}

As well as:

{% gist 5001941 file=FormoCast.cs %}

[Formo](https://github.com/ChrisMissal/Formo) is lightweight, free to use, and has no dependencies. Use it now with NuGet:

<pre>Install-Package Formo</pre>

This covers the majority of use-cases I&#8217;ve come across. If you have improvements to Formo, or just ideas in general, please submit them as issues on the [GitHub issues page](https://github.com/ChrisMissal/Formo/issues "Formo Suggestions/Issues/Defects").

<del>Have an idea for a logo?! I&#8217;d love a <a href="https://github.com/ChrisMissal/Formo/pull/new/master">pull request</a>!</p> 


  <p>
    </del>
  </p>



  <p>
    EDIT: Great logo from <a href="http://timgthomas.com/">Tim G. Thomas</a>: <a href="http://dribbble.com/shots/953675-Formo">http://dribbble.com/shots/953675-Formo</a>
  </p>