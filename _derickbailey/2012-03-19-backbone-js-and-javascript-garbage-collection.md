---
wordpress_id: 853
title: Backbone.js And JavaScript Garbage Collection
date: 2012-03-19T07:10:39+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=853
dsq_thread_id:
  - "616550290"
categories:
  - Backbone
  - DOM
  - JavaScript
  - Marionette
---
A question was asked on Stack Overflow recently, and I provided an answer that I think is worth re-blogging here (while cleaning up the text / grammar). My answer goes in to a little bit of the idea behind a garbage collected language and gets in to some of the basics of how JavaScript knows when to clean up your &#8220;garbage&#8221; &#8211; that is, your objects that are no longer used. What I&#8217;m presenting here is an oversimplification of how JavaScript manages memory. However, these basic ideas should prove useful to people who want to do a better job of managing memory usage in JavaScript.

## [What does Backbone.js do with models that are not used anymore?](http://stackoverflow.com/questions/9758346/what-does-backbone-js-do-with-models-that-are-not-used-anymore/9760641#9760641)

When it comes down to it, Backbone does not explicitly handle cleaning up objects for you. That responsibility falls 50/50 between you and the JavaScript runtime.

JavaScript is a [garbage collected](http://en.wikipedia.org/wiki/Garbage_collection_(computer_science)) language like Java, C#, Ruby, and others. In a garbage collected language, an object that is still referenced by your application will not be cleaned up. The counter point is that when an object is no longer referenced by your application, it will be cleaned up. Therefore, de-reference your objects and allow the JavaScript runtime to clean up the memory when you no longer need those objects.

## Variable References And Cleanup In JavaScript

When you create a variable, you can either scope that variable to a local function or as a global variable (with some additional tricks and patterns that I show in [my JavaScript Scope screencast](http://www.watchmecode.net/javascript-scope)).

Global variables are not cleaned up by the garbage collector during the life of the page. You can leave a page open for days or weeks or infinitely, and any variable that was scoped to the JavaScript runtime global object will stick around the whole time. Globals are cleaned up is when you refresh the page, leave the HTML page behind entirely (such as navigating to a different page and force the browser to load the new page from the server, doing a complete server refresh) or closing the browser or browser tab.

Function scoped variables are cleaned up when the variable falls out of scope. That is, when the function has exited and there are no more references to it, the variable can be cleaned up.

There are a few exceptions to this:

  * Returned values from functions
  * Closures
  * Object attributes and methods
  * Callback functions and DOM events

Ok, calling these &#8220;exceptions&#8221; is stretching it a bit. These types of references still fall under the same rules, but some additional tricks are used by the JavaScript run time to hold on to the references longer than you might expect.

### Return Values

A return value is held in your app by assigning the return value to another variable. A return value falls under the same general rules, but the variable is now in a different function or attached to the global object. Once that variable goes out of scope, it can be cleaned up.

### Closures

A [closure](http://en.wikipedia.org/wiki/Closure_(computer_science)) &#8211; while [a powerful and often used tool in JavaScript](http://devlicio.us/blogs/sergio_pereira/archive/2009/02/23/javascript-time-to-grok-closures.aspx) &#8211; is basically a controlled memory leak. A closure allows a parent scope to provide values that a nested scope can access &#8211; even when the parent scope has exited and nothing else references it. When the nested scope hangs around and has a closure on a variable from the original parent scope, that variable hangs around with it. Once the nested scope is cleaned up, the parent&#8217;s closured variable is allowed to be cleaned up (assuming nothing else is holding on to it).

### Object Attributes And Methods

Objects with attributes and methods fall under the same rules. An object can reference another object or function by having an attribute assigned to it: myObj.foo = thatObj. In this case, any variable that you assign to the object will now live with that object. You can remove the reference from the attribute at any time, or let the object fall out of scope / reference to clean this up.

### Callbacks

[Callback functions](http://en.wikipedia.org/wiki/Callback_(computer_programming)) are handed around as function pointers, or variables that are the actual function (to over-simplify things, again). When you pass a callback function somewhere, the original scope / object that had the callback may still be holding on to it. Additionally, the code that the callback was passed to may hold on to it. If the code that it was handed to is a simple function, then the reference may fall out of scope when the function exits. If the code that you handed the callback to is an event handler, though, you might have to think a little more about cleaning up the callback / event handler

### DOM Events And Event Handlers

The DOM ([Document Object Model](http://en.wikipedia.org/wiki/Document_Object_Model) &#8211; the JavaScript representation of the HTML in your app) is a JavaScript object. Events and other references to your DOM work the same as any other reference. If you have an object handling a DOM event, it has a reference in your app and it won&#8217;t be cleaned up by the garbage collector. If you want it cleaned up, you have to remove all references to it &#8211; including the DOM reference from the event handler.

## Cleaning Up After Yourself

The general rule for cleaning up memory usage in JavaScript is that you have to do it yourself. It&#8217;s not quite like C/C++ where you have to allocate and deallocate memory directly. It&#8217;s more like Java and C# where you have to release all references to an object before it can be cleaned up by the garbage collector.

You can&#8217;t really force garbage collection in JavaScript. Even if you could, you wouldn&#8217;t want to. Garbage collection is controlled by the runtime because the runtime knows better than you, about when it should clean things up. Even though you can&#8217;t force the garbage collection, you can force a variable to be de-referenced and allow the thing it points to be cleaned up by using the delete keyword in JavaScript: \`delete myVar\`. This deletes the reference, not the actual object / value it points to. If you delete the final reference, though, garbage collection can take place on the actual object / value.

## Cleaning Up In A Backbone App

Backbone is JavaScript so it falls under the same rules. But there are some interesting uses of references in Backbone that you need to be aware of which will help you to know when you need to manually clean up some objects, though.

For example: events. An even handler / callback method works by having a reference between the object that triggers the event and the callback that handles the event. This is one of the easiest places to cause memory leaks in a Backbone app and I discuss it in detail in [my Zombies! blog post](http://lostechies.com/derickbailey/2011/09/15/zombies-run-managing-page-transitions-in-backbone-apps/).

Additionally, my [Backbone.Marionette](https://github.com/derickbailey/backbone.marionette) framework that sits on top of Backbone does a lot of cleanup work for you. I provide access to a Region object and various types of views that automatically clean up DOM references, child-view references, event handler references, etc.

Other than being aware of how events work in terms of references, just follow the standard rules for manage memory in JavaScript and you&#8217;ll be fine. If you are loading data in to a Backbone collection full of User objects you want that collection to be cleaned up so it&#8217;s not using anymore memory, you must remove all references to the collection and the individual objects in it.  Once you remove all references, things will be cleaned up. This is just the standard JavaScript garbage collection rule.

## There&#8217;s More To It&#8230;

Even though these basic rules apply to all of the JavaScript runtime environment, following them might not be enough. There are some additional patterns and practices that can help you prevent too much memory from being used in the first place.

For example, don&#8217;t define functions inside of object constructors unless you absolutely have to. Doing this will create a new copy of the function every time you instantiate an object. Instead, attach functions to the object prototype. This will reduce the overall memory footprint of an application, reduce the amount of work that the garbage collector has to do, and generally improve your application performance.

There&#8217;s more to it, still. If you&#8217;re interested in getting all the detail, check out some of these resources:

  * [Annotated ECMAScript 5](http://es5.github.com/)
  * [High Performance JavaScript](http://www.amazon.com/Performance-JavaScript-Faster-Application-Interfaces/dp/059680279X/ref=sr_1_1?ie=UTF8&qid=1332126741&sr=8-1)
  * [JavaScript Patterns](http://www.amazon.com/JavaScript-Patterns-Stoyan-Stefanov/dp/0596806752)
  * [JavaScript: The Good Parts](http://www.amazon.com/JavaScript-Good-Parts-Douglas-Crockford/dp/0596517742)
  * [Memory Leak Patterns In JavaScript](http://www.ibm.com/developerworks/web/library/wa-memleak/)
  * [JavaScript Rocks!](http://javascriptrocks.com/performance/)

Also, be sure to check out my [WatchMeCode screencast: JavaScript Zombies](http://www.watchmecode.net/javascript-zombies) &#8211; in this episode, I cover some of the most common and basic ways in which memory leaks happen in JavaScript, and show how to overcome these problems.

[<img src="http://lostechies.com/content/derickbailey/uploads/2014/02/NewImage3.png" alt="NewImage" width="300" height="225" border="0" />](http://www.watchmecode.net/javascript-zombies)

 