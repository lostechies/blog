---
wordpress_id: 940
title: '$(function(){…}) vs (function($){…})($) or DOMReady vs The Module Pattern'
date: 2012-05-22T07:06:33+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=940
dsq_thread_id:
  - "699741412"
categories:
  - Backbone
  - DOM
  - JavaScript
  - JQuery
  - Principles and Patterns
---
This was originally [a StackOverflow question](http://stackoverflow.com/questions/10371539/why-define-anonymous-function-and-pass-it-jquery-as-the-argument/10372429#10372429). I&#8217;m re-posting here because I think the question is fairly common, and I like the answer that I provided. 

## Why define anonymous function and pass it jQuery as the argument?

This is the original question title, but it doesn&#8217;t really show the nuances of the question&#8217;s content. The StackOverflow user really wants to know the difference between an [immediately-invoked function expression](http://benalman.com/news/2010/11/immediately-invoked-function-expression/), and the jQuery DOMReady event:

{% gist 2762389 1.js %}

vs

{% gist 2762389 2.js %}

At a high level, the two blocks of code shown are dramatically different in when and why they execute. They do not serve the same purpose. But they are not exclusive of each other. In fact, you can nest them in to each other if you want &#8211; although this can have some odd effects if you&#8217;re not careful.

## jQuery&#8217;s &#8220;DOMReady&#8221; function

{% gist 2762389 2.js %}

This is an alias to [jQuery&#8217;s &#8220;DOMReady&#8221; function](http://api.jquery.com/ready/) which executes when the DOM is ready to be manipulated by your JavaScript code. This allows you to write code that needs the DOM, knowing that the DOM is available and ready to be read, written to, and otherwise modified by your application. 

This is not a module, though. This is only a callback function passed in to the DOMReady alias. The major difference between a module and a callback, in this case, is that jQuery waits for the DOM to be ready and then calls the callback function at the appropriate time &#8211; all from the context of jQuery &#8211; while a module pattern or immediately invoking function executes immediately after it&#8217;s defined. In the above examples, the module is receiving jQuery as a parameter, but this is not the same as using jQuery&#8217;s DOMReady event because the module function is called, passing in jQuery as a parameter, immediately. It does not wait for the DOM to be ready. It executes as soon as the function has been parsed.

## JavaScript Modules

{% gist 2762389 1.js %}

This is an immediately-invoking function expression (FKA &#8220;anonymous function&#8221;, &#8220;self-invoking function&#8221;, etc).

The implementation of this is a function that is immediately invoked by the calling (jQuery) parenthesis. The purpose of passing jQuery in to the parenthesis is to provide local scoping to the global variable. This helps reduce the amount of overhead of looking up the $ variable, and allows better compression / optimization for minifiers in some cases.

In this case, the function is being used as the JavaScript &#8220;module&#8221; pattern. Modules in the currently implemented version of JavaScript in most browsers, are not specific constructs like functions. Rather, they are a pattern of implementation that use an immediately invoking function to provide scope and privacy around a &#8220;module&#8221; of related functionality. It&#8217;s common for modules to expose a public API &#8211; the &#8220;revealing module&#8221; pattern &#8211; by returning an object from the module&#8217;s function. But at times, modules are entirely self-contained and don&#8217;t provide any external methods to call. 

For more information on modules, see the following resources:

  * [WatchMeCode Episode 2: Variable Scope](http://www.watchmecode.net/javascript-scope) (covering modules, which provide scope)
  * Ben Alman&#8217;s [Immediately Invoking Function Expressions Post](http://benalman.com/news/2010/11/immediately-invoked-function-expression/)
  * Addy Osmani&#8217;s [Essential Design Patterns in JavaScript book &#8211; the module pattern](http://addyosmani.com/resources/essentialjsdesignpatterns/book/#modulepatternjavascript). 
  * Adequately Good: [JavaScript Module Pattern In-Depth](http://www.adequatelygood.com/2010/3/JavaScript-Module-Pattern-In-Depth)
  * Stoyan Stefanov&#8217;s [JavaScript Patterns book](http://www.amazon.com/JavaScript-Patterns-Stoyan-Stefanov/dp/0596806752)

## Modules vs DOMReady In Backbone Apps

It&#8217;s bad form to define your Backbone code inside of jQuery&#8217;s DOMReady function, and [potentially damaging to your application performance](http://encosia.com/dont-let-jquerys-document-ready-slow-you-down/). This function does not get called until the DOM has loaded and is ready to be manipulated. That means you&#8217;re waiting until the browser has parsed the DOM at least once before you are defining your objects.

It&#8217;s a better idea to define your Backbone objects outside of a DOMReady function. I, among many others, prefer to do this inside of a JavaScript Module pattern so that I can provide encapsulation and privacy for my code. I tend to use the &#8220;Revealing Module&#8221; pattern (see the links above) to provide access to the bits that I need outside of my module.

<span>Modules And DOMReady In Backbone Apps</span>

You&#8217;re likely going to use a DOMReady function even if you define your Backbone objects somewhere else. The reason is that many Backbone apps need to manipulate the DOM in some manner. To do this, you need to wait until the DOM is ready, therefore you need to use the DOMReady function to start your application after it has been defined.

Here&#8217;s a very basic example that uses both a Module and the DOMReady function in a Backbone application.

{% gist 2762389 3.js %}

Note that we&#8217;re defining the module well before the jQuery DOMReady function is called. We&#8217;re also calling the API that our module defined and returned from the module definition, within the DOMReady callback. This is an important point to understand, too. We&#8217;re not defining our objects and our application flow inside of the DOMReady callback. We&#8217;re defining it elsewhere. We&#8217;re letting the application definition live on it&#8217;s own. Then after the application has been defined, and when the DOM is ready, the application is started.

By defining your objects outside of the DOMReady function, and providing some way to reference them, you are allowing the browser to get a head start on processing your JavaScript, potentially speeding up the user experience. It also makes the code more flexible as you can move things around without having to worry about creating more DOMREady functions when you do move things.
