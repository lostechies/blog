---
wordpress_id: 698
title: Achieving Block Scope With Immediate Functions In JavaScript
date: 2011-12-04T09:56:45+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=698
dsq_thread_id:
  - "493051488"
categories:
  - JavaScript
---
I was digging around on twitter and I found [a great comment from @BenAtExocortex](https://twitter.com/#!/benatexocortex/status/143006055998304256):

> &#8220;Javascript has no block scope (!) but one can use self-executing functions instead (as Javascript has function scope.)&#8221;

What Ben is referring to is that JavaScript doesn&#8217;t scope your variables to if statements or other blocks the way C# and other languages would. Consider this example in C#:

[gist id=1430488 file=block.cs]

On the &#8220;i++&#8221; line, the C# compiler (or Resharper / Telerik JustCode / etc) would throw a compiler error or warning, telling you that the variable isn&#8217;t defined at this point. This happens because the variable declaration is scoped to the if statement.

In JavaScript, though, the same code is perfectly fine:

[gist id=1430488 file=block.js]

This is because JavaScript scopes your variables to functions and not to if-blocks. But, we can achieve block-like scope through the use of immediate functions like this:

[gist id=1430488 file=block2.js]

The &#8220;i&#8221; var in the &#8220;doSomething&#8221; function is assigned the value returned by the immediate function. The &#8220;x&#8221; var is scoped to the immediate function giving us block-like scope for our variables.

Of course, this does add a bit of noise to our JavaScript. Chances are if you need something like this you&#8217;ll really want to extract a proper function. There&#8217;s also some memory and performance implications due to re-defining and executing the immediate function every time you run &#8220;doSomething&#8221;. But, if you understand the implications and you need to achieve block-like scope in your JavaScript to isolate temporary variables, this is one way to do it.