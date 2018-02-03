---
wordpress_id: 194
title: 'Frontend &#038; Backend: Gotta Keep&#8217;em Separated'
date: 2014-03-25T20:57:15+00:00
author: Brad Carleton
layout: post
wordpress_guid: http://lostechies.com/bradcarleton/?p=194
dsq_thread_id:
  - "2509131384"
categories:
  - backend
  - frontend
  - web applications
tags:
  - backend
  - frontend
---
I used to start my web applications by throwing all of my code into one big project.  So I&#8217;d have html, css, javascript and all the backend code together in one monolithic directory.

Now, I take a different, smarter approach.  I separate the frontend from the backend. Separate code, separate projects.  Why?

## Different Skillz

One downside to having your entire project tucked neatly into one of today&#8217;s monster frameworks like Rails, Django, or MVC, is that it can be very difficult for a frontend developer to work on the project.

While it might be simple for a seasoned Ruby dev to setup rvm, gem install all of the ruby dependencies, deal with native extensions and cross platform issues.  These things are probably not what your frontend developer is best suited for.

In most cases, your typical frontend and backend developer are very different.  A frontend developer needs to have more focus on the user experience and design, whereas a backend needs to be more focused on architecture and performance.

Or to put it another way.  Your frontend developer is probably an uber-hipster who would keel over and die without his mac and latte, while your backend developer is probably more like one of Richard Stallman&#8217;s original neckbeard disciples.

[<img class="alignnone size-full wp-image-204" title="frontend-backend-developers" src="http://clayvessel.org/clayvessel/wp-content/uploads/2014/03/frontend-backend-developers2.png" alt="" width="598" height="266" />](http://clayvessel.org/clayvessel/wp-content/uploads/2014/03/frontend-backend-developers2.png)

## A better architecture

What if the entire backend of your project is simply an API?  That sure makes things easier and simpler on your backend developers.  Now, they don&#8217;t have to worry at all about html, css, or javascript.

It&#8217;s also much simpler on the frontend developers, since they can start their work without having to worry about &#8220;bugs in the build system&#8221; or other server side problems.

It also promotes making the frontend a real first class application and ensuring that it&#8217;s truly robust.  Hopefully, the frontend developer is now encouraged to code for the inevitable scenario when the backend goes down.

What a better user experience to say, &#8220;Hey, we&#8217;re having some issues with the server right now, try back later&#8221; or even better &#8220;The search service appears to be having issues at the moment, but you can still view your profile and current projects.&#8221;

In general, I think the separation approach also promotes the use of realtime single page applications on the frontend.  In my opinion, this offer the best user experience and design architecture for modern web applications.

&nbsp;