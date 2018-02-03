---
wordpress_id: 28
title: 'Ah Ha Moments &#8211; Handcrafted CSS'
date: 2011-10-17T15:00:17+00:00
author: Ryan Rauh
layout: post
wordpress_guid: http://lostechies.com/ryanrauh/?p=28
dsq_thread_id:
  - "445950181"
categories:
  - CSS
---
I recently started reading [Handcrafted CSS](http://handcraftedcss.com) by Dan Cederholm _(just want to add that I am not being paid to blog about this book, it&#8217;s amazing, go buy it)_. I just finished chapter 1 and there are a few _Ah Ha!_ moments I want to share. Most of these are uninteresting to your seasoned CSS cowboy. For me it brings a greater understanding of CSS and a sharper tool in my toolbox.

## Ah Ha Moment #2: .myclass { position: relative; }



If you look at the textbox above we have a simple textbox with a calendar logo right after it (_Sorry google reader fans, embedded jsfiddle doesn&#8217;t show up yet. Promise I&#8217;ll try and fix that._).

This is a total fail. I want the logo to be inside of the textbox on the right side. To do that we are going to use { position: absolute; }. Here&#8217;s where you say, &#8220;wait I thought your Ah Ha moment was { position: relative; }&#8221;. Ok so what happens when we set position absolute on the icon like this

[gist id=&#8221;1279534&#8243; file=&#8221;position_absolute.css&#8221;]



Whoa! The icon went way over to the top right of the jsfiddle. That&#8217;s because we are absolutely positioning the element **relative** to the closest parent. In this case the closest parent element that is { position:relative; } is the <body> tag. That&#8217;s no good. No worries its easy to fix. 

[gist id=&#8221;1279534&#8243; file=&#8221;position_relative.css&#8221;]



Bam! Now the closest relative parent element is the div wrapping both the textbox and the icon. Now just tweek the top and right values until the icon is where you want it. 

[gist id=&#8221;1279534&#8243; file=&#8221;final.css&#8221;]



## Summary tl;dr;

Absolute positioning is not evil if you are positioning it relative to some kind of container. 

Always herpin, but not derpin

-Ryan