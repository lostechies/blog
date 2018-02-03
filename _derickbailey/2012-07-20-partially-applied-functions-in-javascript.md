---
wordpress_id: 962
title: Partially Applied Functions In JavaScript
date: 2012-07-20T08:30:16+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=962
dsq_thread_id:
  - "773265069"
categories:
  - Async
  - ECMAScript
  - Functional
  - JavaScript
  - Underscore
  - WinJS
---
I&#8217;m finding myself doing more and more [functional programming](http://en.wikipedia.org/wiki/Functional_programming) with JavaScript lately &#8211; especially in recent days with this WinJS project I&#8217;m working on, and [the heavy use of promises that it encourages](http://lostechies.com/derickbailey/2012/07/19/want-to-build-win8winjs-apps-you-need-to-understand-promises/). This feels a little odd to me, considering my current passion for building object-oriented JavaScript apps with Backbone. But at the same time, there&#8217;s something very natural about a functional style in JavaScript. There are a lot of fun things you can do with a functional style in JavaScript and I encourage you to explore it.

## Partial Function Application

One of the tools that I&#8217;ve picked up in the process of exploring a functional style is [partial function application](http://en.wikipedia.org/wiki/Partial_application), which according to Wikipedia, allows us to provide &#8220;a number of arguments to a function, producing another function of smaller arity.&#8221; (&#8220;Arity&#8221; is a fancy word for argument count of a function). Note that [partial function application is not the same thing as &#8220;currying&#8221;](http://msmvps.com/blogs/jon_skeet/archive/2012/01/30/currying-vs-partial-function-application.aspx). The two ideas may be similar, but they are definitely different and the two terms should not be interchanged.

What partial function application really means is that we can take a function that expects 2 parameters, and create a partially applied function that has the first parameter fixed. The result is itself a function that expects only one parameter. When calling that last function, the result of the original function is produced.

An example:

[gist id=3151016 file=1.js]

Here, we&#8217;re using [the ECMAScript 5 standard of the &#8220;bind&#8221; function](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Function/bind) to do the partial application. The &#8220;bind&#8221; function serves two purposes: 1) to bind a function&#8217;s context (&#8220;this&#8221; argument) and 2) to create a partially applied function. 

The net result, when calling the &#8220;partial&#8221; function, is what you would expect to get by calling the original function with two parameters. This can be used any number of times, across any number of parameters. You can supply one or more arguments to bind to your partially applied function, and you can partially apply a partially applied function as well. Of course, this might get a little ridiculous after a while, but it can still be done.

## Implementing Partial Application 

The most basic way to get partial application in to your code is to write for browsers and runtimes (like NodeJS and WinRT) that support ECMAScript-5. 

(**Side note**: Since I&#8217;m working with WinJS and WinRT in a Windows 8 runtime, I get to stick with raw ECMAScript 5 in my JavaScript. IE10 does a great job of implementing this standard, and it&#8217;s really a pleasure to write applications for this browser and the WinRT run time. The added benefit of not having to worry about cross-browser compatibility when building a WinJS application is also really refreshing.) 

But even if you&#8217;re not using a browser or runtime that supports ECMAScript-5 standards and the &#8220;bind&#8221; function, partial application is easy to do. Writing a function to do it yourself doesn&#8217;t take much effort, and there are plenty of implementations available to use &#8211; like [this one from John Resig](http://ejohn.org/blog/partial-functions-in-javascript/):

[gist id=3151016 file=2.js]

Now you might not want to go and modify the core JavaScript &#8220;Function&#8221; prototype to add this (I wouldn&#8217;t personally). But don&#8217;t worry, you could easily modify that to work as a separate function call on it&#8217;s own. Or, you could use a library like Underscore.js, which provides partial application via the &#8220;bind&#8221; function on itself instead of modifying the Function prototype:

[gist id=3151016 file=3.js]

There are probably a thousand other implementations of this around. I&#8217;m only listing these two for the sake of brevity in this blog post.

## A Use Case For This

I&#8217;ve known about partial function application for quite some time now. But I&#8217;ve never had a reason to use it and never understood why it would be useful, or in what scenarios it might be a good idea. It just seemed like an academic exercise to me. In the WinJS/WinRT app that I&#8217;m building with the MS P&P group, though, I may have found a scenario where it makes sense and creates a much more clean expression of code than not using it.

This is some code that [@bennage](https://twitter.com/bennage) and I wrote for the sample WinJS/WinRT app that we&#8217;re building:

[gist id=3151016 file=4.js]

It&#8217;s not terribly bad. In fact, it&#8217;s quite terse and easy to read. It makes heavy use of promises and chains them together. Each of the function calls returns a promise, which facilitates the chained &#8220;then&#8221; calls. Except there&#8217;s that one call in the middle where an inline function is provided in order to get a second parameter passed to the function via a closure. I wanted to see what it would take to make this inline function go away, and partial application solved that problem for me:

[gist id=3151016 file=5.js]

In this version, the inline function has been removed and a local variable has been provided in it&#8217;s place. That local variable is a partially applied function, using ECMAScript-5&#8217;s &#8220;bind&#8221; function. I apply the first parameter to the actual function call, and that returns a function that now only needs one parameter. Since the parameter that comes from the &#8220;then&#8221; call in the promise chain is the exact parameter that this partially applied function needs, I can supply this partially applied function to the &#8220;then&#8221; call and everything works as expected.

## No, Really. An Actual Use Case For This?

Ok, this is a pretty trivial example and can easily be argued as unnecessary. The original code wasn&#8217;t that bad and may be easier to understand for some people. But the end result of the chained &#8220;then&#8221; statements has a certain beauty and elegance that I love. It&#8217;s got a distinct functional style and flow that makes it very easy for me to read, as if [I&#8217;m looking at a sequence diagram for my code](http://lostechies.com/derickbailey/2012/05/10/modeling-explicit-workflow-with-code-in-javascript-and-backbone-apps/) &#8211; and I can&#8217;t help but love that.