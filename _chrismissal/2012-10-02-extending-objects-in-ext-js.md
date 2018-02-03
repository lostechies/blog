---
wordpress_id: 338
title: Extending Objects in Ext JS
date: 2012-10-02T09:05:23+00:00
author: Chris Missal
layout: post
wordpress_guid: http://lostechies.com/chrismissal/?p=338
dsq_thread_id:
  - "868186823"
categories:
  - JavaScript
tags:
  - ext js
  - javascript
  - javascript objects
---
Last time we explored [JavaScript object extension](http://lostechies.com/chrismissal/2012/09/27/extending-objects-with-javascript/ "Extending Objects with JavaScript") we dove into the most popular JavaScript library in the known universe, [jQuery](http://lostechies.com/chrismissal/2012/09/27/extending-objects-in-jquery/ "Extending Objects in jQuery"). This time around we&#8217;ll be looking at Ext JS, a framework I&#8217;ve been using quite a bit lately. Ext JS relies on this capability all over the place. Especially when you want to create your own customizable components.

[gist id=3797195 file=extending-objects-in-ext-js-1.js]

And the output:

[gist id=3797195 file=extending-objects-in-ext-js-2.js]

You&#8217;re welcome to click back or open a new tab to compare this to the previous post, but this is different from the jQuery example. The single difference is that the _desc_ property doesn&#8217;t exist in our extended object. Ext JS has decided that a property with a null value will overwrite a previous value (see _title_), but an _undefined_ value will in effect erase the property.

For more information: [Function-method-apply](http://docs.sencha.com/ext-js/4-1/source/Function.html#Function-method-apply)