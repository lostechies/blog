---
wordpress_id: 849
title: Resizing KendoUI Splitter To Fill Screen Vertically
date: 2012-03-02T09:59:26+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=849
dsq_thread_id:
  - "596258511"
categories:
  - JavaScript
  - JQuery
  - JSFiddle
  - KendoUI
---
I dropped the jQuery.Layout plugin in favor of [KendoUI&#8217;s Splitter](http://demos.kendoui.com/web/splitter/index.html) control yesterday. Kendo&#8217;s Splitter is just so much easier to use and more flexible. It was a no-brainer for me, really.

But I ran in to a problem: how to resize the splitter so that the &#8220;main&#8221; content of my app would resize vertically, while keeping the header and footer at a set, specific size? Fortunately, [Burke Holland came to my rescue](https://twitter.com/burkeholland/status/175303601521049601)! And, as I expected, it&#8217;s a simple solution.

## Resize The Splitter On Window Resize

{% gist 1959279 resize.js %}

Simple enough, right? Just pay attention to the $(window).resize event, calculate the size of the main content area, and call resize on the splitter.

## The Live Demo

Here&#8217;s [the JSFiddle Burke created for me](http://jsfiddle.net/t3AG6/4/), in all it&#8217;s awesomeness:



To actually see this working, you&#8217;ll want to [visit the fiddle directly](http://jsfiddle.net/t3AG6/4/) and then resize your window.

I did make a few small changes to the resize method from the original JSFiddle that I&#8217;m showing, in my gist above. In order to keep the top and bottom panes the same size all the time, I added a resize on them in the function. Otherwise, when you shrink the screen really small and then make it really large again, the top and bottom sections tend to be hidden. I also cleaned up a few global var leaks and fixed an error triggering the reset event for the version of Kendo I&#8217;m using.
