---
wordpress_id: 327
title: Extending Objects in jQuery
date: 2012-09-27T22:01:14+00:00
author: Chris Missal
layout: post
wordpress_guid: http://lostechies.com/chrismissal/?p=327
dsq_thread_id:
  - "862397318"
categories:
  - JavaScript
  - JQuery
tags:
  - javascript
  - javascript objects
  - jquery
---
Welcome to my journey of  [extending objects in JavaScript frameworks](https://lostechies.com/chrismissal/2012/09/27/extending-objects-with-javascript/ "Using various frameworks to extend JavaScript objects"); let&#8217;s explore jQuery! Extending an object in jQuery is simple, there are just a few rules you need to understand. Extension works from left to right and you&#8217;re allowed to pass as many objects to the function as you want. Whatever is passed to the $.extend argument last wins.

**<span style="text-decoration: underline;">For instance:</span>**

<div>
  <span style="text-decoration: underline;"><br /> </span>
</div>

<div>
  {% gist 3797108 file=extending-objects-in-jquery-1.js %}
</div>

<div>
  <span style="text-decoration: underline;"><br /> </span>
</div>

**<span style="text-decoration: underline;">Output:</span>**

<div>
  <span style="text-decoration: underline;"><br /> </span>
</div>

<div>
  {% gist 3797108 file=extending-objects-in-jquery-2.js %}
</div>

<div>
  <span style="text-decoration: underline;"><br /> </span>
</div>

Again, remember that the last one in wins. It is also worth noting that anything extended with an explicit \`undefined\` will keep its original value. If you want to override a value with a &#8220;falsy&#8221; value, use \`null\`, \`false\` or anything else that makes sense in your case.

Arrays are always overwritten by the last object passed in.  The objects inside them are at mercy of their parents. It doesn&#8217;t matter if they are values or objects, the last object passed in, gets the last call.

For more information: <http://api.jquery.com/jQuery.extend/>