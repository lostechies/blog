---
id: 1140
title: 'My attempt to understand the dark side&#8230; err&#8230; AMD/RequireJS'
date: 2013-08-09T10:57:41+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=1140
dsq_thread_id:
  - "1589499851"
categories:
  - requirejs
---
Yes, it&#8217;s true. I&#8217;m finally building a full app with RequireJS, on my own. I&#8217;ve worked with it plenty in the past, but always on other people&#8217;s projects. I don&#8217;t have very many nice things to say about RequireJS, because of my experience with it and with solving the same problems in other manners. But, I need to get this under my belt, as a large-ish project that is built from the ground up with RequireJS. 

My intent to is to better understand RequireJS, it&#8217;s use cases and patterns, and form a more insightful and educated opinion. I am doing my best to open my mind about it and even allow my opinion to be changed. A lot of the problems I had with RequireJS back in my consulting days have been addressed. Shims, for example, make it easier to get non-AMD code in to RequireJS (though [this isn&#8217;t without problems](http://www.icenium.com/blog/icenium-team-blog/2013/08/07/using-icenium-everlive-with-requirejs), still). There are still things I don&#8217;t like, though. We&#8217;ll see.

So far, the experience has been painful, frustrating, and left me with a continued sense of &#8220;WHY?!?!??!!!!!&#8221;. I realize that some of this is just me and my opinions, though, and I&#8217;m doing my best to learn through it, and see how RequireJS wants things to work instead of how I want things to work. 

I already have a few blog posts lined up for things I&#8217;m running in to and doing&#8230; none of which are meant to be a &#8220;do it this way&#8221; kind of post. In my typical style, I&#8217;ll be posting what I&#8217;m learning, as I&#8217;m learning it. That means a lot of what I say will be stupid, wrong and a bad idea. But that&#8217;s the point. Getting this stuff out there will bring feedback and help me learn faster.