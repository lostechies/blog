---
id: 1153
title: Consistency Problems With APIs In JavaScript Promise Libraries
date: 2013-09-20T12:58:57+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=1153
dsq_thread_id:
  - "1781639713"
categories:
  - Async
  - JavaScript
  - JQuery
  - NodeJS
  - Promises
  - Qjs
  - RSVPjs
  - User Experience
  - WinJS
---
Promises are a powerful way to handle asynchronous code in JavaScript. They give us a lot of opportunity to clean up code, and to write code that can register work to be done when the promise is resolved, whether or not the promise has already been resolved. The emergence of the various Promises spec has been great in the last few years, and we are moving toward a more consistent behavior and API set for the core of what promises do.

However… We’re not there yet, and it’s frustrating me nearly every day.

I work in several different projects and runtime environments, and I have to deal with a lot of different promise libraries because of this. The result: a constant learning and re-learning battle, because every Promise library does something slightly different than the others, even when the libraries in question are written to the same Promise spec.

Let’s look at how you create and resolve a promise in [q.js](https://github.com/kriskowal/q), [RSVP.js](https://github.com/tildeio/rsvp.js), [WinJS](http://msdn.microsoft.com/en-us/library/windows/apps/br211867.aspx), and [jQuery](http://api.jquery.com/jQuery.Deferred/). But before I look at them, I want to let every author and contributor to each of these libraries know that I really do appreciate the work they&#8217;ve put in. I use these libraries (or have used them in the past, in the case of WinJS) with great effectiveness in my applications. My code is far better for having put the time and effort in to each of these libraries. The inconsistencies, though, are killing me.

## q.js: Deferred Objects And Promises {#qjsdeferredobjectsandpromises}

I’ll start with q.js because I’m using it in one of my projects and it’s on my mind at the moment.

[gist id=6642093 file=q.js]

Q uses the idea of a “deferred” object to handle the real processing and the promise is only the public API of the promise. You should note that q does not allow you to call `.then()` or other “promise” methods on the deferred object, though. You can only call those on the promise itself.

## jQuery: Deferred Objects And Promises {#jquerydeferredobjectsandpromises}

Q is quite similar to jQuery’s idea of a promise. I honestly don’t know if there is a relationship / influence between q and jQuery, but there certainly looks to be on the surface. The same code in jQuery, though, is just different enough to frustrate you endlessly.

[gist id=6642093 file=jquery.js]

The major difference here, is that q does `q.defer()` and `deferred.promise;` while jQuery does `$.Deferred()` and `deferred.promise()`. jQuery Deferred objects also let you call `.then()` and other “promise” functions on the deferred object itself, unlike q.

These might not seem like much in differences off-hand, but when you are switching between NodeJS and Browser based JavaScript several times throughout a day, or hour, the difference will frustrate you to no end while you try to remember which syntax goes where. I know it drives me crazy, at least.

## RSVP: Just Promises {#rsvpjustpromises}

Next up is RSVP. I’m also using this in a current project. It was brought in to my code through the use of another service in this project. I generally like RSVP as much as I like other Promise libraries &#8211; that is to say, I sing the praises of promises quite regularly and RSVP is great.

RSVP has yet another API for creating an manipulating promises and it is dramtically different than q or jQuery in how you get a promise up and running.

[gist id=6642093 file=rsvp.js]

If you’ve never seen RSVP (or WinJS &#8211; coming up next) this may be confusing. You are not allowed access to a `.resolve()` method on an object instance. Instead, you must provide a callback function to the Promise constructor function. This callback receives a resolve and reject parameter, which are themselves functions. The `resolve` method is the equivalent of `deferred.resolve()` in the previous q and jQuery examples.

Great. Yet another odd syntax that makes me do things in a strange place this time. I might see the point of this, in that you don’t have to worry about where the “public” API is. The only way to resolve the promise is within the callback function that the promise ran when it was created. But this is completely different than q or jQuery. It took me a bit to realize that I was not allowed to have a deferred object to resolve at a later point. I must put all my code to determine when to resolve or reject the promise, within the promise callback &#8211; or at least call out to a method that can determin this for me, to keep the code clean.

## WinJS: Just Promises {#winjsjustpromises}

RSVP isn’t alone, though. As I just mentioned WinJS (the Windows 8 JavaScript API for WinRT/Microsoft Surface applications) uses the same style of promise creation and resolution.

[gist id=6642093 file=win.js]

Other than the `WinJS` vs `RSVP` parent namespaces, WinJS and RSVP’s APIs are pretty much interchangeable. I think there are some slight difference in other areas of the API, though, such as which methods WinJS provides for wrapping code in a promise, or providing progress updates, etc. I’m not sure if these difference fall in to our out of a given Promise spec, though.

## Please Clean This Up {#pleasecleanthisup}

I’m begging the JavaScript community at this point. Please, for the love of developer sanity, continue to make progress on standardizing Promises. Please PLEASE please! Make sure you include the constructor functions and whether or not a Deferred object is part of the solution, and how to resolve and reject the promise.

Yes, I get that there are different needs in different situations. Some libs will have extra things. That’s awesome. But for the parts that are supposed to be the same, please make them the same &#8211; all the way around, from constructor function to method signatures and expected behaviors. Frankly it doesn&#8217;t matter to me all that much, which spec wins. Just make it consistent across all the promises libraries. There are far too many inconsistencies in promises, at this point.

 

[![](http://imgs.xkcd.com/comics/standards.png?v=101271)](http://xkcd.com/927/)

 

## Need To Learn More About Promises?

**Promises are not &#8220;the promised land&#8221;, but they are a powerful tool and one that you should have in your belt.** In spite of my complaints about the inconsistent APIs, I believe they are a necessary and important part of good JavaScript development. Well, maybe not &#8220;in spite of&#8221; &#8211; it&#8217;s more that &#8220;because promises are so important&#8221;, I believe this complaint on API needs to be heard and something should be done. But I&#8217;m splitting hairs and talking about things that a lot of people are even ready to hear, yet.

If you&#8217;re still trying to wrap your head around promises, trying to understand how they actually work and what they really do, you&#8217;re not alone. **Promises are relatively new, and relatively misunderstood** in the world of JavaScript programming. But **I&#8217;ve got something that can help**. I&#8217;ve produced a screencast that shows you how promises really work, behind the scenes, by walking you through the process of building a very basic promise library, from the ground up.

If you&#8217;re looking to wrap your head around these powerful objects, check out [WatchMeCode Episode 13: Promises From The Ground Up](http://www.watchmecode.net/promises-ground-up).

[<img style="margin-left: auto;margin-right: auto" src="http://www.watchmecode.net/images/promises-ground-up.png" alt="" width="" height="" border="0" />](http://www.watchmecode.net/promises-ground-up)

 