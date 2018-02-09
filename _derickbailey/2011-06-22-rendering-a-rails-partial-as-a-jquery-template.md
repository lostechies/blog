---
wordpress_id: 458
title: Rendering A Rails Partial As A jQuery Template
date: 2011-06-22T22:07:54+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=458
dsq_thread_id:
  - "339879933"
categories:
  - JavaScript
  - JQuery
  - Rails
---
A question was [asked on twitter](https://twitter.com/#!/rbazinet/status/83724169665183745):

[<img title="Screen shot 2011-06-22 at 10.52.47 PM.png" src="http://lostechies.com/derickbailey/files/2011/06/Screen-shot-2011-06-22-at-10.52.47-PM.png" border="0" alt="Screen shot 2011 06 22 at 10 52 47 PM" width="514" height="142" />](https://twitter.com/#!/rbazinet/status/83724169665183745)

Here&#8217;s [one of the answers](https://twitter.com/#!/derickbailey/status/83724882654924802) that I sent to rob, in the form of a gist:

{% gist 1041780 use_partial_as_template.html.erb %}

I&#8217;m using this solution in my current rails app and it&#8217;s a very elegant way to use an existing partial as a jQuery template. The only issue you have to solve, then, is how to get the &#8220;${value}&#8221; syntax populated into the rendered template fields. That, too, is simple.

Given this partial:

{% gist 1041780 _partial.html.erb %}

I need to turn &#8220;<%= model.value %>&#8221; into &#8220;${value}&#8221; so that the jQuery template will populate the data. To do that, we provide an @template_model instance of our model, populated with the &#8220;${value}&#8221; values, from our controller.

{% gist 1041780 some_controller.rb %}

Easy-peasy. Our partial renders with the output of &#8220;this is a partial. ${value}&#8221; and when the jQuery template does its magic, it produces &#8220;this is a partial. this is some data&#8221; as the final result. From here, you can use jQueryUI&#8217;s dialog to open the rendered template as a dialog.
