---
wordpress_id: 346
title: Extending Objects in Dojo
date: 2012-10-03T15:21:28+00:00
author: Chris Missal
layout: post
wordpress_guid: http://lostechies.com/chrismissal/?p=346
dsq_thread_id:
  - "870175139"
categories:
  - JavaScript
tags:
  - dojo
  - javascript
  - javascript objects
---
Dojo works a bit differently than we saw with [jQuery](https://lostechies.com/chrismissal/2012/09/27/extending-objects-in-jquery/ "Extending Objects in jQuery") and [ExtJS](https://lostechies.com/chrismissal/2012/10/02/extending-objects-in-ext-js/ "Extending Objects in Ext JS"). They have the notion of _extend_ as well as _mixin_. These both behave differently, not only from each other, but from the previous jQuery.extend and Ext.apply. These methods in Dojo work right to left, different from our previous examples.

Let&#8217;s discuss _mixin_, this is more like what we previously saw with previous libraries&#8217; methods:

{% gist 3797197 file=extending-objects-in-dojo-1.js %}

And the output:

{% gist 3797197 file=extending-objects-in-dojo-2.js %}

If you remember from the previous posts, we extended our _start_, _more_, and _extra_ objects from left to right. Using a Dojo mixin, our arguments are passed to the function in the reverse order; this is by design. Everything in our output of the _extended_ object remains as it was in our _start_ object. The only difference is that _more_ added the _name_ property and _extra_ added the _dojo_ property. This works just like you&#8217;d expect a mixin function to work and just like our previous extend and apply from jQuery and Ext JS.

The dojo.extend function works on an object&#8217;s prototype and doesn&#8217;t follow the same patterns of this series of blog posts. For that reason, I&#8217;m going to skip it and let you do your own homework if you&#8217;re interested. 😉

For more information: [dojo.mixin](http://dojotoolkit.org/reference-guide/1.8/dojo/mixin.html) (Yes I know this way to reference dojo is deprecated, but the old version worked better in my tiny example.)