---
wordpress_id: 13
title: 'Ah Ha Moments &#8211; Handcrafted CSS Chapter 1'
date: 2011-10-10T15:32:46+00:00
author: Ryan Rauh
layout: post
wordpress_guid: http://lostechies.com/ryanrauh/?p=13
dsq_thread_id:
  - "439310929"
categories:
  - CSS
---
I recently started reading [Handcrafted CSS](http://handcraftedcss.com) by Dan Cederholm _(just want to add that I am not being paid to blog about this book, it&#8217;s amazing, go buy it)_. I just finished chapter 1 and there are a few _Ah Ha!_ moments I want to share. Most of these are uninteresting to your seasoned CSS cowboy. For me it brings a greater understanding of CSS and a sharper tool in my toolbox.

Ah Ha Moment #1: a { display:block; }

Your classic anchor tag:

{% gist 1275482 gistfile1.html %}

The anchor tag is an inline element, which 99% of the time is what you want. Think about that 1% of the time when you want an anchor tag to make the entire element clickable.



Hover over each of the list items above and notice how only the link text is clickable _(embedded jsfiddle, sorry google reader fans)_. That&#8217;s a total fail, I want the whole <li> to be clickable. No worries it easy to fix!

![display_block](http://cl.ly/062f3E3Z432j2z1A0Z3G/Image_2011-10-10_at_11.06.06_AM.png)



Notice how the entire <li> is now clickable.

Awesome right? I think so,

-Ryan
