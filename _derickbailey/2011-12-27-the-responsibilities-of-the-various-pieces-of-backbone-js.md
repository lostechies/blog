---
id: 743
title: The Responsibilities Of The Various Pieces Of Backbone.js
date: 2011-12-27T08:00:00+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=743
dsq_thread_id:
  - "517728531"
categories:
  - Backbone
  - JavaScript
---
In my last post on Backbone, I offered my opinion on why [I don&#8217;t look at Backbone as an MVC framework](http://lostechies.com/derickbailey/2011/12/23/backbone-js-is-not-an-mvc-framework/). I left off with a statement about forgetting the MV* family for a moment, and focusing on what&#8217;s really important: how the pieces of Backbone fit together to help us create better JavaScript application. What this really comes down is responsibility. What are each of the pieces of Backbone really responsible for?

## Backbone.History

The primary responsibility of the History object is managing the browser&#8217;s navigation history, which facilitates the forward and back buttons and more.

This is one of the little-known pieces of Backbone as it sits behind the scenes 99% of the time. Typically, the only time you see it come in to play is when you have a Router and you call the history object to kick off the browser&#8217;s history manipulation:

[gist id=1522091 file=history.js]

In truth, the History object does most of the work that you think a Router does. It facilitates the browser&#8217;s forward and back buttons by manipulating the browser&#8217;s history. It updates the URL&#8217;s route (either hash fragment or pushState) and it monitors changes in the URL&#8217;s route. It basically does everything that needs to be done with history, so that we can define and use one or more Routers in our application.

## Backbone.Router And Routes

A router&#8217;s primary responsibility is to organize the route definitions and callback methods into logical groupings (typically based on related objects or related functionality). In reality, the Router organizes an app&#8217;s code for doing this but actually making the update to the route and paying attention to the route happen through the History object. Hence, the Router is used to organize our code and facilitate history manipulation and response, but not to directly manipulate or manage history.

A Router has a few secondary responsibilities, as well: 1) tokenizing the application&#8217;s state in to the browser&#8217;s URL, and 2) rehydrating an application based on a token found in the browser&#8217;s URL.

On a related not: A route is the tokenized representation of our application&#8217;s state.

### Tokenizing State:

As our application progresses, it moves through various states. Some of those states can be represented by simple tokens. For example, viewing an email in GMail can be represented with a token like this:

<img title="Screen Shot 2011-12-23 at 2.24.45 PM.png" src="http://lostechies.com/derickbailey/files/2011/12/Screen-Shot-2011-12-23-at-2.24.45-PM.png" border="0" alt="Screen Shot 2011 12 23 at 2 24 45 PM" width="175" height="30" />

This token is a bookmark-able state that the application transitioned into. When I hit refresh on my browser window, GMail will display the same email message to me that I saw when I clicked on the mail item originally.

When our Backbone applications reach various states, such as viewing an email, we use a router to update the browser&#8217;s URL. We do that through \`router.navigate\`:

[gist id=1522091 file=navigate.js]

### Rehydrating From A Tokenized State:

A router responds to changes in the route and calls the least amount of code possible to put our application in to the state we need. We do this through the use of the router&#8217;s callback methods (or events):

[gist id=1522091 file=router.js]

But the router is not in control the application, the application&#8217;s state, or anything else. It does not control the views or models. A router simply takes the route and figures out which part of the application to call.

Think about a Rails or ASP.NET MVC router. Would you have the router in either of those generate some HTML and send it back to the browser? Not a chance! You would use a controller and view for that. In the same way, we shouldn&#8217;t use a backbone router to &#8220;control&#8221; our application. Rather, we should let the router figure out which route callback needs to be fired, and from there we should call some part of our application that can be in control of the application state.

Sometimes a route callback is a 1-liner that calls out to another objects. Sometimes it is 2 or 3 lines to find an item by id and then call out to another part of our app to get things running. But a router should never instantiate a view and manipulate the DOM directly with jQuery or placing the view in to the DOM. That&#8217;s the responsibility of the application and it&#8217;s state, and a route callback is only one possible entry point into the application&#8217;s state.

## Backbone.Model And Backbone.Collection

Models and collections have one primary responsibility: maintaining application state. They do this by remaining in memory, with all of their associated data remaining in tact, until we change that data or de-reference the object allowing it to be cleaned up. They also do this by managing persistence with a back-end server, when needed.

