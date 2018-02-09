---
wordpress_id: 930
title: 'Conventional HTML in ASP.NET MVC: Client-side templates'
date: 2014-08-14T20:21:39+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=930
dsq_thread_id:
  - "2927566011"
categories:
  - ASPNETMVC
---
<div>
  <p>
    Other posts in this series:
  </p>
  
  <ul>
    <li>
      <a href="http://lostechies.com/jimmybogard/2013/07/18/conventional-html-in-asp-net-mvc-a-primer/">A primer</a>
    </li>
    <li>
      <a href="http://lostechies.com/jimmybogard/2013/08/13/conventional-html-in-asp-net-mvc-building-tags/">Building tags</a>
    </li>
    <li>
      <a href="http://lostechies.com/jimmybogard/2014/07/11/conventional-html-in-asp-net-mvc-adopting-fubu-conventions/">Adopting Fubu conventions</a>
    </li>
    <li>
      <a href="http://lostechies.com/jimmybogard/2014/07/17/conventional-html-in-asp-net-mvc-baseline-behavior/">Baseline behavior</a>
    </li>
    <li>
      <a href="http://lostechies.com/jimmybogard/2014/07/22/conventional-html-in-asp-net-mvc-replacing-form-helpers/">Replacing form helpers</a>
    </li>
    <li>
      <a href="http://lostechies.com/jimmybogard/2014/07/23/conventional-html-in-asp-net-mvc-data-bound-elements/">Data-bound elements</a>
    </li>
    <li>
      <a href="http://lostechies.com/jimmybogard/2014/07/24/conventional-html-in-asp-net-mvc-validators/">Validators</a>
    </li>
    <li>
      <a href="http://lostechies.com/jimmybogard/2014/07/25/conventional-html-in-asp-net-mvc-building-larger-primitives/">Building larger primitives</a>
    </li>
    <li>
      <a href="http://lostechies.com/jimmybogard/2014/08/14/conventional-html-in-asp-net-mvc-client-side-templates/">Client-side templates</a>
    </li>
  </ul>
</div>

In our last post, we brought everything together to build composable blocks of tags driven off of metadata. We did this to make sure that when a concept exists in our application, it’s only defined once and the rest of our system builds off of this concept. This reduces logic duplication across several layers, ensuring that we don’t have to “remember” to do repetitive tasks, like a required field needing an asterisk and data attributes.

All of this works great because we’ve got all the information at our disposal on the server-side, and we can push the completed product down to the client (browser). But what if we’re building a SPA, using Angular or Knockout or Ember or Backbone? Do we have to revert back to our old ways of duplication? Or can we have the best of both worlds?

There tend to be three general approaches:

  * Just hard code it and accept the duplication
  * Include metadata in your JSON API calls, through hypermedia or other means
  * Build intelligence into templates

I’ve done all three, and each have their benefits and drawbacks. Most teams I talk to go with #1, and some go with #2. Very few teams I meet even think about #3.

What I’d like to do is have the power of my original server-side Razor templates, with the strongly-typed views and intelligent expression-based helpers, but instead of complete HTML templates, have these be Angular views or Ember templates:

[<img style="padding-top: 0px; padding-left: 0px; padding-right: 0px; border: 0px;" src="http://lostechies.com/jimmybogard/files/2014/08/image_thumb.png" alt="image" width="346" height="293" border="0" />](http://lostechies.com/jimmybogard/files/2014/08/image.png)

When we deliver our templates to the client as part of our SPA, we’ll serve up a special version of them, one that’s been parsed by our Razor engine. Normally, the Razor engine performs two tasks:

  * HTML generation
  * Binding model data

Instead, we’ll only generate our template, and the client will then bind the model to our template.

### Serving templates, Ember style

Normally, the MVC view engine runs the Razor parser. But we’re not going that path, we’re going to parse the templates ourselves. The result of parsing will be placed inside our script tags. This part is a little long, so I’ll just link to the entire set of code.

[HtmlHelperExtensions](https://gist.github.com/jbogard/47a8f67e5050bd10f2b8)

A couple key points here. First, the part that runs the template through the view engine to render an HTML string:

{% gist 2a037f77eaa939469b56 %}

We render the view through our normal Razor view engine, but surround the result in a script tag signifying this is a Handlebars template. We’ll place the results in cache of course, as there’s no need to perform this step more than once. In our context objects we build up, we simply leave our ViewData blank, so that there isn’t any data bound to input elements.

We also make sure our templates are named correctly, using the folder structure to match Ember’s conventions. In our one actual MVC action, we’ll include the templates in the first request:

{% gist bc991d77f65b6be17b2f %}

Now that our templates are parsed and named appropriately, we can focus on building our view templates.

### Conventional Handlebars

At this point, we want to use our HTML conventions to build out the elements needed for our Ember templates. Unfortunately, we won’t be able to use our previous tools to do so, as Ember uses Handlebars as its templating language. If we were using Angular, it might be a bit easier to build out our directives, but not by much. Client-side binding using templates or directives requires special syntax for binding to scope/model/controller data.

We don’t have our convention model, or even our HtmlTag library to use. Instead, we’ll have to use the old-fashioned way – building up a string by hand, evaluating rules as we go. I could have built a library for creating Ember view helpers, but it didn’t seem to be worth it in my case.

Eventually, I want to get to this:

{% gist 05620cf82d2e6afb2abc %}

But have this render this:

{% gist 5c86e742877396dedc75 %}

First, let’s start with our basic input and just cover the very simple case of a text field.

{% gist 01d4f6f0f72b72b6d00e %}

We grab the expression text and model metadata, and begin building up our Handlebars snippet. We apply our conventions manually for each required attribute, including any additional attributes we need based on the MVC-style mode of passing in extra key/value pairs as a dictionary.

Once we have this in place, we can layer on our label helper:

{% gist 637ceae59754c9f42151 %}

It’s very similar to the code in the MVC label helper, with the slight tweak of defaulting label names to the property names with spaces between words. Finally, our input block combines these two together:

{% gist 28119afea684cdf64c58 %}

Now, our views start to become a bit more sane, and it takes a keen eye to see that it’s actually a Handlebars template. We still get strongly-typed helpers, metadata-driven elements, and synergy between our client-side code and our server-side models:

{% gist e491ca933a1bb35a5ef4 %}

We’ve now come full-circle, leverage our techniques that let us be ultra-productive building out pages on the server side, but not losing that productivity on the client-side. A concept such as “required field” lives in exactly one spot, and the rest of our system reads and reacts to that information.

And that, I think, is pretty cool.