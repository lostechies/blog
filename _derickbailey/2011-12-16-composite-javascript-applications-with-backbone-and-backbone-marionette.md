---
id: 728
title: Composite JavaScript Applications With Backbone And Backbone.Marionette
date: 2011-12-16T09:33:37+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=728
dsq_thread_id:
  - "506548845"
categories:
  - Backbone
  - Composite Apps
  - JavaScript
  - Marionette
---
Although I&#8217;ve mentioned it in this blog already, and have been tweeting about it, we&#8217;ll call this the official announcement for my new Backbone.Marionette library.

[Backbone.Marionette](http://github.com/derickbailey/backbone.marionette): Make your BackboneJS apps dance with a composite application structure!

## Why?

Over the last … however many months I&#8217;ve been using Backbone, I&#8217;ve developed a number of opinions around building apps. I have a particular style of code that I write, with a particular set of functionality that is common through most of (if not all of) my apps. Backbone.Marionette is another of the many plugins I&#8217;ve created, that encapsulates my opinions.

To date, i have the following libraries for Backbone, with more ideas in my head based on the work I&#8217;m currently doing:

  * [Backbone.ModelBinding](http://github.com/derickbailey/backbone.modelbinding)
  * [Backbone.Memento](http://github.com/derickbailey/backbone.memento)
  * **[Backbone.Marionette](http://github.com/derickbailey/backbone.marionette)**

My goal with these plugins is not to say &#8220;this is how you must work with Backbone&#8221;. Rather, I want to provide options and opinions for those that are running into the same problems that I&#8217;ve run into. When I find myself solving the same problem over and over again, I find myself wanting to extract the solution into a library. This lets me get on with my real application development instead of focusing on solving the same problem again.

The trick with my plugins, is to provide a set of libraries that all work independently, but can be combined in very creative ways to create some even more amazing. Even within each library, I&#8217;m trying to take an approach that allows you to use only the parts that you want. Of the three plugins I&#8217;ve written, I think ModelBinding is the most restrictive / hand-holding. Memento and Marionette both offer a great deal of freedom and flexibility vs the configurability of ModelBinding.

## What?

Marionette is a library of tools that you can use when you want to, without being forced to use every single piece of it. These tools include:

  * Application initialization
  * View management
  * Event aggregation

Though the number of pieces is currently small, each of these pieces is very flexible and can be used without requiring any other piece. They can also be integrated into existing applications as-needed, allowing you to migrate an app from your existing code to Marionette.

## How: Application Initialization

This was the big piece for me in building Marionette. I noticed that at some point that my BackboneJS applications tend to gather a cruft of procedural mess in an &#8220;application object&#8221;. This application object has always been responsible for starting up the various bits of the app: routers, initial views, instantiating collections and initial models, etc.

The problem is that these objects have usually ended up in a giant tangled mess with far too many concerns. For example, here&#8217;s some code from an image gallery that I wrote a few months ago. Note that this is only the application startup code:

[gist id=1486459 file=gallery.js]

It&#8217;s a giant mess and it&#8217;s difficult to understand and maintain.

The solution involved recognizing that I was putting far too many concerns into a single place, combined with a healthy dose of encapsulation. I want each functional area of my application to have it&#8217;s own start up code, encapsulated within that functional area&#8217;s code. I don&#8217;t want to have to mash all the functional areas together into one procedural mess. So, I build the \`Backbone.Marionette.Application\` object.

This object provides a number of different features, one of which is the ability to register application initialization callbacks. To do this, you need to create an instance of an Application object, first. Then call the \`addInitializer\` method and provide a callback function. The initialization functions are then kicked off when you call the \`start\` method on your application:

[gist id=1486459 file=initializer.js]

You can optionally pass an object through the start method, as well. This object is made available to all of the initializer callbacks as a single parameter to the callback function. Additionally, there&#8217;s a &#8220;initialize:before&#8221; and &#8220;initialize:after&#8221; event that the application object raises, using Backbone&#8217;s Event functionality.

The trick is to keep your code organized and put your initializers next to the code that they initialize. Don&#8217;t just cram all of your initializers into a single file, recreating the same mess from my image gallery. Put your initializers near the code that they initialize. Keep them separate, keep it clean and decoupled. Add as many initializers as you need. Just remember that you have no guarantee of the order in which they run.

For more info on the application object, see [the documentation](http://github.com/derickbailey/backbone.marionette).

## How: Event Aggregation

The \`Application\` object comes with an event aggregator built into it. You can call the \`.vent\` property of any Application instance and have full access to the Backbone Event system. I won&#8217;t go into any more detail about this right now, as you can [read up on the basics of how I use event aggregators in my previous blog post](http://lostechies.com/derickbailey/2011/07/19/references-routing-and-the-event-aggregator-coordinating-views-in-backbone-js/).

Of course you can still build your own event aggregator with one line of code.

[gist id=1486459 file=vent.js]

In fact, this is all I&#8217;m doing in the Application object. I just put it there as a convenience so I don&#8217;t have to create one manually for every app:

## How: View Management

In one of my recent blog posts on composite JS apps I talked about [the use of a region manager](http://lostechies.com/derickbailey/2011/09/15/zombies-run-managing-page-transitions-in-backbone-apps/), and the code that I wrote in that post has been migrated into Backbone.Marionette as the \`RegionManager\` object.

The [intent and purpose of a RegionManager](http://lostechies.com/derickbailey/2011/12/12/composite-js-apps-regions-and-region-managers/) is the same as I&#8217;ve previously talked about. The difference in Marionette is how you access a RegionManager. You have two options: use the \`addRegions\` method on your Application instance, or manually create a RegionManager object. The choice gives you flexibility, allowing you to use a RegionManager without using the rest of Marionette, if you want to.

The \`addRegions\` method on the Application object accepts a single parameter of a JavaScript object literal. The keys for this object become the names of the regions, and the value of each key should be a jQuery selector that points to the HTML DOM element that your region manager will manage:

[gist id=1486459 file=region.js]

You can also pass a RegionManager definition as a value. See [the documentation](http://github.com/derickbailey/backbone.marionette) for more info on this.

Once the application is started, each of the keys that specified will be available on the application object instance. You can then call the \`show\` method on your region managers to show your Backbone views in that region.

## Documentation And Source Code

I&#8217;ve linked to the documentation several times, which is found on the Github repository that houses the code:

<http://github.com/derickbailey/backbone.marionette>

I also have the annotated documentation that I&#8217;ve previously talked about, available at:

<http://derickbailey.github.com/backbone.marionette/docs/backbone.marionette.html>

## BBCloneMail: A Reference Application

In addition to the source code and documentation, I&#8217;m building a sample application that can be used as a reference for building Backbone applications with Backbone.Marionette. The name &#8220;BBCloneMail&#8221; comes from the idea of a &#8220;Backbone clone of GMail&#8221; to demonstrate a composite application. Though it&#8217;s styling is different than Gmail&#8217;s, you can clearly see the influence in the layout, the use of categories (labels) and the drop list to switch between the mail and contacts apps.

You can find BBCloneMail online at:

<http://bbclonemail.heroku.com>

The source code is here:

<http://github.com/derickbailey/bbclonemail>

And the annotated source as documentation is here:

<http://derickbailey.github.com/bbclonemail/docs/bbclonemail.html>

## But Wait! There&#8217;s More!

This is the first official release of Backbone.Marionette: v0.1.0… I expect the functionality to continue to grow and evolve as I use it in more application, and as (hopefully) I see other people using it and contributing their own needs to the code.