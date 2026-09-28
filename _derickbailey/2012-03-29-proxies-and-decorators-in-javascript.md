---
wordpress_id: 861
title: Proxies And Decorators In JavaScript
date: 2012-03-29T07:25:44+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=861
dsq_thread_id:
  - "628744845"
categories:
  - Design Patterns
  - JavaScript
  - Principles and Patterns
---
Proxies and Decorators are both [design patterns in software development](http://en.wikipedia.org/wiki/Software_design_pattern) &#8211; recipes that provide common solution to common problems. I largely group Proxies and Decorators in to the same category and use them interchangeably because the implementation between them is 99% the same in most language &#8211; especially in JavaScript. The important distinction between them &#8211; as with any design pattern &#8211; is the intent of the pattern.

## Proxies

The intent of a [Proxy object](http://en.wikipedia.org/wiki/Proxy_pattern) is to forward a call on to another service or object, without the original caller knowing.

Think about the term &#8220;proxy&#8221; on the internet. If you have a proxy server set up on your network, all of the calls that you make to get out to the internet are actually made to this proxy server. The proxy server then makes the actual call to the real service or resource for you. When the real resource is returned to the proxy server, it may do something with that resource before it returns it to you, the original requester.

Proxy objects are the same in software. You make a call to a resource or service and the call that you make is handled by an object that can figure out how to make the real call, possibly pre-process the results and send any response you need, back to you.

## Decorators

The intent of a [Decorator](http://en.wikipedia.org/wiki/Decorator_pattern) is to provide additional functionality on top of an existing function or object. That is, the original code that you were intending to call will still be called, but the decorator has provided additional code or logic that will also get run in order to do something else.

Think about a 3rd party software reseller or VAR (value-added reseller). When you want to make a purchase, you could go through the company that produces the software. Chances are, though, if you are working for a company of sufficient size, you are going to make the purchase through a 3rd party reseller. The 3rd party adds value to the purchase by offering discounts and incentives that the original maker can&#8217;t provide. The reseller can do this because you have an account with them and you make a large number of purchases through them. The additional services and incentives may be consultation and recommendation to make sure you&#8217;re getting what you need, it may be discounts on even small orders, or it may be &#8220;buy this and get that for free&#8221; for unrelated items. This additional service sits on top of your intent to buy the software or package that you need. You still get to buy it, but you also get other benefits.

A decorator in software can work the same way. You may call out to a particular object or service and end up executing more code than you originally thought, while still getting the response that you need.

<span style="font-size: 18px; font-weight: bold;">Proxies And Decorators In JavaScript</span>

If the lines between these two patterns are getting a bit blurry in your mind &#8211; yes, they are blurry. The difference in the intent between these two patterns may be large enough to describe easily, but the implementation between them is largely the same.

In raw JavaScript, proxies and decorators can both be facilitated with the same code, such as this:

{% gist 2136035 1.js %}

This is actually the implementation of the [Underscorejs \`wrap\` method](http://documentcloud.github.com/underscore/docs/underscore.html#section-59). It&#8217;s a very handy little tool that lets us easily implement both proxies and decorators.

The difference, again, comes back to the intent of the usage. If I&#8217;m intending this to be used as a proxy, I may simply forward the call on to another function:

{% gist 2136035 2.js %}

If I&#8217;m intending this to be a decorator, I may want to call the original function while providing some additional logic that manipulates the original function&#8217;s response:

{% gist 2136035 3.js %}

The implementation of both of these patterns is largely the same in this example, but the intent is different which is what determines the specific pattern that I&#8217;m using.

## Simplifying Proxies

One of the great things about JavaScript is our ability to build Frankenstein monsters out of spare parts (as one of my clients recently put it). We can pull arms and legs and heads off a number of different objects and assemble them in to some monstrosity at runtime, allowing us to create the object that behaves the way we want.

The ability to mash objects together and replace parts as needed means we can greatly simplify proxies in JavaScript. In fact, if we are intending to wholesale replace a function with another function that simply proxies out to another service, we can get rid of the boilerplate &#8216;wrap&#8217; method entirely and jump straight to method replacement:

{% gist 2136035 4.js %}

instant proxy: just replace the original function with yours.

## Many More Options, Still

JavaScript is a very flexible language, as we&#8217;ve seen. We can implement the same core functionality and capabilities in many different ways. And there are still more ways that we could approach these patterns. That&#8217;s the beauty of design patterns, in my mind. They are not prescriptive answers. They are recipes for solutions. It&#8217;s up to us, the chef writing the code, to mix and match the recipes and to augment, simplify, deconstruct and reconstitute these patterns in meaningful ways.

For more information on design patterns, more options for implementing them, and many other very useful patterns, checkout these resources:

  * Addy Osmani&#8217;s [Essential JavaScript Design Patterns](http://addyosmani.com/resources/essentialjsdesignpatterns/book/) (a must read / reference)
  * Stefan Stoyanov&#8217;s [JavaScript Patterns book](http://www.amazon.com/JavaScript-Patterns-Stoyan-Stefanov/dp/0596806752) &#8211; not strictly &#8220;design patterns&#8221; but includes many design patterns
  * The infamous [&#8220;Gang of Four&#8221; (GoF) design patterns book](http://www.amazon.com/Design-Patterns-Elements-Object-Oriented-ebook/dp/B000SEIBB8) &#8211; the original source
  * OODesign.com &#8211; [Object Oriented Design Patterns](http://www.oodesign.com/)

Once again, feel free to drop links to your favorite design pattern resources &#8211; especially those that relate to JavaScript &#8211; in the comments.
