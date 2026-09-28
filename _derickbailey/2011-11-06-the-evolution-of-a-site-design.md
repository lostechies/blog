---
wordpress_id: 642
title: 'The Evolution Of A Site&#8217;s Design'
date: 2011-11-06T14:23:55+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=642
dsq_thread_id:
  - "463603817"
categories:
  - Design
---
Site design is an evolutionary process, like anything else. As new and updated information is needed on the site, the design must change to correctly display it. New functionality is also added on a regular basis, and things must be moved around to accommodate this. There are also times when you realize that a design just isn&#8217;t right for some reason &#8211; maybe the wrong information is being highlighted or the functionality that you want to show off isn&#8217;t standing out.

## The Evolution Of My Site

In my case, I&#8217;ve been building a website to sell my first screencast over at [WatchMeCode.net](http://watchmecode.net). It&#8217;s only been up for a couple of weeks now, but the design has gone through an almost continuous evolution. There is hardly a day that goes by, where I am not tweaking something on the site to make sure I am highlighting the right things, showing the right information at the right time, and providing the most value to my visitors.

Just for fun, I decided to create a quick video that shows the evolution of my WatchMeCode.net site. Here&#8217;s the video:



## Making The Video

The setup to create the video was simple.

I use [LiveReload](http://livereload.com/) when I&#8217;m building my websites. This little tool will tell my browser to refresh the page when any of the files for the site change. It will also stream in JavaScript and CSS changes silently. And, I&#8217;m using Git to manage my source code.

I started at the head of the repository &#8211; the most recent version. I hit record in ScreenFlow and recorded everything on my screen &#8211; including a terminal window that you don&#8217;t see in this video. Then every few seconds, I ran this command in my terminal window:

git checkout HEAD^

This forced the repository to move backward one commit at a time. Every time this checkout happened, LiveReload saw the file system changes and told the browser to update itself. Once I had everything recorded, I added the &#8220;Evolution of …&#8221; section to the end, cropped the video down to the size you see now, and exported it. Then I opened the exported video in iMovie, reversed it, and exported that to YouTube. The result is what you see, above.