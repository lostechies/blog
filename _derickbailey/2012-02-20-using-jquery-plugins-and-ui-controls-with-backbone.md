---
wordpress_id: 825
title: Using jQuery, Plugins and UI Controls With Backbone
date: 2012-02-20T08:15:07+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=825
dsq_thread_id:
  - "582957642"
categories:
  - Backbone
  - DOM
  - HTML5
  - JavaScript
  - JQuery
  - KendoUI
  - Marionette
  - Telerik
  - Tools and Vendors
---
Most Backbone applications either use jQuery or Zepto as their DOM manipulation of choice. I tend to use jQuery as it&#8217;s supported across more browsers and has more features &#8211; though it is a little heavier in terms of download size (and maybe performance). I also use a lot of jQuery plugins for various controls, to create specific effects, etc. It&#8217;s generally easy to do, as Backbone&#8217;s views provide direct access to a jQuery element as &#8220;this.el&#8221; or &#8220;this.$el&#8221;. From there, we can call standard jQuery code and plugins.

There are some common patterns I&#8217;ve noticed for doing this, too. Specifically, when to call a particular jQuery function or plugin largely depends on the purpose of that function and sometimes depends on how that function or plugin is built.

## DOM Dependent/Independent

At a very basic level, jQuery manipulations of the DOM can fall in to 1 of 2 categories: DOM-dependent and DOM-independent. Many of the operations that we do in jQuery are dependent on the HTML that we&#8217;re manipulating being in the DOM already. Some of them don&#8217;t need the HTML to be part of the DOM, though. In those cases, we can work with document fragments that aren&#8217;t currently displayed or part of the DOM.

For example, it doesn&#8217;t make much sense to call &#8220;[.slideUp](http://api.jquery.com/slideUp/)&#8221; if the HTML we&#8217;re manipulating isn&#8217;t currently displayed. The animation that this method causes would still run, but we wouldn&#8217;t see anything. The end result would not be visible and we would have wasted the browser&#8217;s execution time on this animation. I generally lump visual changes and animations in to the DOM-dependent category because it doesn&#8217;t make sense to use these methods if the HTML is not in the DOM yet.

On the other hand, I often call &#8220;[.hide](http://api.jquery.com/hide/)&#8221; on document fragments before they are attached to the DOM. I do this so that when the HTML fragments are finally added to the DOM, they won&#8217;t be visible to the user. Then, after I&#8217;ve attached the HTML to the DOM, I can call &#8220;slideUp&#8221; or any of a number of other methods in jQuery, to cause the content to be displayed. I call these methods DOM-independent because they can be called whether we are working with a document fragment that only exists in memory, or working with an element that is already part of the DOM.

Of course, this is a great oversimplification of things. There is a lot of functionality in jQuery that doesn&#8217;t even deal with HTML elements or the DOM at all. These would clearly fall in to the DOM-independent category, but I&#8217;m not even going to address those right now. And even though this is a simplified way to view jQuery&#8217;s functions, it&#8217;s generally useful. It also helps us understand when we should call some of these methods when we think about integration with Backbone.

## Simple Manipulations And Events

Most of the simple manipulations that we perform with jQuery are DOM-independent. We can call them and manipulate a document fragment or a DOM element directly, whenever we want to. This includes not only showing / hiding HTML elements, but also adding and removing them, attaching events, and more.

Consider this example:

{% gist 1865366 1.js %}

Here we can see a number of jQuery manipulations and events in place.

Starting with the core of Backbone&#8217;s View, an HTML element is generated when a view instance is created. This gets populated into &#8220;this.el&#8221; and cached in a jQuery selector object as &#8220;this.$el&#8221;.

