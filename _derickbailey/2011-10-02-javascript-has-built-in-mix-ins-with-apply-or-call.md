---
wordpress_id: 600
title: 'JavaScript Has Built-In Mix-ins With &#8216;apply&#8217; Or &#8216;call&#8217;'
date: 2011-10-02T12:46:38+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=600
dsq_thread_id:
  - "432251088"
categories:
  - Uncategorized
---
While I was running the Object-Oriented JavaScript discussion / demo at Pablo&#8217;s Fiesta this weekend, Jimmy Bogard asked me to try something fun. I had a small constructor function defined with a couple of methods defined directly in it.

{% gist 1257742 1-stuff.js %}

I also had an object literal with no methods defined, and was showing something (I don&#8217;t remember what, at the moment). Jimmy asked me to call &#8216;apply&#8217; on the constructor function and pass my object literal into it.

{% gist 1257742 2-apply.js %}

Then he asked me to call one of the methods from the function constructor on my object literal instance.

{% gist 1257742 3-whatever.js %}

I expected this to fail, because I didn&#8217;t think the method would be around on my object literal. I was wrong, of course! [Here&#8217;s that code running in a live JSFiddle](http://jsfiddle.net/derickbailey/Brp4S/4/) (click the &#8216;result&#8217; tab if you&#8217;re seeing the embedded version in this post).



CRAZY! … or… simply exposing how constructor functions actually work, exposing an easy way to do mixins with JavaScript?

Here&#8217;s what&#8217;s happening:

1) When I call the function using \`apply\`, the first parameter i used as the context of the call. Therefore, \`this\` inside of the function refers to the object that I&#8217;ve passed in to \`apply\`. When \`this.someMethod = function(){…}\` is called, &#8216;this&#8217; is the object i passed in.

2) I&#8217;m allowed to add any function I want to any object I want at any time, simply by assigning the function to an attribute on the object. Therefore, when \`this.someMethod = …\` is called, it&#8217;s as if I was directly calling \`foo.someMethod = …\` directly.

With this in mind it seems that JavaScript has mix-ins built right in. There&#8217;s no need to use something like underscore.js&#8217; \`extend\` method. But I wonder: are there any gotchas to this scenario? Anything that I need to watch our for? I&#8217;m going to have to play a little more to see what the effects are, what scenarios really work well and don&#8217;t, etc.
