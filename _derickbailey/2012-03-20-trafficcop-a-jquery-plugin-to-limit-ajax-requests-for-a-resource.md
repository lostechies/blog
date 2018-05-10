---
wordpress_id: 859
title: 'TrafficCop: A jQuery Plugin To Limit AJAX Requests For A Resource'
date: 2012-03-20T07:05:47+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=859
dsq_thread_id:
  - "617884780"
categories:
  - Async
  - JavaScript
  - JQuery
---
A while back, I wrote about [asynchronous template loading](https://lostechies.com/derickbailey/2012/02/09/asynchronously-load-html-templates-for-backbone-views/) for Backbone applications. At the bottom of that post, I showed some code that I wrote which would limit the number of AJAX calls that are made to the server, to one per resource. That way we wouldn&#8217;t end up with multiple calls to the same template, wasting precious network time.

{% gist 2131536 1.js %}

Well it turns out I was on the right track, but [Jim Cowart](http://freshbrewedcode.com/jimcowart/) has a much better implementation of this as a jQuery plugin called [TrafficCop](https://github.com/ifandelse/TrafficCop). Using this plugin, I was able to reduce my code from the above to this:

{% gist 2131536 2.js %}

My BBCloneMail app has been updated to use TrafficCop and this is the actual code from the &#8220;[bbclonemail.views.js](http://derickbailey.github.com/bbclonemail/docs/bbclonemail.views.html#section-5)&#8221; file. Be sure to read [Jim&#8217;s blog post that introduces](http://freshbrewedcode.com/jimcowart/2011/11/25/traffic-cop/) TrafficCop, why it&#8217;s needed, etc. And checkout [the source on Github](https://github.com/ifandelse/TrafficCop).
