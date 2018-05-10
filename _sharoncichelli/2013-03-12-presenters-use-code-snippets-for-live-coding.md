---
wordpress_id: 182
title: Presenters, Use Code Snippets for Live Coding
date: 2013-03-12T08:15:25+00:00
author: Sharon Cichelli
layout: post
wordpress_guid: http://lostechies.com/sharoncichelli/?p=182
dsq_thread_id:
  - "1132576583"
categories:
  - Arduino
  - Conference
tags:
  - presenting
---
Creating code live on the fly makes a more compelling demo, but actually typing those curly braces and semi-colons can kill a presentation. As hard as it is [not to say &#8220;um&#8221;](https://lostechies.com/sharoncichelli/2012/03/20/how-not-to-say-um-when-presenting/), it&#8217;s nigh impossible to not make a million typos on stage.

Code snippets, where you need to type only a short keyword to automatically insert a small piece of relevant code, are a great antidote. I learned this strategy from watching [Burke Holland](http://a.shinynew.me/) teach us about CoffeeScript. Most code editors and text editors support code snippets, and if yours doesn&#8217;t, you can use [AutoHotKey](http://www.autohotkey.com/) to define a set of hotstrings.

Here&#8217;s an example of one of mine. In the Arduino IDE, I type:
  
    `.ledhigh`
  
and AutoHotKey immediately replaces that with:
  
    `digitalWrite(led, HIGH);<br />
    delay(700);`

My snippets are short so that I can explain as I create the code, creating an experience for the audience that feels very much like live coding&mdash;but it&#8217;s live coding with flawless fingers. 

I put my [Arduino presentation snippets on GitHub](https://github.com/scichelli/Arduino-Sketches/blob/master/CodeMashArduino.ahk). You&#8217;ll notice two tips there. First, I prefixed my hotstring abbreviations with a period to make conflicts unlikely. Second, I added a conditional at the top to make the hotstrings apply only when the Arduino IDE is active.
  
    `#IfWinActive ahk_class SunAwtFrame`
  
I discovered the class of the window by using the Window Spy application that comes with AutoHotKey. I used the ahk_class instead of the window title because, although the Arduino IDE changes its window title based on the sketch it is showing, the class type of the window stays the same.

It&#8217;s tempting to launch into a presentation figuring the most exciting way to share code with the audience is to type it live. If you&#8217;ve ever actually done this, though, you know how devilishly your hands will _betray you_. At the other extreme, a wall of code on a slide will captivate your audience, at the expense of anything you might be saying at the time. Use code snippets to dole out code in explainable chunks, live but without the typos.