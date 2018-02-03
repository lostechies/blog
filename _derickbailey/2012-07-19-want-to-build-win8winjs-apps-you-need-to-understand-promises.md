---
wordpress_id: 958
title: Want To Build Win8/WinJS Apps? You Need To Understand Promises.
date: 2012-07-19T07:35:16+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=958
dsq_thread_id:
  - "772022690"
categories:
  - Async
  - CommonJS
  - JavaScript
  - WinJS
---
If you&#8217;re not [following me on Twitter](https://twitter.com/derickbailey), you may not know about my current project work. I&#8217;m working with [Christopher Bennage](https://twitter.com/bennage) and the [Microsoft Patterns & Practices](http://msdn.microsoft.com/en-us/practices) group to build a [Windows 8](http://windows.microsoft.com/), [WinJS](http://msdn.microsoft.com/en-us/library/windows/apps/br229773.aspx), Metro-style app with HTML, CSS and JavaScript. It&#8217;s a tremendously fun project, and I&#8217;m learning a lot &#8211; not only about Windows 8 and metro style apps, but also about raw ECMAScript-5 based development, with no shims or facades, no jQuery and no Backbone.js. And one of the most important things that I&#8217;ve learned about WinJS development so far, is that if you want to build apps for Windows 8 with HTML and JavaScript, you must have a solid understanding of asynchronous JavaScript development and [promises](http://wiki.commonjs.org/wiki/Promises).

## Basic Async JavaScript: Callbacks

The most basic form of asynchronous development in JavaScript is the use of callback methods. If you&#8217;ve written a line of jQuery.ajax code or DOM event handling, you&#8217;ve worked with callbacks:

[gist id=3143855 file=1.js]

The anonymous functions in both of these example are callback functions. They are functions that are called at some non-deterministic point in the future. They may be called immediately. They may be called a few seconds from now. They may never be called. The circumstances in which these anonymous callback functions are executed is up to the code that we are calling initially. Fortunately, these circumstances are documented within the jQuery API and documentation and we can be reasonably certain about the timing of the execution of these callbacks.

The reason that callbacks facilitate asynchronous JavaScript is due to the non-deterministic nature of calling them. As the designer of the API that takes in a callback, you are handed a direct reference to a function when a callback is passed in to your methods parameters. This allows you to call that function whenever you need to:

[gist id=3143855 file=2.js]

In the case of asynchronous code, such as animations, DOM click events, and AJAX calls across the network, the callback that is supplied to the method is not fired immediately. It is fired when a response from the external network call returns, when the DOM element is manipulated by the user, or when the animation completes. The function that is doing the work simply holds on to the callback reference and calls it when necessary.

## The Problem With Callbacks

Callbacks are a very useful and tremendously powerful tool. They also have some oddities and quirks related to the &#8220;this&#8221; variable (JavaScript&#8217;s context), but [that can easily be managed](http://www.watchmecode.net/javascript-context). But worse than managing &#8220;this&#8221;, callbacks have a much deeper problem relating to code readability and maintainability. 

Look at what happens to the code when we have multiple nested callbacks:

[gist id=3143855 file=3.js]

Yes this is a contrived example, but it is based on the realities of raw callback-based async code in JavaScript. I&#8217;ve seen code 10x worse than this in any number of JavaScript applications. Heavy use of jQuery tends to make this especially awful as we add more and more code to handle more and more sub-sequent callbacks based on changing state within our application.

Fortunately, it doesn&#8217;t have to be this way. There are some simple things we can do to help clean up the nested callback nightmare, including the use of delegated events within view objects ([how Backbone handles DOM events in views](http://backbonejs.org/#View)), named methods and method pointers instead of anonymous callback methods (as described by Rob Conery in [his post on cleaning up callbacks with Node](http://wekeroad.com/2012/04/05/cleaning-up-deep-callback-nesting-with-nodes-eventemitter) &#8211; equally applicable to browser based code and WinJS code),  promises (which I&#8217;ll get to in a moment) and some other interesting implementation such as [using &#8220;reduce&#8221; function calls with promises](https://gist.github.com/3136752#gistcomment-375391), etc.

## I Promise To Call It, But I Really Don&#8217;t Care About Your Callback

Promises are a powerful tool that provides some rather significant benefit to both the function that previously took a callback as a parameter, and to the code that needs to provide a callback to the method being called. In short, a promise decouples the callback from the function call, while providing a more flexible method of executing callbacks for code that is potentially asynchronous.

