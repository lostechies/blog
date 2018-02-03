---
wordpress_id: 3395
title: Extending Objects in Underscore
date: 2012-10-05T11:03:44+00:00
author: Chris Missal
layout: post
wordpress_guid: http://lostechies.com/chrismissal/?p=351
dsq_thread_id:
  - "872693113"
categories:
  - JavaScript
  - Underscore
tags:
  - javascript
  - javascript objects
  - underscore
---
Underscore is a very nice library, it&#8217;s what Backbone JS is built on. What I&#8217;ve come to like about it is its ability to provide very helpful functions that let you more effectively work with sets of data.

Below is the code we&#8217;ve seen before, only slightly modified because we&#8217;re using Underscore&#8217;s _extend_ function now.

[gist id=3797198 file=extending-objects-in-underscore-1.js]

And the output:

[gist id=3797198 file=extending-objects-in-underscore-2.js]

This is the exact same output as our [Ext JS example](http://lostechies.com/chrismissal/2012/10/02/extending-objects-in-ext-js/ "Extending Objects in Ext JS"). Since there&#8217;s nothing new, I can&#8217;t go on about too many differences, but I can, however, bring up another related function in Underscore, _defaults_.

The _defaults_ method is interesting in that it works very similarly, but turns our familiar objects into something new that the others haven&#8217;t yet done.

[gist id=3797201 file=adding-defaults-to-objects-in-underscore-1.js]

And the output:

[gist id=3797201 file=adding-defaults-to-objects-in-underscore-2.js]

This one fills in missing properties and ignores any match applied after. Our _start_ object was able to keep the _id_ as _123_, the _count_ at _41_ and so on. The second argument, _more_ set the _name_ property because it didn&#8217;t exit in _start_ and finally the properties on _extra_ already existed, so it had no effect on the final output.

The _extend_ and _defaults_ functions work almost opposite from each other, but are great to have side-by-side when you need them.

For more information: [extend](http://underscorejs.org/#extend) and [defaults](http://underscorejs.org/#defaults).

&nbsp;