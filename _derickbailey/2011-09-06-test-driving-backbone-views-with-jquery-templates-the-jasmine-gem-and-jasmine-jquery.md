---
wordpress_id: 539
title: Test-Driving Backbone Views With JQuery Templates, The Jasmine Gem, and Jasmine-JQuery
date: 2011-09-06T08:31:03+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=539
dsq_thread_id:
  - "406257075"
categories:
  - Backbone
  - JQuery
  - Model-View-Controller
  - Ruby
  - Unit Testing
---
In my current production rails app, I use Cucumber to test my backbone code as an integration test &#8211; to make sure that the entire system is playing nice. Over the weekend, I decided to dive a little deeper into my test-driven-fu with Backbone apps. I wanted to get into the flow of test-driven development for all of my backbone applications, not just the plugins and complex logic scenarios that I have been doing so far.

## A Roadblock: jQuery Selectors And Templates

I like jQuery Templates. They make my life with backbone much easier. But, I quickly ran into a problem when I got to the point where I wanted to start testing my backbone views that use jQuery Templates. Here&#8217;s the problem in a nutshell:

{% gist 1197506 1-problem.js %}

And a template definition, stuff into my page&#8217;s HTML, like this:

{% gist 1197506 2-template.erb %}

The problem is that line in the middle of the backbone view &#8211; the one that uses jQuery to load up the contents of my template. How am I supposed to get access to my template definition when it&#8217;s stuck inside of an HTML page that my jasmine tests don&#8217;t have loaded up?!

## Jasmine-JQuery Fixtures To The Rescue!

After floundering around for hours, I finally started seeing some potential solutions for this in having an external template file to use, and loading that up with the [Jasmine-jQuery](https://github.com/velesin/jasmine-jquery) plugin and it&#8217;s &#8216;fixtures&#8217; feature. [I&#8217;ve read about fixtures before](http://tinnedfruit.com/2011/04/26/testing-backbone-apps-with-jasmine-sinon-3.html), but had not found a real need for them in my tests… until now. As it turns out, fixtures are exactly what I need. They let me either specify some HTML directly in my tests, or load up an external fixture &#8211; an HTML file &#8211; and have it be available in my tests.

After loading the Jamsine-jQuery plugin into my Jasmine tests, I only needed to add one line of code to have my template available:

{% gist 1197506 3-test-with-fixture.js %}

Now in my tests, I&#8217;ll have the template that I need available. My backbone view will be able to select it from the DOM, render it with my model or collection, and manipulate it as needed.

## Potentially Duplicated HTML

There&#8217;s one more problem that using a fixture introduced, though. The default load path for fixtures is the &#8216;/spec/javascripts/fixtures&#8217; folder. This makes sense as a default. Since fixtures are for tests, then the fixtures load path should be in the spec folder somewhere. However, my template is currently stuck inside of the HTML of my page.

To have my template available as a fixture, I needed to copy my template from my HTML page into a file in the fixtures folder. This sounds like duplication to me &#8211; one copy in the real HTML page and one copy in the fixtures folder. This might be OK for something small, but it would be a maintenance nightmare for a large problem with a lot of templates.

The solution I found is a combination of a few things: external template files, adjusting the load path of the fixtures, and rendering my templates into my HTML page as partial views.

## External Template Files

To start with, I decided to put my templates into external files. I read several blog posts and stack overflow where people talked about doing this, and I decided to go ahead and give it a try. I need to have my templates available to both my actual application and my specs. At first, I thought this was going to end up in duplication, again.

After some more thought, I decided to try using a symlink. I&#8217;m using Sintra with ERB templates as the back-end for this app, so I put my template into the \`./views\` folder with a file name of \`some-template-id.erb\`. Then, I went into the \`/spec/javascripts/\` folder and I created a symlink:

{% gist 1197506 4-symlink.sh %}

Now my folder structure at \`/spec/javascripts/fixtures\` would point to my views folder. This would let the Jasmine-jQuery fixtures load the templates and also allow me to use my templates in my HTML views.

## Rendering Templates As Partial Views

The next thing I needed to do was use my templates in my HTML page. I found an article by Dave Ward that talks about [using external template files](http://encosia.com/using-external-templates-with-jquery-templates/) and loading them as-need via an AJAX request. However, I didn&#8217;t like this idea. If I have one or two templates on a page, this isn&#8217;t a big deal. But if I have 10 or 15 templates on a page, this would become a performance issue pretty quickly &#8211; even with HTTP Caching, etc. The initial load of each template would be a hit that I don&#8217;t want my users to have to take. Then there&#8217;s the issue of making sure the web server caches and sets the timeout for the template correctly… more than I wanted to deal with.

The solution that I came across, in the end, was much easier: render the template as a partial view. Since I already have ERB templates available on the server side, it was easy to take my template file and turn it into an ERB template that the server can render as a partial. All I had to do was render the partial into my HTML view:

{% gist 1197506 5-index.erb %}

This allowed me to have my jQuery template set up for use with my actual application, in addition to it being available to my Jasmine specs.

## Scrapping Symlinks. Adjust The Fixture Load Path

After reading some additional documentation for Jasmine-jQuery fixtures, I saw that it&#8217;s possible to change the load path for the templates. In addition, I&#8217;m using the Jasmine ruby gem to run my jasmine specs. This gem uses Sinatra (which I was already using in my app) to host the page that runs all of the jasmine specs. The Sinatra configuration for the Jasmine specs runs on port 8888 and opens up the entire folder structure of the application as part of the publicly accessible content via HTTP requests. This means that my \`./views\` folder is accessible via \`http://localhost:8888/views/\`. I scrapped the symlink, then, in favor of setting the load path for my fixtures.

{% gist 1197506 6-load-path.js %}

I added this line of code to a file in \`./spec/javascripts/helpers/\` to ensure that it is always loaded and set for my Jasmine specs. Once I did this, my fixtures were now being loaded from from the views folder, via http requests, and I could drop the symlink for the fixtures folder.

## Applicable To More Than Just Sinatra

One of my goals in setting this up was to have a solution that was applicable to more than just my current needs. Of course some of the implementation details that I&#8217;ve shown here are specific to Sinatra and the way I currently have things set up. However, the general idea of using external jQuery template file and rendering them into your HTML page for your actual application is almost universal to modern web development frameworks. This could be done easily in Rails, ASP.NET MVC, Django, Zend and other web server frameworks that allow partial views.
