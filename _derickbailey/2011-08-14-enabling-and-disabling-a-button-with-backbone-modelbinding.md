---
wordpress_id: 523
title: Enabling And Disabling A Button With Backbone.ModelBinding
date: 2011-08-14T13:19:53+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=523
dsq_thread_id:
  - "385876575"
categories:
  - Backbone
  - Backbone.ModelBinding
  - JavaScript
  - Semantics
---
This is a follow-up post to [my previous post on how to enable and disable a button with backbone](https://lostechies.com/derickbailey/2011/06/15/binding-a-backbone-view-to-a-model-to-enable-and-disable-a-button/). I showed a working solution in that version, but there are a few things about it that I don&#8217;t like. [After some discussion about this same scenario on the backbone mailing group](https://groups.google.com/forum/#!topic/backbonejs/d07E5pAxm1w), I decided I wanted to tackle it a different way &#8211; using my [Backbone.ModelBinding](https://github.com/derickbailey/backbone.modelbinding) plugin.

## How It Works

The Backbone.ModelBinding plugin allows you to bind a model&#8217;s properties to various attributes of an html element through the use of a data-bind attribute in your html element (see the readme for more detail). One of the things you can do with this is set the element to be disabled based on the value of a model&#8217;s property:

{% gist 1145196 1-disable.html %}

This works well. It allows you to enable and disable the save button based on the model&#8217;s \`invalid\` property. When the model is invalid, it disables the button and when it&#8217;s valid, it enables the button.

The negative semantics for button enabling and disabling are important. There are times when you will want to enable a button if the model is invalid, for example. In general, though, I don&#8217;t like using the negative form of valid to enable and disable a save button. It gets confusing to talk about \`invalid\` in the code, in my opinion. So I added the ability to specify \`enabled\` in a data-bind attribute, which lets me use an \`isValid\` property on my model:

{% gist 1145196 2-enable.html %}

Again, when my model is valid, the save button is enabled and when the model is not valid, the save button is disabled. The difference is the semantics of the model&#8217;s property and the way the data-bind attribute reads. For my money, the positive semantics for enabling and disabling a save button are easier to read and understand.

## A Demonstration

[Check out this JSFiddle for a working demonstration](http://jsfiddle.net/derickbailey/hxaZf/15/) of both the \`enabled\` and \`disabled\` data-bind attributes. Be sure to look at the javascript and html source, to wrap your head around both of these examples.



 
