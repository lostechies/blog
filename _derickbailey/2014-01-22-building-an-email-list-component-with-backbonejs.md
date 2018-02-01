---
id: 1231
title: Building An Email List Component With BackboneJS
date: 2014-01-22T09:12:49+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=1231
dsq_thread_id:
  - "2158823934"
categories:
  - Backbone
  - Books
  - E-Books
  - HTML5
  - JavaScript
  - Marionette
  - Model-View-Controller
  - Model-View-Presenter
  - Modules
---
In my post about [re-launching myself in to the independent life](http://lostechies.com/derickbailey/2014/01/20/2013-was-an-amazing-year-2014-will-be-a-rebirth/), I talked a little bit about restarting my effort to complete [my Building Backbone Plugins eBook](http://backboneplugins.com). I&#8217;ve already started down the path, reviewing existing chapters and beginning to fill in some of the missing pieces. My goal is to have the book content complete by the end of January, and have it edited well enough to call it done by the end of February. 

As part of my effort to get things done, I&#8217;m re-examining the flow of content and chapters. And I have to say coming back to this book after many months away is an eye opener in this regard. I immediately noticed several chapters out of place and an entire section of content that didn&#8217;t make sense in the flow of information. I&#8217;ve already taken steps to correct this and have reorganized several chapters and removed Part 5 of the book, absorbing the chapters into other parts. In the middle of all this, I also decided that one of the chapters from Part 5 does not need to be in the book at all &#8211; the chapter on building an email list component. Rather than toss the entire work in to the trash, though, I wanted to share this chapter with everyone. There&#8217;s a chance that it may find its way in to another book at another time, but that is yet to be determined.

## What Is A Component?

There are a lot of different definitions of “component” floating around these days. For the purposes of this book, a generalized definition will be borrowed from the up-coming W3C standard for Web Components, and from frameworks such as AngularJS which provide a way to build component based applications.

Components are a combination of visual portions of the application and the logic and processing of that visualization. They encapsulate a small feature or sub-set of a feature in a manner that allows the component to be wired together with other components, creating a larger feature set or functional area of an application. They have at least one view with some amount of logic and process (a.k.a. “workflow”).

> **Web Components:**
> 
> ****For more information on Web Components, see [this work-in-progress document from the W3C](http://www.w3.org/TR/2013/WD-components-intro-20130606/) and [the Polymer project](http://www.polymer-project.org/). AngularJS is also a current framework that builds on the ideas of component based architecture and can be found at [AngularJS.org](http://angularjs.org).

## Email Apps And Components

A typical email app has several distinct areas of the application’s screen. There is a list of categories or labels, a list of email to show for a given mail box, a search or filter box, and an individual email view, for example. Each of these &#8211; and likely additional areas of functionality on the screen &#8211; can be composed in to small workflow objects as components of the larger email work flow.

The classic example of Gmail illustrates all of these basic components, and many more.

<img src="http://lostechies.com/derickbailey/files/2014/01/gmail-components.png" alt="Gmail components" width="600" height="496" border="0" />

The primary email screen shows a list of categories or labels to the left, a list of email to the right, a search screen at the top, filters, chat sessions, and much more. Each of these areas of functionality can be broken down in to separate components that can then be orchestrated to created a more functional system. This orchestration happens through an API that each of the components exposes, with a higher level workflow (as discussed in the previous chapter) controlling all of the individual components.

## Building An Email List Component {#buildinganemaillistcomponent}

In GMail, the email list that shows the list of mail for the currently selected label or category, applying any filters or search criteria, etc. It may sound like it has a lot of responsibilities, but this can be very easily mitigated with good application design.

Assume the email list is built as a component within the larger screen. There are other components on the screen, as well. Many of them will deal with the raw list of email in some way (not the display of the list, but the actual email data list). One will display the list, one will filter the list, one will search within the list, and possibly more. If multiple component are dealing with the data in some way, it does not make sense for any one of them to have sole responsibility for managing that list. Each component, then, will only have responsibility for it’s use of the list and for exposing an API that lets other parts of the app know what manipulation is occurring.

Before getting to the coordination of components, though, take this idea in to account and build a component to display the list of email.

## [Note: A Base Component]

In [the book](http://backboneplugins.com), there is an entire chapter dedicated to building the base component, explaining why you want each of the things in place. For this post, though, I&#8217;m not going to re-build the entire base component. Instead, I&#8217;m going to create an alias to an existing object inside of [MarionetteJS](http://marionettejs.com) &#8211; [the Controller object](https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.controller.md). This object contains the same core capabilities and structure as the Component base in the book. In fact, the Controller in Marionette is what I have been using to build my Components in real projects and is what inspired these chapters in the first place.

For the sake of this blog post, then, a Component base will be defined with this simple variable assignment:

[gist id=8560125 file=1.js]

## Defining The Component, Top Down {#definingthecomponenttopdown}

Start by extending from the Component type, and add an initialize method that looks for a `mailList` attribute on the options. Assume this is a Backbone.Collection instance, representing the email that should be displayed.

[gist id=8560125 file=2.js]

Next, you’ll need a view to display the list of email. Since the data is in a Backbone.Collection, you can use the CollectionView and ItemView from the first part of this book to do that. Just define a template for the items, and create view definitions appropriately.

[gist id=8560125 file=3.html]

[gist id=8560125 file=4.js]

Now within the Component, add a `show` method that takes the views, renders them, and shows them in the region that the Component is referencing.

[gist id=8560125 file=5.js]

And there you have it &#8211; a very basic component with which to show the list of email. Although, this is a rather simple example, it illustrates the basics of creating a component.

## Exposing An API For Mail Item Selection {#exposinganapiformailitemselection}

To make the `MailListComponent` more useful, it would be good for it to expose an API that allows other objects to know when a mail item has been selected. The easiest way to do this with a backbone application is with events, and the MailListComponent can trigger an event stating a mail item was selected.

For it to expose this method appropriately, though, it will need to know when a mail item is selected or clicked in the case of using a mouse. Listening to an event from the collection to know when a single item is selected would be ideal. But you don’t necessarily have control over the collection definition for the email. Wouldn’t it be nice if you could wrap the collection with the additional functionality of selecting an item? And doesn’t that just sound so familiar?

Take the `MultiPickCollection` from Chapter 9, and set it up inside of the component.

[gist id=8560125 file=6.js]

The `MailListView` can assume it is using a pickable collection with pickable model instances in the item view, as well.

[gist id=8560125 file=7.js]

Now the MailListComponent can listen to the “picked” event on the MultiPickCollection and when it sees an item picked, it can forward that event out through the component instance. This creates an API that another object can use to coordinate behavior with other parts of the app.

[gist id=8560125 file=8.js]

## Want To Know More? {#lessonslearned}

If you&#8217;re interested in the abstractions and ideas behind all of this code, you&#8217;ll want to check out the rest of [my Building Backbone Plugins eBook](http://backboneplugins.com). The entire book is focused on helping you understand how to get rid of the boilerplate code that often finds its way in to your Backbone applications. 