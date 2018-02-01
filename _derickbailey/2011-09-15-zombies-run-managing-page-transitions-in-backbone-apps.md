---
id: 548
title: Zombies! RUN! (Managing Page Transitions In Backbone Apps)
date: 2011-09-15T09:55:09+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=548
dsq_thread_id:
  - "415528908"
categories:
  - Backbone
  - JavaScript
  - Model-View-Controller
---
One of the common issues or questions I see for [Backbone.js](http://documentcloud.github.com/backbone/) goes something like this:

> _&#8220;Whenever I hit the same route more than once, I end up getting seeing this call being made multiple times. It seems to accumulate another call every time I hit the route. What&#8217;s going on?&#8221;_

or

> _&#8220;I&#8217;ve noticed that my views are still handling events after I remove them from the screen. How do I stop this from happening?&#8221;_

or

> _&#8220;How do I make sure I clean things up when moving to a new page in my app?&#8221;_

At the heart of all of these questions is a problem that most backbone developers will run into at some point: zombies. That&#8217;s right &#8211; the living dead creatures and plague us and cause problems… only in this case, we&#8217;re referring to zombie objects in an application &#8211; otherwise known as memory leaks.

## The Plague: Event Binding

The majority of the problems that people are referring to in these questions and issues are caused by the events that we bind to in our apps. Given that Backbone is an event-driven framework, it stands to reason that we&#8217;re going to be using a lot of events; and events are everywhere in Backbone apps.

We bind events to our DOM elements using the declarative \`events\` configuration in our views:

[gist id=1219582 file=1-view-events.js]

We bind events from our models and collections so that our views can respond to changes and re-render themselves:

[gist id=1219582 file=2-view-model-events.js]

We even use Backbone.Events in our own objects so that we can create application-level events and event-driven architectures for our apps.

[gist id=1219582 file=3-event-aggregator.js]

Events are everywhere, and with good reason. They allow us to write modular, reactive code. We don&#8217;t have to stick to procedural loops and long methods that check state in order to figure out what to do next. Events allow us to know when state has changed and respond to that change appropriately.

Problems arise, though, when we bind objects together through these events but we don&#8217;t bother unbinding them. As long as these objects are bound together, and there is a reference in our app code to at least one of them, they won&#8217;t be cleaned up or garbage collected. The resulting memory leaks are like the zombies of the movies &#8211; hiding in dark corners, waiting to jump out and eat us for lunch.

For example &#8211; Backbone apps tend to have one or more areas of the screen that are updated with different views based on what the user is doing. It&#8217;s common to see a main area where the focused content is displayed, as well. When we the user interacts with our app, we update this area of the screen by having a new view instance render some new content for us. The result is new information being displayed for the user, as we expect.

The problem, though, is that it&#8217;s easy to write our code in a manner that doesn&#8217;t let us properly clean up our views when switching them out. For example, we could have a router with route methods that instantiate new views and simply replace the html of our main content area:

[gist id=1219582 file=4-router-zombies.js]

This has the desired effect, visually. A user hitting either of these routes will see the content they expect to see. Unfortunately, though, any events that we&#8217;ve bound in our view may still be hanging around.

## Rule #2: Double Tap

To correct this, I like to introduce an application object that manages the transitions between my views. This object is solely responsible for managing the content of a specific DOM element, displaying what needs to be displayed and cleaning up anything that no longer needs to be there.

[gist id=1219582 file=5-appview.js]

With this in place, we can re-write our router to have a reference to an AppView object. Then, when a route method is fired, the router will tell the AppView instance to display the new view for us. Since the AppView knows about the previously displayed view still, it can call any clean up code that we need for that view.

[gist id=1219582 file=6-router.js]

Now our router doesn&#8217;t have to worry about creating zombies. We&#8217;ve effectively managed our application&#8217;s view transitions by introducing an object who&#8217;s sole purpose is that transition management.

## Closing A View

In this AppView example, I&#8217;ve chosen to have the it call a \`.close()\` method on every view that it is removing from the screen. There isn&#8217;t a method called &#8216;close&#8217; on a Backbone.View, by default. We need to add this method ourselves, as a convention for our application to follow.

We can add our close method to our views a few different ways: add the method to every view in our app, create our own base view with this method, or add it directly to the \`Backbone.View.prototype\`. There&#8217;s not necessarily anything wrong any of these choices, though my preference is to build a basic close method into the Backbone.View.prototype.

There&#8217;s a common bit of functionality that each of our views will need when closing, in most cases. We need to unbind the DOM element events, we need to unbind any custom events that our view raises, and we need to remove the HTML that represents this view from the DOM. These three things can be done in two lines of code inside of our \`close\` method:

[gist id=1219582 file=7-close.js]

The call to \`this.remove()\` delegates to jQuery behind the scenes, by calling \`$(this.el).remove()\`. The effect of this is 2-fold. We get the HTML that is currently populated inside of \`this.el\` removed from the DOM (and therefore, removed from the visual portion of the application), and we also get all of the DOM element events cleaned up for us. This means that all of the events we have in the \`events: { … }\` declaration of our view are cleaned up automatically!

Secondly, the call to \`this.unbind()\` will unbind any events that our view triggers directly &#8211; that is, anytime we may have called \`this.trigger(…)\` from within our view, in order to have our view raise an event.

The last thing we need to do, then, is unbind any model and collection events that our view is bound to. To do this, though, we can&#8217;t use a generic close method on our base view. If we tried to, we would likely end up writing a lot of extraneous code and potentially slowing our app down or causing issues by accidentally unbinding all events for the model or collection, everywhere. If we have multiple views listening to events on the same object, this would remove the ability for our app to respond to the model and collection changes correctly.

The solution, then, is to take a page from the WinForms / .NET world and have an &#8220;onClose&#8221; method that any view can implement when it needs to have custom code run, when the view is closed:

[gist id=1219582 file=8-close.js]

Then in a view that has bound itself to a model or collection event, we can provide an implementation of onClose:

[gist id=1219582 file=9-onclose-view.js]

Our view will now be correctly cleaned up when the AppView calls the close method.

## More Than Just Views For Zombies

Of course there are far more potential zombies in our Backbone apps than just views. Any time we make a call to the \`.bind(…)\` method on any object, we need to be aware of the lifespan of the objects involved. If the objects are going to live for the span of the application&#8217;s life, then we may not need to do any clean up. If the objects are temporal, though, it&#8217;s likely that we will need some sort of cleanup in place.

We all need to be good citizens of the potential zombieland in stateful, event-driven application development. Know the rules, stay safe, and above all <del>don&#8217;t</del> be a hero.

&nbsp;

### P.S.

I&#8217;ve learned a lot about JavaScript and Backbone memory management since I wrote this. If you want to keep up to date and get the latest info, <a href="https://my.leadpages.net/leadbox/145613173f72a2%3A10737f12eb46dc/5685265389584384/" target="_blank">join my mailing list.</a> I&#8217;ve got a lot of insight to share and you don&#8217;t want to miss out!