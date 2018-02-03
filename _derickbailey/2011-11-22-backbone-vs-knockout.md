---
wordpress_id: 686
title: Backbone vs Knockout
date: 2011-11-22T08:12:06+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=686
dsq_thread_id:
  - "480330191"
categories:
  - Backbone
  - JavaScript
  - Knockout
---
There&#8217;s an unfortunate dichotomy of &#8220;Backbone vs Knockout&#8221; floating around these days. It&#8217;s mostly in the .NET space where Knockout tends to get the most attention but I&#8217;ve heard others mention this, too. It&#8217;s an unfortunate argument, though. Both libraries are great, both are very powerful and both solve different problems in the front-end development space. The major difference between the two is the focus of each.

## Strengths And Weaknesses

Knockout aims to provide slick, easy to use model bindings between the HTML and Model. It&#8217;s very XAML/Silverlight/WPF like in it&#8217;s implementation and usage patterns (this makes sense considering where it came from). Knockout does not provide guidance or constructs beyond the model, though. It&#8217;s up to the developers to build well structured JavaScript applications beyond the models and model bindings. This often leads developers without good JavaScript experience down a bad path because they don&#8217;t realize that they need to consider good application structure when using Knockout. Of course this problem is not the fault of Knockout by any means. It&#8217;s simply a lack of understanding of what the tool provides, or how to structure large JavaScript apps, in many cases.

Backbone, on the other hand, takes a &#8220;good JavaScript app architecture&#8221; approach. It focuses on providing constructs that can be used to organize your code in meaningful ways. One thing to note about Backbone is that it&#8217;s not a heavy-handed, prescriptive MVC framework. In truth, it fits within the MV* families, but is not MVC or MVVM or any other specific variant. It takes ideas from a lot of these variants and provides a library of constructs that can be used when needed, without requiring the use of any of them. This is one of the reasons I&#8217;ve stuck with Backbone &#8211; it&#8217;s flexible. It lets me use only a View when I want to, or only a Model when I want to. Unlike Knockout, Backbone does not directly address the model binding space. It provides plenty of hooks and open / flexibility in it&#8217;s design and implementation, though, allowing model binding to be integrated in to it.

## Model Binding

It really is a shame that there is such a &#8220;Backbone vs Knockout&#8221; mentality when these tools should play together and create an even better experience for the developer and end-user. The big problem has been that they clobber each other when it comes to the idea of a &#8220;model&#8221;. However, Knockout&#8217;s recent releases have an API that can be used to bind anything to Knockout. With that, here&#8217;s a project up on Github that brings both KO and BB together:

<https://github.com/kmalakoff/knockback>

[](https://github.com/kmalakoff/knockback)There&#8217;s also my own Backbone.ModelBinding plugin which aims to bring a lot of model binding capabilities to Backbone without using Knockout (while being heavily inspired by it):

<https://github.com/derickbailey/backbone.modelbinding>

## Knockout -> Backbone

For what it&#8217;s worth: I know a handful of people that start with Knockout because of the astounding demos and jaw-dropping ease of creating model bindings. After building some very large JavaScript apps, though, they wished that they had gone with something like Backbone which provides a better structure out of the box for large apps. I&#8217;m not saying you can&#8217;t built large JavaScript apps with Knockout. You have to build the infrastructure or find another infrastructure to support the large app design needs, though.

## Knockout AND Backbone

With Knockback bringing both of these projects together, maybe you don&#8217;t need to choose one or the other for the system at large. Maybe you can get down to choosing which one is right for the specific page your building, including both of them when needed.