Ok, what that really means is that a function that previously took a callback method no longer needs to take that callback method. Instead, it can return a promise object. The promise object itself can then handle registering and calling as many callback methods as needed. When the code in the called function is done, it resolves or completes the promise (depending on which promise implementation you&#8217;re using &#8211; more on that in a bit). Resolving or completing the promise will cause all of the callbacks that are registered with the promise to be executed.

[gist id=3143855 file=4.js]

This function used to take a callback, as shown in previous examples. But now it returns a promise instead. To make use of this, we can call it like this:

[gist id=3143855 file=5.js]

Note that we are still using a callback function, but we&#8217;re no longer passing the callback in to the function that we&#8217;re executing. Instead, we&#8217;re passing it to the promise&#8217; &#8220;then&#8221; function. This is the function, in Promises/A syntax and in ([jQuery&#8217;s $.when/then syntax](http://lostechies.com/derickbailey/2012/03/27/providing-synchronous-asynchronous-flexibility-with-jquery-when/)), that gets called when the promise is completed or resolved successfully. This means that when the function we called completes and has all of the information that it needs, it called &#8220;promise.complete()&#8221; which caused all of the registered &#8220;then&#8221; callbacks to be executed. 

One of the primary benefits that promises provides to the code that returns the promise, is the decoupling of the function being called and the callbacks being executed. In the earlier examples, the function being called had to explicitly know about the callback method. It should ideally check for the existence of the callback &#8211; to make sure it&#8217;s not undefined or null &#8211; and also check to make sure it&#8217;s a function.  This is a lot of noise just to call the callback, but it&#8217;s necessary noise. A promise reduces this noise significantly. If a function is creating a promise object, it doesn&#8217;t need to care about the callbacks that are going to be called. It only needs to care about calling the &#8220;complete&#8221; method (or &#8220;resolve&#8221; method on jQuery promises). Beyond this, the function returning the promise doesn&#8217;t care about your callbacks. It doesn&#8217;t need to check for valid functions, check to make sure the callback exists, or do anything else to make sure it can call the callback. It just calls &#8220;complete&#8221; and the promise worries about that other noise.

There are a number of other benefits that promises bring to the table, too: including more flexibility, the ability to manage multiple callbacks, a guarantee that your registered callback will be fired (even if it&#8217;s added after the promise is resolved), and more. While these are important topics to understand &#8211; especially the part about handling error conditions &#8211; I&#8217;m going to leave those other benefits as explanations for other material that I&#8217;ll link to at the bottom of this post.

## Too Many Promises

Promises aren&#8217;t anything new in JavaScript and certainly not in Software development. They&#8217;ve been around for a while now. Unfortunately for JavaScript, though, they aren&#8217;t a set-in-stone standard (like all the good patterns in JS, it seems) and there are a number of competing specs for promises. If you look at the CommonJS wiki for example, you&#8217;ll find [no less than 5 specifications for promises](http://wiki.commonjs.org/wiki/Promises) (including one redacted). jQuery has it&#8217;s own flavor of promises that it uses (and which I&#8217;ve talked about before). And there are other JavaScript libraries that implement various flavors of promises on their own, at least partially if not creating a complete promise implementation.

This is rather unfortunate as it just creates a lot of confusion. There is one spec that seems to be gaining more momentum and popularity among them, though: the CommonJS Promises/A spec. The unfortunate side of this, though, is that jQuery&#8217;s promises are very different than the Promises/A spec in terms of the API and semantics of the method names. Functionally they are very much the same, but they are facilitated in ways that are just slightly different &#8211; and different enough to cause some frustration. It would be nice to see jQuery move to the Promises/A spec, but that seems unlikely at this point.

## WinJS Promises: Promises/A

Hey, remember when I started this blog post and was talking about WinJS and building apps for Windows 8? … right 🙂

One of the first thing you&#8217;ll notice when getting in to WinJS development and really using the framework to build your applications, is the prevalent use of promises. And they are EVERYWHERE. The first file you open when you create a new project (other than a &#8220;blank&#8221; project) has this line of code in it, in fact:

[gist id=3143855 file=6.js]

What&#8217;s even more fun about that, though, is that this is nested inside of a callback function for an event handler. So… yeah. How&#8217;s that for some async JS love in WinJS? 🙂 

As you get further into working with WinJS and the WinRT runtime APIs (found [in the &#8220;Windows&#8221; namespace](http://msdn.microsoft.com/en-us/library/windows/apps/br211377.aspx)), promises will become more and more common. Any time you want to access the file system to load images or other files, you&#8217;re going to be writing async JavaScript. Any time you want to make a connection to a web service to get some data, it&#8217;s async again. Anytime you want to do just about anything that isn&#8217;t done directly in the application&#8217;s memory space with your code, it&#8217;s going to be async. And nearly every time you do anything async with JavaScript in a WinJS app, it&#8217;s going to be done with promises. This even bubbles it&#8217;s way up to your own code after a while. It&#8217;s not something you can get away from. 

For example, in the app that I&#8217;m helping to build for the P&P team, for example, we&#8217;re working on creating a &#8220;[Live Tile](http://msdn.microsoft.com/en-us/library/windows/apps/hh761490.aspx)&#8221; for the application. This involved a countless number of asynchronous calls out to the file system, to various streams of information, and to get and set the template used to create the tile for the app. We did everything we could to hide the implementation details behind some appropriate abstractions, and the code turned out clean. But it required a heavy use of promises in the calls we were making, as well as the code we wrote for our API.

Of course we could have used callbacks. It would have worked:

[gist id=3136752 file=1_before.js]

But I personally prefer the promises version:

[gist id=3136752 file=2_after.js]

It&#8217;s much more simple, much more clean, and much easier for me to read and understand. 

## Not A Golden Hammer Of Smashing Problems

While promises are certainly useful in cleaning up async code, and it is necessary that you understand them to work with WinJS effectively, it&#8217;s not a complete solution and you can still do stupid stuff with them. Take a look at this code, for example (part of the spike to learn how to build Live Tiles, creating a thumbnail from an existing image file):

[gist id=3143855 file=7.js]

This is a giant mess… but it uses promises! The problem here is that the promises are being abused as a fancy inline, nested callback mechanism. We may as well be using standard callbacks instead of promises at this point. Promises certainly can be used to clean up code, but promises themselves are not an end-all shiny hammer of awesomeness.

(And don&#8217;t worry about this sample too much. We&#8217;ve already cleaned this up for the real / production version of the app &#8211; this was just a spike to learn).

There are still other patterns and practices that you need to understand, such as JavaScript modules, namespaces, object-oriented development, functional aspects of JavaScript, and much much more. Hopefully this little taste of promises will get you ready for what you need to know and provide some context for further ready and study. You need to understand promises anyways, and if you&#8217;re going to work with WinJS and WinRT apps in Windows 8, there is no chance of doing so successfully without knowing promises in and out.

## Further Reading

There&#8217;s a lot more to asynchronous JavaScript than can be fit in to this blog post. Here are some of the articles and book I recommend reading, to get yourself up to speed on what you&#8217;ll need to know for working with async JavaScript in general, nearly all of which will be applicable to WinJS apps:

  * [Trevor Burnham&#8217;s &#8220;Async JavaScript&#8221; e-book](http://leanpub.com/asyncjs). **This is easily my highest recommendation.** You need to buy this book right now. The first two or three chapters are worth the cost of the entire book, alone. The rest of the book is a great discussion on async techniques and tools in JavaScript.
  * [CommonJS Promises wiki](http://wiki.commonjs.org/wiki/Promises) &#8211; hardcore, down and dirty specs for promises
  * [The Qjs documentation](https://github.com/kriskowal/q/) &#8211; lots of very interesting ideas for composing promises in JavaScript
  * [Async Programming in JavaScript with Promises](http://blogs.msdn.com/b/ie/archive/2011/09/11/asynchronous-programming-in-javascript-with-promises.aspx) &#8211; by Matt Podwysocki
  * [jQuery promise](http://api.jquery.com/promise/)

<div>
  For WinJS/WinRT specifically:
</div>

  * [WinJS Promise object](http://msdn.microsoft.com/en-us/library/windows/apps/br211867.aspx)
  * [Asynchronous programming in Metro style apps](http://msdn.microsoft.com/en-us/library/windows/apps/hh464924.aspx)
  * [Asynchronous programming in JavaScript / Metro apps](http://msdn.microsoft.com/en-us/library/windows/apps/hh700330.aspx)
  * [WinJS Promises Sample App](http://code.msdn.microsoft.com/windowsapps/Promise-e1571015)

I&#8217;m sure there are a thousand more articles, blog posts, videos and books on this. Feel free to drop some links in the comments with your favorite async-js / promises material.

## Want To Truly Understand Promises?

If you&#8217;re still trying to wrap your head around promises, trying to understand how they actually work and what they really do, you&#8217;re not alone. **Promises are relatively new, and relatively misunderstood** in the world of JavaScript programming. But **I&#8217;ve got something that can help**. I&#8217;ve produced a screencast that shows you how promises really work, behind the scenes, by walking you through the process of building a very basic promise library, from the ground up.

If you&#8217;re looking to wrap your head around these powerful objects, check out [WatchMeCode Episode 13: Promises From The Ground Up](http://www.watchmecode.net/promises-ground-up).

[<img style="margin-left: auto;margin-right: auto" src="http://www.watchmecode.net/images/promises-ground-up.png" alt="" width="" height="" border="0" />](http://www.watchmecode.net/promises-ground-up)