---
wordpress_id: 125
title: 'Accessible Markup: Provide a pronunciation tip to screenreaders'
date: 2012-11-19T21:55:37+00:00
author: Sharon Cichelli
layout: post
wordpress_guid: http://lostechies.com/sharoncichelli/?p=125
dsq_thread_id:
  - "935453764"
categories:
  - Uncategorized
tags:
  - accessibility
  - charity
  - css
  - html
---
Last weekend concluded my team&#8217;s contribution to [Knowbility&#8217;s](http://www.knowbility.org/) [Open AIR](http://www.knowbility.org/v/open-air/) competition, building an accessible website for [Texas ROSE](http://www.texasrose.org/), who advocates for electric utility customers. I encountered an interesting challenge, while I was testing the site with a screenreader: It pronounced their Twitter handle, [@TexasROSEorg](http://twitter.com/texasroseorg), as one unintelligible word.

[Deque](http://www.deque.com/), a provider of accessibility solutions, provided help-desk Q&A support during the rally by answering the hashtag #dequeAIR. I reached out to them (Phrasing a tech support question in 140 characters really focuses the mind.), and got great help from [@ChrisCM2006](http://twitter.com/chriscm2006/).

Here&#8217;s the problem. The screenreader pronounces @TexasROSEorg as if it were a word. Putting a title attribute on the anchor tag did not help, nor did wrapping it with an abbr tag with a title attribute. It just read the contents of the tag, like this:



But I want to make it sound like &#8220;Texas Rose org.&#8221; Now, this is a good moment to take a sidebar on accessibility, which is that calling something &#8220;accessible&#8221; is a personal and subjective assessment. What works for one person can completely flout another. Meeting the needs of as many different audiences as possible is complex and difficult, and always involves trade-offs. So if you are a screenreader user, please tell me whether it is helpful, or a hindrance, to have the Texas ROSE Twitter handle pronounced as three words instead of one.

The solution is to tell the screenreader to ignore the one-word version, and to include a three-word version that is pushed way off the visible screen.

Here&#8217;s the markup:
  
{% gist 4115738 %}

Inside the anchor tab, there is a span with the attribute &#8220;aria-hidden=true&#8221; wrapping the version for text-consuming users. The aria-hidden attribute tells the screenreader to skip the contents of that span, so it is not read out loud. The three-word version that follows _is_ read by the screenreader, and to avoid showing this version in the text, it is given a CSS class that sets its position far off the viewable frame.

Here&#8217;s the CSS definition of the offscreen class:
  
{% gist 4115638 %}

Why use the positioning trick instead of &#8220;display:none&#8221; or &#8220;visibility:hidden&#8221;? Many screenreaders will not read content that is hidden via display or visibility, but will read content that is inline but &#8220;appears&#8221; to be off the page.

The result is a <span aria-hidden="true">@TexasROSEorg</span><span style="position:absolute; left:-10000px; top:auto; width:1px; height:1px; overflow:hidden;">Texas ROSE org</span> that sounds like this:



I was pleased that I got the screenreader to pronounce the Twitter handle the same way I would have said it out loud. I do hope that it creates intelligible words for screenreader users, as well. It&#8217;s only &#8220;accessible&#8221; if it actually suits what people need.

I had a fantastic time being part of [Headspring&#8217;s](http://www.headspring.com/) team and competing in and learning from Open AIR. It was a well run event and a great opportunity to be nerdy for a worthy cause.