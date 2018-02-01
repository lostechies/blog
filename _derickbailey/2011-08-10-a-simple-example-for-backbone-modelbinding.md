---
id: 521
title: A Simple Example For Backbone.ModelBinding
date: 2011-08-10T20:19:26+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=521
dsq_thread_id:
  - "382750631"
categories:
  - Backbone
  - Backbone.ModelBinding
  - JavaScript
  - JQuery
---
I received a question via Github, asking if I had any simple, functional examples of my [Backbone.ModelBinding plugin](https://github.com/derickbailey/backbone.modelbinding). After looking back through my blog posts and the documentation for it, I realized I did not. So, I whipped one up real quick. Here&#8217;s the JSFiddle for it:



(and for those of you using an RSS reader, the above iframe points to <http://jsfiddle.net/derickbailey/Cpn3g/4/> )

The functionality of this example is very simple, but is shows just how little code you need to make your forms and html elements work together, through the use of backbone&#8217;s models and my plugin.

When the app is started, it populates a &#8216;person&#8217; with the name &#8216;joe bob&#8217;. The form is bound to the model, so it is updated with the correct text in the input boxes. This demonstrates the form input convention binding.

The display area is also bound to the model so it displays the name. When you make changes to either the first name or last name in the form and then tab out of the text box (or otherwise cause the text box to lose focus / fire it&#8217;s &#8220;change&#8221; event), the display area will be updated with the information you entered. This demonstrates the data-bind attribute binding.

Be sure to checkout the full source in the Javascript and HTML tabs of the fiddle. I think you&#8217;ll be pleasantly surprised at how easy this is.