In the render view, then, we see that we are using jQuery to create additional document fragments. For performance reasons (since it&#8217;s possible that the view&#8217;s &#8220;el&#8221; was attached to the DOM without the view knowing it), we&#8217;re populating the document fragment with content entirely in memory. This includes the addition of some data and calling &#8220;hide&#8221; on the fragment. We can manipulate the fragment with DOM-independent functions as much as we want, at this point.

Once we&#8217;ve completed the rendering of the HTML contents, we stuff it all in to the view&#8217;s el. The el is then attached to the DOM and the content we generated and we can begin using DOM-dependent methods.

We can also attach DOM level events to the fragments that we&#8217;ve generated.  Since jQuery is turning our strings in to proper document fragments for us, the DOM events are available. That means we can call methods like &#8220;.click&#8221; and &#8220;.blur&#8221; on the view&#8217;s &#8220;el&#8221; if we want to. But I generally consider this to be an anti-pattern. There are some cases where you&#8217;ll need to manually attach events, and it can be done here in the render method.  For the most part, though, we should be using Backbone&#8217;s declarative &#8220;events&#8221; on our views.

## DOM Events And Simple Animations

Backbone&#8217;s &#8220;View&#8221; object abstracts a little bit of jQuery&#8217;s event system for us, through the use of the declarative &#8220;events&#8221;.

{% gist 1865366 2.js %}

Surprisingly, DOM events are partially DOM-independent. As I said above, we can add the events to the document fragments before they become part of the DOM. We can even trigger them manually without them being part of the DOM. In general, though, we let the DOM fire it&#8217;s events for us.

Allowing the user to fire DOM events through DOM interactions (clicks, blurs, changes, etc) is DOM-dependent, of course. The view must attach any HTML structure that it needs to the DOM before the user can interact with them, to fire these events.

Often when we &#8220;click&#8221; or &#8220;change&#8221; or fire off some other DOM level event in our code, we want to respond to this by manipulating the DOM in a visual manner. For example, we might want to call &#8220;.hide(&#8216;slow&#8217;)&#8221; on a portion of the view&#8217;s &#8220;el&#8221; in order to hide some items on the screen with a simple animation. The above example shows this. When you click on the top level &#8220;div&#8221;, the child &#8220;ul&#8221; is shown or hidden using the &#8220;[slideToggle](http://api.jquery.com/slideToggle/)&#8221; animation method from jQuery.

## jQuery Plugins And UI Controls

There are a large number of jQuery UI controls available, including the jQueryUI suite itself. I&#8217;ve used this suite and many other plugins for UI controls with Backbone a lot.

Generally speaking, most jQuery UI controls are partially DOM-independent in that you can call the jQuery plugin method to get them started before the document fragment you&#8217;re working with is attached to the DOM. Once the document fragment has been configured with the plugin&#8217;s code and additional structure, though, the plugins generally become DOM-dependent (as illustrated in the previous section).

For example, if you want to convert a &#8220;ul&#8221; list in to a menu structure using [KendoUI](http://www.kendoui.com/), you can call &#8220;[.kendoMenu](http://demos.kendoui.com/web/menu/index.html)&#8221; during the render method of the view:

{% gist 1865366 3.js %}

Once the Kendo menu in configured, though, the view&#8217;s &#8220;el&#8221; has to be attached to the DOM (if it isn&#8217;t already). When that happens, you&#8217;ll see the menu structure in place.

## DOM-Dependent UI Controls

I have run in to a few scenarios where a jQuery plugin was entirely DOM-dependent &#8211; or at least, my usage of it was. This meant that I could not call the plugin&#8217;s method prior to the Backbone view&#8217;s &#8220;el&#8221; being added to the DOM.

The &#8220;easy&#8221; solution to this is to have the view attach it&#8217;s &#8220;el&#8221; directly to the DOM in some fashion. But [as I&#8217;ve talked about before](http://lostechies.com/derickbailey/2011/11/09/backbone-js-object-literals-views-events-jquery-and-el/), this is a bad idea. Instead, it only takes a few extra lines of code &#8211; which can be easily extracted in to something reusable &#8211; to make this work.

{% gist 1865366 4.js %}

In this example, I&#8217;ve added a method to the view called &#8220;onShow&#8221;. This method contains the call to the jQuery &#8220;[Layout Manager](http://layout.jquery-dev.net/documentation.cfm)&#8221; plugin, which in my experience has been entirely DOM-dependent. Note that the &#8220;onShow&#8221; method doesn&#8217;t get called from within the view, though. This is because it&#8217;s not the view&#8217;s responsibility for adding itself to the DOM. It&#8217;s the responsibility of the code that needs the view, to do this.

{% gist 1865366 5.js %}

The code that needs the view will instantiate it, call render and attach the resulting &#8220;view.el&#8221; to the DOM somehow. This is pretty straight-forward so far. What is does next, though, is check for the existence of an &#8220;onShow&#8221; method in the view. If that method does exist, it gets called. Since the code that is using the view knows that it has already added the view to the DOM, it knows when to call the &#8220;onShow&#8221; method. This allows us to write code that relies on DOM-dependent functionality without the view having to know if it&#8217;s been added to the DOM or not.

(FWIW: in retrospect, I regret using the Layout Manager plugin that I linked to and showed. It&#8217;s caused me a lot of frustration. I find it far easier to use KendoUI&#8217;s &#8220;[Splitter](http://demos.kendoui.com/web/splitter/index.html)&#8221; control, instead.)

## Extracting The onShow Method Call

I&#8217;ve written this &#8220;onShow&#8221; method and the code to call it, a countless number of times. It became such a ubiquitous part of my code that I added it to my &#8220;RegionManager&#8221; in [Backbone.Marionette](https://github.com/derickbailey/backbone.marionette) (a region manager is [responsible for managing the rendering, display and closing of a view](http://lostechies.com/derickbailey/2011/12/12/composite-js-apps-regions-and-region-managers/), for a given region of the screen).

I&#8217;ve also found it to be very useful to have two additional methods that are called on my views: onClose and onRender. I specifically have onClose and onRender. onClose is called by the region manager when closing an existing view. onRender, though, is called by my base &#8220;ItemView&#8221; or &#8220;CollectionView&#8221; in Marionette, as I&#8217;ve extracted the core rendering in to these two objects but still want to provide a way for specific views to take advantage of DOM-independent plugins and UI controls.

## Context Is Still King

As always, the patterns and implementations that I&#8217;ve shown here are entirely contextual. You&#8217;ll likely find scenarios where some DOM-independent code should not be called until after the view&#8217;s &#8220;el&#8221; is part of the DOM, for example. Use your judgement, experience and trial-and-error with the various methods and functions that you have to call to get your behavior correct.

## Full Disclosure On KendoUI

I want to be up front about my use of KendoUI in this post. I&#8217;m using KendoUI in some of these examples and I link to it directly because I love this control suite. I was, however, given a free Telerik Ultimate subscription so that I could continue using Kendo and the other tools. I was asked to talk about Kendo when appropriate, in return for this subscription. When Telerik offered that to me, I gladly accepted &#8211; not because I saved a few hundred $, but because I was going to write this anyways and spend my own $ on the control suite. It was simply a win-win situation for me, to get the free subscription and to help spread the word on a control suite that I love using with Backbone.
