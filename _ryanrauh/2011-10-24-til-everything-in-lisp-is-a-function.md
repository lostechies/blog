---
wordpress_id: 41
title: TIL everything in Lisp is a function
date: 2011-10-24T19:35:55+00:00
author: Ryan Rauh
layout: post
wordpress_guid: http://lostechies.com/ryanrauh/?p=41
dsq_thread_id:
  - "452186829"
categories:
  - Functional Programming
tags:
  - Haskell
  - JavaScript
  - Lisp
---
I&#8217;m current reading [Structure and Interpretation of Computer Programs](https://docs.google.com/a/fitorbit.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BxVCLS4f8Sg5OGUwMmZlZjYtZWQ4Zi00ZThmLWFkMjYtNTIxZmY4ODhjNDdl&hl=en&authkey=CLnyyF4&pli=1) as part of a study group we started during Pablo&#8217;s Fiesta. Our goal is learn Haskell by reading this book and implementing all of the exercises in Haskell instead of Lisp. So far its been really fun and it&#8217;s actually forcing me to learn both Haskell and Lisp at the same time.

I find Lisp to be a fascinating language and it actually makes a lot more sense to me than Haskell does. Going through the exercises we came across this really interesting piece of code.

[gist id=&#8221;1309414&#8243; file=&#8221;a\_plus\_abs_b.ss&#8221;]

Ok so what&#8217;s going on here?

  * if b > 0 
      * return +
  * else 
      * return &#8211;

<img class="aligncenter" src="http://cl.ly/443n0X2m2D2q0u0i003M/at_first_i_was_like.jpg" alt="at first i was like" />

I think it is really cool that symbols like + and &#8211; are just functions, therefore you can return them from an if statement. Here is how this might look in javascript.

[gist id=&#8221;1309414&#8243; file=&#8221;a\_plus\_abs_b.js&#8221;]

Arguably not as cool as the Lisp example but it helped me understand it better.

## OMG whats the point 

The point is go out and [learn you a Haskell](http://learnyouahaskell.com) (_or any functional language other than javascript_ ). It&#8217;s for a greater good. I had never thought of + and &#8211; as just functions and now I&#8217;m kind of pissed that other languages don&#8217;t let you exposed them as such. Or give me a choice like Haskell does. 

[gist id=&#8221;1309414&#8243; file=&#8221;a\_plus\_abs_b.hs&#8221;]

Herp Derp,

-Ryan