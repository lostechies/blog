---
id: 855
title: Managing Layouts And Nested Views With Backbone.Marionette
date: 2012-03-22T07:14:03+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=855
dsq_thread_id:
  - "620624750"
categories:
  - Backbone
  - Composite Apps
  - JavaScript
  - Marionette
---
I&#8217;ve received numerous questions about managing layouts and nested views in Backbone over the last few months. Until recently, though, I never had a great answer. Many of the applications that I&#8217;ve built had a lot of custom code to handle the specific needs of that application&#8217;s layout and generally avoiding deeply nested views.

All of that changed recently, though, and I found myself needing the ability to manage a larger set of views as siblings. Specifically, I needed a way to render an application layout, have it behave like a view in that I can send it over to one of my region manager objects, and have its own region managers that can show views within the layout.

<span style="font-size: 18px; font-weight: bold;">Marionette.Layout</span>

The answer that I found is something that several Marionette users had suggested and tried on their own: render the layout as a view, directly, and then create some regions from the generated HTML of that view. After trying this out on one of my projects, I quickly realized that this was the answer I needed so I put it together formally, in the Marionette.Layout object.

The core of Layout is an ItemView + Regions. In fact, that&#8217;s exactly what the Layout is… it extends from Marionette&#8217;s ItemView and it adds the ability to specify a set of regions that will be instantiated with the Layout.

[gist id=2131050 file=1.js]

When you create a new instance of MyLayout, you&#8217;ll get access to &#8220;myRegion&#8221; and &#8220;anotherRegion&#8221; immediately. They won&#8217;t really be able to do anything until you call the layout&#8217;s &#8220;render&#8221; method, though. Once the layout has been rendered, you can call the &#8220;show&#8221; method on the regions to show whatever content you want in the region.

[gist id=2131050 file=2.js]

## Nested Views And Layouts

One of the benefits of using an ItemView as the base object for my Layout is that I can send the Layout to an existing Region&#8217;s &#8220;show&#8221; method. This means I can nest a layout within an existing part of the application &#8211; whether it&#8217;s hard coded HTML, another ItemView, or even another Layout. Anywhere that a Backbone.View can be used, a Layout can be put in it&#8217;s place, allowing a nearly unlimited nesting structure (limited by a JavaScript runtime engine and it&#8217;s stack size, memory usage, etc).

In addition, if you&#8217;re using Marionette&#8217;s various view types (ItemView, CollectionView, CompositeView and Layout) in combination with Regions, all of the cleanup that is needed, is built right in to the views. When you close a view by either calling \`.close()\` on it, or by replacing it within a region using the region&#8217;s \`.show()\` method, the view and it&#8217;s children will be closed and cleaned up. This means you don&#8217;t have to worry quite as much about memory leaks and other issues, though you still have to [make sure you de-reference the view entirely](http://lostechies.com/derickbailey/2012/03/19/backbone-js-and-javascript-garbage-collection/).

## Layout vs Application

A client recently asked me why I had both a Layout and an Application object in Marionette. He specifically wanted to know what the difference was and when to use which. The core difference comes down to semantics, but there are some technical differences as well.

A Layout has a visual representation. It renders a template and it can handle DOM events and update the DOM when needed. An Application on the other hand has no visual representation. It&#8217;s a light-weight object that provides some key functionality for an application to get up and running in JavaScript, including the standard use as a namespace object. Both Layout and Application provide a \`.vent\` attribute as an event aggregator, though. In that, they are similar. The last of the major difference, though, is that an Application object has initializers. You can register initializer callbacks that are fired when the application&#8217;s \`start()\` method is called. There are no initializers with a Layout, though you could get some of the same effect using events that the Layout triggers.

## An Example: BBCloneMail

I&#8217;ve updated my [BBCloneMail](https://github.com/derickbailey/bbclonemail) application to use a Layout, specifically to show what it can do. The new version of this example app renders the entire page as one Layout object, and includes the app switching drop down list as part of the layout. Now when you switch between Mail and Contacts in the app, it&#8217;s the Layout for the over-all app that handles this.

[gist id=2131050 file=3.js]

There is one small oddity in this, though. Since I&#8217;m lazy-loading templates from the server &#8211; including the layout template &#8211; the call to start Backbone.history has to be delayed until after the layout is rendered. If I don&#8217;t put this delay in place, then the mail and categories won&#8217;t show up after they are rendered. To fix this issue, I moved the \`Backbone.history.start()\` in to the BBCloneMail.Layout file and took advantage of the view &#8220;render&#8221; method returning a jQuery deferred object.

[gist id=2131050 file=4.js]

When this deferred object is &#8220;done&#8221;, I know it&#8217;s been rendered. That means I can start the history object and kick off my routers, which in term render the mail and categories on to the screen.

## Some Better Examples?

I know there are some better use cases for a Layout than what I&#8217;ve shown, here. In fact, I&#8217;ve used it for better purposes already &#8211; but on a few projects that I can&#8217;t talk about (NDA and all that). One of the ways that I have thought about using a Layout, though, is to represent a sub-application. For example, in a tab-oriented application, each open tab may represent a separate sub-application and have it&#8217;s own layout needs. A Layout object would be a great way to render the tab&#8217;s contents and allow different parts of the tab&#8217;s contents to be swapped out as needed.

And I&#8217;m sure there are other scenarios where a Layout will come in handy, as well. This feature of Marionette has been requested numerous times, so I know people are working with applications that need this functionality. I also feel like this finally rounds out the majority of the functionality that Marionette really needed, to be a composite application framework. There&#8217;s still more to come, though. I&#8217;m constantly learning and finding new patterns that I want to incorporate in to Marionette. One of these days, though, I&#8217;ll let it hit v1.0.