### In-Memory State

A stateful object is one that lives in memory with a set of specified data, even after we&#8217;re done calling methods on it. A backbone model and collection are typically stateful objects because we hold references to them in our app. This keeps them in memory and allows us to read and change the state of the object. Changing the state of an object may change the state of the overall application.

[gist id=1522091 file=memorystate.js]

### Persistent State

When the state changes, it sticks around in that state until we explicitly change it again. But the state of a model or collection in Backbone can be rather volatile. If a user leaves our application, closes their browser or hits the refresh button on the browser, the state of our application may be lost. If we need to maintain the application state between sessions of our app, we have to persist the state somewhere. We do this by calling various persistence methods on our models and collections:

[gist id=1522091 file=persistence.js]

## Backbone.Sync

Backbone.Sync is responsible for the network communications of the persistence operations found in models and collections. It does this by delegating to jQuery&#8217;s $.ajax method, and by default will communicate using JSON data over a RESTful API on a server.

You typically don&#8217;t touch or notice Backbone.Sync because it&#8217;s hidden behind the model and collection APIs for persistence. When Backbone&#8217;s persistence mechanisms don&#8217;t fit your needs, though, Backbone.Sync is where you want to change things to match what your back-end server requires. There are many different implementations of Backbone.Sync, including some for non-RESTful server, for use with Socket.io, and much much more.

## Backbone.View

The primary responsibility of a view is to coordinate interactions between the end user and the application&#8217;s services.

The interactions between the user and the application&#8217;s services are facilitated through many different means, including the use of jQuery or Zepto.js to handle DOM level events, calling in to models and collections directly through the user of \`this.model\` and \`this.collection\` respectively, and generating new HTML that will be displayed to the end-user in response to changes in the application state.

[gist id=1522091 file=view.js]

In spite of their importance and having their fingers in all the pies of Backbone, views are not in control. They respond to changes in the application state in order to render the right HTML at the right time. They also facilitate changing the state by calling other objects that can change the state, but only on behalf of the user who initiates a state change by interacting with the DOM. Views are effectively the middle-man of a Backbone app.

Of course views can be used in some very simple scenarios where they respond to, manipulate, and maintain the state of an application. But this should only be done when you&#8217;re using a Backbone view to help organize some jQuery code without building a full Backbone application.

## Backbone.Events

The primary responsibility of Backbone.Events is to decouple the knowledge of state changes from the response to those state changes, through the use of the observer pattern.

Backbone.Events is the little powerhouse that facilitates nearly every aspect of a Backbone application. This is the one piece of Backbone that is found in every other piece of Backbone. Every time you call &#8220;bind&#8221; or &#8220;trigger&#8221; on any Backbone object, you&#8217;re using Backbone.Events.

[gist id=152209 file=events.js]

Events let us decouple the various pieces of our app while still providing a unified way for all of those pieces to communicate. Aside from being used in every other piece of Backbone, we can also use Backbone.Events in our own objects. One of my personal favorite ways to do this is through the use of an [event aggregator](http://lostechies.com/derickbailey/2011/07/19/references-routing-and-the-event-aggregator-coordinating-views-in-backbone-js/) to decouple and facilitate communication between higher level application concerns.

[gist id=1522091 file=vent.js]

## Your Code

Understanding what each of these pieces is responsible for will help guide our decisions in how we use them. Can I put this jQuery selector and DOM manipulation directly in my model? Sure, I can. Should I? Heh &#8211; no. A clear separation between DOM manipulation and data manipulation is important. Separating the other concerns of the application are equally as important, of course.

Here&#8217;s the kicker, though. You&#8217;ll notice that none of what I&#8217;ve talked about in any of these responsibilities includes workflow, large scale structure, managing dependencies or any of a number of other subjects. There&#8217;s a lot that Backbone gives us, and it&#8217;s a great tool set to own. But beyond a specific set of tools that should be used to facilitate a specific set of responsibilities in our applications, you still need to know [how to write good JavaScript](http://www.watchmecode.net/). And you [still need to write your own code](http://lostechies.com/derickbailey/2011/08/30/dont-limit-your-backbone-apps-to-backbone-constructs/) to handle the rest of your applications&#8217; needs.