---
wordpress_id: 688
title: 'Is JavaScript&#8217;s &#8220;Global&#8221; Scope Really Just A Closure?'
date: 2011-11-30T21:22:22+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=688
dsq_thread_id:
  - "489243098"
categories:
  - JavaScript
---
I hear a lot of talk about how it&#8217;s a performance penalty to use globally scoped variables in JavaScript (not to mention, dangerous / dumb). When a function looks for a variable, it checks the current scope, then it checks any outer scopes that the function may be nested in, and finally it reaches the outer-most scope: the global scope of the JavaScript runtime.

It occurred to me, as I was wrapping up the edits for my &#8220;[Variable Scope In JavaScript](http://www.watchmecode.net/javascript-scope)&#8221; screencast, that this is evidence to suggest that access to the global scope, from anywhere other than the global scope in a JavaScript runtime environment, is nothing more than a closure.

Look at it this way: when we access the &#8220;foo&#8221; variable from within the &#8220;sayFoo&#8221; function of this code



(click the link for the JSFiddle, if you&#8217;re in an RSS reader) the runtime has to step out of the &#8220;sayFoo&#8221; function and find the &#8220;foo&#8221; variable declared in the &#8220;outerScope&#8221; function.

Now look at similar code accessing the \`$\` variable from jQuery, as well as a \`bar\` variable defined in the outermost, global scope:



Honestly, I had always assumed that there was something special about the global scope of a JavaScript runtime. I had assumed that the browsers and other runtimes had to build some special mechanism in which the global scope was made available to other scopes. It looks like global scope is nothing more than the bi-product of the closure support that JavaScript has built into it, in combination with the outermost scope of the runtime (a DOMWindow or some other scope for CommonJS implementations).

… mystery, suddenly not so mysterious.