---
wordpress_id: 16
title: Unobtrusive JavaScript Part 1
date: 2008-10-15T14:54:11+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2008/10/15/unobtrusive-javascript-part-1.aspx
dsq_thread_id:
  - "262055531"
categories:
  - JavaScript
---
I&#8217;ve been talking to a lot of people lately about Unobtrusive JavaScript (UJS) and what it means to design your web UI around this paradigm.&nbsp; I&#8217;m surprised in the number of people who are not aware of this concept and how it can improve your UI design and performance.&nbsp; I am going to do a series of posts on this topic: a brief introduction to the concepts and detailed posts on each concept with examples.&nbsp; At the end I am going to introduce a helper library I have been working on to help create content in a UJS style.

&nbsp;

### Principles of Unobtrusive JavaScript

There are only a few principles that drive a UJS design, but they can have profound impact on your design.

  1. **Separation of Markup, Style and Behavior.**&nbsp; This is a similar concept to Separation of Concerns when designing object oriented systems.&nbsp; And you get some of the same benefits of SOC and then some.&nbsp; There should be no style information or behavior information embedded into your HTML markup. Also, style and behavior should be in separate files when possible. 
      * **Make No Assumptions**. One of the most challenging aspects of web development is that as a web developer/designer, you have very little control of the environment your application is executed in.&nbsp; Not all browsers are created equal, the number of devices that are display web pages is ever increasing, and users have lots of options that can severely impact your design and functionality.&nbsp; Because of these challenges, you can take nothing for granted.&nbsp; You need to design your web site so that it will work regardless of the abilities of the rendering engine and user preferences. 
          * **Progressive Enhancement.**&nbsp; For browsers that have more capability, provide more functionality and better user experience. 
              * **Follow W3C standards**. Avoid using browser specific features and use the W3C DOM and event model to affect behavior and design.&nbsp; Not only will this broaden your user base, it will save you numerous cross-browser headaches.</ol> 
            Many other people include following JavaScript best practices in the list of UJS principles.&nbsp; I always find these to be very subjective and open to interpretation.&nbsp; I will list what I consider to be best practices, but I&#8217;m sure you have your own list as well.&nbsp; Best practices should be followed regardless of whether or not you are following UJS guidelines.
            
            ### Benefits from UJS
            
            So the obvious question about UJS is &#8220;why should I care&#8221;.&nbsp; There are some obvious benefits to following these practices.&nbsp;&nbsp; Your application will be much easier to maintain and modify.&nbsp; Correctly separating style with CSS style sheets gives you the ability to change you layout as necessary without wading through copious amounts of HTML markup.&nbsp; You also get the same benefit if you need to change the behavior of you system.&nbsp; Using the event model instead of embedding your JavaScript give you the ability to add and change behavior very easily.&nbsp; By following Progressive Enhancement you will increase the number of users who can view your web site and give them more options as to how they can view it.&nbsp; It also extends the lifetime of your web site because it will work on whatever the next latest and greatest web browsing gizmo come out.
            
            You will also get a performance boost as well. If you keep your html markup clean, that is less work for the browser to worry about.&nbsp; It can do it&#8217;s job, render html.&nbsp; Your page footprint will also be smaller, giving you faster load times as well.&nbsp; Also by separating your CSS and JavaScript into separate files, this allows browsers to cache them separately and loading them only when changes occur.
            
            The next few blog posts will go into each of these concepts in detail.&nbsp; I will give examples of poorly designed markup and how to refactor them to a UJS style.
            
            Stay Tuned!!