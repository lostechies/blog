---
id: 1324
title: Reassign JavaScript Function Parameters In Reverse Order, Or Lose Your Params
date: 2014-03-18T06:00:04+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=1324
dsq_thread_id:
  - "2456861552"
categories:
  - JavaScript
  - NodeJS
---
Every now and then I need to have a method support 2 or 3 arguments, providing a default value for one of them if only 2 are specified. My typical solution is to check the number of arguments passed to the function and reassign the named parameters as needed. I think this is a fairly typical solution in JavaScript. Except I spent about 30 minutes trying to track down a bug, just now, and it&#8217;s somewhat perplexing to me.

## Can You Spot The Bug?

Here&#8217;s a sample of the code in question, that you can run from NodeJS. I&#8217;m using NodeJS 0.10.26 in this case.

[gist id=9497859 file=fail.js]

There isn&#8217;t anything terribly special here. Check the number of arguments. If it&#8217;s 2, then re-assign the &#8216;a&#8217; variable to a default, reassign &#8216;b&#8217; to what &#8216;a&#8217; originally was, and reassign &#8216;c&#8217; to what &#8216;b&#8217; originally was. Note that I&#8217;m doing this reassignment through the use of the arguments array, as well.

Can you guess what the output is, based on the code above?

<img style="margin-left: auto;margin-right: auto" src="http://lostechies.com/derickbailey/files/2014/03/NewImage7.png" alt="NewImage" width="217" height="182" border="0" />

#WAT

## Why are my parameters empty?

How I Thought Parameters Worked

I&#8217;ve always assumed method parameters worked the same way as variables. If I have 2 variables pointing at the same data, and I reassign one of them, then the other one is not reassigned.

[gist id=9497859 file=vars.js]

This makes sense to me. This is how by-reference variables have always worked in my mind. And so, I&#8217;ve always expected function parameters to work the same. But apparently method parameters don&#8217;t work this way. Based on the above behavior, my currently confused understanding of this relationship says that the &#8220;a&#8221; parameter is not actually a variable in JavaScript. Rather, it&#8217;s some special construct that references the value of arguments[0]&#8230; not a by-ref variable that points to this value, but more like a by-val variable that \*IS\* the value of this memory location. 

Given this by-val nature of the named parameter -> arguments[n] relationship, when my code above assigned &#8220;a&#8221; to an empty string it wiped out the &#8220;arguments[0]&#8221; value as well. 

#WAT

## Fixing The Bug: Reverse The Reassignment Order

In order to work around this, you have to reassign the parameters in reverse order. 

[gist id=9497859 file=win.js]

And now the results are what I expected:

<img style="margin-left: auto;margin-right: auto" src="http://lostechies.com/derickbailey/files/2014/03/NewImage8.png" alt="NewImage" width="209" height="172" border="0" />

## By-Val Params

It turns out JavaScript does treat params and the arguments object as a by-val relationship. You change one, the other is also changed, unlike standard variables. From what I&#8217;ve read, this isn&#8217;t just NodeJS either &#8211; it&#8217;s the JavaScript spec.

Honestly, I had no idea that it was treating function parameters as by-val. After all these years with JavaScript, this language still surprises me.