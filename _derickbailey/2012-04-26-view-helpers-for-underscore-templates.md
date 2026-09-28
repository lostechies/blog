---
wordpress_id: 912
title: View Helpers For Underscore Templates
date: 2012-04-26T06:50:55+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=912
dsq_thread_id:
  - "664828606"
categories:
  - Backbone
  - JavaScript
  - Marionette
  - Underscore
---
Underscore&#8217;s template engine lets you run any arbitrary JavaScript code that you want, within a template. You could write an entire JavaScript application within an underscore template if you want. But this is a really bad idea. Templates should be clean and simple. Some people go so far as to say &#8220;logic-less templates&#8221;, but I honestly don&#8217;t think that&#8217;s reasonable. I also don&#8217;t think it&#8217;s reasonable or responsible to have a bunch of JavaScript code littered throughout the template, though. 

Fortunately, it&#8217;s easy to build helper methods for [Underscore](http://underscorejs.org/) [templates](http://underscorejs.org/#template) (and they end up looking a lot like Rails view helpers).

## Logic In Templates: A Bad Idea

On a client project recently, I had a JavaScript object that needed to be bound to my template. The object looked somewhat like this:

{% gist 2489539 1.js %}

I needed to take all of the &#8220;addresses&#8221; and find each specific address within the array, by name, so that I could get the right information in place at the right time in my template.

The first pass of code that I wrote to do this, looked like this:

{% gist 2489539 2.html %}

And this worked, but it&#8217;s a bad idea. I have a lot of duplication in this template and I have a lot of logic and processing of data in the template, too. This is going to make for a very painful setup when it comes to maintenance &#8211; especially if / when I have to change how the address is looked up.

## View Helper Methods: A Better Idea

In asking around on twitter for some suggestions on how to clean this up, I received several responses. Out of everything that everyone said, though, I liked the response I got from [DaveTheNinja](https://twitter.com/#!/davetheninja) because of it&#8217;s simplicity.

The basic idea is to recognize that the data I send to my template is a JavaScript object. Since this is an object, it can have methods. If I can have methods on my object, why not put methods on it as view helper methods?

{% gist 2489539 3.js %}

The helper method &#8211; &#8220;getAddress&#8221; &#8211; is pretty much the same code. But now it&#8217;s consolidated in to a single location and I&#8217;m able to give better formatting for it which makes it easier to read and understand.

You can also see that I&#8217;ve kept the data separate from the objects until just before rendering the template. I&#8217;m using Underscore&#8217;s &#8220;extend&#8221; method to copy all of the methods from my &#8220;viewHelpers&#8221; object on to my data object.

Then when I pass the data object to my template, I can call my &#8220;getAddress&#8221; method like this:

{% gist 2489539 4.html %}

And we&#8217;re done! I now have view helper methods that I can call from within my templates.

## Using This With Backbone

I use this technique with Backbone a lot. The code that I showed above is really no different than what I do with my Backbone views, either. When you get to the point where you need to render your template, just extend the view helper methods on to your data before doing the actual rendering:

{% gist 2489539 5.js %}

## Using This With Backbone.Marionette

I&#8217;ve added this functionality in to [Backbone.Marionette](https://github.com/derickbailey/backbone.marionette) as well. ItemView, CompositeView and Layout will all look for a \`templateHelpers\` attribute on a view definition. If it finds it, it will mix that object in to the data that is used to render the template: 

{% gist 2489539 6.js %}

You can specify a reference to the viewHelpers object as shown in this example, provide an object literal as the templateHelpers directly, or specify a function that returns an object with the helper methods that you want. For more information see [the documentation for Marionette](http://derickbailey.github.com/backbone.marionette/#marionette-view/view-templatehelpers).

## Other Template Engines

This basic technique will probably work with other template engines, too. Some engines like Handlebars, though, have this idea baked in to them directly. But if you&#8217;re using Underscore&#8217;s templates, then this is a good way to keep your templates clean while still providing the logic you need.
